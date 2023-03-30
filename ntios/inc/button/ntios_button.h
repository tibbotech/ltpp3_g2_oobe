/* Copyright 2022 Tibbo Technology Inc. */

#ifndef NTIOS_XPAT_BUTTON_NTIOS_BUTTON_H_
#define NTIOS_XPAT_BUTTON_NTIOS_BUTTON_H_

#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "base/ntios_property.h"
#include "button/ButtonPeriodic.h"

namespace ntios{
  namespace threads {
    class Periodic;
  }
}


namespace ntios {
namespace button {

class Button {
 friend class ntios::threads::Periodic;
 public:
  Button(uint32_t gpio_num, Logger& log, Ev2Fifo& ev2)  { btn = new ButtonPeriodic(gpio_num, log, ev2);}
  ~Button();

  Property<no_yes, Button> pressed{this, nullptr, &Button::pressedGetter,
                                   PropertyPermissions::Read};
  Property<byte, Button> time{this, nullptr, &Button::timeGetter,
                              PropertyPermissions::Read};
  Property<uint64_t, Button> timems{this, nullptr, &Button::timeMsGetter,
                                   PropertyPermissions::Read};

 private:
  ButtonPeriodic *btn;
  ButtonPeriodic* getBtnPeriodic() { return btn; }
  uint64_t timeMsGetter() const;
  byte timeGetter() const;
  no_yes pressedGetter() const;
};
}  // namespace button
}  // namespace ntios

#endif  //  NTIOS_XPAT_BUTTON_NTIOS_BUTTON_H_
                  