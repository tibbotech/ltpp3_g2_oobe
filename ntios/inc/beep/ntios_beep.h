/* Copyright 2021 Tibbo Technology Inc. */

#ifndef BEEP_NTIOS_BEEP_H_
#define BEEP_NTIOS_BEEP_H_

/* INCLUDES */
#include <string>

#include "beep/ntios_beepchannel.h"



/* EXTERN VARIABLES */
extern ntios::beeppattern::BEEP_channel beep_channel;



/* NAMESPACES */
namespace ntios {
namespace beeppattern {

/* CLASSES */
class BEEP_internal {
    friend class BEEP;
    friend class Periodic;

 public:
    /* CONSTRUCTOR */
    BEEP_internal() {}

    /* DESTRUCTOR */
    ~BEEP_internal() {}



    /*
    * Plays the specified pattern string 'beep_str' as specified in database 'pwmstates'.
    *
    * Remark:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull;This function is triggered in 'ntios_periodic.cpp' by function 'periodic_task_main'.
    */    
    void update();

 private:
    /* FUNCTIONS */
    bool update_isPlaying(pl_beep_seq beepseq);
};  // class BEEP_internal



class BEEP {
 public:
    /* CONSTRUCTOR */
    BEEP() : isBeepSpeedVal(BEEP_SPEED_20), \
            isBeepFreqVal(BEEP_FREQ_350K), \
            isBeepDutyCyclePercVal(BEEP_DUTY_CYCLE_PERC_50) {
        /* Initialize pwm */
        beep_channel.BEEP_pwm_init();

        /* Set pointers */
        BEEP_pwmstates_ctx_ptr = BEEP_pwmstates_ctx;
        beep_seqno_ptr = &beep_seqno;
        BEEP_updatequeues_ctx_ptr = BEEP_updatequeues_ctx;
        beep_updatequeues_index_ptr = &beep_updatequeues_index;
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~BEEP() {
    }



    /* PROPERTIES */
    /*
    * The Duty-Cycle-Percentage is defined as the fraction (%) of one period in which a signal or system is active.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 100.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 50.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; From 0 - 50: volume increases until the maximum (50 %) is reached.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; from 50 - 100: volume decreases until there is no sound (100 %).
    * Reference:
    *&nbsp;&nbsp;&nbsp;&nbsp; http://www.justanotherlanguage.org/content/tutorial_pwm2
    */
    Property<U8, BEEP> duty_cycle_perc{this, \
                        &BEEP::BeepDutyCyclePercSetter, \
                            &BEEP::BeepDutyCyclePercGetter, \
                                PropertyPermissions::ReadWrite};

    /*
    * Defines the buzzer frequency (frequency of the square wave output on the line).
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 1265 - 4294967295.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 350000.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If input value < 1265, then the frequency will be automatically set to 1265.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The frequency >= duty cycle (volume). 
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If beep.frequency < 1265 → an error would occur saying "write error: Device 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; or resource busy" (sysfs).
    */
    Property<U32, BEEP> frequency{this, \
                        &BEEP::BeepfreqSetter, \
                            &BEEP::BeepfreqGetter, \
                                PropertyPermissions::ReadWrite};

    /*
    * Sets/returns the speed at which the each beep-object (e.g., B, -, ~, *) is played.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: any value except for 0.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 20.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If value = 0, then speed will be automaticallly set to 20.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; speed is dependent on the time-interval (10ms) of the Global Loop.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For example, if speed = 20, then this means that Globally the Loop has 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to cycle at least 20 times before ONE beep-object (e.g. b, B, -) can be played.
    */
    Property<U32, BEEP> speed{this, \
                        &BEEP::BeepspeedSetter, \
                            &BEEP::BeepspeedGetter, \
                                PropertyPermissions::ReadWrite};

    /* 
    * Returns the beep-string in the 'on_beep' event.
    */
    Property<string, BEEP> beepstr{this, \
                        nullptr, \
                            &BEEP::BeepStringGetter, \
                                PropertyPermissions::Read};




    /* FUNCTIONS */

    /*
    * Loads new beeper pattern to play.
    * 
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: Pattern string, can include the following characters:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '-': the buzzer is off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'B' or 'b': the buzzer is on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '~': looped pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '*': double-speed pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; You can use this symbol twice to x4 speed.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; Adding even more '*' will not have any effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: flag which defines whether 'beep.play' is allowed to interrupt the 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; current played pattern or not:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_BEEP_NOINT: cannot interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_BEEP_CANINT: can interrupt.
    */
    void play(const string &pattern, pl_beep_int patint);

    /*
    * Loads new beeper pattern to play.
    * 
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: Pattern string, can include the following characters:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '-': the buzzer is off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'B' or 'b': the buzzer is on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '~': looped pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '*': double-speed pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; You can use this symbol twice to x4 speed.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; Adding even more '*' will not have any effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: flag which defines whether 'beep.play' is allowed to interrupt the 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; current played pattern or not:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_BEEP_NOINT: cannot interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_BEEP_CANINT: can interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patseq: flag which tells whether the specified pattern is part of a sequence=group or not.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_BEEP_SEQ_DISABLED.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_BEEP_SEQ_ENABLED.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Possible options:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_BEEP_CANINT & PL_BEEP_SEQ_DISABLED: CAN interrupt and overwrite patterns which are currently playing.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; All databases will be resetted (incl. elements flagged with 'PL_BEEP_SEQ_ENABLED')
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_BEEP_NOINT & PL_BEEP_SEQ_DISABLED: can NOT interrupt and overwrite pattern which is currently playing.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; If nothing is playing, then all databases will be resetted (incl. elements flagged with 'PL_BEEP_SEQ_ENABLED').
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_BEEP_CANINT & PL_BEEP_SEQ_ENABLED: CAN interrupt and overwrite patterns flagged with 'PL_BEEP_SEQ_ENABLED'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; The database elements which are marked with 'pl_beep_seq = PL_BEEP_SEQ_ENABLED' will be resetted/removed.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_BEEP_NOINT & PL_BEEP_SEQ_ENABLED: can NOT interrupt and overwrite any patterns.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; However, the specified pattern can be APPENDED to become part of a sequence-group.
    */ 
    void playseq(const string &pattern, \
                        pl_beep_int patint, \
                        pl_beep_seq patseq);



 private:
    /* PROPERTIES */
    /* <duty-cycle-perc> PROPERTY parameters & functions */
    U8 isBeepDutyCyclePercVal;
    void BeepDutyCyclePercSetter(U8 isBeepDutyCyclePerc);
    U8 BeepDutyCyclePercGetter() const;

    /* <frequency> PROPERTY parameters & functions */
    U32 isBeepFreqVal;
    void BeepfreqSetter(U32 isBeepFreq);
    U32 BeepfreqGetter() const;

    /* <speed> PROPERTY parameters & functions */
    U32 isBeepSpeedVal;
    void BeepspeedSetter(U32 isBeepSpeed);
    U32 BeepspeedGetter() const;

    /* <beepstr> PROPERTY parameters & functions */
    string BeepStringGetter() const;

    /* VARIABLES */

    /* 
    * Database containing information regarding a specific pattern.
    *
    * Remark:
    *   For more information, see structure 'beep_pwmstates_t' (file: ntios_beeptypes.h).
    */
    beep_pwmstates_t BEEP_pwmstates_ctx[NUM_BEEP_SEQNO_MAX] = {};

    /* 
    * parameter containing the current beep_seqno value.
    */
    U8 beep_seqno = 0;
    /* 
    * Database containing a list of to be played patterns which are ordened according to FIFO.
    */
    beep_updatequeues_t BEEP_updatequeues_ctx[NUM_BEEP_UPDATEQUEUE_MAX] = {};
    /*
    * Index which indicates:
    * 1. The CURRENT number of ITEMS in the database 'BEEP_updatequeues_ctx'.
    * 2. The next INDEX to be used to add element to database 'BEEP_updatequeues_ctx'.
    */
    U8 beep_updatequeues_index = 0;
};  // class BEEP

}  // namespace beeppattern
}  // namespace ntios


#endif  // BEEP_NTIOS_BEEP_H_
