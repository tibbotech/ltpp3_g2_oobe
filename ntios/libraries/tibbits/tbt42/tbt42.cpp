/*Copyright 2021 Tibbo Technology Inc.*/

//***********************************************************************************************************
//            Tibbit #42 (RTC with NVRAM and temperature sensor)
//***********************************************************************************************************

#include "global.h"

//----------------------------------------------------------------------------
#define TBT42_INIT_SIGNATURE 0x1010
#define TBT42_STAMP "TBT42> "
#define TBT42_CR_LF "\r\n"

#define TBT42_SECONDS 0x0
#define TBT42_MINUTES 0x1
#define TBT42_HOURS 0x2
#define TBT42_DATE 0x4
#define TBT42_MONTH 0x5
#define TBT42_YEAR 0x6
#define TBT42_A1M1 0x7
#define TBT42_A1M2 0x8
#define TBT42_A1M3 0x9
#define TBT42_A1M4 0xA
#define TBT42_CONTROL 0xE
#define TBT42_STATUS 0xF
#define TBT42_TEMP_H 0x11
#define TBT42_TEMP_L 0x12
#define TBT42_NVRAM_AD 0x18
#define TBT42_NVRAM_DT 0x19

#define MINS_IN_DAY 1440
#define SECS_IN_DAY MINS_IN_DAY * 60

//--------------------------------------------------------------------
void tbt42_reg_write_bcd(U8 add, U8 data, pl_io_num pin_cs, U8 channel);
U8 tbt42_reg_read_bcd(U8 add, pl_io_num pin_cs, U8 channel);
void tbt42_reg_write_bin(U8 add, U8 data, pl_io_num pin_cs, U8 channel);
U8 tbt42_reg_read_bin(U8 add, pl_io_num pin_cs, U8 channel);

#define RTC_DEBUG_PRINT 1

#if (RTC_DEBUG_PRINT == 1)
void rtc_debug_print(const string &data);
#endif

//--------------------------------------------------------------------
U8 spi_num_tbt42;
U16 rtc_init_flag;

/*
 * Call this function to initialize the Tibbit.
 * Use_ssi argument specifies whether you want to communicate with this Tibbit
 * using the SSI channel running in the I2C mode (YES), or go for direct I/O
 * manipulation a.k.a. bit-banging (NO). Note that there is a limited number of
 * SSI channels so if you set use_ssi=YES this function may return NG, meaning
 * that there are no free SSI channels left. This doesn't mean failure. Rather,
 * it means that comms will proceed in bit banging mood.
 */
tbt42_errcheck tbt42_init(no_yes use_ssi, pl_io_num pin_cs, pl_io_num pin_clk,
                          pl_io_num pin_mosi, pl_io_num pin_miso, U8 *channel) {
  /* DEFINE VARIABLES */
  U8 value;
  tbt42_errcheck ret = TBT42_OK;

#if (RTC_DEBUG_PRINT == 1)
  rtc_debug_print("++++++++++");
#endif
  rtc_init_flag = TBT42_INIT_SIGNATURE;

  *channel = sspi_register("TBT42", pin_mosi, pin_miso, pin_clk, PL_SSI_MODE_1,
                           use_ssi);
#if (RTC_DEBUG_PRINT == 1)
  rtc_debug_print("spi num:" + str(*channel));
#endif

  /* SPI CS */
  io.num = pin_cs;
  io.enabled = YES;
  io.state = HIGH;

  if (*channel < 4) {
    ssi.channel = *channel;

    /* SPI CLK */
    io.num = pin_clk;
    io.enabled = YES; /* Enable as output */
    io.state = HIGH;

    /* SPI DO (MOSI) */
    io.num = pin_mosi;
    io.state = HIGH;
    io.enabled = YES;

    /* SPI DI (MISO) */
    io.num = pin_mosi;
    io.enabled = NO;

    /* setup SSI channel */
    ssi.channel = *channel;
    ssi.mode = PL_SSI_MODE_1;
    ssi.clkmap = pin_clk;
    ssi.dimap = pin_miso;
    ssi.domap = pin_mosi;
    ssi.zmode = PL_SSI_ZMODE_ALWAYS_ENABLED;
    ssi.direction = PL_SSI_DIRECTION_LEFT;
    ssi.baudrate = PL_SSI_BAUD_FASTEST;
    ssi.enabled = YES;
  } else {
    if (use_ssi == YES) {
      ret = TBT42_NO_SSI_AVAILABLE;
    }
  }

#if (RTC_DEBUG_PRINT == 1)
  rtc_debug_print("----------");
#endif

  sspi_get(spi_num_tbt42);

  value = tbt42_reg_read_bin(TBT42_CONTROL, pin_cs, *channel);
  tbt42_reg_write_bin(TBT42_CONTROL, value & 0xFC, pin_cs, *channel);

  value = tbt42_reg_read_bin(TBT42_STATUS, pin_cs, *channel);
  value = value & 0xF0;

  if (value & 0x80) {
    tbt42_reg_write_bin(TBT42_STATUS, value, pin_cs, *channel);
  } else {
    ret = TBT42_SELF_TEST_FAIL;
  }

  return ret;
}

