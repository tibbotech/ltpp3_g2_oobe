
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_SYS_NTIOS_SYS_H_
#define NTIOS_XPAT_SYS_NTIOS_SYS_H_

#include <cmath>
#include <string>

#include "base/ntios_base.h"
#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "io/ntios_io_map.h"

typedef enum {
  PL_SYS_RESET_TYPE_INTERNAL,
  PL_SYS_RESET_TYPE_EXTERNAL,
} pl_sys_reset_type;

typedef enum {
  PL_SYS_EXT_RESET_TYPE_INTERNAL,
  PL_SYS_EXT_RESET_TYPE_WATCHDOG,
  PL_SYS_EXT_RESET_TYPE_POWERUP,
  PL_SYS_EXT_RESET_TYPE_BROWNOUT,
  PL_SYS_EXT_RESET_TYPE_RSTPIN
} pl_sys_ext_reset_type;

typedef enum {
  PL_SYS_MODE_RELEASE,
  PL_SYS_MODE_DEBUG,
} pl_sys_mode;

/* NAMESPACES */
namespace ntios {
namespace syst {

/**
 * @brief This is the sys. object, which loosely combines "general system" stuff
 * such as initialization (boot) event, buffer management, system timer, PLL
 * mode, and some other miscellaneous properties and methods.
 */
class SYS {
 public:
  SYS();
  ~SYS();

  /*Methods*/

  /**
   * @brief Call this method after requesting all buffers you need through
   * methods like ser.txbuffrq and sock.cmdbuffrq. This method takes a
   * significant amount of time (hundreds of milliseconds) to execute, during
   * which time the device cannot receive network packets, serial data, etc. For
   * certain interfaces like serial ports, some incoming data could be lost.
   *
   * Not all platforms may require buffer allocation. for backward compatibility
   * reasons, this method may be called even if the platform does not require
   * global buffer allocation.
   */
  virtual void buffalloc();

  /**
   * @brief Sends (prints) a string into the Output pane. This method allows you
   * to trace the execution of your application by printing messages in TIDE's
   * Output pane. This method only works when sys.runmode = 1 —
   * PL_SYS_MODE_DEBUG. It is ignored when the application is compiled for
   * release.
   *
   * @param str The string to print.
   */
  template <typename... Args>
  void debugprint(const string& str, Args const&... args) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-security"
    printf((const char*)str.c_str(), ntios::base::Argument(args)...);
#pragma GCC diagnostic pop
    fflush(stdout);
  }

  template <typename... Args>
  void debugprintline(const string& str, Args const&... args) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wformat-security"
    printf((const char*)str.c_str(), ntios::base::Argument(args)...);
    printf("\n");
    fflush(stdout);
#pragma GCC diagnostic pop
  }

  /**
   * @brief Delays the system for at least ms milliseconds.
   *
   * @param ms The number of milliseconds to delay the system.
   */
  void delayms(dword ms);

  /**
   * @brief Method should only be used under the guidance of Tibbo support
   * as part of advanced diagnostic procedures.
   * @param hfsr Hard fault status register
   * @param cfsr Configurable fault status registers
   * @param lr Link register
   * @param pc Program counter
   * @param current_lr Current link register
   */
  void getexceptioninfo(dword& hfsr, dword& cfsr, dword& lr, dword& pc,
                        dword& current_lr);

  /**
   * @brief Stops your program execution.
   * Once this method has been used, there is no way for your
   * device to resume execution without your help.
   */
  void halt();

  /**
   * @brief Reboots the device.
   */
  void reboot();

  /**
   * @brief Sets the serial number of the device.
   *
   * @param str the new serial number.
   * @return ok_ng
   */
  ok_ng setserialnum(string str);

  /*Properties*/

  /**
   * @brief If supported by the platform, this method returns the rest reason,
   * otherwise it returns PL_SYS_EXT_RESET_TYPE_RSTPIN.
   */
  Property<pl_sys_ext_reset_type, SYS> extresettype{
      this, nullptr, &SYS::extresettypeGetter, PropertyPermissions::Read};

  /**
   * @brief On platforms that do not support dynamic memoery, this property
   * returns the number of free (not yet allocated) buffer pages (one page= 256
   * bytes). On platforms that support dynamic memory, this property returns
   * 128;
   */
  Property<word, SYS> freebuffpages{this, nullptr, &SYS::freebuffpagesGetter,
                                    PropertyPermissions::Read};

  /**
   * @brief Returns the version of the Monitor/Loader.
   */
  Property<string, SYS> monversion{this, nullptr, &SYS::monversionGetter,
                                   PropertyPermissions::Read};

  /**
   * @brief  Sets/returns the period for the on_sys_timer event generation
   * expressed in 10ms intervals.
   */
  Property<unsigned char, SYS> onsystimerperiod{
      this, &SYS::onsystimerperiodSetter, &SYS::onsystimerperiodGetter,
      PropertyPermissions::ReadWrite};

