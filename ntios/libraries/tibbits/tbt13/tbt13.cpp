//***********************************************************************************************************
//			Tibbit #13 (4-channel ADC)
//***********************************************************************************************************

#include "global.h"

#define TBT13_INIT_SIGNATURE 0x9D6B
#define TBT13_STAMP "TBT13> "
#define TBT13_CR_LF chr(13) + chr(10)

#define TBT13_WRITE_ADDR 0x10
#define TBT13_READ_ADDR 0x11

#if TBT13_DEBUG_PRINT == 1
void adc_debug_print(string data);
#endif

unsigned int tbt13_init_flag;

void test(string signature) { return; }

ok_ng tbt13_init(string signature, pl_io_num data_pin, pl_io_num clk_pin,
                 unsigned char *tbt_channel, no_yes use_ssi) {
  ok_ng tbt13_init;
  tbt13_init = OK;
  tbt13_init_flag = TBT13_INIT_SIGNATURE;

#if TBT13_DEBUG_PRINT == 1
  adc_debug_print("++++++++++");
#endif

  *tbt_channel = si2c_register(signature, data_pin, clk_pin, use_ssi);
#if TBT13_DEBUG_PRINT == 1
  adc_debug_print("i2c num:" + str(*tbt_channel));
#endif
  if (*tbt_channel < 4) {
    ssi.channel = *tbt_channel;
    ssi.enabled = NO;
    ssi.baudrate = PL_SSI_BAUD_SLOWEST;
    ssi.clkmap = clk_pin;
    ssi.dimap = data_pin;
    ssi.domap = data_pin;
    ssi.zmode = PL_SSI_ZMODE_ENABLED_ON_ZERO;
    ssi.direction = PL_SSI_DIRECTION_LEFT;
    ssi.mode = PL_SSI_MODE_0;
    ssi.enabled = YES;
    io.num = clk_pin;
    io.state = HIGH;
    io.num = data_pin;
    io.state = HIGH;
  } else {
    if (use_ssi == YES) {
      tbt13_init = NG;
    }
  }

#if TBT13_DEBUG_PRINT == 1
  adc_debug_print("----------");
#endif
  return tbt13_init;
}

void tbt13_channel_select(tbt13_nums channel, unsigned char tbt_channel) {
  if (tbt13_init_flag != TBT13_INIT_SIGNATURE) {
#if TBT13_DEBUG_PRINT == 1
    adc_debug_print("The lib is not initialized, call tbt13_init() first");
#endif
    return;
  }

  unsigned char ch;

  switch (channel) {
    case ADC_1:

      ch = 0x88;
      break;

    case ADC_2:

      ch = 0x98;
      break;

    case ADC_3:

      ch = 0xA8;
      break;

    case ADC_4:

      ch = 0xB8;
      break;
  }

  si2c_get(tbt_channel);
  si2c_start();
  si2c_write(TBT13_WRITE_ADDR);
  si2c_write(ch);
  si2c_start();
}

int tbt13_get_prev_mv(unsigned char tbt_channel) {
  int tbt13_get_prev_mv;
  long dw;

  dw = tbt13_get_prev(tbt_channel);

#if ADC_RESOLUTION == ADC_RES_LOW
  tbt13_get_prev_mv = (dw * 1953125 - 1000000000) / 100000;
#elif ADC_RESOLUTION == ADC_RES_MID
  tbt13_get_prev_mv = (dw * 976562 - 1000000000) / 100000;
#else
  tbt13_get_prev_mv = (dw * 488281 - 1000000000) / 100000;
#endif
  return tbt13_get_prev_mv;
}

unsigned int tbt13_get_prev(unsigned char tbt_channel) {
  unsigned int tbt13_get_prev;
  unsigned char byte_hi, byte_lo;

  if (tbt13_init_flag != TBT13_INIT_SIGNATURE) {
#if TBT13_DEBUG_PRINT == 1
    adc_debug_print("The lib is not initialized, call tbt13_init() first");
#endif
    return tbt13_get_prev;
  }

  si2c_get(tbt_channel);
  si2c_start();
  si2c_write(TBT13_READ_ADDR);
  byte_hi = si2c_read(true);
  byte_lo = si2c_read(true);
  si2c_stop();

#if ADC_RESOLUTION == ADC_RES_LOW
  tbt13_get_prev = byte_lo / 64 + byte_hi * 4;  // 10 bit
#elif ADC_RESOLUTION == ADC_RES_MID
  tbt13_get_prev = byte_lo / 32 + byte_hi * 8;  // 11 bit
#else
  tbt13_get_prev = byte_lo / 16 + byte_hi * 16;  // 12 bit
#endif
  return tbt13_get_prev;
}

#if TBT13_DEBUG_PRINT == 1
void adc_debug_print(string data) {
  sys.debugprint(TBT13_STAMP + data + TBT13_CR_LF);
}
#endif