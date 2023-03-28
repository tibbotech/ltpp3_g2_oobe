/* Copyright 2021 Tibbo Technology Inc. */

#ifndef PAT_NTIOS_PATTYPES_H_
#define PAT_NTIOS_PATTYPES_H_

    /* INCLUDES */
    #include <string>



    /* CONSTANTS */
    const char *const PAT_EMPTYSTRING = "";
    const char *const PAT_ASTERISK = "*";
    const char *const PAT_DASH = "-";
    const char *const PAT_TILDE = "~";
    const char *const PAT_LOWERCASE_L = "l";
    const char *const PAT_UPPERCASE_L = "L";

    const U8 PAT_ASTERISK_DEC = 42;
    const U8 PAT_DASH_DEC = 45;
    const U8 PAT_TILDE_DEC = 126;
    const U8 PAT_UPPERCASE_GREEN_DEC = 71;
    const U8 PAT_LOWERCASE_GREEN_DEC = 103;
    const U8 PAT_UPPERCASE_RED_DEC = 82;
    const U8 PAT_LOWERCASE_RED_DEC = 114;
    const U8 PAT_UPPERCASE_B_DEC = 66;
    const U8 PAT_LOWERCASE_B_DEC = 98;
    const U8 PAT_UPPERCASE_L_DEC = 76;
    const U8 PAT_LOWERCASE_L_DEC = 108;
    const U8 PAT_NUM_2_DEC = 50;
    const U8 PAT_NUM_3_DEC = 51;
    const U8 PAT_NUM_4_DEC = 52;
    const U8 PAT_NUM_5_DEC = 53;
    const U8 PAT_NUM_6_DEC = 54;

    const U8 PAT_LED2_BINDECVAL = 1;
    const U8 PAT_LED3_BINDECVAL = 2;
    const U8 PAT_LED4_BINDECVAL = 4;
    const U8 PAT_LED5_BINDECVAL = 8;
    const U8 PAT_LED6_BINDECVAL = 16;

    const U8 PAT_CHANNEL_BOGUS = 255;
    const U8 PAT_LIMIT255 = 255;
    const U16 PAT_LIMIT65K = 65535;

    const U8 PAT_REMOVE_ENTRY_ISPRESENT_INDEX = 0;



    /* ENUMS */
    typedef enum {
        /**
         * PLATFORM CONSTANT. Tells the pat.play method that the new pattern 
         * can only be loaded if NO pattern is playing at the moment. 
         */
        PL_PAT_NOINT = 0,
        /**
         * PLATFORM CONSTANT. Tells the pat.play method that the new pattern 
         * can be loaded even if another pattern is playing at the moment. 
         * Remark:
         *  The pattern which is currently being played will be terminated.
         */
        PL_PAT_CANINT = 1
    } pl_pat_int;

    typedef enum {
        PL_PAT_SEQ_GRP_NULL, PL_PAT_SEQ_GRP_1, PL_PAT_SEQ_GRP_2, PL_PAT_SEQ_GRP_3,  // NOLINT
        PL_PAT_SEQ_GRP_4, PL_PAT_SEQ_GRP_5, PL_PAT_SEQ_GRP_6, PL_PAT_SEQ_GRP_7,  // NOLINT
        PL_PAT_SEQ_GRP_8, PL_PAT_SEQ_GRP_9, PL_PAT_SEQ_GRP_10, PL_PAT_SEQ_GRP_11,  // NOLINT
        PL_PAT_SEQ_GRP_12, PL_PAT_SEQ_GRP_13, PL_PAT_SEQ_GRP_14, PL_PAT_SEQ_GRP_15,  // NOLINT
        PL_PAT_SEQ_GRP_16, PL_PAT_SEQ_GRP_17, PL_PAT_SEQ_GRP_18, PL_PAT_SEQ_GRP_19,  // NOLINT
        PL_PAT_SEQ_GRP_20, PL_PAT_SEQ_GRP_21, PL_PAT_SEQ_GRP_22, PL_PAT_SEQ_GRP_23,  // NOLINT
        PL_PAT_SEQ_GRP_24, PL_PAT_SEQ_GRP_25, PL_PAT_SEQ_GRP_26, PL_PAT_SEQ_GRP_27,  // NOLINT
        PL_PAT_SEQ_GRP_28, PL_PAT_SEQ_GRP_29, PL_PAT_SEQ_GRP_30, PL_PAT_SEQ_GRP_31,  // NOLINT
        PL_PAT_SEQ_GRP_32, PL_PAT_SEQ_GRP_33, PL_PAT_SEQ_GRP_34, PL_PAT_SEQ_GRP_35,  // NOLINT
        PL_PAT_SEQ_GRP_36, PL_PAT_SEQ_GRP_37, PL_PAT_SEQ_GRP_38, PL_PAT_SEQ_GRP_39,  // NOLINT
        PL_PAT_SEQ_GRP_40, PL_PAT_SEQ_GRP_41, PL_PAT_SEQ_GRP_42, PL_PAT_SEQ_GRP_43,  // NOLINT
        PL_PAT_SEQ_GRP_44, PL_PAT_SEQ_GRP_45, PL_PAT_SEQ_GRP_46, PL_PAT_SEQ_GRP_47,  // NOLINT
        PL_PAT_SEQ_GRP_48, PL_PAT_SEQ_GRP_49, PL_PAT_SEQ_GRP_50, PL_PAT_SEQ_GRP_51,  // NOLINT
        PL_PAT_SEQ_GRP_52, PL_PAT_SEQ_GRP_53, PL_PAT_SEQ_GRP_54, PL_PAT_SEQ_GRP_55,  // NOLINT
        PL_PAT_SEQ_GRP_56, PL_PAT_SEQ_GRP_57, PL_PAT_SEQ_GRP_58, PL_PAT_SEQ_GRP_59,  // NOLINT
        PL_PAT_SEQ_GRP_60, PL_PAT_SEQ_GRP_61, PL_PAT_SEQ_GRP_62, PL_PAT_SEQ_GRP_63,  // NOLINT
        PL_PAT_SEQ_GRP_64, PL_PAT_SEQ_GRP_65, PL_PAT_SEQ_GRP_66, PL_PAT_SEQ_GRP_67,  // NOLINT
        PL_PAT_SEQ_GRP_68, PL_PAT_SEQ_GRP_69, PL_PAT_SEQ_GRP_70, PL_PAT_SEQ_GRP_71,  // NOLINT
        PL_PAT_SEQ_GRP_72, PL_PAT_SEQ_GRP_73, PL_PAT_SEQ_GRP_74, PL_PAT_SEQ_GRP_75,  // NOLINT
        PL_PAT_SEQ_GRP_76, PL_PAT_SEQ_GRP_77, PL_PAT_SEQ_GRP_78, PL_PAT_SEQ_GRP_79,  // NOLINT
        PL_PAT_SEQ_GRP_80, PL_PAT_SEQ_GRP_81, PL_PAT_SEQ_GRP_82, PL_PAT_SEQ_GRP_83,  // NOLINT
        PL_PAT_SEQ_GRP_84, PL_PAT_SEQ_GRP_85, PL_PAT_SEQ_GRP_86, PL_PAT_SEQ_GRP_87,  // NOLINT
        PL_PAT_SEQ_GRP_88, PL_PAT_SEQ_GRP_89, PL_PAT_SEQ_GRP_90, PL_PAT_SEQ_GRP_91,  // NOLINT
        PL_PAT_SEQ_GRP_92, PL_PAT_SEQ_GRP_93, PL_PAT_SEQ_GRP_94, PL_PAT_SEQ_GRP_95,  // NOLINT
        PL_PAT_SEQ_GRP_96, PL_PAT_SEQ_GRP_97, PL_PAT_SEQ_GRP_98, PL_PAT_SEQ_GRP_99,  // NOLINT
        PL_PAT_SEQ_GRP_100, PL_PAT_SEQ_GRP_101, PL_PAT_SEQ_GRP_102, PL_PAT_SEQ_GRP_103,  // NOLINT
        PL_PAT_SEQ_GRP_104, PL_PAT_SEQ_GRP_105, PL_PAT_SEQ_GRP_106, PL_PAT_SEQ_GRP_107,  // NOLINT
        PL_PAT_SEQ_GRP_108, PL_PAT_SEQ_GRP_109, PL_PAT_SEQ_GRP_110, PL_PAT_SEQ_GRP_111,  // NOLINT
        PL_PAT_SEQ_GRP_112, PL_PAT_SEQ_GRP_113, PL_PAT_SEQ_GRP_114, PL_PAT_SEQ_GRP_115,  // NOLINT
        PL_PAT_SEQ_GRP_116, PL_PAT_SEQ_GRP_117, PL_PAT_SEQ_GRP_118, PL_PAT_SEQ_GRP_119,  // NOLINT
        PL_PAT_SEQ_GRP_120, PL_PAT_SEQ_GRP_121, PL_PAT_SEQ_GRP_122, PL_PAT_SEQ_GRP_123,  // NOLINT
        PL_PAT_SEQ_GRP_124, PL_PAT_SEQ_GRP_125, PL_PAT_SEQ_GRP_126, PL_PAT_SEQ_GRP_127,  // NOLINT
        PL_PAT_SEQ_GRP_128, PL_PAT_SEQ_GRP_129, PL_PAT_SEQ_GRP_130, PL_PAT_SEQ_GRP_131,  // NOLINT
        PL_PAT_SEQ_GRP_132, PL_PAT_SEQ_GRP_133, PL_PAT_SEQ_GRP_134, PL_PAT_SEQ_GRP_135,  // NOLINT
        PL_PAT_SEQ_GRP_136, PL_PAT_SEQ_GRP_137, PL_PAT_SEQ_GRP_138, PL_PAT_SEQ_GRP_139,  // NOLINT
        PL_PAT_SEQ_GRP_140, PL_PAT_SEQ_GRP_141, PL_PAT_SEQ_GRP_142, PL_PAT_SEQ_GRP_143,  // NOLINT
        PL_PAT_SEQ_GRP_144, PL_PAT_SEQ_GRP_145, PL_PAT_SEQ_GRP_146, PL_PAT_SEQ_GRP_147,  // NOLINT
        PL_PAT_SEQ_GRP_148, PL_PAT_SEQ_GRP_149, PL_PAT_SEQ_GRP_150, PL_PAT_SEQ_GRP_151,  // NOLINT
        PL_PAT_SEQ_GRP_152, PL_PAT_SEQ_GRP_153, PL_PAT_SEQ_GRP_154, PL_PAT_SEQ_GRP_155,  // NOLINT
        PL_PAT_SEQ_GRP_156, PL_PAT_SEQ_GRP_157, PL_PAT_SEQ_GRP_158, PL_PAT_SEQ_GRP_159,  // NOLINT
        PL_PAT_SEQ_GRP_160, PL_PAT_SEQ_GRP_161, PL_PAT_SEQ_GRP_162, PL_PAT_SEQ_GRP_163,  // NOLINT
        PL_PAT_SEQ_GRP_164, PL_PAT_SEQ_GRP_165, PL_PAT_SEQ_GRP_166, PL_PAT_SEQ_GRP_167,  // NOLINT
        PL_PAT_SEQ_GRP_168, PL_PAT_SEQ_GRP_169, PL_PAT_SEQ_GRP_170, PL_PAT_SEQ_GRP_171,  // NOLINT
        PL_PAT_SEQ_GRP_172, PL_PAT_SEQ_GRP_173, PL_PAT_SEQ_GRP_174, PL_PAT_SEQ_GRP_175,  // NOLINT
        PL_PAT_SEQ_GRP_176, PL_PAT_SEQ_GRP_177, PL_PAT_SEQ_GRP_178, PL_PAT_SEQ_GRP_179,  // NOLINT
        PL_PAT_SEQ_GRP_180, PL_PAT_SEQ_GRP_181, PL_PAT_SEQ_GRP_182, PL_PAT_SEQ_GRP_183,  // NOLINT
        PL_PAT_SEQ_GRP_184, PL_PAT_SEQ_GRP_185, PL_PAT_SEQ_GRP_186, PL_PAT_SEQ_GRP_187,  // NOLINT
        PL_PAT_SEQ_GRP_188, PL_PAT_SEQ_GRP_189, PL_PAT_SEQ_GRP_190, PL_PAT_SEQ_GRP_191,  // NOLINT
        PL_PAT_SEQ_GRP_192, PL_PAT_SEQ_GRP_193, PL_PAT_SEQ_GRP_194, PL_PAT_SEQ_GRP_195,  // NOLINT
        PL_PAT_SEQ_GRP_196, PL_PAT_SEQ_GRP_197, PL_PAT_SEQ_GRP_198, PL_PAT_SEQ_GRP_199,  // NOLINT
        PL_PAT_SEQ_GRP_200, PL_PAT_SEQ_GRP_201, PL_PAT_SEQ_GRP_202, PL_PAT_SEQ_GRP_203,  // NOLINT
        PL_PAT_SEQ_GRP_204, PL_PAT_SEQ_GRP_205, PL_PAT_SEQ_GRP_206, PL_PAT_SEQ_GRP_207,  // NOLINT
        PL_PAT_SEQ_GRP_208, PL_PAT_SEQ_GRP_209, PL_PAT_SEQ_GRP_210, PL_PAT_SEQ_GRP_211,  // NOLINT
        PL_PAT_SEQ_GRP_212, PL_PAT_SEQ_GRP_213, PL_PAT_SEQ_GRP_214, PL_PAT_SEQ_GRP_215,  // NOLINT
        PL_PAT_SEQ_GRP_216, PL_PAT_SEQ_GRP_217, PL_PAT_SEQ_GRP_218, PL_PAT_SEQ_GRP_219,  // NOLINT
        PL_PAT_SEQ_GRP_220, PL_PAT_SEQ_GRP_221, PL_PAT_SEQ_GRP_222, PL_PAT_SEQ_GRP_223,  // NOLINT
        PL_PAT_SEQ_GRP_224, PL_PAT_SEQ_GRP_225, PL_PAT_SEQ_GRP_226, PL_PAT_SEQ_GRP_227,  // NOLINT
        PL_PAT_SEQ_GRP_228, PL_PAT_SEQ_GRP_229, PL_PAT_SEQ_GRP_230, PL_PAT_SEQ_GRP_231,  // NOLINT
        PL_PAT_SEQ_GRP_232, PL_PAT_SEQ_GRP_233, PL_PAT_SEQ_GRP_234, PL_PAT_SEQ_GRP_235,  // NOLINT
        PL_PAT_SEQ_GRP_236, PL_PAT_SEQ_GRP_237, PL_PAT_SEQ_GRP_238, PL_PAT_SEQ_GRP_239,  // NOLINT
        PL_PAT_SEQ_GRP_240, PL_PAT_SEQ_GRP_241, PL_PAT_SEQ_GRP_242, PL_PAT_SEQ_GRP_243,  // NOLINT
        PL_PAT_SEQ_GRP_244, PL_PAT_SEQ_GRP_245, PL_PAT_SEQ_GRP_246, PL_PAT_SEQ_GRP_247,  // NOLINT
        PL_PAT_SEQ_GRP_248, PL_PAT_SEQ_GRP_249, PL_PAT_SEQ_GRP_250, PL_PAT_SEQ_GRP_251,  // NOLINT
        PL_PAT_SEQ_GRP_252, PL_PAT_SEQ_GRP_253, PL_PAT_SEQ_GRP_254, PL_PAT_SEQ_GRP_255  // NOLINT
    } pl_pat_seq_grp;

    typedef enum {
        /**
         * PLATFORM CONSTANT. The specified pattern does NOT belong a sequence-group. 
         */  
        PL_PAT_SEQ_OFF = 0,
        /**
         * PLATFORM CONSTANT. The specified pattern BELONGS to a sequence-group.
         */  
        PL_PAT_SEQ_ON = 1,
        /**
         * PLATFORM CONSTANT. The specified pattern is currently playing.
         */
        PL_PAT_ISPLAYING = 2
    } pl_pat_seq_status;

    typedef enum {
        /**
         * PLATFORM CONSTANT. The specified Pattern is not played or has not finished playing yet.
         */  
        PL_PAT_PLAY_NOT_FINISHED = 0,
        /**
         * PLATFORM CONSTANT. The specified pattern has finished playing, the 'on_pat'
         *  event can be triggered.
         */
        PL_ONPAT_EVENT_START = 1,
        /**
         * PLATFORM CONSTANT. The on_pat event has been triggered. The 'channel' and 'channel_seqno' pair 
         *  can be removed from database.
         */  
        PL_PAT_REMOVE_ENTRY = 2,
        /**
         * PLATFORM CONSTANT. This state is used when the pat_play_state is irrelevant.
         */      
        PL_PAT_STATE_NULL = 255
    } pl_pat_play_state;




    /* STRUCTURES */
    typedef struct {
        /*
        * Tells whether a pattern is currently playing.
        * Remarks:
        *   In 'pat.play' -> 'isReadyToPlay' is set to 'true' only if:
        *       1. 'patint = PL_PAT_CANINT'.
        *       2. 'patint = PL_PAT_NOINT', but no patterns are playing.
        *   In 'pat.update' -> 'isReadyToPlay' is set to 'false' only if:
        *       1. 'loop = false'.
        *       2. 'pat_index = pat_strlen'
        */
        bool isReadyToPlay;
        /*
        * This boolean is set to true once the whole pattern has been played.
        * Remarks:
        * - Only valid for "non-looped" patterns.
        * - In pat.update -> set to true/false.
        */
        bool lastCycle_isEnabled;
        /* 
        * true: tilde '~' is found, then play pattern infinitely
        * false: tilde '~' is not found, then play pattern only once
        */
        bool loop;
        /*
        * 2: one asterisk '*' is found.
        * 4: two asterisk '**' or more are found.
        */
        U32 ppspeed_div;
        /*
        * Number of cycles before playing one pattern-object.
        * Remarks:
        *   'ppspeed' can be changed via:
        *   - with the property 'pat.ppspeed.
        *   - by putting one or two asterisks in the to-be-played pattern.
        */
        U32 ppspeed;
        /* 
        * Countdown to '0' before playing 1 pattern-object.
        * Remarks: 
        * - a global cycle is 10ms.
        * - In 'pat.play' -> 'ppspeed_ctr' is set to '0'.
        * - In 'pat.update' -> ppspeed_ctr < ppspeed: ppspeed_ctr++.
        *                   -> ppspeed_ctr = ppspeed: ppspeed_ctr = 0.
        * - a 'pattern-object' is one playable object which is part of the pattern string (e.g. G, R, B, L23456, etc...).
        */
        U32 ppspeed_ctr;
        /* Green IO-line set via 'pat.greenmap' */
        pl_io_num green_ionum;
        /* Red IO-line set via 'pat.redmap' */
        pl_io_num red_ionum;
        /* Pattern to be played */
        string pat_str;
        /* Red pattern string length */
        U16 pat_strlen;
        /*
        * Pattern string index.
        * Remarks:
        * - Keeps track of the next pattern-object to be played.
        * - In 'pat.play' -> 'pat_index' is set to '1'.
        * - In 'pat.update' -> when ppspeed_ctr = 0: pat_index++ (increment by 1)
        */
        U16 pat_index;
        /*
        * This parameter tells whether an 'on_pat' event should be triggered or not 
        *   for the specified channel.
        * Remark:
        *   When playing a pattern with 'pat.play', this boolean is always set to 'YES'.
        *   However, when playing with pat_internal.signalplay, this boolean is always set to 'NO'.
        */
        no_yes on_pat_isEnabled;
    } pat_iostates_t;

    typedef struct {
        pat_iostates_t iostates[NUM_PAT_CHANNEL_SEQNO_MAX];
    } pat_iostates_db_t;

    typedef struct {
        pl_pat_seq_grp channel_seqgrp;
    } pat_seq_grp_t;


    /*
    * Structure containing:
    * 1. channel -> channel in which the pattern will be played.
    * 2. channel_seqno -> channel sequence number (ranging from 0 - 255) .
    *       belonging to that pattern that will be played.
    * 3. channel_seqgrp:
    * There are a total of 256 sequence groups.
    * Options:
    *   PL_PAT_SEQ_GRP_NULL: sequence DISABLED.
    *   PL_PAT_SEQ_GRP_1 - 255: sequence ENABLED.
    * 4. channel_seqstatus:
    *   0: PL_PAT_SEQ_OFF.
    *   1: PL_PAT_SEQ_ON.
    *   2: PL_PAT_ISPLAYING.
    * 5. channel_patPlayState:
    *   0: PL_PAT_PLAY_NOT_FINISHED.
    *   1: PL_ONPAT_EVENT_START.
    *   2: PL_PAT_REMOVE_ENTRY.
    * 6. remove_entry_isPresent: keeps track of whether there are any
    *       array-elements marked with 'PL_PAT_REMOVE_ENTRY'.
    *   Remarks:
    *   1. boolean can be accessed with 'PAT_updatequeues_ctx_ptr[PAT_REMOVE_ENTRY_ISPRESENT_INDEX].remove_entry_isPresent'.
    *   2. using this boolean can avoid unnecessary execution of function 'PAT_updatequeues_remove' (less overhead).
    */
    typedef struct {
        U8 channel;
        U8 channel_seqno;
        pl_pat_seq_grp channel_seqgrp;
        pl_pat_seq_status channel_seqstatus;
        pl_pat_play_state channel_patPlayState;
        no_yes remove_entry_isPresent;
    } pat_updatequeues_db_t;

    /* Structure containing the 'current channel sequence number' */
    typedef struct {
        U8 channel_seqno;
    } pat_channel_seqno_db_t;


    /* EXTERN VARIABLES */
    extern pat_iostates_db_t *PAT_iostates_ctx_ptr;
    extern pat_channel_seqno_db_t *PAT_channel_seqno_ctx_ptr;
    extern pat_updatequeues_db_t *PAT_updatequeues_ctx_ptr;
    extern U8 *pat_updatequeues_ctx_index_ptr;

#endif  // PAT_NTIOS_PATTYPES_H_
