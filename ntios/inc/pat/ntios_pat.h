/* Copyright 2021 Tibbo Technology Inc. */

#ifndef PAT_NTIOS_PAT_H_
#define PAT_NTIOS_PAT_H_

/* INCLUDES */
#include <string>

#include "pat/ntios_patchannel.h"



/* EXTERN VARIABLES */
extern ntios::pattern::PAT_channel *PAT_channels_ptr;



/* NAMESPACES */
namespace ntios {
namespace pattern {

/* CLASSES */
class PAT_internal {
    /* FRIENDS */
    friend class PAT;
    friend class Periodic;

 public:
    /* CONSTRUCTOR */
    PAT_internal() {
        /*
        * For loop making use of array 'PAT_channels_index_arr' which contains the
        *   relevant 'channel' numbers to be used.
        * Remark:
        *   By making use of this array, the for-loop only needs to loop 6 times
        *       instead of 255 times.
        */
        for (U8 c : PAT_channels_index_arr) {
            PAT_channels[c].channel = c;
        }

        /* Assign pointer(s) to parameters */
        PAT_channels_ptr = PAT_channels;
    }

    /* DESTRUCTOR */
    ~PAT_internal() {  }



    /* ARRAYS */
       /* ARRAYS */
    /*
    * Array containing the relevant channel numbers.
    * Remark:
    *   This array will be used later on in for-loop(s) to selectively target 
    *       only 6 channels instead of 256 channels.
    */
    U8 PAT_channels_index_arr[NUM_PAT_CHANNEL_INUSE] = {0, 1, 2, 3, 4, 62};



    /* PUBLIC FUNCTIONS */

    /*
    * Plays a specified signal pattern.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: string containing the LED pattern to be played:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '-': both LEDs off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '~': looped pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '*': double-speed pattern (can reside anywhere in the pattern string).    
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'L' or 'l': any signal pattern MUST start with this letter.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '2' to '6': number or combo of numbers which follow(s) after the letter 'L' or 'l'. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; Up to 5 LEDs can be lid up at the same time.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; The combo of numbers do NOT have to be added chronologically.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: flag which defines whether 'pat.play' is allowed to interrupt the current played pattern or not:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_PAT_NOINT: cannot interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_PAT_CANINT: can interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patseqgrp: assign the specified pattern to a group.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_PAT_SEQ_GRP_NULL: Disable playing pattern as part of sequence-group.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; (1 - 255) - (PL_PAT_SEQ_GRP_1 to 255): Enable playing pattern as part of a specified sequence-group.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; In the file from which this function will be called, globally create an instance called:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ntios::pattern::PAT_internal pat_internal.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; After that, call this function with command:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pat_internal.playseq_signal(...);
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; channel is automatically set to 'NUM_PAT_CHANNEL_SIGNAL' (62).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; When using this function, No 'on_pat' event will not be triggered.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ***Note: If the 'on_pat' event is required, then use 'pat.play' instead.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If 'patseq = PL_PAT_SEQ_ENABLED', then up to 256 patterns (per channel) can be played as a sequence.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; For additional descriptions, see function 'playseq'.
    */
    void playseq_signal(const string &pattern, \
                        pl_pat_int patint, \
                        pl_pat_seq_grp patseqgrp);
    /********************************************************************
    * Explanation:
    * Totally, there are 5 signal LEDs, which are LED2, LED3, LED4, LED5, and LED6.
    * Here is a simple scheme showing the signal LEDs and their corresponding Binary Decimal Value.
    * 
    *   +------+------+------+------+------+
    *   | LED6 | LED5 | LED4 | LED3 | LED2 |
    *   +------+------+------+------+------+
    *   |  16  |   8  |   4  |   2  |   1  |    <- Binary Decimal Value
    *   +------+------+------+------+------+
    *      MSB                        LSB
    * 
    * These Binary Decimal Values will be required in 'PAT_get_clean_pattern' (file: ntios_patchannel.cpp).
    * In order to play the Signal LEDs, the following rule must be obeyed
    * Here is an example of a valid signal pattern string:
    * 
    *   pattern = "L26-L35-L4-L35-L26---L23456---~*"
    * 
    * Remark:
    *   Make sure to enter the pattern corretly, because if any illegal char (numerical or non-numerical) 
    *   is found within the LED pattern-object, the LED pattern-object is cut off leaving only the 
    *   substring on the left-side of the illegal numerical value.
    *   
    *   Here is an example of invalid chars within a signal pattern:
    *       pattern (input) = "L2a6-L395-L4-L35-L26---L23$456---~*"
    *                            ^    ^                  ^
    *                            |    |                  |
    *   invalid chars------------+----+------------------+
    * 
    *   Signal pattern after correction:
    *       pattern (corrected) = "L2-L3-L4-L35-L26---L23---~*"
    ********************************************************************/

