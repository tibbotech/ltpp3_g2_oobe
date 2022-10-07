/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_P2_H_
#define NTIOS_P2_H_
#include <signal.h>

#include <thread>  // NOLINT Google does not like thread

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"

TIOS_WEAK void on_sys_init();

/**
 * @brief Periodic event which is generated at intervals defined by the
 * sys.onsystimerperiod property.
 *
 * @remark A word of caution. Using 'doevents' statement may lead to the
 * skipping (loss) of the events which are waiting in the queue. However, since
 * the 'on_sys_timer' event is generated periodically, the queued events, which
 * were skipped earlier on, would be executed anyways.
 */
TIOS_WEAK void on_sys_timer();

/**
 * @brief This event is generated when a state change (from LOW to HIGH or vice
 * versa) on one or multiple enabled interrupt lines is detected.
 *
 * @remark Each bit of the linestate argument corresponds with one interrupt
 * line. When it comes to the 'bit-dec-value' it would look like this:
 * PL_INT_NUM_0 = 1
 * PL_INT_NUM_1 = 2
 * PL_INT_NUM_2 = 4
 * PL_INT_NUM_3 = 8
 * PL_INT_NUM_4 = 16
 * PL_INT_NUM_5 = 32
 * PL_INT_NUM_6 = 64
 * PL_INT_NUM_7 = 128
 * Note: the above interrupt-number vs. bit-dec-value relationship is according
 * to TiOS definition.
 *
 * All interrupt lines are disabled by default and can be enabled individually
 * through the io.intenabled property.
 *
 * @param linestate
 */
TIOS_WEAK void on_io_int(int linestate);

namespace ntios {
namespace base {

using base::logging::Logger;

class P2 {
  std::thread p2;
  Logger p2Log;
  EvFifo ev2;

 protected:
  TIOS_IN_RAM void p2_task_main(void);

 public:
  P2();
  void start();
  void join();
};

}  // namespace base

}  // namespace ntios

#endif  // NTIOS_P2_H_
