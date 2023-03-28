/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef IO_NTIOS_IO_H_
#define IO_NTIOS_IO_H_

/* NOTE
*   Global Instance 'io' is defined in 'threads/ntios_includes.h'
*/

/* INCLUDES */
#include <gpiod.h>
#include <sys/stat.h>  /* required for method 'dirExists' */
#include <array>
#include <cstring>   /* required for 'strcat' and 'strcmp' */
#include <fstream>   /* required for read from/write to file */
#include <iostream>
#include <string>

#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "gpiodfunc/ntios_gpiodfunc.h"
#include "io/ntios_iotypes.h"



/* NAMESPACE */
namespace ntios {
    /* MACROS */
    #ifndef INTUNSET
        #define INTUNSET (-1)
    #endif

    #ifndef UNSET
        #define UNSET "UNSET"
    #endif


    /* ENUMERATES */
    typedef enum { STRINGTYPE, INTEGERTYPE } outputType_num;

    typedef enum {
        PL_LINUX_IO_0,
        PL_LINUX_IO_1,
        PL_LINUX_IO_2,
        PL_LINUX_IO_3,
        PL_LINUX_IO_4,
        PL_LINUX_IO_5,
        PL_LINUX_IO_6,
        PL_LINUX_IO_7,
        PL_LINUX_IO_8,
        PL_LINUX_IO_9,
        PL_LINUX_IO_10,
        PL_LINUX_IO_11,
        PL_LINUX_IO_12,
        PL_LINUX_IO_13,
        PL_LINUX_IO_14,
        PL_LINUX_IO_15,
        PL_LINUX_IO_16,
        PL_LINUX_IO_17,
        PL_LINUX_IO_18,
        PL_LINUX_IO_19,
        PL_LINUX_IO_20,
        PL_LINUX_IO_21,
        PL_LINUX_IO_22,
        PL_LINUX_IO_23,
        PL_LINUX_IO_24,
        PL_LINUX_IO_25,
        PL_LINUX_IO_26,
        PL_LINUX_IO_27,
        PL_LINUX_IO_28,
        PL_LINUX_IO_29,
        PL_LINUX_IO_30,
        PL_LINUX_IO_31,
        PL_LINUX_IO_32,
        PL_LINUX_IO_33,
        PL_LINUX_IO_34,
        PL_LINUX_IO_35,
        PL_LINUX_IO_36,
        PL_LINUX_IO_37,
        PL_LINUX_IO_38,
        PL_LINUX_IO_39,
        PL_LINUX_IO_40,
        PL_LINUX_IO_41,
        PL_LINUX_IO_42,
        PL_LINUX_IO_43,
        PL_LINUX_IO_44,
        PL_LINUX_IO_45,
        PL_LINUX_IO_46,
        PL_LINUX_IO_47,
        PL_LINUX_IO_48,
        PL_LINUX_IO_49,
        PL_LINUX_IO_50,
        PL_LINUX_IO_51,
        PL_LINUX_IO_52,
        PL_LINUX_IO_53,
        PL_LINUX_IO_54,
        PL_LINUX_IO_55,
        PL_LINUX_IO_56,
        PL_LINUX_IO_57,
        PL_LINUX_IO_58,
        PL_LINUX_IO_59,
        PL_LINUX_IO_60,
        PL_LINUX_IO_61,
        PL_LINUX_IO_62,
        PL_LINUX_IO_63,
        PL_LINUX_IO_NUM_NULL = 254
    } pl_linux_io_num;

    /* EXTERN VARIABLE */
    extern pl_linux_io_num *pin_map_ptr;