/*
 * reads the current daycount, mincount, and seconds from the RTC. Use year(),
 * month(), date(), hours(), minutes(), and weekday() syscalls to convert
 * these values into the actual date and time.
 */
void tbt42_rtc_get(U16 *wdaycount, U16 *wmincount, U8 *bsec, pl_io_num pin_cs,
                   U8 channel) {
  U8 byear, bmonth, bday, bhour, bmin;

  if (rtc_init_flag != TBT42_INIT_SIGNATURE) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print(
        "The lib is not initialized, "
        "call tbt42_init() first");
#endif

    return;
  }
  byear = tbt42_reg_read_bcd(TBT42_YEAR, pin_cs, channel);
  bmonth = tbt42_reg_read_bcd(TBT42_MONTH, pin_cs, channel);
  bday = tbt42_reg_read_bcd(TBT42_DATE, pin_cs, channel);
  bhour = tbt42_reg_read_bcd(TBT42_HOURS, pin_cs, channel);
  bmin = tbt42_reg_read_bcd(TBT42_MINUTES, pin_cs, channel);
  *bsec = tbt42_reg_read_bcd(TBT42_SECONDS, pin_cs, channel);
  *wdaycount = daycount(byear, bmonth, bday);
  *wmincount = mincount(bhour, bmin);
}

/* Writes the specified daycount, mincount, and seconds into the RTC. Use
 * daycount() and mincount() syscalls to convert your date and time into the
 * daycount and mincount values. Returns NG if values you supplied are
 * invalid.
 */
ok_ng tbt42_rtc_set(U16 wdaycount, U16 wmincount, U8 bsec, pl_io_num pin_cs,
                    U8 channel) {
  ok_ng ret;
  U8 byear, bmonth, bday, bhour, bmin;

  ret = OK;

  if (rtc_init_flag != TBT42_INIT_SIGNATURE) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print(
        "The lib is not initialized, "
        "call tbt42_init() first");
#endif

    ret = NG;

    return ret;
  }

  if (bsec > 59) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print("Maximum bsec number is 59");
#endif

    ret = NG;

    return ret;
  }
  if (wmincount > 1439) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print("Maximum wmincount number is 1439.");
#endif

    ret = NG;

    return ret;
  }

  /* CONVERT TO YEAR, MONTH, DAY, HOUR, MIN */
  byear = year(wdaycount);
  bmonth = month(wdaycount);
  bday = date(wdaycount);
  bhour = hours(wmincount);
  bmin = minutes(wmincount);

  /* WRITE DATA INTO RTC */
  tbt42_reg_write_bcd(TBT42_SECONDS, bsec, pin_cs, channel);  // sec
  tbt42_reg_write_bcd(TBT42_MINUTES, bmin, pin_cs, channel);  // min
  tbt42_reg_write_bcd(TBT42_HOURS, bhour, pin_cs, channel);   // hr
  tbt42_reg_write_bcd(TBT42_DATE, bday, pin_cs, channel);     // date
  tbt42_reg_write_bcd(TBT42_MONTH, bmonth, pin_cs, channel);  // month
  tbt42_reg_write_bcd(TBT42_YEAR, byear, pin_cs, channel);    // year

  /* OUTPUT */
  return ret;
}

