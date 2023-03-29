/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_BASE_NTIOS_EVFIFO_H_
#define NTIOS_XPAT_BASE_NTIOS_EVFIFO_H_

#include <stdexcept>
#include <string>

#include "base/ntios_config.h"
#include "base/ntios_types.h"

namespace ntios {
namespace base {
typedef enum { EV_TMR_10MS, EV_TMR_HALFSEC } ev1_code_t;

typedef enum {
  EV2_INIT,
  EV2_TMR,
  EV2_ON_PAT,
  EV2_ON_PAT_LEDBAR,
  EV2_SER_DATA,
  EV2_SER_SENT,
  EV2_SER_ESC,
  EV2_BTN_PRESSED,
  EV2_BTN_RELEASED,
  EV2_IO_INT,
  EV2_IO_INT_LINE
} ev2_code_t;

typedef struct {
  ev2_code_t code;
  U8 length;
  U8 data[MAX_EV2_DATA_LENGTH];
} ev2_fifo_message_t;

class Ev1Fifo {
 private:
  std::string name;
  TIOS_QUEUE mq;

 public:
  Ev1Fifo(std::string queueName, U32 maxItems);
  ~Ev1Fifo();
  bool in(ev1_code_t* ev);
  bool out(ev1_code_t* ev);
  uint32_t getCount();
};

class Ev2Fifo {
 private:
  std::string name;
  TIOS_QUEUE mq;

 public:
  Ev2Fifo(std::string queueName, U32 maxItems);
  ~Ev2Fifo();
  bool in(ev2_fifo_message_t* ev);
  bool out(ev2_fifo_message_t* ev);
  uint32_t getCount();
};

}  // namespace base
}  // namespace ntios

#endif  // NTIOS_XPAT_BASE_NTIOS_EVFIFO_H_