    /* Enum containing the array-linenumber of array 'ioPortArray' */
    typedef enum {
        ARRAY_LINENUM_0,
        ARRAY_LINENUM_1,
        ARRAY_LINENUM_2,
        ARRAY_LINENUM_3,
        ARRAY_LINENUM_4,
        ARRAY_LINENUM_5,
        ARRAY_LINENUM_6,
        ARRAY_LINENUM_7,
        ARRAY_LINENUM_8,
        ARRAY_LINENUM_9,
        ARRAY_LINENUM_10,
        ARRAY_LINENUM_11,
        ARRAY_LINENUM_12,
        ARRAY_LINENUM_13,
        ARRAY_LINENUM_14,
        ARRAY_LINENUM_15,
        ARRAY_LINENUM_16,
        ARRAY_LINENUM_17,
        ARRAY_LINENUM_18,
        ARRAY_LINENUM_19,
        ARRAY_LINENUM_20,
        ARRAY_LINENUM_21,
        ARRAY_LINENUM_22,
        ARRAY_LINENUM_23,
        ARRAY_LINENUM_24,
        ARRAY_LINENUM_25,
        ARRAY_LINENUM_26,
        ARRAY_LINENUM_27,
        ARRAY_LINENUM_28,
        ARRAY_LINENUM_29,
        ARRAY_LINENUM_30,
        ARRAY_LINENUM_31,
        ARRAY_LINENUM_NULL = 255
    } array_linenum_enum;


    /*
    * Remark:
    * Interrupt line 0 (mapped to IO line 16, bit-dec-val: 1)
    * Interrupt line 1 (mapped to IO line 17, bit-dec-val: 2)
    * Interrupt line 2 (mapped to IO line 18, bit-dec-val: 3)
    * Interrupt line 3 (mapped to IO line 19, bit-dec-val: 8)
    * Interrupt line 4 (mapped to IO line 20, bit-dec-val: 16)
    * Interrupt line 5 (mapped to IO line 21, bit-dec-val: 32)
    * Interrupt line 6 (mapped to IO line 22, bit-dec-val: 64)
    * Interrupt line 7 (mapped to IO line 23, bit-dec-val: 128)
    */
    typedef enum {
        PL_INT_NUM_0,
        PL_INT_NUM_1,
        PL_INT_NUM_2,
        PL_INT_NUM_3,
        PL_INT_NUM_4,
        PL_INT_NUM_5,
        PL_INT_NUM_6,
        PL_INT_NUM_7,
        PL_INT_NUM_NULL
    } pl_int_num;

    typedef enum {
        BIT128 = 128,
        BIT64 = 64,
        BIT32 = 32,
        BIT16 = 16,
        BIT8 = 8,
        BIT4 = 4,
        BIT2 = 2,
        BIT1 = 1,
        BIT_UNSET = 255
    } pl_bit_dec_value;

    // STRUCTURES for 1D-ARRAY
    /**
     * @brief Structure containing IO related information.
     */
    typedef struct {
        pl_io_port_num _portNum;
        array_linenum_enum _portLineNum;
        pl_bit_dec_value _portBitDecVal;
        pl_int_num _intnum;
        pl_bit_dec_value _intBitDecVal;
        /* cppcheck-suppress unusedStructMember */
        bool _intIsEnabled;
        low_high _intState;
        pl_io_num _num;
        std::string _linuxIoFolder;
        pl_linux_io_num _linuxIoNum;
    } pl_io_struct;

    /**
     * @brief Structure containing Interrupt related information.
     */
    typedef struct {
        pl_int_num _intnum;
        pl_bit_dec_value _intBitDecVal;
        /* cppcheck-suppress unusedStructMember */
        bool _intIsEnabled;
        low_high _intState;
        pl_io_num _num;
    } pl_int_struct;



/* CLASSES */
class IO_INTERNAL {
    friend class IO;
    friend class SSI_channel;

 public:
    /* CONSTRUCTOR */
    IO_INTERNAL() : ioStateArray{LOW} {
        chip = gpiod_chip_open_by_name("gpiochip0");
        for (U8 i = 0; i < LINUX_NUM_IO; i++) {
            gpiodChipMap[i] = gpiod_chip_get_line(chip, pin_map[i]);
        }

        gpiodChipMap_ptr = gpiodChipMap;
        ioStateArray_ptr = ioStateArray;
        pin_map_ptr = pin_map;
    }