/*
 * Sets the alarm if enable_alarm=YES. Disables the alarm if enable_alarm=NO.
 * With alarm enabled...
 *   - When wdaycount=0 AND wmincount=0 AND bsec=0 alarm occurs every
 * second.
 *   - When wdaycount=0 AND wmincount=0 AND bsec>0 alarm occurs every minute
 * and on the second specified by bsec.
 *   - When wdaycount>0 alarm occurs on the date/time specified by the
 * combination of wdaycount, wmincount, and bsec.
 */
ok_ng tbt42_alarm_set(U16 wdaycount, U16 wmincount, U8 bsec,
                      no_yes enable_alarm, pl_io_num pin_cs, U8 channel) {
  ok_ng ret;
  U8 bday, bhour, bmin;
  U8 value;

  /* INITIAL SETTING */
  ret = NG;

  /* CHECK IF INITIALIZED */
  if (rtc_init_flag != TBT42_INIT_SIGNATURE) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print(
        "The lib is not initialized, "
        "call tbt42_init() first");
#endif
    return ret;
  }

  if (bsec > 59) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print("Maximum bsec number is 59.");
#endif
    return ret;
  }
  if (wmincount > 1439) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print("Maximum wmincount number is 1439.");
#endif
    return ret;
  }

  /* CONVERT TO DAY, HOUR, MINUTES */
  bday = date(wdaycount);
  bhour = hours(wmincount);
  bmin = minutes(wmincount);

  if (bsec = 0 && wdaycount == 0 && wmincount == 0) {
    // per second
    bday = 0x80;
    bhour = 0x80;
    bmin = 0x80;
    bsec = 0x80;
  } else {
    if (wdaycount == 0 && wmincount == 0) {
      // seconds match (per minute)
      bday = 0x80;
      bhour = 0x80;
      bmin = 0x80;
    } else {
      if (bsec = 0 && bmin == 0) {
        // minutes and seconds match
        bday = 0x80;
        bhour = 0x80;
      } else {
        if (bday == 0) {
          // hours,minutes and seconds match
          bday = 0x80;
        }
      }
    }
  }

  /* WRITE DATA INTO RTC */
  tbt42_reg_write_bcd(TBT42_A1M4, bday, pin_cs, channel);   // date
  tbt42_reg_write_bcd(TBT42_A1M3, bhour, pin_cs, channel);  // hr
  tbt42_reg_write_bcd(TBT42_A1M2, bmin, pin_cs, channel);   // min
  tbt42_reg_write_bcd(TBT42_A1M1, bsec, pin_cs, channel);   // sec

  if (enable_alarm == YES) {
    value = tbt42_reg_read_bin(TBT42_STATUS, pin_cs, channel);
    value = value & 0xF0;
    tbt42_reg_write_bin(TBT42_STATUS, value, pin_cs, channel);
  }

  value = tbt42_reg_read_bin(TBT42_CONTROL, pin_cs, channel);
  value = value & 0xFC;
  if (enable_alarm == YES) {
    value = value | 0x05;
  } else {
    value = value | 0x04;
  }

  tbt42_reg_write_bin(TBT42_CONTROL, value, pin_cs, channel);

  ret = OK;

  return ret;
}

ok_ng tbt42_alarm_waiting(pl_io_num pin_miso, pl_io_num pin_cs, U8 channel) {
  ok_ng ret;

  ret = NG;

wait_alarm:
  if (io.lineget(pin_miso) == HIGH) {
    goto wait_alarm;
  }

  tbt42_rtc_int_clear(pin_cs, channel);

  ret = OK;

  return ret;
}

