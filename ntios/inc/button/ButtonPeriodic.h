/* Copyright 2022 Tibbo Technology Inc. */

#ifndef NTIOS_XPAT_BUTTON_BUTTONPERIODIC_H_
#define NTIOS_XPAT_BUTTON_BUTTONPERIODIC_H_

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "base/ntios_property.h"

namespace ntios {
namespace button {

class Periodic;  // forward declaration
using ntios::base::Ev2Fifo;
using ntios::base::logging::Logger;

class ButtonPeriodic {
  friend class Periodic;

 private:
  uint32_t gpio_num;
  Logger& btnLog;
  Ev2Fifo& ev2;
  const int BTN_DBNC_CONST = 3;
  uint8_t btn_dbnc_ctr;

  uint32_t btn_status;
  uint64_t btn_last_pressed_time;
  uint64_t btn_last_released_time;

 protected:
  uint32_t btnst;

 public:
  ButtonPeriodic(uint32_t gpio_num, Logger& log, Ev2Fifo& ev2);
  void platform_init();
  ~ButtonPeriodic();
  uint64_t getLastPressedTime();
  uint64_t getLastReleasedTime();
  bool getRawButtonState();
  bool getButtonState() { return btnst; }
  void update();
};
}  // namespace button
}  // namespace ntios

#endif  //  NTIOS_XPAT_BUTTON_BUTTONPERIODIC_H_
