/* Copyright 2021 Tibbo Technology Inc. */

#ifndef BEEP_NTIOS_BEEPCHANNEL_H_
#define BEEP_NTIOS_BEEPCHANNEL_H_

/* INCLUDES */
#include <cstring>
#include <map>
#include <string>

#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "beep/ntios_beeptypes.h"
#include "io/ntios_iotypes.h"
#include "syscalls/ntios_strman.h"
#include "syscalls/ntios_conv.h"
#include "sysfsfunc/ntios_sysfsfunc.h"



/* NAMESPACES */
namespace ntios {
namespace beeppattern {

/* CLASS */
class BEEP_channel {
 public:
    /* CONSTRUCTOR */
    BEEP_channel() : isBeepSpeedVal(BEEP_SPEED_20), \
            isBeepFreqVal(BEEP_FREQ_350K), \
            isBeepDutyCyclePercVal(BEEP_DUTY_CYCLE_PERC_50) {
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~BEEP_channel() {}



    /* PROPERTIES */
    Property<U8, BEEP_channel> duty_cycle_perc{this, \
                        &BEEP_channel::BeepDutyCyclePercSetter, \
                            &BEEP_channel::BeepDutyCyclePercGetter, \
                                PropertyPermissions::ReadWrite};

    Property<U32, BEEP_channel> frequency{this, \
                        &BEEP_channel::BeepfreqSetter, \
                            &BEEP_channel::BeepfreqGetter, \
                                PropertyPermissions::ReadWrite};

    Property<U32, BEEP_channel> speed{this, \
                        &BEEP_channel::BeepspeedSetter, \
                            &BEEP_channel::BeepspeedGetter, \
                                PropertyPermissions::ReadWrite};

    /* 
    * Parameter which is used by 'on_beep_handler' (file: ntios_p2.cpp).
    * This parameter must be PUBLIC.
    */
    string isBeepStrVal;
    Property<string, BEEP_channel> beepstr{this, \
                        nullptr, \
                            &BEEP_channel::BeepStringGetter, \
                                PropertyPermissions::Read};



    /* FUNCTIONS */
    void playseq(U8 beepdutycycleperc, \
                        U32 beepfreq, \
                        U32 beepspeed, \
                        const string &pattern, \
                        pl_beep_int patint, \
                        pl_beep_seq beepseq);

    void update(string beepstr, \
                        U8 beepseqno, \
                        pl_beep_seq beepseq, \
                        U16 updatequeues_index);

    void BEEP_updatequeues_remove(pl_beep_play_state beepPlayState);

    void BEEP_pwm_init();   /* is used in ntios_beep.h > CONSTRUCTOR */

    void BEEP_set_dutycyle(U32 isDutyCycle);
    void BEEP_set_enable(no_yes isEnabled);
    void BEEP_set_freq(U32 isFreq);

 private:
    /* CONSTANTS */
    const U8 BEEP_NUMOFDIGIT_1 = 1;
    const U8 BEEP_NUMOFDIGIT_2 = 2;
    const U16 BEEP_LIMIT65K = 65535;

    /* ENUMERATES */
    typedef enum {
        BEEP_OFF,
        BEEP_ON
    } pl_beep_beepstate;

    typedef enum {
        APPEND,
        SUBSTITUTE
    } pl_beep_updatetype;

    typedef enum {
        DELETE_OFF,
        DELETE_ALL
    } pl_beep_del_state;


    /* PROPERTIES */
    /* <duty-cycle-perc> PROPERTY parameters & functions */
    U8 isBeepDutyCyclePercVal;
    void BeepDutyCyclePercSetter(U8 isBeepDutyCyclePerc);
    U8 BeepDutyCyclePercGetter() const;

    /* <frequency> PROPERTY parameters & functions */
    U32 isBeepFreqVal;
    void BeepfreqSetter(U32 isBeepFreq);
    U32 BeepfreqGetter() const;

    /* <patspeed> PROPERTY parameters & functions */
    U32 isBeepSpeedVal;
    void BeepspeedSetter(U32 isBeepSpeed);
    U32 BeepspeedGetter() const;

    /* <beepstr> PROPERTY parameters & functions */
    string BeepStringGetter() const;



    /* FUNCTIONS */
    bool BEEP_isAllowedToPlay(pl_beep_int patint, \
                        pl_beep_seq beepseq, \
                        U8 *beepseqno, \
                        pl_beep_del_state *beepdelstate);
    bool BEEP_pattern_isPlaying( \
                        pl_beep_seq_status beepseqstatus);
    bool BEEP_beepseqno_isAvailable(U8 *beepseqno);
    bool BEEP_updatequeues_matchIsFound(U8 beepseqno);
    U16 BEEP_get_available_channel_seqno();

    void BEEP_updatequeues_subst_and_append(string beepstr, \
                        U8 beepseqno, \
                        pl_beep_seq beepseq, \
                        pl_beep_play_state beep_patPlayState_append, \
                        pl_beep_play_state beep_patPlayState_subst, \
                        U16 updatequeues_index);
    void BEEP_updatequeues_substOrAppend(string beepstr, \
                        U8 beepseqno, \
                        pl_beep_seq beepseq, \
                        pl_beep_seq_status beepseqstatus, \
                        pl_beep_play_state beepplaystate_subst, \
                        U16 updatequeues_index, \
                        pl_beep_updatetype beepupdatetype);
    void BEEP_updatequeues_update(string beepstr_update, \
                        U8 beepseqno_update, \
                        pl_beep_seq beepseq_update, \
                        pl_beep_seq_status seqstatus_update, \
                        pl_beep_play_state patPlayState_subst_update, \
                        no_yes remove_entry_isPresent_update, \
                        U16 updatequeues_index);
    void BEEP_pwmstates_reset_all();
    void BEEP_pwmstates_reset_basedOn_seqno(U8 beepseqno);
    void BEEP_db_substAndReset_basedOn_playPatState( \
                        pl_beep_seq_status beepseqstatus, \
                        pl_beep_play_state beepplaystate_subst);

    void BEEP_pwmstates_init(U8 beepseqno);

    string BEEP_get_clean_pattern(const string &pattern);

    U32 BEEP_replace_and_get_numOfOccur(string &pattern, \
                        const string &oldchar, \
                        const string &newchar);

    void BEEP_set_enablestate_handler(U8 beepseqno, \
                        string pattern_obj);

    // void BEEP_set_enable(no_yes isEnabled);
};  // class BEEP_channel

}  // namespace beeppattern
}  // namespace ntios

#endif  // BEEP_NTIOS_BEEPCHANNEL_H_