/*
 * Returns NO if alarm is disabled or YES if enabled, in which case
 * wdaycout, wmincount, and bsec will contain current alarm settings.
 */
no_yes tbt42_alarm_setting_get(U16 *wdaycount, U16 *wmincount, U8 *bsec,
                               pl_io_num pin_cs, U8 channel) {
  no_yes ret = NO;
  U8 byear, bmonth, bday, bhour, bmin;

  /* Check if lib is initialized */
  if (rtc_init_flag != TBT42_INIT_SIGNATURE) {
#if (RTC_DEBUG_PRINT == 1)
    rtc_debug_print(
        "The lib is not initialized, "
        "call tbt42_init() first");
#endif

    /* Output: NO */
    return ret;
  }

  byear = tbt42_reg_read_bcd(TBT42_YEAR, pin_cs, channel);
  bmonth = tbt42_reg_read_bcd(TBT42_MONTH, pin_cs, channel);
  bday = tbt42_reg_read_bcd(TBT42_A1M4, pin_cs, channel);
  bhour = tbt42_reg_read_bcd(TBT42_A1M3, pin_cs, channel);
  bmin = tbt42_reg_read_bcd(TBT42_A1M2, pin_cs, channel);
  *bsec = tbt42_reg_read_bcd(TBT42_A1M1, pin_cs, channel);

  if ((*bsec & 0x80) && (bmin & 0x80) && (bhour & 0x80) && (bday & 0x80)) {
    // alarm once per second
    bday = tbt42_reg_read_bcd(TBT42_DATE, pin_cs, channel);
    bhour = tbt42_reg_read_bcd(TBT42_HOURS, pin_cs, channel);
    bmin = tbt42_reg_read_bcd(TBT42_MINUTES, pin_cs, channel);
    *bsec = tbt42_reg_read_bcd(TBT42_SECONDS, pin_cs, channel) + 1;
  } else {
    if ((bday & 0x80) && (bhour & 0x80) && (bmin & 0x80)) {
      // alarm when seconds match
      bday = tbt42_reg_read_bcd(TBT42_DATE, pin_cs, channel);
      bhour = tbt42_reg_read_bcd(TBT42_HOURS, pin_cs, channel);
      bmin = tbt42_reg_read_bcd(TBT42_MINUTES, pin_cs, channel) + 1;
      *bsec = *bsec & 0x7F;
    } else {
      if ((bday & 0x80) && (bhour & 0x80)) {
        // alarm when minutes and secondes match
        bday = tbt42_reg_read_bcd(TBT42_DATE, pin_cs, channel);
        bhour = tbt42_reg_read_bcd(TBT42_HOURS, pin_cs, channel) + 1;
        bmin = bmin & 0x7f;
        *bsec = *bsec & 0x7f;
      } else {
        if (bday & 0x80) {
          bday = tbt42_reg_read_bcd(TBT42_DATE, pin_cs, channel) + 1;
          bhour = bhour & 0x7F;
          bmin = bmin & 0x7F;
          *bsec = *bsec & 0x7F;
        } else {
          bday = bday & 0x7F;
          bhour = bhour & 0x7F;
          bmin = bmin & 0x7F;
          *bsec = *bsec & 0x7F;
        }
      }
    }
  }

  // check the format
  if (*bsec > 59) {
    *bsec = 0;
    bmin = bmin + 1;
  }

  if (bmin > 59) {
    bmin = 0;
    bhour = bhour + 1;
  }

  if (bhour > 23) {
    bhour = 0;
    bday = bday + 1;
  }

  U8 max_day;
  if (bmonth == 1 || bmonth == 3 || bmonth == 5 || bmonth == 7 || bmonth == 8 ||
      bmonth == 10 || bmonth == 12) {
    max_day = 31;
  } else {
    max_day = 30;
  }

  if (bday > max_day) {
    bday = 1;
    bmonth = bmonth + 1;
  }

  if (bmonth > 12) {
    bmonth = 1;
    byear = byear + 1;
  }

  *wdaycount = daycount(byear, bmonth, bday);
  *wmincount = mincount(bhour, bmin);

  if (tbt42_reg_read_bin(TBT42_CONTROL, pin_cs, channel) & 0x01) {
    ret = YES;
  } else {
    ret = NO;
  }
  return ret;
}

