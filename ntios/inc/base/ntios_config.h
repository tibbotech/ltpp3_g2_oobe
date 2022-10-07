/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_CONFIG_H_
#define NTIOS_CONFIG_H_

#include <mutex>  // NOLINT Google does not like mutex
#define NTIOS_PLATFORM_NAME "LTPP3G2"
#define NTIOS_VER_NUM "0.0.1"
#define NTIOS_VER_STRING '<', TIOS_PLATFORM_NAME, '-', TIOS_VER_NUM, '>', '\0'
extern std::mutex tios_critical_mutex;

/// TODO remove FROMISR variable use the
#define TIOS_IS_ISR() 0
#define TIOS_CREATE_ISRSTATUS()
#define TIOS_ENTER_CRITICAL() //tios_critical_mutex.lock()
#define TIOS_EXIT_CRITICAL() //tios_critical_mutex.unlock()

#define TIOS_NOSW_YES() //tios_critical_mutex.lock()
#define TIOS_NOSW_NO() //tios_critical_mutex.unlock()

#define TIOS_IN_RAM
#define TIOS_ALIGN_4 __attribute__((__aligned__(4)))

#define EV1_QUEUE_NAME "/EV1Q"

#define EV2_QUEUE_NAME "/EV2Q"

#define EV1_MAX_ITEMS 64

#define EV2_MAX_ITEMS 64

#define TIOS_WEAK __attribute__((weak))



#define NUM_IO 56
#define NUM_IO_PORT 4

#define MAX_UARTS 5
#define	NUM_UARTS 4

#define DEFAULT_BUFF_SIZE 1024

#define MAX_SOCKETS 32




#endif  // NTIOS_CONFIG_H_
