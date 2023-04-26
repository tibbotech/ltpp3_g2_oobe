/*Copyright 2021 Tibbo Technology Inc.*/

//***********************************************************************************************************
//  Tibbit #28 (ambient light sensor)
//***********************************************************************************************************
#include "global.h"

#define TBT28_INIT_SIGNATURE 0x5982
#define TBT28_STAMP "TBT28> "
#define TBT28_CR_LF (chr(13) + chr(10))

#define TBT28_WRITE_ADDR 0x46  // address code for write
#define TBT28_READ_ADDR 0x47   // address code for read

#define TBT28_CMD_POWER_DOWN 0x00
#define TBT28_CMD_POWER_ON 0x01
#define TBT28_CMD_AUTO_RESOL_0 0x10
#define TBT28_CMD_HRESOL_0 0x12
#define TBT28_CMD_LRESOL_0 0x13

void tbt28_cmd_send(U8 cmd);
void tbt28_delay_msecond(word value);

#if TBT28_DEBUG_PRINT == 1
void tbt28_debug_print(const string &data);
#endif

U8 i2c_num_tbt28;
U16 tbt28_init_flag;

ok_ng tbt28_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk,
                 pl_io_num pin_data, U8 *channel) {
  ok_ng ret = OK;
  tbt28_init_flag = TBT28_INIT_SIGNATURE;

#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("++++++++++");
#endif

  *channel = si2c_register(signature, pin_data, pin_clk, use_ssi);

#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("i2c num:" + str(*channel));
#endif

  si2c_get(*channel);

  if (*channel <= 3) {
    ssi.channel = *channel;
    ssi.enabled = NO;
    ssi.baudrate = PL_SSI_BAUD_FASTEST;
    ssi.clkmap = pin_clk;
    ssi.dimap = pin_data;
    ssi.domap = pin_data;
    ssi.direction = PL_SSI_DIRECTION_LEFT;
    ssi.zmode = PL_SSI_ZMODE_ENABLED_ON_ZERO;
    ssi.mode = PL_SSI_MODE_0;
    ssi.enabled = YES;
  } else {
    if (use_ssi == YES) {
      ret = NG;
    }
  }

/* Switch sensor to power down mode */
#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("Switch sensor to power down mode");
#endif
  tbt28_cmd_send(TBT28_CMD_POWER_DOWN);

/* Switch sensor to power on mode */
#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("Switch sensor to power on mode");
#endif
  tbt28_cmd_send(TBT28_CMD_POWER_ON);

/* Switch sensor to high resolution mode */
#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("Switch sensor to high resolution mode");
#endif
  tbt28_cmd_send(TBT28_CMD_HRESOL_0);

/* Wait to complete 1st Auto-resolution mode measurement.(max. 180 ms) */
#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print(
      "Wait to complete 1st Auto-resolution "
      "mode measurement.(max. 180 ms)");
#endif
  tbt28_delay_msecond(150);

#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("----------");
#endif

  /* Output */
  return ret;
}

word tbt28_get(unsigned char *channel) {
  /* Returns a 16-bit number expressing relative ambient light intensity */
  U8 upper, lower;
  U16 ret = 0;

  if (tbt28_init_flag != TBT28_INIT_SIGNATURE) {
#if TBT28_DEBUG_PRINT == 1
    tbt28_debug_print(
        "The lib is not initialized, "
        "call tbt28_init() first");
#endif

    return ret;
  }

  si2c_get(*channel);

  si2c_start();
  si2c_write(TBT28_READ_ADDR);
  upper = si2c_read(true);
  lower = si2c_read(false);
  si2c_stop();

#if TBT28_DEBUG_PRINT == 1
  tbt28_debug_print("u:" + hex(upper) + " l:" + hex(lower));
#endif
  ret = upper * 256 + lower;
  if (ret == 0) {
    tbt28_cmd_send(TBT28_CMD_POWER_DOWN);
    tbt28_cmd_send(TBT28_CMD_POWER_ON);
    tbt28_cmd_send(TBT28_CMD_HRESOL_0);
    tbt28_delay_msecond(150);
  }

  /* Output */
  return ret;
}

void tbt28_cmd_send(U8 cmd) {
  si2c_start();
  si2c_write(TBT28_WRITE_ADDR);
  si2c_write(cmd);
  si2c_stop();
}

void tbt28_delay_msecond(word value) { sys.delayms(value); }

#if TBT28_DEBUG_PRINT == 1
void tbt28_debug_print(const string &data) {
  sys.debugprint(TBT28_STAMP + data + TBT28_CR_LF);
}
#endif
