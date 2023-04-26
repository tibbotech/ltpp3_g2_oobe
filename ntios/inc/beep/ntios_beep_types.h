#ifndef 

/* ENUMS */
typedef enum {
  /**
   * @brief PLATFORM CONSTANT. Tells the beep.play method that the new pattern
   * can only be loaded if NO pattern is playing at the moment.
   */
  PL_BEEP_NOINT = 0,
  /**
   * @brief PLATFORM CONSTANT. Tells the beep.play method that the new pattern
   * can be loaded even if another pattern is playing at the moment.
   * @remark the pattern which is currently being played will be terminated.
   */
  PL_BEEP_CANINT = 1
} pl_beep_int;