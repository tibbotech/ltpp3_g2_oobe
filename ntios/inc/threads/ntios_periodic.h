/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_THREADS_NTIOS_PERIODIC_H_
#define NTIOS_XPAT_THREADS_NTIOS_PERIODIC_H_

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "button/ButtonPeriodic.h"
#include "button/ntios_button.h"
#include "pat/ntios_pat.h"
#include "beep/ntios_beep.h"
#include "beep/ntios_beepchannel.h"

/* TIOS_WEAK */
// TIOS_WEAK void tios_serv_watchdog() {}
// TIOS_WEAK void tios_serv_timercountms() {}
// TIOS_WEAK void tios_serv_beep_pat() {}
// TIOS_WEAK void tios_serv_btn() {}
// TIOS_WEAK void tios_serv_kp() {}
// TIOS_WEAK void tios_serv_pat(); ---> NOT USED ANYMORE, replaced by
// pat.update()

/* NAMESPACES */
namespace ntios {
namespace threads {
/* CLASSES */

using ntios::base::Ev1Fifo;
using ntios::base::Ev2Fifo;
using ntios::base::logging::Logger;
using ntios::button::ButtonPeriodic; 
using ntios::button::Button; 
using ntios::beep::Beep;
using ntios::pattern::PAT;
using ntios::internal::beep::BeepChannel;
using ntios::pattern::PAT_internal;

class Periodic {
  // friend class sys;
  friend class P2;
  friend class P1;
  // friend class Button_internal;
  //  friend class ser;
  //  friend class SerialPort;

  TIOS_THREAD periodic;
  Logger& periodicLog;
  Ev1Fifo& ev1;
  Ev2Fifo& ev2;
  ButtonPeriodic& btnper; 
  PAT_internal& pat_internal;
  Beep& beep; 

  const U8 HALF_SEC_CONST = 50;
  U8 var_per_ctr = HALF_SEC_CONST;
  U8 half_sec_ctr = 0; /* used to measure 1/2 second periods */

  /* This variable is shared with P1 */
  volatile no_yes en_ev2_tmr;
  volatile no_yes en_ev_tmr_10ms;

 protected:
  static void periodic_task_start(Periodic& obj);
  TIOS_IN_RAM void periodic_task_main();
  void platform_init();
  void Wait();

 public:
  Periodic(Logger& log, Ev1Fifo& ev1, Ev2Fifo& ev2, Button& button, PAT& pat, Beep &beep);
  /*
   * Remarks:
   *   The variable can be changed with 'sys.onsystimerperiod'
   *   For example: sys.onsystimerperiod = 50 (500ms) (Default)
   */
  U8 ev2_tmr_period = 50;

  Periodic();
  void start();
  void join();
};

}  // namespace threads
}  // namespace ntios

#endif  // NTIOS_XPAT_THREADS_NTIOS_PERIODIC_H_
