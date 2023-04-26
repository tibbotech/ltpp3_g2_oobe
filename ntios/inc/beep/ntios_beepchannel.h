/* Copyright 2021 Tibbo Technology Inc. */

#ifndef BEEP_NTIOS_BEEPCHANNEL_H_
#define BEEP_NTIOS_BEEPCHANNEL_H_

#include <cstring>
#include <map>
#include <string>
#include <mutex>
#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "beep/ntios_beeptypes.h"
#include "syscalls/ntios_conv.h"
#include "syscalls/ntios_strman.h"






namespace ntios {
namespace internal {
namespace beep {

typedef struct {
  U8 BeepSpeed;
  U8 BeepSpeedCounter;
  U8 BeepSpeedDiv;
  U8 BeepIndex;
  bool LoopEnabled;
  string CleanPattern;
  bool IsPlaying;
} beep_pattern_t;


using ntios::base::Ev2Fifo;

typedef enum { BEEP_OFF, BEEP_ON } pl_beep_beepstate;

typedef enum { APPEND, SUBSTITUTE } pl_beep_updatetype;

typedef enum { DELETE_OFF, DELETE_ALL } pl_beep_del_state;

class BeepChannel {
 public:
  /**
   * @brief Construct a new BeepChannel object
   *
   * @param ev2 the queue in which to push events
   */
  BeepChannel(byte num, Ev2Fifo &ev2) : num(num), ev2(ev2), mFrequency(BEEP_FREQ_DEFAULT), mVolume(BEEP_DUTY_CYCLE_PERC_50) { pwm_init(); };

  /**
   * @brief Begins playing a sequence of beeps.
   *
   * @param pattern
   * @param patint
   */
  void playseq(const string &pattern, pl_beep_int patint);

  /**
   * @brief Get the Frequency object
   *
   * @return float
   */
  float getFrequency() const;

  /**
   * @brief Set the Frequency object
   *
   * @param freq
   */
  void setFrequency(float freq);

  /**
   * @brief Get the Volume object
   *
   * @return byte
   */
  byte getVolume() const;

  /**
   * @brief Set the Volume object
   *
   * @param volume
   */
  void setVolume(byte volume);

  /**
   * @brief Initializes the pwm output
   *
   */
  void pwm_init();

  /**
   * @brief Updates the pattern being played.
   *
   * @remark this is called by the periodic thread
   */
  void update();

  /**
   * @brief Enables or disables the pwm output
   *
   * @param isEnabled
   */
  void enabled(no_yes isEnabled);

  void PrepareNextPattern(const string &pattern);

 private:
  Ev2Fifo &ev2;
  byte mVolume;
  U32 mDutyCycle;
  float mFrequency;
  byte num;
  beep_pattern_t mNextPattern;
  beep_pattern_t mCurrentPattern;
  std::mutex mCurrentPatternMutex;
};

}  // namespace beep
}  // namespace internal
}  // namespace ntios

#endif  // BEEP_NTIOS_BEEPCHANNEL_H_
