/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_THREADS_NTIOS_P2_H_
#define NTIOS_XPAT_THREADS_NTIOS_P2_H_

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "threads/ntios_periodic.h"
#include "io/ntios_io.h"
// #include "threads/ntios_periodic.h"

/* DEFINES */
#ifndef P2_ON_SYS_INIT_LOGGING_ISNEABLED
#define P2_ON_SYS_INIT_LOGGING_ISNEABLED 0
#endif
#ifndef P2_ON_SYS_TIMER_LOGGING_ISNEABLED
#define P2_ON_SYS_TIMER_LOGGING_ISNEABLED 0
#endif
#ifndef P2_ON_BEEP_LOGGING_ISNEABLED
#define P2_ON_BEEP_LOGGING_ISNEABLED 1
#endif
#ifndef P2_ON_PAT_LOGGING_ISNEABLED
#define P2_ON_PAT_LOGGING_ISNEABLED 1
#endif
#ifndef P2_OTHER_LOGGING_ISNEABLED
#define P2_OTHER_LOGGING_ISNEABLED 0
#endif

/* FUNCTIONS */
/**
 * @brief The sys object provides a very important event- on_sys_init.
 * This event is guaranteed to be generated first when your device starts
 * running. Therefore, you should put all your initialization code for sockets,
 * ports, etc. into the event handler for this event.
 *
 * @return TIOS_WEAK
 */
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
 * @brief Periodic event which is Generated after a beep pattern has finished
 * playing.
 *
 * @remark
 * 1. This can only happen for "non-looped" patterns.
 * 2. Multiple on_beep events may be waiting in the event queue.
 * 3. The event won't be generated if the current pattern is superseded
 * (overwritten) by a new call to beep.play.
 */
TIOS_WEAK void on_beep();

/**
 * @brief Periodic event which is Generated after an LED pattern has finished
 * playing.
 *
 * @remark
 * 1. This can only happen for "non-looped" patterns.
 * 2. Multiple on_pat events may be waiting in the event queue.
 * 3. When the event handler for this event is entered, the pat.channel property
 *    is automatically set to the channel for which this event was generated.
 * 4. The event won't be generated if the current pattern is superseded
 * (overwritten) by a new call to pat.play.
 */
TIOS_WEAK void on_pat();


TIOS_WEAK void on_pat_ledbar();

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
TIOS_WEAK void on_io_int(byte linestate);

TIOS_WEAK void on_io_int_line(pl_io_num ionum, pl_int_num intnum, pl_int_edge edge);

TIOS_WEAK void on_button_pressed();

TIOS_WEAK void on_button_released();


/* NAMESPACES */
namespace ntios {
namespace threads {

using ntios::base::Ev1Fifo;
using ntios::base::Ev2Fifo;
using ntios::base::logging::Logger;
using ntios::threads::Periodic;
using ntios::base::ev2_fifo_message_t;
class P2 {
 private:
  TIOS_THREAD p2;
  Logger& p2Log;
  Ev2Fifo& ev2;
  Periodic& per;


 protected:
  static void p2_task_start(P2& obj);
  void p2_task_main();
  void platform_init();

 public:
  P2(Logger& log,
     Ev2Fifo& ev2,
     Periodic& per);  
  void start();
  void join();
  void doevent(const ev2_fifo_message_t& event );
};  // class P2

}  // namespace threads
}  // namespace ntios

#endif  // NTIOS_XPAT_THREADS_NTIOS_P2_H_
