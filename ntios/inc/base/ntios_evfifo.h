/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_EVFIFO_H_
#define NTIOS_EVFIFO_H_

#include <mqueue.h>

#include <string>

#include "base/ntios_types.h"
namespace ntios {
namespace base {
typedef enum  { EV_TMR_10MS } Ev1Code;
typedef enum  { EV2_INIT, EV2_TMR }Ev2Code;

#define MAX_EV2_LENGTH 16
typedef struct {
  Ev2Code code;
  U8 length;
  U8* data[MAX_EV2_LENGTH];
} ev_fifo_message_t;

class EvFifo {
 private:
  std::string name;
  mqd_t mq;
  bool isProducer;

 public:
  EvFifo(std::string queueName, bool isProducer, U32 maxItems);
  ~EvFifo();
  U8 in(ev_fifo_message_t* ev);
  U8 out(ev_fifo_message_t* ev);
};
}  // namespace base

}  // namespace ntios

#endif  // NTIOS_EVFIFO_H_
