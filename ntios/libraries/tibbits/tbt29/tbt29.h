#ifndef _LIBRARIES_TIBBITS_TBT29_H_
#define _LIBRARIES_TIBBITS_TBT29_H_

typedef enum 
{
    TBT29_OK,
    TBT29_WRONG_MFGID,
    TBT29_WRONG_DEVID_REVISION,
    TBT29_NO_SSI_AVAILABLE,
} tbt29_errcheck;


tbt29_errcheck tbt29_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk, pl_io_num pin_data, unsigned char *channel);

float tbt29_get_c(unsigned char *channel);
int tbt29_get(unsigned char channel);

#endif