    /*
    * DESTRUCTOR
    * Remark: Not sure if this is correct.
    */
    ~IO_INTERNAL() {
        delete[] gpiodChipMap_ptr;
        for(int i=0;i<64;i++){
            gpiod_line_release(gpiodChipMap_ptr[i]);
        }
        gpiod_chip_close(chip);
    }



 private:
    /* VARIABLES */
    static pl_linux_io_num pin_map[];
    struct gpiod_chip *chip;
    struct gpiod_line *gpiodChipMap[NUM_IO_TOTAL];
    low_high ioStateArray[NUM_IO_TOTAL];
};  // class IO_INTERNAL

class IO {
/*
* Remarks
* Functions starting with 'gpiod' (e.g. gpiod_chip_open_by_name, gpiod_chip_get_line, etc.)
*   are included in the 'gpiod.h' library 
*/;
 public:
    /* CONSTRUCTOR */
    IO() : portenabledVal{0}, portStateVal{255} {
        getFileContentIntVal = 0;
        intNumSetVal = PL_INT_NUM_0;
        intIsEnabledVal = NO;
        isEnabledVal = NO;
        linuxIoNum = PL_LINUX_IO_NUM_NULL;
        numVal = PL_IO_NUM_0;
        portNumVal = PL_IO_PORT_NUM_0;

        /*
        * 1. Initialize range of IO-lines 0-55.
        * 2. Initialize range of IO-lines 60-61.
        * 3. Initialize range of IO-lines 62-63.
        * Remarks:
        *   The reason why this is needed is because if any IO-line was already used
        *   in a previous code-run, and the LTPP3-G2 device was NOT rebooted afterwards,
        *   then this IO-line is still in an un-initialized state and therefore needs 
        *   to be initialized. Failure to do so, will result in unwanted results.
        */
        SignalIoInit();
        StatusIoInit();
    }

    /* DESTRUCTOR */
    ~IO() {}



    /* PROPERTIES */
    /* <enabled> Property */
    /**
     * @brief Sets/Returns the 'direction' of the currently selected IO-line.
     *
     * @remarks
     * Default value = false.
     * If an IO-line is 'disabled', thus set to false', then the direction is
     * 'in'. If an IO-line is 'enabled', thus set to true', then the direction is
     * 'out'. The IO-line selection is made through the 'io.num' property.
     */
    Property<no_yes, IO> enabled{this,
                        &IO::EnabledSetter,
                            &IO::EnabledGetter,
                                PropertyPermissions::ReadWrite};

    /* <num> Property */
    /**
     * @brief Property to set/return the 'number' of the currently selected
     * IO-line. This selection is related to io.enabled and io.state properties.
     *
     * @remarks Default value = PL_IO_NUM_0.
     */
    Property<pl_io_num, IO> num{this,
                        &IO::NumSetter,
                            &IO::NumGetter,
                                PropertyPermissions::ReadWrite};

    /* <state> Property */
    /**
     * @brief Property to set/return the 'state' of the currently selected
     * IO-line. The IO-line selection is made through the 'io.num' property.
     *
     * @remark Default value = LOW.
     */
    Property<low_high, IO> state{this,
                        &IO::StateSetter,
                            &IO::StateGetter,
                                PropertyPermissions::ReadWrite};

    /* <portenabled> Property */
    /**
     * @brief Sets/returns the 'direction' of the currently selected 8-bit
     * IO-port consisting of 8 IO-lines.
     *
     * @remarks
     * For each bit (line) '0' means 'input' and '1' means 'output'.
     * Default value = 0.
     * If 'portenabled = 0', then ALL IO-lines' direction are set to 'in' (unless
     * certain IO lines are already reserved for TX, RX, RTS, CTS). If
     * 'portenabled = 255', then ALL IO-lines' direction are set to 'out' (unless
     * certain IO lines are already reserved for TX, RX, RTS, CTS). The IO-port
     * selection is made through the 'io.portnum' property.
     */
    Property<U8, IO> portenabled{this,
                        &IO::PortEnabledSetter,
                            &IO::PortEnabledGetter,
                                PropertyPermissions::ReadWrite};

