/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_P1_H_
#define NTIOS_P1_H_
#include <thread>  // NOLINT Google does not like thread
#include "base/ntios_periodic.h"
#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"

TIOS_IN_RAM void tios_p1_thread(void);

namespace ntios {
namespace base {

class P1 {
  friend class ser;
  std::thread p1;
  logging::Logger p1Log;
  EvFifo ev1;
  EvFifo ev2;
 

 protected:
  TIOS_IN_RAM void p1_task_main(void);

 public:
  P1();
  void start();
  void join();
};

}  // namespace base

}  // namespace ntios

#endif  // NTIOS_P1_H_
