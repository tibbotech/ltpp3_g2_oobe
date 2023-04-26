#ifndef NTIOS_XPAT_PWM_NTIOS_PWM_INTERNAL_H_
#define NTIOS_XPAT_PWM_NTIOS_PWM_INTERNAL_H_

#include <cstdint>
#include <string>

#include "base/ntios_types.h"

namespace ntios {

namespace pwm {

namespace internal {
using std::string;
class pwm_internal {
 public:
  static void WriteValue(string path, string value);
  static void SetFrequencyAndDutyCycle(byte channel, double frequency,
                                       double dutycycle);
  static void EnablePwm(byte channel);
  static void DisablePwm(byte channel);
};

}  // namespace internal

}  // namespace pwm
}  // namespace ntios

#endif  // NTIOS_XPAT_PWM_NTIOS_PWM_INTERNAL_H_