    /* <portnum> Property */
    /**
     * @brief Property to set/return the currently selected 8-bit IO-port.
     * This selection is related to io.portenabled and io.portstate properties.
     *
     * @remarks
     * Default value = PL_IO_PORT_NUM_0.
     */
    Property<pl_io_port_num, IO> portnum{this,
                        &IO::PortNumSetter,
                            &IO::PortNumGetter,
                                PropertyPermissions::ReadWrite};

    /* <portstate> Property */
    /**
     * @brief Property to set/return the 8-bit IO port's state for the currently
     * selected IO-port number. The IO-line selection is made through the
     * 'io.num' property.
     *
     * @remarks
     * Ech individual bit in this byte value sets/returns the state of the
     * corresponding IO-line within the port. Default value = 255.
     */
    Property<U8, IO> portstate{this,
                        &IO::PortStateSetter,
                            &IO::PortStateGetter,
                                PropertyPermissions::ReadWrite};

    /* <intenabled> Property */
    /**
     * @brief Property to enable/disable the 'on_io_int' event for the currently
     * selected Interrupt-line number.
     *
     * @remarks
     * Default value = false.
     * The Interrupt-line selection is made through the 'io.intnum' property.
     */
    Property<no_yes, IO> intenabled{this,
                        &IO::IntIsEnabledSetter,
                            &IO::intIsEnabledGetter,
                                PropertyPermissions::ReadWrite};

    /* <intnum> Property */
    /**
     * @brief Property to set/return the Interrupt-line's 'number' of the
     * currently selected Interrupt-line number. This selection is related to
     * io.intenabled property.
     *
     * @remark Default value = PL_INT_NUM_0.
     */
    Property<pl_int_num, IO> intnum{this,
                        &IO::IntNumSetter,
                            &IO::IntNumGetter,
                                PropertyPermissions::ReadWrite};

    /* <lineget> FUNCTION */
    /**
     * @brief Returns the 'state' of the currently selected i/o-line.
     *
     * @param num The selected IO-line number.
     *
     * @return low_high.
     */
    low_high lineget(pl_io_num num);

    /* <linset> FUNCTION */
    /**
     * @brief Sets the 'state' of the currently selected IO-line.
     *
     * @remarks
     * 1. The line must be configured as 'output' (io.enabled = true) for this
     * method to have any effect.
     * 2. The io.num and io.enabled will not be set implicitely by this function.
     * 3. If IO-line direction is set to INPUT, then the last known IO-line 'state' value is returned.
     * 4. Default value = 0 (e.g. an error has occurred).
     *
     * @param num The selected IO-line number.
     * @param state The I/0-line's state (0-LOW/1-HIGH).
     */
    void lineset(pl_io_num num, low_high state);

    /* <invert> FUNCTION */
    /**
     * @brief Inverts the 'state' of the currently selected i/o-line.

    * @remark
    * 1. The line must be configured as 'output' (io.enabled = true) for this
    method to have any effect.
    * 2. The io.num and io.enabled will not be set implicitely by this function.
    * @param num The selected IO-line number.
    */
    void invert(pl_io_num num);

    /* <portget> FUNCTION */
    /**
     * @brief Returns the 8-bit IO port's state for the currently selected
     * IO-port number.
     *
     * @param portnum The specified IO-port number.
     *
     * @return int
     */
    U8 portget(pl_io_port_num portnum);

    /* <portset> FUNCTION */
    /**
     * @brief Sets the 8-bit IO port's state for the currently selected IO-port
     * number. Each individual bit of the state argument defines the state of the
     * corresponding IO-line within the port.
     *
     * @remark IO-line(s) must be configured as 'output' for writes to this
     * property to have (full) effect. This means that IO-line(s), which are set
     * as 'input', are ignored.
     *
     * @param portnum The specified IO-port number.
     * @param state The 8-bit IO-port's state.
     */
    void portset(pl_io_port_num portnum, U8 state);

