/*Copyright 2021 Tibbo Technology Inc.*/

/*
***********************************************************************************************************
*            SSI CHANNEL ALLOCATION LIBRARY
***********************************************************************************************************
*/
/* INCLUDES */
#include <array>
#include <string>

#include "global.h"

/* DEFINES */
#define SSI_STAMP "SSI> "
#define SSI_CR_LF chr(13) + chr(10)
#define SSI_MAX_CHANNELS 4
#define SSI_UNUSED_SIGNATURE "----"
#define SSI_INIT_SIGNATURE 0x1252

/* PRE-DEFINED FUNCTIONS */
void ssi_init();
void ssi_debugprint(const string &print_data);

/* ARRAYS */
no_yes ssi_in_use[SSI_MAX_CHANNELS];
/* Original definition (Not working */
string ssi_user_signature[SSI_MAX_CHANNELS];

/* VARIBLES */
U16 ssi_init_flag;

/* FUNCTIONS */

U8 ssi_get(const string &signature) {
  U8 f, ret;

  if (ssi_init_flag != SSI_INIT_SIGNATURE) {
    ssi_init();
    ssi_init_flag = SSI_INIT_SIGNATURE;
  }

  for (f = 0; f <= SSI_MAX_CHANNELS - 1; f++) {
    if (ssi_in_use[f] == NO) {
      ssi_in_use[f] = YES;
      ssi_user_signature[f] = signature;
      ret = f;
#if SSI_DEBUG_PRINT
      ssi_debugprint("'" + ssi_user_signature[f] + "' got SSI channel #" +
                     str(f));
#endif

      return ret;
    }
  }

// no free SSI channels found
#if SSI_DEBUG_PRINT
  ssi_debugprint("'" + signature + "'" +
                 "could not get an SSI channel: no free channels left");
#endif

  ret = 255;
  return ret;
}

//--------------------------------------------------------------------
string ssi_who_uses(U8 ssi_num) {
  /* Returns the signature of the specified SSI channel's user. */
  string ssi_who_uses;
  if (ssi_init_flag != SSI_INIT_SIGNATURE) {
    ssi_init();
    ssi_init_flag = SSI_INIT_SIGNATURE;
  }

  if (ssi_in_use[ssi_num] == NO) {
    ssi_who_uses = SSI_UNUSED_SIGNATURE;
  } else {
    ssi_who_uses = ssi_user_signature[ssi_num];
  }
  return ssi_who_uses;
}

//--------------------------------------------------------------------
void ssi_release(unsigned char ssi_num) {
  /*
   * Releases the SSI channel (number), restores the channel's properties to
   * their default states.
   */
  U8 ssi_bup;
  // U16 i;

  if (ssi_init_flag != SSI_INIT_SIGNATURE) {
    ssi_init();
    ssi_init_flag = SSI_INIT_SIGNATURE;
  }

  ssi_bup = ssi.channel;
  ssi.channel = ssi_num;

  /*
   * restore this SSI channel to its default state (except mapping)
   */
  ssi.enabled = NO;
  ssi.baudrate = PL_SSI_BAUD_FASTEST;
  ssi.direction = PL_SSI_DIRECTION_RIGHT;
  ssi.mode = PL_SSI_MODE_0;
  ssi.zmode = PL_SSI_ZMODE_ALWAYS_ENABLED;

#if SSI_DEBUG_PRINT

  ssi_debugprint("'" + ssi_user_signature[ssi_num] +
                 "' released SSI channel #" + str(ssi_num));
#endif

  ssi_in_use[ssi_num] = NO;
  ssi_user_signature[ssi_num] = SSI_UNUSED_SIGNATURE;
  ssi.channel = ssi_bup;
}

//------------------------------------------------------------------------------
void ssi_init() {
  unsigned char f;

  for (f = 0; f <= (SSI_MAX_CHANNELS - 1); f++) {
    ssi_in_use[f] = NO;
    ssi_user_signature[f] = SSI_UNUSED_SIGNATURE;
  }
}

//------------------------------------------------------------------------------
#if SSI_DEBUG_PRINT
void ssi_debugprint(const string &print_data) {
  sys.debugprint(SSI_STAMP + (print_data.c_str()) + SSI_CR_LF);
}
#endif
