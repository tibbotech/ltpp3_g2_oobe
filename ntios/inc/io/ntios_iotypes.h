/*Copyright 2021 Tibbo Technology Inc.*/

/* INCLUDES */
#include <gpiod.h>

#include "base/ntios_config.h"



#ifndef IO_NTIOS_IOTYPES_H_
#define IO_NTIOS_IOTYPES_H_
    /* ENUMERATES */
    /*
    * Enum pl_io_num contains the list of constants that refer to available GPIO
    * lines. Use these constants when selecting the line with the io-object (see
    * the io.num property).
    * REMARK: 
    *   These values coincide with the structure 'gpiodChipMap'
    */
    typedef enum {
        PL_IO_NUM_MIN_1 = -1,   /* Value=255 */
        PL_IO_NUM_0,       /*Belongs to S1*/
        PL_IO_NUM_1,       /*Belongs to S5*/
        PL_IO_NUM_2,       /*Belongs to S9*/
        PL_IO_NUM_3,       /*Belongs to S13*/
        PL_IO_NUM_4,       /*Belongs to S3*/
        PL_IO_NUM_5,       /*Belongs to S7*/
        PL_IO_NUM_6,       /*Belongs to S11*/
        PL_IO_NUM_7,       /*Belongs to S15*/
        PL_IO_NUM_8,       /*Belongs to S1*/
        PL_IO_NUM_9,       /*Belongs to S1*/
        PL_IO_NUM_10,      /*Belongs to S5*/
        PL_IO_NUM_11,      /*Belongs to S5*/
        PL_IO_NUM_12,      /*Belongs to S9*/
        PL_IO_NUM_13,      /*Belongs to S9*/
        PL_IO_NUM_14,      /*Belongs to S13*/
        PL_IO_NUM_15,      /*Belongs to S13*/
        PL_IO_NUM_16,      /*Belongs to S1*/
        PL_IO_NUM_17,      /*Belongs to S5*/
        PL_IO_NUM_18,      /*Belongs to S9*/
        PL_IO_NUM_19,      /*Belongs to S13*/
        PL_IO_NUM_20,      /*Belongs to S3*/
        PL_IO_NUM_21,      /*Belongs to S7*/
        PL_IO_NUM_22,      /*Belongs to S11*/
        PL_IO_NUM_23,      /*Belongs to S15*/
        PL_IO_NUM_24,
        PL_IO_NUM_25,
        PL_IO_NUM_26,
        PL_IO_NUM_27,
        PL_IO_NUM_28,
        PL_IO_NUM_29,
        PL_IO_NUM_30,
        PL_IO_NUM_31,
        PL_IO_NUM_32,       /*Belongs to S3*/
        PL_IO_NUM_33,       /*Belongs to S4*/
        PL_IO_NUM_34,       /*Belongs to S7*/
        PL_IO_NUM_35,       /*Belongs to S7*/
        PL_IO_NUM_36,       /*Belongs to S11*/
        PL_IO_NUM_37,       /*Belongs to S11*/
        PL_IO_NUM_38,       /*Belongs to S15*/
        PL_IO_NUM_39,       /*Belongs to S15*/
        PL_IO_NUM_40,
        PL_IO_NUM_41,
        PL_IO_NUM_42,
        PL_IO_NUM_43,
        PL_IO_NUM_44,
        PL_IO_NUM_45,
        PL_IO_NUM_46,
        PL_IO_NUM_47,
        PL_IO_NUM_48,
        PL_IO_NUM_49,
        PL_IO_NUM_50,
        PL_IO_NUM_51,
        PL_IO_NUM_52,
        PL_IO_NUM_53,
        PL_IO_NUM_54,
        PL_IO_NUM_55,
        PL_IO_NUM_NULL = 254    /* same value as PL_LINUX_IO_NUM_NULL */
    } pl_io_num;

    /* Enum containing the IO-ports of IO-lines */
    typedef enum {
        PL_IO_PORT_NUM_0,
        PL_IO_PORT_NUM_1,
        PL_IO_PORT_NUM_2,
        PL_IO_PORT_NUM_3,
        PL_IO_PORT_NUM_NULL = 255
    } pl_io_port_num;

    /* Enum containing the Status LED IO-lines */
    typedef enum {
        PL_STATUS_REDLED = 62,
        PL_STATUS_GREENLED = 63,
        PL_STATUS_NULL = 255
    } pl_status_num;

    /* Enum for controlling the Signal LEDs */
    typedef enum {
        PL_SIGNAL_CLKPIN = 60,
        PL_SIGNAL_DATAPIN = 61,
        PL_SIGNAL_NULL = 255
    } pl_signal_num;

    /* Enum containing the IO-line 'state' */
    typedef enum {
        LOW = 0,
        HIGH = 1,
        STATE_UNSET = 255
    } low_high;



    /* EXTERN VARIABLES */

    /**
     * @brief Variable which stores information regarding the 'linestate' of the 8
     * Interrupt-lines. The informwation itself is the accumulated bit decimal value
     * of all Interrupt-lines from which the linestate has CHANGED.
     *
     * @remark 
     * The informwation itself is the accumulated bit decimal value of all Enabled
     * Interrupt-lines.
    */
    extern int intEnabledByteVal;

    /**
     * @brief Structure which stores IO-lines information.
     *
     * @remark 
     * 1. For more information regarding the structure, check the following link:
     *      https://github.com/brgl/ssintf/blob/master/lib/core.c
     * 2. This pointer has to be a GLOBAL VARIABLE, because otherwise instances
     *      'io' and 'ssi' will NOT share the same 'gpiodChipMap'
    */
    extern gpiod_line **gpiodChipMap_ptr;

    /**
     * @brief Array which stores IO-lines 'state' information.
    */
    extern low_high *ioStateArray_ptr;

#endif  // IO_NTIOS_IOTYPES_H_
