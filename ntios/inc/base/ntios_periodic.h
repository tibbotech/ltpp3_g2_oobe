/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_PERIODIC_H_
#define NTIOS_PERIODIC_H_
#include <signal.h>

#include <thread>  // NOLINT Google does not like thread

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"

TIOS_WEAK void tios_serv_watchdog(){};
TIOS_WEAK void tios_serv_timercountms(){};
TIOS_WEAK void tios_serv_pat(){};
TIOS_WEAK void tios_serv_beep_pat(){};
TIOS_WEAK void tios_serv_btn(){};
TIOS_WEAK void tios_comm_serv_ichar_delay(){};
TIOS_WEAK void tios_serv_kp(){};

namespace ntios {
namespace base {

class Periodic {
  friend class sys;
  std::thread periodic;
  logging::Logger periodicLog;
  EvFifo ev1;
  EvFifo ev2;
  sigset_t set;
  sigset_t sigset;

  no_yes en_ev2_tmr = HALF_SEC_CONST;
  U8 var_per_ctr = HALF_SEC_CONST;
  U8 half_sec_ctr = 0;  // used to measure 1/2 second periods
  U8 ev2_tmr_period=0;
  const U8 HALF_SEC_CONST = 50;

 protected:
  TIOS_IN_RAM void periodic_task_main(void);
  void Wait();
  void Init();

 public:
  Periodic();
  void start();
  void join();
};

}  // namespace base

}  // namespace ntios

#endif  // NTIOS_PERIODIC_H_
