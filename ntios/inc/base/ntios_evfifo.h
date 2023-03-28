/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef BASE_NTIOS_EVFIFO_H_
#define BASE_NTIOS_EVFIFO_H_

#include <mqueue.h>

#include <stdexcept>
#include <string>

#include "base/ntios_types.h"

namespace ntios {
namespace base {
typedef enum { EV_TMR_10MS, EV_TMR_HALFSEC } Ev1Code;
// typedef enum { EV2_INIT, EV2_TMR } Ev2Code;
typedef enum {
    EV2_INIT,
    EV2_TMR,
    EV2_ON_PAT,
    EV2_SER_DATA,
    EV2_SER_SENT,
    EV2_SER_ESC
} Ev2Code;

#define MAX_EV2_LENGTH 16

typedef struct {
  Ev2Code code;
  U8 length;
  // U8* data[MAX_EV2_LENGTH];
  U8 data[MAX_EV2_LENGTH];
} ev2_fifo_message_t;

template <class T>
class EvFifo {
 private:
  std::string name;
  mqd_t mq;
  bool isProducer;

 public:
  EvFifo(std::string queueName, bool isProducer, U32 maxItems);
  ~EvFifo();
  U8 in(T* ev);
  U8 out(T* ev);
};

template <class T>
EvFifo<T>::EvFifo(string queueName, \
                  bool isProducer, \
                    U32 maxItems) {
  struct mq_attr attr;
  name = queueName;
  attr.mq_flags = 0;
  attr.mq_maxmsg = 5;
  attr.mq_msgsize = sizeof(T);
  attr.mq_curmsgs = 0;

  if (isProducer) {
    mq = mq_open(name.c_str(), O_CREAT | O_WRONLY, 0700, &attr);
  } else {
    mq = mq_open(name.c_str(), O_CREAT | O_RDONLY, 0700, &attr);
  }
  if (mq < 0) {
    std::perror(("mq_open(-1) " + queueName + " failed").c_str());
    printf("ERROR: %d\n", errno);
    throw std::runtime_error("Unable to create queue");
  }
}

template <class T>
EvFifo<T>::~EvFifo() {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wterminate"
// A failure to close the queue should cause the program to terminate.
// This is intended behavior and should not be a warning.
if (mq_close(mq) < 0) {
    throw std::runtime_error("Unable to create queue");
}
if (!isProducer) {
    if (mq_unlink(name.c_str()) < 0) {
        throw std::runtime_error("Unable to create queue");
    }
}
#pragma GCC diagnostic pop
}

template <class T>
U8 EvFifo<T>::in(T* ev) {
    if (0 <= mq_send(mq, reinterpret_cast<char*>(ev), sizeof(T), 0)) {
        return 1;
    }

    std::perror(("mq_send(-1) " + this->name + " failed").c_str());
    printf("ERROR: %d\n", errno);

    return 0;
}

template <class T>
U8 EvFifo<T>::out(T* ev) {
    if (0 <= mq_receive(mq, reinterpret_cast<char*>(ev), sizeof(T), NULL)) {
      return 1;
    }

    // std::perror(("mq_receive(-1) " + this->name + "failed").c_str());
    // printf("ERROR: %d\n", errno);
    return 0;
}

typedef EvFifo<Ev1Code> Ev1Queue;
typedef EvFifo<ev2_fifo_message_t> Ev2Queue;

}  // namespace base
}  // namespace ntios

#endif  // BASE_NTIOS_EVFIFO_H_