    // -FUNCTIONS CALLED BY OTHER FILES */
    /**
     * @brief Gets the Accumulated 8-bit linestate of all the Interrupt-lines.
     *
     * @remark Each bit of the linestate argument corresponds with one interrupt
     * line. When it comes to the 'bit-dec-value' it would look like this:
     * PL_INT_NUM_0 = 1
     * PL_INT_NUM_1 = 2
     * PL_INT_NUM_2 = 4
     * PL_INT_NUM_3 = 8
     * PL_INT_NUM_4 = 16
     * PL_INT_NUM_5 = 32
     * PL_INT_NUM_6 = 64
     * PL_INT_NUM_7 = 128
     * Note: the above interrupt-number vs. bit-dec-value relationship is
     * according to TiOS definition.
     *
     * * @return int
     */
    int intGetLineState();



 private:
    /* INSTANCES */
    ntios::libgpiod::GPIOD_func gpiod_func;

    /* VARIABLES */
    pl_int_num intNumSetVal;
    pl_io_num numVal;
    pl_io_port_num portNumVal;

    std::string linuxIoFolder;
    std::string getFileContentStrVal;

    U8 portenabledVal;
    U8 portStateVal;
    int getFileContentIntVal;
    int linuxIoNum;

    no_yes isEnabledVal;
    bool intIsEnabledVal;



    /* ARRAYS */
    // static pl_linux_io_num pin_map[];
    static pl_io_struct ioPortStatSigArray[];
    static pl_io_struct ioPortArray[];
    static pl_int_struct intArray[];



    /* PROPERTIES */
    /* <state> Property variables & FUNCTIONS */
    /**
     * @brief Sets the 'direction' of the currently selected IO-line.
     *
     * @param isEnabled Boolean (YES/NO).
     */
    void EnabledSetter(no_yes isEnabled);

    /**
     * @brief Returns the 'direction' of the currently selected IO-line.
     *
     * @return bool
     */
    no_yes EnabledGetter() const;


    /* <num> Property variables & FUNCTIONS */
    /**
     * @brief Sets the'number' of the currently set IO-line.
     *
     * @param num The selected IO-line number.
     */
    void NumSetter(pl_io_num num);

    /**
     * @brief Returns the 'number' of the currently set IO-line.
     *
     * @return pl_io_num
     */
    pl_io_num NumGetter() const;


    /* <state> Property variables & FUNCTIONS */
    /**
     * @brief Sets the 'state' of the currently selected IO-line.
     *
     * @param state The specified IO-line's state.
     */
    void StateSetter(low_high state);

    /**
     * @brief Returns the 'state' of the currently set IO-line.
     *
     * @page The line must be configured as 'output' (io.enabled = true) for this
     * method to have any effect
     * 
     * @Remarks
     * 1. If IO-line direction is set to INPUT, then the last known IO-line 'state' value is returned.
     * 2. 
     *
     * @return low_high
     */
    low_high StateGetter() const;


    /* <portenabled> Property variables & FUNCTIONS */
    /**
     * @brief Sets the 'direction' of the currently selected 8-bit IO-Port.
     *
     * @param isEnabledVal
     */
    void PortEnabledSetter(U8 isEnabledVal);

    /**
     * @brief Returns the 'direction' of the currently selected 8-bit IO-Port.
     *
     * @return U8 decimal value
     */
    U8 PortEnabledGetter() const;

    /**
     * @brief Sets the 'direction' of the currently selected 8-bit IO-Port.
     *
     * @param isEnabledVal
     * 
     * Remark:
     *  This function is called in function 'PortEnabledSetter'
     */
    void portenableset(U8 isEnabledVal);

    /* <portnum> Property variables & FUNCTIONS */
    /**
     * @brief Sets the 'number' of the currently selected 8-bit IO-port.
     *
     * @param portnum The specified 8-bit IO-port's 'number'.
     */
    void PortNumSetter(pl_io_port_num portnum);

    /**
     * @brief Returns the 'number' of the currently selected 8-bit IO-port.
     *
     * @return pl_io_port_num
     */
    pl_io_port_num PortNumGetter() const;


    /* <portstate> Property variables & FUNCTIONS */
    /**
     * @brief Sets the 'state' of the currently selected 8-bit IO-port.
     *
     * @param state The specified 8-bit IO-port's state.
     */
    void PortStateSetter(U8 state);

