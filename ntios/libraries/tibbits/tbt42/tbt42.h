/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef __LIBRARY_TIBBITS_TBT42_H__
#define __LIBRARY_TIBBITS_TBT42_H__

enum tbt42_errcheck { TBT42_OK, TBT42_SELF_TEST_FAIL, TBT42_NO_SSI_AVAILABLE };

/*
 * Call this function to initialize the Tibbit.
 * Use_ssi argument specifies whether you want to communicate with this Tibbit
 * using the SSI channel running in the I2C mode (YES), or *go for direct I/O
 * manipulation a.k.a. bit-banging (NO). *Note that there is a limited number of
 * SSI channels so if you set use_ssi=YES this function may return NG, meaning
 * that there are no free SSI channels left. This doesn't mean failure. Rather,
 * it means that comms will proceed in bit banging mood.
 */
tbt42_errcheck tbt42_init(no_yes use_ssi, pl_io_num pin_cs, pl_io_num pin_clk,
                          pl_io_num pin_mosi, pl_io_num pin_miso, U8 *channel);

/*
 * Reads the current daycount, mincount, and seconds from the RTC. Use year(),
 * month(), date(), hours(), minutes(), and weekday() syscalls to convert these
 * values into the actual date and time.
 */
void tbt42_rtc_get(U16 *wdaycount, U16 *wmincount, U8 *bsec, pl_io_num pin_cs,
                   U8 channel);

/*
 * Writes the specified daycount, mincount, and seconds into the RTC. Use
 * daycount() and mincount() syscalls to convert your date and time into the
 * daycount and mincount values. Returns NG if values you supplied are invalid.
 */
ok_ng tbt42_rtc_set(U16 wdaycount, U16 wmincount, U8 bsec, pl_io_num pin_cs,
                    U8 channel);

/*
 * Sets the alarm if enable_alarm=YES. Disables the alarm if enable_alarm=NO.
 * With alarm enabled...<br> When wdaycount=0 AND wmincount=0 AND bsec=0 alarm
 * occurs every second.<br> When wdaycount=0 AND wmincount=0 AND bsec>0 alarm
 * occurs every minute and on the second specified by bsec.<br> When wdaycount>0
 * alarm occurs on the date/time specified by the combination of wdaycount,
 * wmincount, and bsec.
 */
ok_ng tbt42_alarm_set(unsigned int wdaycount, unsigned int wmincount, U8 bsec,
                      no_yes enable_alarm, pl_io_num pin_cs, U8 channel);

ok_ng tbt42_alarm_waiting(pl_io_num pin_miso, pl_io_num pin_cs, U8 channel);

/*
 * Returns NO if alarm is disabled or YES if enabled, in which case wdaycout,
 * wmincount, and bsec will contain current alarm settings.
 */
no_yes tbt42_alarm_setting_get(unsigned int *wdaycount, unsigned int *wmincount,
                               U8 *bsec, pl_io_num pin_cs, U8 channel);

/* Clears the alarm interrupt thus causing the INT line to go HIGH
 * (deactivate).*/
void tbt42_rtc_int_clear(pl_io_num pin_cs, U8 channel);

/*
 * Reads the current temperature. The temperature is measured in steps of 0.25
 * degrees C. Reading the temperature does not cause the actual temperature
 * measurement to occur. Measurements happen once in every 64 seconds and are
 * independent of temperature reads.
 */
float tbt42_temp_get(pl_io_num pin_cs, U8 channel);

/*
 * Reads a byte of data from the non-volatile memory at address 0~255.
 */
U8 tbt42_nvram_read(U8 address, pl_io_num pin_cs, U8 channel);

/*
 * Writes a byte of data into the non-volatile memory at address 0~255.
*/
void tbt42_nvram_write(U8 data_to_write, U8 address, pl_io_num pin_cs,
                       U8 channel);

#endif  // __LIBRARY_TIBBITS_TBT42_H__