  /**
   * @brief Returns the current reset type.
   *
   */
  Property<pl_sys_reset_type, SYS> resettype{
      this, nullptr, &SYS::resettypeGetter, PropertyPermissions::Read};

  /**
   * @brief Returns current run (execution) mode.
   *
   */
  Property<pl_sys_mode, SYS> runmode{this, nullptr, &SYS::runmodeGetter,
                                     PropertyPermissions::Read};

  /**
   * @brief Returns the serial number of the device.
   *
   */
  Property<string, SYS> serialnum{this, nullptr, &SYS::serialnumGetter,
                                  PropertyPermissions::Read};

  /**
   * @brief Returns the time (in half-second intervals) elapsed since the device
   * powered up.
   *
   */
  Property<word, SYS> timercount{this, nullptr, &SYS::timercountGetter,
                                 PropertyPermissions::Read};

  /**
   * @brief Returns the time (in half-second intervals) elapsed since the device
   * powered up.
   *
   */
  Property<dword, SYS> timercount32{this, nullptr, &SYS::timercount32Getter,
                                    PropertyPermissions::Read};

  /**
   * @brief Returns the amount of time (in milliseconds) elapsed since the
   * device powered up.
   * @remark Care should be exercised, because this property is not read-only.
   * For the read-only variant, see sys.timercountmse.
   */
  Property<dword, SYS> timercountms{this, &SYS::timercountmsSetter,
                                    &SYS::timercountmsGetter,
                                    PropertyPermissions::ReadWrite};
  /**
   * @brief Returns the amount of time (in milliseconds) elapsed since the
   * device powered up.
   */
  Property<dword, SYS> timercountmse{this, nullptr, &SYS::timercountmseGetter,
                                     PropertyPermissions::ReadWrite};

  /**
   * @brief  Returns the total amount of memory pages available for buffers
   * On ntios platforms this property is not used and always returns 256.
   */
  Property<word, SYS> totalbuffpages{this, nullptr, &SYS::totalbuffpagesGetter,
                                     PropertyPermissions::Read};

  /**
   * @brief Returns the version of the TiOS firmware.
   */
  Property<string, SYS> version{this, nullptr, &SYS::versionGetter,
                                PropertyPermissions::Read};

  Property<dis_en, SYS> wdautoreset{this, &SYS::wdautoresetSetter,
                                    &SYS::wdautoresetGetter,
                                    PropertyPermissions::ReadWrite};

  /**
   * @brief Enables the watchdog timer.
   *
   */
  Property<no_yes, SYS> wdenabled{this, &SYS::wdenabledSetter,
                                  &SYS::wdenabledGetter,
                                  PropertyPermissions::ReadWrite};

  /**
   * @brief Sets the watchdog timer period in seconds.
   *
   */
  Property<word, SYS> wdperiod{this, &SYS::wdperiodSetter, &SYS::wdperiodGetter,
                               PropertyPermissions::ReadWrite};

  /**
   * @brief Feeds the watchdog timer .
   *
   */
  void wdreset();

 private:
  /* System Status */

  pl_sys_mode mrunmode;
  pl_sys_mode runmodeGetter() const;

  pl_sys_reset_type mresettype;
  pl_sys_reset_type resettypeGetter() const;

  pl_sys_ext_reset_type mextresettype;
  pl_sys_ext_reset_type extresettypeGetter() const;

  /*Memory*/
  word totalbuffpagesGetter() const;

  word freebuffpagesGetter() const;

  string mserialnum;
  string serialnumGetter() const;

  /*System Timer*/
  const qword mTimeStampStartMs;
  qword mTimerCountMsStart;
  qword mTimerCountMsOffset;

  qword getTimestampMs() const;

  word timercountGetter() const;

  dword timercount32Getter() const;

  dword timercountmsGetter() const;

  void timercountmsSetter(dword timercountms);

  dword timercountmseGetter() const;

  byte onsystimerperiodGetter() const;
  void onsystimerperiodSetter(byte onsystimerperiod);

  /*Watchdog*/
  no_yes mwdenabled;
  no_yes wdenabledGetter() const;

  void wdenabledSetter(no_yes wdenabled);

  dis_en mwdautoreset;
  dis_en wdautoresetGetter() const;

  void wdautoresetSetter(dis_en wdautoreset);

  word mwdperiod;
  word wdperiodGetter() const;

  void wdperiodSetter(word wdperiod);

  pl_sys_speed_choices mspeed;
  pl_sys_speed_choices speedGetter() const;

  /*Version Information*/
  string mMonVersion;
  string monversionGetter() const;

  string mversion;
  string versionGetter() const;
};
}  // namespace syst
} /* namespace ntios */
#endif
