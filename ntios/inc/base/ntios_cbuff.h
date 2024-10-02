
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_CBUFF_H_
#define NTIOS_CBUFF_H_

#include "base/ntios_config.h"
#include "base/ntios_types.h"

// This is c-buffer control structure:
#define CB_INPTR 0       // current committed input pointer
#define CB_INPTR_WT 4    // write transaction input pointer
#define CB_OUTPTR 8      // current committed output pointer
#define CB_OUTPTR_RT 12  // read transaction output pointer
#define CB_TOP 16        // top of data
#define CB_CAP 20        // capacity (32-bit value)
#define CB_FLAG_WT 24    // write transaction flag
#define CB_FLAG_RT 28    // read transaction flag
#define CB_DATA_BASE 32  // beginning of data itself

//-------------------------------------------------------------------------
#define _CB_INPTR (*(U32 *)(ptr + CB_INPTR))
#define _CB_INPTR_WT (*(U32 *)(ptr + CB_INPTR_WT))
#define _CB_OUTPTR (*(U32 *)(ptr + CB_OUTPTR))
#define _CB_OUTPTR_RT (*(U32 *)(ptr + CB_OUTPTR_RT))
#define _CB_TOP (*(U32 *)(ptr + CB_TOP))
#define _CB_CAP (*(U32 *)(ptr + CB_CAP))
#define _CB_FLAG_WT (*(ptr + CB_FLAG_WT))
#define _CB_FLAG_RT (*(ptr + CB_FLAG_RT))

namespace ntios {
namespace base {

class CircularBuffer {
  U8 *ptr;

 public:
  explicit CircularBuffer(U32 size);
  ~CircularBuffer();
  void clear();
  U32 cap_pages();
  //U32 cap();
  U32 cap() const;
  U32 free();
  U32 len();
  U8 check_wt_opened();
  U32 wt_len();
  U32 rt_len();
  U32 store_indir(U32 len, TIOS_ADDR *tptr);
  U32 fetch_indir(U32 len, TIOS_ADDR *tptr);
  U32 store(U8 *dptr, U32 len);
  U32 fetch(U8 *dptr, U32 len);
  void wt_commit();
  void rt_commit();
  void rt_commit_part(U32 len);
  void wt_abort();
  void rt_abort();
  U32 Resize(U32 size);
  U32 rawsize();
  /*
          void xmem_copy(U16 dest, U16 src, U16 len);
          void adjust_vars( U16 dis, U8 dir);
          */
 private:
  U32 size;
};

}  // namespace base

}  // namespace ntios

#endif  // NTIOS_CBUFF_H_
