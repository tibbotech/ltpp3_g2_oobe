/* Copyright 2021 Tibbo Technology Inc. */

#ifndef PAT_NTIOS_PATCHANNEL_H_
#define PAT_NTIOS_PATCHANNEL_H_

/* INCLUDES */
#include <cstring>
#include <map>
#include <string>

#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "gpiodfunc/ntios_gpiodfunc.h"
#include "io/ntios_iotypes.h"
#include "pat/ntios_pattypes.h"



/* NAMESPACES */
namespace ntios {
namespace pattern {

/* CLASS */
class PAT_channel {
 public:
    /* CONSTRUCTOR */
    PAT_channel() : isChannelVal(0), isGreenmapVal(PL_IO_NUM_MIN_1), \
                        isRedmapVal(PL_IO_NUM_MIN_1), \
                        isPatspeedVal(PAT_SPEED_20) {
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~PAT_channel() {}



    /* PROPERTIES */

    /*
    * Property:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Sets/returns the number of the currently selected LED channel 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (channels are enumerated from 0).
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 4.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 0 → play pattern on the STATUS LEDs (which is built in the board).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 1- 4 → play pattern on the selected IO-lines.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 0.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channels are enumerated from 0. All other properties, methods, 
    *&nbsp;&nbsp;&nbsp;&nbsp;and an event of this object relate to the currently selected channel. 
    *&nbsp;&nbsp;&nbsp;&nbsp;Note that this property's value will be set automatically when the
    *&nbsp;&nbsp;&nbsp;&nbsp;event handle for the on_pat event is entered.
    */
    Property<U8, PAT_channel> channel{this, \
                &PAT_channel::ChannelSetter, \
                    &PAT_channel::ChannelGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * Property:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; For the selected LED channel (using the pat.channel property), sets/returns the 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; number of the IO-line that will act as a GREEN LED control line.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 56.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value: 56 → PL_IO_NUM_NULL.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 1- 4 → play pattern on the selected IO-lines.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lowast;&lowast;&lowast;Do NOT forgot to configure the IO-lines as OUTPUT.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Defaults:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Channel 0: (-1) (no mapping, read-only): the Green Status LED (control line) 
	*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; of Tibbo device is always used by this channel;
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Channels 1-4: PL_IO_NUM_NULL (non-existent line).
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel 0 is special — its LED control lines can't be remapped, because 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; channel 0 uses the standard Green and red status LEDs (aka SG and SR). 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For channel 0, when reading the property the return value is always (-1).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Please note that writing has no effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All other channels use regular IO-lines of Tibbo devices. Any IO-line can be 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selected to become the Green control line of the selected channel. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; By default, all control lines are mapped to the non-existent line PL_IO_NUM_NULL.
    */
    Property<pl_io_num, PAT_channel> greenmap{this, \
                &PAT_channel::GreenmapSetter, \
                    &PAT_channel::GreenmapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * Property:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; For the selected LED channel (using the pat.channel property), sets/returns the 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; number of the IO-line that will act as a RED LED control line.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 56.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value: 56 → PL_IO_NUM_NULL.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 1- 4 → play pattern on the selected IO-lines.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lowast;&lowast;&lowast;Do NOT forgot to configure the IO-lines as OUTPUT.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Defaults:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Channel 0: (-1) (no mapping, read-only): the Red Status LED (control line) 
	*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; of Tibbo device is always used by this channel;
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Channels 1-4: PL_IO_NUM_NULL (non-existent line).
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel 0 is special — its LED control lines can't be remapped, because 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; channel 0 uses the standard Red and red status LEDs (aka SG and SR). 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For channel 0, when reading the property the return value is always (-1).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Please note that writing has no effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All other channels use regular IO-lines of Tibbo devices. Any IO-line can be 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; selected to become the Red control line of the selected channel. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; By default, all control lines are mapped to the non-existent line PL_IO_NUM_NULL.
    */
    Property<pl_io_num, PAT_channel> redmap{this, \
                &PAT_channel::RedmapSetter, \
                    &PAT_channel::RedmapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * Property:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; For the selected LED channel (using the pat.channel property), sets/returns the
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; speed at which the each pattern-object (e.g., B, R, G, ~, *) is played.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: any unsigned int (U32) value, except for 0.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 20.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If value = 0, then patspeed will be automaticallly set to 20.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patspeed is dependent on the time-interval (10ms) of the Global Loop.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; For example, if patspeed = 20, then this means that Globally the Loop has 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to cycle at least 20 times before ONE pattern-object can be played.
    */
    Property<U32, PAT_channel> patspeed{this, \
                &PAT_channel::PatspeedSetter, \
                    &PAT_channel::PatspeedGetter, \
                        PropertyPermissions::ReadWrite};



    /* FUNCTIONS */
    void playseq(U8 channel, \
                        pl_io_num green_ionum, \
                        pl_io_num red_ionum, \
                        U32 patspeed, \
                        const string &pattern, \
                        pl_pat_int patint, \
                        pl_pat_seq_grp patseqgrp, \
                        no_yes event_isEnabled);
    void update(U8 channel, \
                        U8 channel_seqno, \
                        pl_pat_seq_grp channel_seqgrp, \
                        U16 updatequeues_index);


    /*
    * Filters out the specified 'channel-channel_seqno' pair from the database 'PAT_updatequeues_ctx_ptr'.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the channel to be filtered out.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patPlayState: the pattern-play-state to be filtered out.
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; When filtering based on 'channel' make sure to input 'patPlayState = (pl_pat_play_state) PAT_LIMIT255'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; On the other hand, when filtering based on 'patPlayState' make sure to input 'channel = PAT_LIMIT255'.
    */
    void PAT_updatequeues_remove(U8 channel, \
                        pl_pat_play_state patPlayState);

 private:
    /* CONSTANTS */
    const U8 PAT_NUMOFDIGIT_1 = 1;
    const U8 PAT_NUMOFDIGIT_2 = 2;

    /* ENUMERATES */
    typedef enum {
        APPEND,
        SUBSTITUTE
    } pl_pat_updatetype;

    typedef enum {
        DELETE_OFF,
        DELETE_ALL
    } pl_pat_del_state;


    /* <channel> PROPERTY parameters & functions */
    U8 isChannelVal;  /* Initialized */
    void ChannelSetter(U8 isChannel);
    U8 ChannelGetter() const;

    /* <greenmap> PROPERTY parameters & functions */
    pl_io_num isGreenmapVal;
    void GreenmapSetter(pl_io_num isGreenmap);
    pl_io_num GreenmapGetter() const;

    /* <redmap> PROPERTY parameters & functions */
    pl_io_num isRedmapVal;
    void RedmapSetter(pl_io_num isRedmap);
    pl_io_num RedmapGetter() const;

    /* <patspeed> PROPERTY parameters & functions */
    U32 isPatspeedVal;
    void PatspeedSetter(U32 isPatspeed);
    U32 PatspeedGetter() const;



    /* FUNCTIONS */

    /*
    * Replaces an old character with a new character for a given string.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: string from which a character will be replaced.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; oldchar: to-be-replaced.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; newchar: new character which replaces the old character.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: Modified string after replacing 'oldchar with 'newchar'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; noccur: number of occurrences of 'oldchar'
    */
    U32 PAT_replace_and_get_numOfOccur(string &pattern, \
                            const string &oldchar, \
                            const string &newchar);

    void PAT_set_linestate_handler(U8 channel, \
                            U8 channel_seqno, \
                            string pattern_obj);
    
    /*
    * Determines whether the specified pattern can be processed by function 'playseq'.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the specified channel in which the pattern will be played.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: patint: flag which defines whether 'pat.play' is allowed to interrupt the current played pattern or not.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patseq: flag which tells whether the specified pattern is part of a group of patterns which are played sequentially.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the sequence-number pointer, which is to be determined in this function.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; updatequeues_index: array-index pointer which is to be determined in this function.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; isdeleteAll: flag pointer which is to be determined in this function.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; boolean {true|false}:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; true: function 'playseq' is allowed to continue and process the specified pattern.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; false: function 'playseq' is NOT allowed to continue and process the specified pattern.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the channel sequence-number to be used for the specified channel and pattern.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the channel sequence-number to be used for the specified channel and pattern.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; isdeleteAll: flag which determines whether to reset all records of a specified channel:
    */
    bool PAT_isAllowedToPlay(U8 channel, \
                            pl_pat_int patint, \
                            pl_pat_seq_grp patseqgrp, \
                            U8 *channel_seqno, \
                            pl_pat_del_state *patdelstate);
    /*
    * Checks whether the specified channel or sequence-group is currently playing any pattern.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the specified channel in which the pattern will be played.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqgrp: the sequence-group for which the substitution & appending will take place.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; boolean {true|false}.
    */
    bool PAT_pattern_isPlaying(U8 channel, \
                        pl_pat_seq_grp patseqgrp);
    /*
    * Determines the next channel_seqno index.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the sequence-number pointer, which is to be determined in this function.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno.
    */
    bool PAT_channel_seqno_isAvailable(U8 channel, U8 *channel_seqno);
    bool PAT_updatequeues_matchIsFound(U8 channel, U8 channel_seqno);
    U16 PAT_get_available_channel_seqno(U8 channel);

    void PAT_iostates_init(U8 channel, U8 channel_seqno);

    string PAT_get_clean_pattern(U8 channel, const string &pattern);

    /*
    * Substitues and appends the specified pattern-play-state values.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the channel for which the substitution & appending will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the sequence-number for which the substitution & appending will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqgrp: the sequence-group for which the substitution & appending will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqstatus: the sequence-status for which the substitution & appending will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_patPlayState: the pattern-play-state for which the appending will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_patPlayState_subst: the pattern-play-state for which the substition will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; updatequeues_index: current index for which the substition will take place.
    */
    void PAT_updatequeues_subst_and_append(U8 channel, \
                        U8 channel_seqno, \
                        pl_pat_seq_grp channel_seqgrp, \
                        pl_pat_play_state channel_patPlayState, \
                        pl_pat_play_state channel_patPlayState_subst, \
                        U16 updatequeues_index);

    /*
    * Substitues the specified pattern-play-state values.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the channel to be substituted/appended.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the sequence-number to be substituted/appended.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqgrp: the sequence-group to be substituted/appended.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqstatus: the sequence-status to be substituted/appended.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_patPlayState: the pattern-play-state to be substituted/appended.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; index: index at which the subsitution/append will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; updatetype: flag indicating whether to append OR substitute.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If 'updatetype = APPEND', then parameter 'pat_updatequeues_ctx_index_ptr' will be incremented by 1.
    */
    void PAT_updatequeues_substOrAppend(U8 channel, \
                        U8 channel_seqno, \
                        pl_pat_seq_grp channel_seqgrp, \
                        pl_pat_seq_status channel_seqstatus, \
                        pl_pat_play_state channel_patPlayState_subst, \
                        U16 updatequeues_index, \
                        pl_pat_updatetype updatetype);

    /* 
    Updates the database with the specified values.
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel: the channel to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqno: the sequence-number to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqgrp: the sequence-group to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqstatus: the sequence-status to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_patPlayState: the pattern-play-state to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; remove_entry_isPresent_update: the flag to be updated.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; index: index at which the update will take place.
    */
    void PAT_updatequeues_update(U8 channel_update, \
                        U8 seqno_update, \
                        pl_pat_seq_grp seqgrp_update, \
                        pl_pat_seq_status seqstatus_update, \
                        pl_pat_play_state patPlayState_subst_update, \
                        no_yes remove_entry_isPresent_update, \
                        U16 updatequeues_index);

    /*
    * In 'PAT_updatequeues_ctx_ptr' sets the pattern-play-state to PL_PAT_REMOVE_ENTRY and 
    *   in 'PAT_iostates_ctx_ptr' resets the all data based on the specified sequence-group.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_seqgrp: the sequence-group for which the substitution will take place.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel_patPlayState_subst: the pattern-play-state for which the substition will take place.
    */
    void BEEP_db_substAndReset_basedOn_patSeqGrp( \
                        pl_pat_seq_grp channel_seqgrp, \
                        pl_pat_play_state channel_patPlayState_subst);

    /*
    * Resets the database 'PAT_iostates_ctx_ptr[channel].iostates[channel_seqno]' based on the specified 'channel'.
    */
    void PAT_iostates_reset_basedOn_channel(U8 channel);
    /*
    * Resets the database 'PAT_iostates_ctx_ptr[channel].iostates[channel_seqno]' based on the specified 'channel-channel_seqno' pair.
    */
    void PAT_iostates_reset_basedOn_channelAndSeqno(U8 channel, \
                        U8 channel_seqno);
};  // class PAT_channel

}  // namespace pattern
}  // namespace ntios

#endif  // PAT_NTIOS_PATCHANNEL_H_
