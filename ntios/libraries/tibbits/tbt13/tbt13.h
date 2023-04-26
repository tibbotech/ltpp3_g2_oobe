#ifndef _LIBRARIES_TIBBITS_TBT13_H_
#define _LIBRARIES_TIBBITS_TBT13_H_

enum tbt13_nums { ADC_1, ADC_2, ADC_3, ADC_4 };

/**
 * Call this function to initialize the Tibbit.
 * Use_ssi argument specifies whether you want to communicate with this Tibbit
 * using the SSI channel running in the I2C mode (YES), or go for direct I/O
 * manipulation a.k.a. bit-banging (NO). Note that there is a limited number of
 * SSI channels so if you set use_ssi=YES this function may return NG, meaning
 * that there are no free SSI channels left. This doesn't mean failure. Rather,
 * it means that comms will proceed in bit banging mood.
 */
ok_ng tbt13_init(string signature, pl_io_num data_pin, pl_io_num clk_pin,
                 unsigned char *tbt_channel, no_yes use_ssi);

/*
 * Selects an active ADC channel. Use tbt13_get_prev_mv() or tbt13_get_prev()
 * for actual conversion.
 */
void tbt13_channel_select(tbt13_nums channel, unsigned char tbt_channel);

/* Performs ADC conversion for the selected channel and returns PREVIOUS
 * conversion result expressed in mV. Select desired channel using
 * tbt13_channel_select() and remember to DISCARD the first result as it will
 * pertain to the conversion on the previous channel.
 */
int tbt13_get_prev_mv(unsigned char tbt_channel);

/*
 * Performs ADC conversion for the selected channel and returns PREVIOUS
 * conversion as an unsigned 10-bit value. The range is from 0 (-10V) to 1023
 * (+10V). Select desired channel using tbt13_channel_select() and remember to
 * DISCARD the first result as it will pertain to the conversion on the previous
 * channel.
 */
unsigned int tbt13_get_prev(unsigned char tbt_channel);

#endif  // _LIBRARIES_TIBBITS_TBT13_H_