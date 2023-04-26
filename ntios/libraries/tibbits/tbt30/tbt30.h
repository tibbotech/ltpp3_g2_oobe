/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef __LIBRARY_TIBBITS_TBT30_H__
#define __LIBRARY_TIBBITS_TBT30_H__

/* FUNCTIONS */
void tbt30_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk,
                pl_io_num pin_data, U8 *channel);
ok_ng tbt30_get_pc(float *humidity, float *temperature, U8 channel);
ok_ng tbt30_get(U16 *humidity, U16 *temperature, U8 channel);

#endif /* __LIBRARY_TIBBITS_TBT30_H__ */