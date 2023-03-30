
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_BASE_NTIOS_CBUFF_H_
#define NTIOS_XPAT_BASE_NTIOS_CBUFF_H_

#include "base/ntios_config.h"
#include "base/ntios_types.h"

namespace ntios {
namespace base {

class CircularBuffer {
  U8 *ptr;

 public:
  explicit CircularBuffer(U32 size);
  ~CircularBuffer();
  void clear();
  U32 cap_pages();
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

#endif  // NTIOS_XPAT_BASE_NTIOS_CBUFF_H_
