#include "base/ntios_property"
#include "base/ntios_types.h"

namespace ntios {
namespace base {
#define on_sys_init (main)
class sys {
 public:
  debugprint(string s);

  /**
   * @brief Property to set/return the period on which the event method
   * 'on_sys_timer' are generated.
   *
   * @remarks
   * Default value = 500 [ms].
   * Define in 1 [ms] increment.
   */
  Property<int, sys> onsystimerperiod{this, &sys::onSysTimerPeriodSetter,
                                      &sys::onSysTimerPeriodGetter,
                                      PropertyPermissions::ReadWrite};

 private:
  
  /**
   * @brief Sets the period on which the on_sys_timer are be generated.
   *
   * @param timerPeriod The specified on_sys_timer period in [ms].
   */
  void onSysTimerPeriodSetter(int timerPeriod);

  /**
   * @brief Returns the period on which the on_sys_timer event are generated.
   *
   * @return int.
   */
  int onSysTimerPeriodGetter() const;
};
}  // namespace base
}  // namespace ntios