    /**
     * @brief Returns the 'state' of the currently set 8-bit IO-port.
     *
     * @remark The line must be configured as 'output' for this method to have any
     * effect.
     *
     * @return int.
     */
    U8 PortStateGetter() const;

    /* <intenabled> Property variables & FUNCTIONS */
    /**
     * @brief Property to enable/disable the 'on_io_int' event for the currently
     * selected Interrupt-line number.
     *
     * @param isIntEnabled Boolean (true/false) .
     */
    void IntIsEnabledSetter(no_yes isIntEnabled);

    /**
     * @brief Returns the boolean (true/false) indicating whether the 'on_io_int'
     * event is enabled or disabled.
     *
     * @return bool.
     */
    no_yes intIsEnabledGetter() const;

    /* <intnum> Property variables & FUNCTIONS */
    // /**
    //  * @brief Gets the bit decimal value for the currently selected
    //  Interrupt-line number.
    //  *
    //  * @param intnum The specified Interrupt-line number.
    //  */
    // int intNumBitDecValGetter(pl_int_num intnum);

    /**
     * @brief Sets the Integer-'number' of the currently selected Interrupt-line
     * number.
     *
     * @param intnum The specified Interrupt-line number.
     */
    void IntNumSetter(pl_int_num intnum);

    /**
     * @brief Returns the 'number' of the currently set Interrupt-line number.
     *
     * @return pl_int_num.
     */
    pl_int_num IntNumGetter() const;

    /**
     * @brief Returns the IO-Information based on the specified 'num' argument.
     *
     * @param num The selected IO-line number.
     * @param int_num The selected Interrupt-line number.
     *
     * @remark
     * @return pl_io_struct.
     */
    pl_io_struct ioNumInfoGet(pl_io_num num, pl_int_num int_num);

    /**
     * @brief Updates the table containing the Interrupt-line numbers and their
     * active-status (true/false) respectively.
     *
     * @param intnum The specified Interrupt-line number.
     * @param isIntEnabled Boolean (true/false) .
     */
    void intUpdateVariables(pl_int_num intnum, bool isIntEnabled);

    /**
     * @brief Checks whether the directory specified by 'targetDir' argument
     * exists.
     *
     * @param targetDir Target directory which needs to be checked.
     *
     * @return bool.
     */
    bool dirExists(const std::string &targetDir);

    /**
     * @brief Gets the file-content for a specified file.
     *
     * @param targetFullPath  Target file from which the content needs to be
     * retrieved.
     * @param valueLineNum  Line-number containing the content which needs to be
     * retrieved.
     * @param outputType  Specify whether the output will be an INTEGER or STRING.
     */
    void fileContentGetter(const std::string &targetFullPath,
                                int valueLineNum,
                                    outputType_num outputType);

    /**
     * @brief Functions to initialize the IO-lines by Enabling/Disabling them.
     */
    void SignalIoInit();
    void StatusIoInit();

    /**
     * @brief Checks whether the specified IO-line num is allowed to access a function or not.
     * 
     * @param num 
     * @return true 
     * @return false 
     */
    bool IoNumIsValid(pl_io_num num);

    /**
     * @brief Writes an integer or string value to the specified 'targetFullPath'
     * file.
     *
     * @param targetFullPath  Target file to which the content needs to be
     * written.
     * @param intVal  Integer value which needs to be written.
     * @param strVal  String value which needs to be written.
     */
    void writeToFile(const std::string &targetFullPath,
                        int intVal,
                            const std::string &strVal);

    /**
     * @brief Sets the 'direction' of the specified argument 'num' whether to in
     * or out. Remark: The 'direction' depends on the boolean 'isEnabled'. If
     * true, then the 'direction' is set to 'out'. If false, then the 'direction'
     * is set to 'in'.
     *
     * @param num The selected IO-line number.
     * @param isEnabled Boolean (YES/NO) .
     */
    void SetDirection(pl_io_num num, bool isEnabled);
};  // class IO

}  // namespace ntios
#endif  // IO_NTIOS_IO_H_
