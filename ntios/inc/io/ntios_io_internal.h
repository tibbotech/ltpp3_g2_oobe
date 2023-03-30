

#ifndef NTIOS_XPAT_IO_NTIOS_IO_INTERNAL_H_
#define NTIOS_XPAT_IO_NTIOS_IO_INTERNAL_H_

#include <cstdint>
#include <mutex>

#include "base/ntios_evfifo.h"
#include "base/ntios_types.h"

namespace ntios {

namespace io {

namespace internal {

using ntios::base::ev2_code_t;
using ntios::base::ev2_fifo_message_t;
using ntios::base::Ev2Fifo;

class IoInternal {
 private:
  static IoInternal* mInstance;
  static std::mutex mMutex;

 protected:
  IoInternal();
  ~IoInternal();

 public:
  IoInternal(IoInternal& other) = delete;
  void operator=(const IoInternal&) = delete;

  static IoInternal* GetInstance() {
    std::lock_guard<std::mutex> lock(mMutex);
    if (mInstance == nullptr) {
      mInstance = new IoInternal();
    }
    return mInstance;
  }

  void PlatformInit();
  void SetDirection(uint8_t, uint8_t direction, low_high value);
  void SetDirection(uint8_t, uint8_t direction);
  uint8_t GetDirection(uint8_t num);
  void SetState(uint8_t io, uint8_t state);
  uint8_t GetState(uint8_t io);
  void Invert(uint8_t io);
  void SetLedBar(uint8_t clknum, uint8_t datanum, uint8_t stateDecVal);

  void EnableInterrupt(uint8_t io, uint8_t intnum, pl_int_edge edge);
  void DisableInterrupt(uint8_t io, uint8_t intnum);
  bool IsInterruptEnabled(uint8_t intnum);
  uint8_t GetInterruptIo(uint8_t intnum);
  pl_int_edge PollInterrupt(uint8_t io, uint8_t intnum);
  void CheckInterrupts(Ev2Fifo& ev2);

  void SetPortDirection(uint8_t port, uint8_t direction);
  byte GetPortDirection(uint8_t port);
  void SetPortState(uint8_t port, uint8_t state);
  uint8_t GetPortState(uint8_t port);

  no_yes en_ev2_io_int;

};

}  // namespace internal
}  // namespace io
}  // namespace ntios

#endif  // NTIOS_XPAT_IO_NTIOS_IO_INTERNAL_H_
