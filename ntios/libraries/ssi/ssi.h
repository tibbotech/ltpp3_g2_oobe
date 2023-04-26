/*Copyright 2021 Tibbo Technology Inc.*/

//***********************************************************************************************************
//			SSI CHANNEL ALLOCATION LIBRARY
//***********************************************************************************************************

#ifndef __LIBRARIES_SSI_H__
#define __LIBRARIES_SSI_H__

// 1- debug output in console
// 0- no debug output
#ifndef SSI_DEBUG_PRINT
#define SSI_DEBUG_PRINT 0
#endif

// Maximum length of the SSI channel user's signature string
#ifndef SSI_MAX_SIGNATURE_LEN

#define SSI_MAX_SIGNATURE_LEN 3

#endif

/*
 * Returns a free SSI channel number or 255 if no free channels left.
 */
U8 ssi_get(const string &signature);

string ssi_who_uses(U8 ssi_num);

void ssi_release(U8 ssi_num);

#endif  // __LIBRARIES_SSI_H__