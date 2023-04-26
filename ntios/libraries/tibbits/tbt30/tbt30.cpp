/*Copyright 2021 Tibbo Technology Inc.*/

//***********************************************************************************************************
//            Tibbit #30 (humidity and temperature sensor)
//***********************************************************************************************************
#include "global.h"

#define TBT30_INIT_SIGNATURE 0x3969
#define TBT30_STAMP "TBT30> "
#define TBT30_CR_LF chr(13) + chr(10)

#define TBT30_WRITE_ADDR 0x4E
#define TBT30_READ_ADDR 0x4F

enum tbt30_status {
  TBT30_STATUS_NORMAL_OPERATION = 0x0,
  TBT30_STAUTS_STALE_DATA = 0x1,
  TBT30_STAUTS_IN_COMMAND_MODE = 0x2,
  TBT30_STAUTS_NOT_USED = 0x3
};

void tbt30_delay_msecond(U16 value);

#if TBT30_DEBUG_PRINT == 1
void tbt30_debug_print(const string &data);
#endif

//--------------------------------------------------------------------
U8 i2c_num_tbt30;
U16 tbt30_init_flag;

/* Call this function to initialize the Tibbit.
 * Use_ssi argument specifies whether you want to communicate with this Tibbit
 * using the SSI channel running in the I2C mode (YES), or go for direct I/O
 * manipulation a.k.a. bit-banging (NO). Note that there is a limited number
 * of SSI channels so if you set use_ssi=YES this function may return NG,
 * meaning that there are no free SSI channels left. This doesn't mean
 * failure. Rather, it means that comms will proceed in bit banging mood.
 */
void tbt30_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk,
                pl_io_num pin_data, U8 *channel) {
#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("++++++++++");
#endif

  tbt30_init_flag = TBT30_INIT_SIGNATURE;
  *channel = si2c_register(signature, pin_data, pin_clk, use_ssi);

  io.num = pin_clk;
  io.enabled = YES;
  io.num = pin_data;
  io.enabled = YES;
  io.state = HIGH;

#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("i2c num: " + str(*channel));
#endif
  if (*channel < 4) {
    ssi.channel = *channel;
    ssi.enabled = NO;
    ssi.baudrate = (pl_ssi_baud)5;
    ssi.clkmap = pin_clk;
    ssi.dimap = pin_data;
    ssi.domap = pin_data;
    ssi.direction = PL_SSI_DIRECTION_LEFT;
    ssi.mode = PL_SSI_MODE_2;
    ssi.zmode = PL_SSI_ZMODE_ENABLED_ON_ZERO;
    ssi.enabled = YES;
  }

#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("----------");
#endif
}

/*
 * Returns "real" humidity and temperature data expressed in %PH and degrees
 * C. NOTE: this call may fail, so check the ON/NG status returned by the
 * function.
 */
ok_ng tbt30_get_pc(float *humidity, float *temperature, U8 channel) {
  ok_ng ret;
  U16 temp, hum;

  ret = tbt30_get(&hum, &temp, channel);

  *humidity = hum;
  *humidity = (*humidity * 100) / 16383;

  *temperature = temp;
  *temperature = *temperature / 16383;
  *temperature = *temperature * 165;
  *temperature = *temperature - 40;
  return ret;
}

/* #lizard forgives the complexity */
ok_ng tbt30_get(U16 *humidity, U16 *temperature, U8 channel) {
  /*
   * Returns humidity and temperature data expressed as 16-bit unsigned values.
   * See how the conversion into "real" values is done in tbt30_get_pc().
   * NOTE: this call may fail, so check the ON/NG status returned by the
   * function.
   */
  ok_ng ret;
  tbt30_status status;
  U8 data1, data2, data3, data4, tmp1, hi, lo, temp2;

  if (tbt30_init_flag != TBT30_INIT_SIGNATURE) {
#if TBT30_DEBUG_PRINT == 1
    tbt30_debug_print(
        "The lib is not initialized, "
        "call tbt30_init() first");
#endif
    return ret;
  }

  ret = OK;

  si2c_get(channel);

  // send the measurement request
  si2c_start();
  si2c_write(TBT30_WRITE_ADDR);
  si2c_stop();

  tbt30_delay_msecond(50);

  // fetch humidity data
  si2c_start();
  si2c_write(TBT30_READ_ADDR);
  data1 = si2c_read(true);
  data2 = si2c_read(true);
  data3 = si2c_read(true);
  data4 = si2c_read(false);
  si2c_stop();

  status = (tbt30_status)(data1 & 0x80);
  status = (tbt30_status)((U8)status / 128);
  status = (tbt30_status)(((U8)status & 0x40) / 64);

#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("-status(" + str(status) + ")-");
  tbt30_debug_print("     data1:" + hex(data1));
  tbt30_debug_print("     data2:" + hex(data2));
  tbt30_debug_print("     data3:" + hex(data3));
  tbt30_debug_print("     data4:" + hex(data4));
#endif

  switch (status) {
    case TBT30_STATUS_NORMAL_OPERATION:
#if TBT30_DEBUG_PRINT == 1
      tbt30_debug_print("TBT30_STATUS_NORMAL_OPERATION");
      break;
#endif

      /* To Jim: This 'break' needs to be added when transpiling */
      break;
    case TBT30_STAUTS_STALE_DATA:
#if TBT30_DEBUG_PRINT == 1
      tbt30_debug_print("TBT30_STATUS_STALE_DATA");
      ret = NG;
      return ret;
      break;
#endif

      /* To Jim: This 'break' needs to be added when transpiling */
      break;
    case TBT30_STAUTS_IN_COMMAND_MODE:
#if TBT30_DEBUG_PRINT == 1
      tbt30_debug_print("TBT30_STATUS_IN_COMMAND_MODE");
#endif
      ret = NG;
      return ret;
      break;
    case TBT30_STAUTS_NOT_USED:
#if TBT30_DEBUG_PRINT == 1
      tbt30_debug_print("TBT30_STATUS_NOT_USED");
#endif

      ret = NG;
      return ret;
      break;

    default:
      break;
  }

  // humidity:   Data1 [13:6] + Data2 [7:0]
  // temerature: Data3 [13:6] + Data4 [5:0]
  tmp1 = data1 * 4;
  *humidity = tmp1 * 64 + data2;

#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("Raw humidity value=" + hex(tmp1 * 64 + data2));
#endif

  tmp1 = data3 * 4;
  tmp1 = tmp1 / 16;
  hi = data3 / 64 * 16;
  hi = hi + tmp1;

  tmp1 = data3 & 0x03;
  tmp1 = tmp1 * 64;

  temp2 = data4 & 0xC0;
  temp2 = temp2 / 4;
  lo = tmp1 + temp2;

  tmp1 = data4 & 0x3C;
  tmp1 = tmp1 / 4;
  lo = lo + tmp1;

  *temperature = hi * 256 + lo;
#if TBT30_DEBUG_PRINT == 1
  tbt30_debug_print("Raw temperature value=" + hex(*temperature));
#endif

  return ret;
}

void tbt30_delay_msecond(U16 value) { sys.delayms(50); }

#if TBT30_DEBUG_PRINT == 1
void tbt30_debug_print(const string &data) {
  sys.debugprint(TBT30_STAMP + data + TBT30_CR_LF);
}
#endif
