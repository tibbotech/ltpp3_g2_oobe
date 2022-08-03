/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef THREADS_NTIOS_P1_H_
#define THREADS_NTIOS_P1_H_

/* INCLUDES */
#include <thread>  // NOLINT Google does not like thread
#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "threads/ntios_periodic.h"


/* FUNCTIONS */
TIOS_IN_RAM void tios_p1_thread(void);
TIOS_WEAK void tios_check_uarts() {}



/* NAMESPACES */
namespace ntios {
namespace base {
class P1 {
  std::thread p1;
  logging::Logger p1Log;
  Ev1Queue ev1;
  Ev2Queue ev2;
  ntios::base::Periodic& per;
 protected:
  TIOS_IN_RAM void p1_task_main(void);

 public:
  P1();
  void start();
  void join();
};

}  // namespace base
}  // namespace ntios

#endif  // THREADS_NTIOS_P1_H_
