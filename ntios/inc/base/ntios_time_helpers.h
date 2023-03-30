
/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_BASE_NTIOS_TIME_HELPERS_H_
#define NTIOS_XPAT_BASE_NTIOS_TIME_HELPERS_H_
#include "base/ntios_types.h"
namespace ntios {
namespace base {
namespace time {
class TimeHelpers {
 public:
  static uint64_t getTickCountMS();
  static void incTickCount();
};
}  // namespace time
}  // namespace base
}  // namespace ntios

#endif  // NTIOS_XPAT_BASE_NTIOS_TIME_HELPERS_H_