    /*
    * Plays the specified pattern string pat_str as specified in database 'iostates'.
    *
    * Remark:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull;This function is triggered in 'ntios_periodic.cpp' by function 'periodic_task_main'.
    */    
    void update();

 private:
    /* INSTANCES */
    ntios::pattern::PAT_channel PAT_channels[NUM_PAT_CHANNEL_MAX];



    /* FUNCTIONS */
    bool update_isPlaying(pl_pat_seq_grp patseqgrp);
};  // class PAT_internal



class PAT {
 public:
    /* CONSTRUCTOR */
    PAT() : isChannelVal(0), isPatspeedVal(PAT_SPEED_20), \
                        isRedmapVal(PL_IO_NUM_MIN_1), \
                        isGreenmapVal(PL_IO_NUM_MIN_1) {
        PAT_iostates_ctx_ptr = PAT_iostates_ctx;
        PAT_channel_seqno_ctx_ptr = PAT_channel_seqno_ctx;
        PAT_updatequeues_ctx_ptr = PAT_updatequeues_ctx;
        pat_updatequeues_ctx_index_ptr = &pat_updatequeues_index;
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~PAT() {
       
    }



    /* PROPERTIES */

    /*
    * Sets/returns the number of the currently selected LED-channel.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 4.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 0 → play pattern on the STATUS LEDs (accessible by users).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 1- 4 → play pattern on the TIBBIT LEDs (accessible by users).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channel: 62 → play pattern on the SIGNAL LEDs (not accessible by users).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Default: 0.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Always start with this property, whenever changes are required to be 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; made to other properties (e.g., greenmap, redmap, patspeed).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Channels are enumerated from 0. All other properties, methods, 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; and an event of this object relate to the currently selected channel. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Note that this property's value will be set automatically when the
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; event handle for the 'on_pat' event is entered.
    */
    Property<U8, PAT> channel{this, \
                &PAT::ChannelSetter, \
                    &PAT::ChannelGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the selected LED-channel (using the pat.channel property), sets/returns the 
    * number of the IO-line that will act as a GREEN LED control line.
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
    Property<pl_io_num, PAT> greenmap{this, \
                &PAT::GreenmapSetter, \
                    &PAT::GreenmapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the selected LED-channel (using the pat.channel property), sets/returns the 
    * number of the IO-line that will act as a RED LED control line.
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
    Property<pl_io_num, PAT> redmap{this, \
                &PAT::RedmapSetter, \
                    &PAT::RedmapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the selected LED-channel (using the pat.channel property), sets/returns the
    * speed at which the each pattern-object (e.g., B, R, G, ~, *) is played.
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
    Property<U32, PAT> patspeed{this, \
                &PAT::PatspeedSetter, \
                    &PAT::PatspeedGetter, \
                        PropertyPermissions::ReadWrite};



    /* FUNCTIONS */

    /*
    * Loads a new LED pattern to play on the currently selected LED channel (selection is made 
    *&nbsp;&nbsp;&nbsp;&nbsp; through the pat.channel property).
    * 
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: string containing the LED pattern to be played:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '-': both LEDs off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'R' or 'r': red LED on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'G' or 'g': green LED on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'B' or 'b': both LEDs on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '~': looped pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '*': double-speed pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; You can use this symbol twice to x4 speed.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; Adding even more '*' will not have any effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: flag which defines whether 'pat.play' is allowed to interrupt the 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; current played pattern or not:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_PAT_NOINT: cannot interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_PAT_CANINT: can interrupt.
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If only 'pat.greenmap' is configured, and if 'pattern' contains both
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; pattern-string 'G' and 'R', then:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Only pattern-string 'G' will be played.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Pattern-string 'R', however, is treated as a '-', meaning turn LED off.
    */
    void play(const string &pattern, pl_pat_int patint);
    /*
    * Remarks:
    *   1. This function can also used to play Signal Pattern LEDs.
    *   2. Before calling this function, make sure to assign channel = 62 with comamnd:
    *       pat.channel = NUM_PAT_CHANNEL_SIGNAL
    *   3. This function will trigger an 'on_pat' event.
    *   4. For more explanations, see function 'playseq_signal' (in this file).
    */

    /*
    * Loads a new LED pattern to play on the currently selected LED channel (selection is made through the pat.channel property).
    * 
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pattern: string containing the LED pattern to be played:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '-': both LEDs off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'R' or 'r': red LED on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'G' or 'g': green LED on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 'B' or 'b': both LEDs on.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '~': looped pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; '*': double-speed pattern (can reside anywhere in the pattern string).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; You can use this symbol twice to x4 speed.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; Adding even more '*' will not have any effect.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patint: flag which defines whether 'pat.play' is allowed to interrupt the current played pattern or not:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_PAT_NOINT: cannot interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_PAT_CANINT: can interrupt.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; patseqgrp: assign the specified pattern to a group.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_PAT_SEQ_GRP_NULL: Disable playing pattern as part of sequence-group.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; (1 - 255) - (PL_PAT_SEQ_GRP_1 to 255): Enable playing pattern as part of a specified sequence-group.
    * Details:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; If only 'pat.greenmap' is configured, and if 'pattern' contains both pattern-string 'G' and 'R', then:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Only pattern 'G' will be played.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Pattern 'R', however, is treated as a '-', meaning turn LED off.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Possible options:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_PAT_CANINT & PL_PAT_SEQ_GRP_NULL: CAN interrupt and overwrite all patterns belonging to 'channel'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; all elements within the same 'channel will be resetted.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_PAT_NOINT & PL_PAT_SEQ_GRP_NULL: can NOT interrupt and overwrite any patterns belonging to 'channel'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; If nothing is playing, then all elements  within the same 'channel will be resetted.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_PAT_CANINT & (PL_PAT_SEQ_GRP_1 to 255): CAN interrupt and overwrite all the patterns belonging to 'patseqgrp'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; all elements within the same 'patseqgrp' will be resetted.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; PL_PAT_NOINT & (PL_PAT_SEQ_GRP_1 to 255): can NOT interrupt and overwrite any patterns belonging to 'patseqgrp'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&there4; However, the specified pattern can be APPENDED to become part of 'patseqgrp'.
    */ 
    void playseq(const string &pattern, \
                        pl_pat_int patint, \
                        pl_pat_seq_grp patseqgrp);


 private:
    /* PROPERTY FUNCTIONS */

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



    /* VARIABLES */

    /* 
    * Database containing information regarding a specific pattern.
    * Remark:
    *   For more information, see structure 'pat_iostates_t' (file: ntios_pattypes.h).
    */
    pat_iostates_db_t PAT_iostates_ctx[NUM_PAT_CHANNEL_MAX] = {};

    /* 
    * Database containing a list of all 256 {channel, channel_seqno} combinations.
    * IMPORTANT TO KNOW:
    *   In this database, the 'channel_seqno' is ALWAYS the CURRENT channel sequence-number to be used.
    */
    pat_channel_seqno_db_t PAT_channel_seqno_ctx[NUM_PAT_CHANNEL_SEQNO_MAX] = {};   // NOLINT

    /* 
    * Database containing a list of to be played patterns which are ordened according to FIFO.
    */
    pat_updatequeues_db_t PAT_updatequeues_ctx[NUM_PAT_UPDATEQUEUE_MAX] = {};

    /*
    * Index which indicates:
    * 1. The CURRENT number of ITEMS in the database 'PAT_updatequeues_ctx'.
    * 2. The next INDEX to be used to add element to database 'PAT_updatequeues_ctx'.
    */
    U8 pat_updatequeues_index = 0;

};  // class PAT

}  // namespace pattern
}  // namespace ntios

#endif  // PAT_NTIOS_PAT_H_
