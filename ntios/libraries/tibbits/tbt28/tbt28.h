/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef _LIBRARIES_TIBBITS_TBT28_H_
#define _LIBRARIES_TIBBITS_TBT28_H_

/*
 * Call this function to initialize the Tibbit.
 * Use_ssi argument specifies whether you want to communicate with this Tibbit
 * using the SSI channel running in the I2C mode (YES), or go for direct I/O
 * manipulation a.k.a. bit-banging (NO). Note that there is a limited number of
 * SSI channels so if you set use_ssi=YES this function may return NG, meaning
 * that there are no free SSI channels left. This doesn't mean failure. Rather,
 * it means that comms will proceed in bit banging mood.
 */
ok_ng tbt28_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk,
                 pl_io_num pin_data, U8 *channel);

word tbt28_get(unsigned char *channel);

#endif /*_LIBRARIES_TIBBITS_TBT28_H_*/