void tbt42_rtc_int_clear(pl_io_num pin_cs, U8 channel) {
  /*
   * Clears the alarm interrupt thus causing the INT line to go HIGH
   * (deactivate).
   */
  U8 value;

  value = tbt42_reg_read_bin(TBT42_STATUS, pin_cs, channel);
  value = value & 0xF0;
  tbt42_reg_write_bin(TBT42_STATUS, value, pin_cs, channel);
}

/* Reads the current temperature. The temperature is measured in steps of 0.25
 * degrees C. Reading the temperature does not cause the actual temperature
 * measurement to occur. Measurements happen once in every 64 seconds and are
 * independent of temperature reads.
 */
float tbt42_temp_get(pl_io_num pin_cs, U8 channel) {
  float ret;
  int tmp;

  tmp = tbt42_reg_read_bin(TBT42_TEMP_H, pin_cs, channel) * 256 +
        tbt42_reg_read_bin(TBT42_TEMP_L, pin_cs, channel);
  tmp = tmp / 64;  // to get rid of 6 empty bits
  ret = tmp;
  ret = ret / 4;
  return ret;
}

/*
 * Reads a byte of data from the non-volatile memory at address 0~255.
 */
U8 tbt42_nvram_read(U8 address, pl_io_num pin_cs, U8 channel) {
  U8 ret;

  tbt42_reg_write_bin(TBT42_NVRAM_AD, address, pin_cs, channel);
  ret = tbt42_reg_read_bin(TBT42_NVRAM_DT, pin_cs, channel);
  return ret;
}

/*
 * Writes a byte of data into the non-volatile memory at address 0~255.
 */
void tbt42_nvram_write(U8 data_to_write, U8 address, pl_io_num pin_cs,
                       U8 channel) {
  tbt42_reg_write_bin(TBT42_NVRAM_AD, address, pin_cs, channel);
  tbt42_reg_write_bin(TBT42_NVRAM_DT, data_to_write, pin_cs, channel);
}

U8 tbt42_reg_read_bcd(U8 add, pl_io_num pin_cs, U8 channel) {
  U8 ret;
  U8 digit1, digit0;

  sspi_get(channel);

  io.lineset(pin_cs, LOW);
  sspi_write(add);
  ret = sspi_read();
  io.lineset(pin_cs, HIGH);

  digit1 = ret / 16;
  digit0 = ret & 0x0F;
  ret = digit1 * 10 + digit0;
  return ret;
}

void tbt42_reg_write_bcd(U8 add, U8 data, pl_io_num pin_cs, U8 channel) {
  U8 digit1, digit0;

  digit1 = data / 10;
  digit0 = data - digit1 * 10;
  data = digit1 * 16 + digit0;

  sspi_get(channel);
  io.lineset(pin_cs, LOW);
  sspi_write(add | 0x80);
  sspi_write(data);
  io.lineset(pin_cs, HIGH);
}

U8 tbt42_reg_read_bin(U8 add, pl_io_num pin_cs, U8 channel) {
  U8 ret;
  sspi_get(channel);

  io.lineset(pin_cs, LOW);
  sspi_write(add);
  ret = sspi_read();
  io.lineset(pin_cs, HIGH);
  return ret;
}

void tbt42_reg_write_bin(U8 add, U8 data, pl_io_num pin_cs, U8 channel) {
  sspi_get(channel);
  io.lineset(pin_cs, LOW);
  sspi_write(add | 0x80);
  sspi_write(data);
  io.lineset(pin_cs, HIGH);
}

#if (RTC_DEBUG_PRINT == 1)
void rtc_debug_print(const string &data) {
  sys.debugprint(TBT42_STAMP + data + TBT42_CR_LF);
}
#endif
