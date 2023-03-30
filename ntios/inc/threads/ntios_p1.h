/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_THREADS_NTIOS_P1_H_
#define NTIOS_XPAT_THREADS_NTIOS_P1_H_

/* INCLUDES */

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "threads/ntios_periodic.h"

/* NAMESPACES */
namespace ntios {
namespace threads {

using ntios::base::Ev1Fifo;
using ntios::base::Ev2Fifo;
using ntios::base::logging::Logger;
// using ntios::base::Periodic;

class P1 {
 private:
  TIOS_THREAD p1;
  Logger& p1Log;
  Ev1Fifo& ev1;
  Ev2Fifo& ev2;
  Periodic& per;

 protected:
  static void p1_task_start(P1& obj);
  void p1_task_main();
  void platform_init();

 public:
  P1(Logger& log, Ev1Fifo& ev1, Ev2Fifo& ev2, Periodic& per);
  void start();
  void join();
};

}  // namespace threads
}  // namespace ntios

#endif  // NTIOS_XPAT_THREADS_NTIOS_P1_H_
