/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef THREADS_NTIOS_PERIODIC_H_
#define THREADS_NTIOS_PERIODIC_H_

/* INCLUDES */
#include <signal.h> /* library used to handle different kind of signals */
#include <thread>  // NOLINT Google does not like thread

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"



/* TIOS_WEAK */
// TIOS_WEAK void tios_serv_watchdog() {}
// TIOS_WEAK void tios_serv_timercountms() {}
// TIOS_WEAK void tios_serv_beep_pat() {}
// TIOS_WEAK void tios_serv_btn() {}
// TIOS_WEAK void tios_serv_kp() {}
// TIOS_WEAK void tios_serv_pat(); ---> NOT USED ANYMORE, replaced by pat.update()



/* NAMESPACES */
namespace ntios {
namespace base {
/* CLASSES */
class Periodic {
    friend class sys;
    friend class P2;
    friend class P1;
    // friend class ser;
    // friend class SerialPort;

    std::thread periodic;
    logging::Logger periodicLog;
    Ev1Queue ev1;
    Ev2Queue ev2;
    sigset_t set;
    sigset_t sigset;

    U8 var_per_ctr = HALF_SEC_CONST;
    U8 half_sec_ctr = 0;  /* used to measure 1/2 second periods */
    const U8 HALF_SEC_CONST = 50;

    /* This variable is shared with P1 */
    volatile no_yes en_ev2_tmr;
    volatile no_yes en_ev_tmr_10ms;



 protected:
    TIOS_IN_RAM void periodic_task_main(void);
    void Wait();
    void Init();



 public:
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

}  // namespace base
}  // namespace ntios



#endif  // THREADS_NTIOS_PERIODIC_H_
