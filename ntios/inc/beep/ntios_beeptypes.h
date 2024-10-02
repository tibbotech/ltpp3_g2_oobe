/* Copyright 2021 Tibbo Technology Inc. */

#ifndef BEEP_NTIOS_BEEPTYPES_H_
#define BEEP_NTIOS_BEEPTYPES_H_

    /* INCLUDES */
    #include <string>



    /* CONSTANTS */
    const char *const BEEP_EMPTYSTRING = "";
    const char *const BEEP_ASTERISK = "*";
    const char *const BEEP_DASH = "-";
    const char *const BEEP_TILDE = "~";
    const char *const BEEP_UPPERCASE_B = "B";
    const char *const BEEP_LOWERCASE_B = "b";

    const U8 BEEP_ASTERISK_DEC = 42;
    const U8 BEEP_DASH_DEC = 45;
    const U8 BEEP_TILDE_DEC = 126;
    const U8 BEEP_UPPERCASE_B_DEC = 66;
    const U8 BEEP_LOWERCASE_B_DEC = 98;

    const U8 BEEP_LIMIT255 = 255;
    const U16 BEEP_LIMIT65K = 65535;

    const U8 BEEP_REMOVE_ENTRY_ISPRESENT_INDEX = 0;



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

    typedef enum {
        /**
         * PLATFORM CONSTANT. The specified pattern is NOT part of a sequence-group. 
         */  
        PL_BEEP_SEQ_DISABLED = 0,
        /**
         * PLATFORM CONSTANT. The specified pattern is part of a sequence-group. 
         */  
        PL_BEEP_SEQ_ENABLED = 1
    } pl_beep_seq;

    typedef enum {
        /**
         * PLATFORM CONSTANT. The specified pattern is NOT part of a sequence-group. 
         */  
        PL_BEEP_SEQ_OFF = 0,
        /**
         * PLATFORM CONSTANT. The specified pattern is part of a sequence-group. 
         */  
        PL_BEEP_SEQ_ON = 1,
        /**
         * PLATFORM CONSTANT. The specified pattern is currently playing.
         */
        PL_BEEP_ISPLAYING = 2
    } pl_beep_seq_status;

    typedef enum {
        /**
         * PLATFORM CONSTANT. The specified Pattern is not played or has not finished playing yet.
         */  
        PL_BEEP_PLAY_NOT_FINISHED = 0,
        /**
         * PLATFORM CONSTANT. The specified pattern has finished playing, the 'on_beep'
         *  event can be triggered.
         */
        PL_ONBEEP_EVENT_START = 1,
        /**
         * PLATFORM CONSTANT. The on_beep event has been triggered. The 'BEEP_seqno' can be removed from database.
         */  
        PL_BEEP_REMOVE_ENTRY = 2,
        /**
         * PLATFORM CONSTANT. This state is used when the pat_play_state is irrelevant.
         */      
        PL_BEEP_STATE_NULL = 255
    } pl_beep_play_state;


    /* STRUCTURES */
    typedef struct {
        /*
        * Tells whether a pattern is currently playing.
        * Remarks:
        *   In 'beep.play' -> 'isReadyToPlay' is set to 'true' only if:
        *       1. 'patint = PL_BEEP_CANINT'.
        *       2. 'patint = PL_BEEP_NOINT', but no patterns are playing.
        *   In 'beep.update' -> 'isReadyToPlay' is set to 'false' only if:
        *       1. 'loop = false'.
        *       2. 'beep_index = beep_strlen'
        */
        bool isReadyToPlay;
        /*
        * This boolean is set to true once the whole pattern has been played.
        * Remarks:
        * - Only valid for "non-looped" patterns.
        * - In ntios_beepchannel::update -> set to true/false.
        */
        bool lastCycle_isEnabled;
        /* 
        * true: tilde '~' is found, then play pattern infinitely
        * false: tilde '~' is not found, then play pattern only once
        */
        bool loop;
        /*
        * Frequency: 1265 - 4294967295.
        * Remark:
        *   With the frequency, the beep 'tone' can be adnusted.
        */
        U32 frequency;
        /*
        * duty_cycle: 0 - 4294967295.
        * Remarks:
        *   - With the duty_cycle, the 'volume' can be adjusted.
        *   - dutycycle = (frequency*duty_cyle_perc)/100.
        */
        U32 duty_cycle;
        /*
        * 2: one asterisk '*' is found.
        * 4: two asterisk '**' or more are found.
        */
        U32 bpspeed_div;
        /*
        * Number of cycles before playing one beep-object.
        * Remarks:
        *   'bpspeed' can be changed:
        *   - with the property 'beep.bpspeed.
        *   - by putting one or two asterisks in the to-be-played pattern.
        */
        U32 bpspeed;
        /* 
        * Countdown to '0' before playing 1 beep-object.
        * Remarks: 
        * - a global cycle is 10ms.
        * - In 'beep.play' -> 'bpspeed_ctr' is set to '0'.
        * - In 'beep.update' -> bpspeed_ctr < bpspeed: bpspeed_ctr++.
        *                   -> bpspeed_ctr = bpspeed: bpspeed_ctr = 0.
        * - a 'beep-object' is one playable object which is part of the pattern string (e.g., B, -).
        */
        U32 bpspeed_ctr;
        /* Beep pattern to be played */
        string beep_str;
        /* Beep pattern string length */
        U16 beep_strlen;
        /*
        * Pattern string index.
        * Remarks:
        * - Keeps track of the next beep-object to be played.
        * - In 'beep.play' -> 'beep_index' is set to '1'.
        * - In 'beep.update' -> when bpspeed_ctr = 0: beep_index++ (increment by 1)
        */
        U16 beep_index;
    } beep_pwmstates_t;



    /*
    * Structure containing:
    * 1. beepseqno -> The current sequence number (ranging from 0 - 255) 
    * 2. beepseqstatus:
    *   0: PL_BEEP_SEQ_OFF.
    *   1: PL_BEEP_SEQ_ON.
    *   2: PL_BEEP_ISPLAYING.
    * 3. beepplaystate: There are 3 options:
    *   0: PL_BEEP_PLAY_NOT_FINISHED.
    *   1: PL_ONBEEP_EVENT_START.
    *   2: PL_BEEP_REMOVE_ENTRY.
    * 4. remove_entry_isPresent: keeps track of whether there are any
    *       array-elements marked with 'PL_BEEP_REMOVE_ENTRY'.
    *   Remarks:
    *   1. boolean can be accessed with 'BEEP_updatequeues_ctx_ptr[BEEP_REMOVE_ENTRY_ISPRESENT_INDEX].remove_entry_isPresent'.
    *   2. using this boolean can avoid unnecessary execution of function 'BEEP_updatequeues_remove' (less overhead).
    */
    typedef struct {
        string beepstr;
        U8 beepseqno;
        pl_beep_seq beepseq;
        pl_beep_seq_status beepseqstatus;
        pl_beep_play_state beepplaystate;
        no_yes remove_entry_isPresent;
    } beep_updatequeues_t;


    /* EXTERN VARIABLES */
    extern beep_pwmstates_t *BEEP_pwmstates_ctx_ptr;
    extern U8 *beep_seqno_ptr;
    extern beep_updatequeues_t *BEEP_updatequeues_ctx_ptr;
    extern U8 *beep_updatequeues_index_ptr;

#endif  // BEEP_NTIOS_BEEPTYPES_H_
