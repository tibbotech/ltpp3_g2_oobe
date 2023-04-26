
/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_LINUX_LTPP3G2_BASE_NTIOS_CONFIG_H_
#define NTIOS_LINUX_LTPP3G2_BASE_NTIOS_CONFIG_H_

#include <mqueue.h>

#include <mutex>   // NOLINT Google style prefers 
#include <thread>  // NOLINT Google style does not like thread

#include "base/ntios_types.h"

#define NTIOS_PLATFORM_NAME "LTPP3G2"
#define NTIOS_VER_NUM "0.0.1"
#define NTIOS_VER_STRING '<', TIOS_PLATFORM_NAME, '-', TIOS_VER_NUM, '>', '\0'
extern std::mutex tios_critical_mutex;

/// TODO remove FROMISR variable use the
#define TIOS_IS_ISR() 0
#define TIOS_CREATE_ISRSTATUS()
#define TIOS_ENTER_CRITICAL()  tios_critical_mutex.lock()
#define TIOS_EXIT_CRITICAL()   tios_critical_mutex.unlock()

#define TIOS_NOSW_YES()   tios_critical_mutex.lock()
#define TIOS_NOSW_NO()    tios_critical_mutex.unlock()

#define TIOS_IN_RAM
#define TIOS_ALIGN_4 __attribute__((__aligned__(4)))

#define TIOS_THREAD std::thread
#define TIOS_QUEUE mqd_t

#define EV1_QUEUE_NAME "/ev1"
#define EV2_QUEUE_NAME "/ev2"

#define MAX_EV2_DATA_LENGTH 16

#define EV1_MAX_ITEMS 512
#define EV2_MAX_ITEMS 4096

#define TIOS_WEAK __attribute__((weak))



#define NUM_SSI_CHANNELS 8 /* used in ntios_ssi.h and ntios_ssi.cpp */

#define NUM_PAT_CHANNEL_USER_MAX 5
/* Remark: number 62 is derived from SIGNAL LED6 and LED2 */
#define NUM_PAT_CHANNEL_SIGNAL 62
#define NUM_PAT_CHANNEL_STATUS 0
#define NUM_PAT_CHANNEL_INUSE 6 /* channel: 0 - 4, 62 */
#define NUM_PAT_CHANNEL_MAX 255
#define NUM_PAT_CHANNEL_SEQNO_MAX 255
#define NUM_PAT_UPDATEQUEUE_MAX 255
/* Currently number of channels = 6 (channel: 0-4, 62) */
// #define NUM_PAT_UPDATEQUEUE_MAX ((NUM_PAT_CHANNEL_INUSE * \
                        // (NUM_PAT_CHANNEL_SEQNO_MAX + 1)) - 1)
#define NUM_PAT_SEQGRP_MAX 255
#define PAT_SPEED_20 20 /* Wait for 20 cycles */

#include "beep/ntios_beep_config.h"

#define MAX_UARTS 5
#define NUM_UARTS 4

#define DEFAULT_BUFF_SIZE 1024

#define MAX_SOCKETS 32

#define BTN_GPIO_NUM 59     ///

#endif  // BASE_NTIOS_CONFIG_H_
