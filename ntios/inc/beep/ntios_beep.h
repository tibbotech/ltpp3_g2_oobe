/* Copyright 2021 Tibbo Technology Inc. */

#ifndef NTIOS_XPAT_BEEP_NTIOS_BEEP_H_
#define NTIOS_XPAT_BEEP_NTIOS_BEEP_H_

#include <string>

#include "base/ntios_evfifo.h"
#include "beep/ntios_beepchannel.h"
#include "beep/ntios_beeptypes.h"

using ntios::base::Ev2Fifo;

namespace ntios {
namespace threads {
class Periodic;
}  // namespace threads
}  // namespace ntios

namespace ntios {
namespace beep {

class Beep {
  friend class ntios::threads::Periodic;

 public:
  /**
   * @brief Construct a new BEEP object
   *
   * @param ev
   */
  Beep(Ev2Fifo &ev2) : mBeepChannel(0, ev2) {}

#pragma region Properties
  /**
   * @brief Sets the frequency of the beep object.
   *
   * @param freq The frequency of the beep object in Hz.
   */
  Property<real, Beep> frequency{this, &Beep::BeepFreqSetter,
                                 &Beep::BeepFreqGetter,
                                 PropertyPermissions::ReadWrite};

  /**
   * @brief Sets the volume of the beep object.
   *
   * @param volume The volume of the beep object.
   *
   */
  Property<byte, Beep> volume{this, &Beep::BeepVolumeSetter,
                              &Beep::BeepVolumeGetter,
                              PropertyPermissions::ReadWrite};
#pragma endregion

  /**
   * @brief Loads new beeper pattern to play.
   *
   * @param pattern Pattern string, can include the following characters:
   * '-': the buzzer is off
   * 'B' or 'b': the buzzer is on
   * '~': looped pattern (can reside anywhere in the pattern string)
   * '*': double-speed pattern (can reside anywhere in the pattern string)
   *
   * @param patint Defines whether the beep.play method is allowed to interrupt
   * another pattern that is already playing: 0 — PL_BEEP_NOINT: cannot
   * interrupt 1 — PL_BEEP_CANINT: can interrupt)
   */
  void play(const string &pattern, pl_beep_int patint);

 private:
#pragma region Properties
  /* <duty-cycle-perc> PROPERTY parameters & functions */
  void BeepVolumeSetter(byte volume);
  byte BeepVolumeGetter() const;

  void BeepFreqSetter(real beepfreq);
  real BeepFreqGetter() const;

#pragma endregion

  void update() { mBeepChannel.update(); }

  ntios::internal::beep::BeepChannel mBeepChannel;

};  // class BEEP

}  // namespace beep
}  // namespace ntios

#endif  // NTIOS_XPAT_BEEP_NTIOS_BEEP_H_
