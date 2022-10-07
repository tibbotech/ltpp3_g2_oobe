#ifndef NTIOS_BASE_
#define NTIOS_BASE_

#include "base/ntios_log.h"
#include "base/ntios_p1.h"
#include "base/ntios_p2.h"
#include "base/ntios_types.h"
#include "io/ntios_io.h"
#include "ser/ntios_ser.h"
#include "ser/ntios_serialport.h"

using std::string;

extern ntios::base::P1 p1;
extern ntios::base::P2 p2;
extern ntios::base::Periodic per;
extern ntios::serial::ser ser;
extern ntios::io io;

#endif