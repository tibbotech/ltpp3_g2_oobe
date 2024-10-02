/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef BASE_NTIOS_BASE_H_
#define BASE_NTIOS_BASE_H_



/* INCLUDES */
#include <string>

#include "base/ntios_log.h"
#include "base/ntios_types.h"
#include "threads/ntios_p1.h"
#include "threads/ntios_p2.h"
#include "io/ntios_io.h"
#include "ssi/ntios_ssi.h"
#include "sys/ntios_sys.h"



/* USING */
using std::string;



/* NAMESPACES */
namespace ntios {
namespace base {
/* CLASSES */
class P1;
class P2;
}  // namespace base

namespace serial {
/* CLASSES */
class ser;
class SerialPort;
}  // namespace serial


}  // namespace ntios
#endif  // BASE_NTIOS_BASE_H_
