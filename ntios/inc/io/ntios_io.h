#ifndef __NTIOS_IO_H__
#define __NTIOS_IO_H__

//--INCLUDES

#include <gpiod.h>

#include <iostream>
#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"



//--EXTERN VARIABLES (GLOBAL)
/**
 * @brief Variable which stores information regarding the 'linestate' of the 8
 * Interrupt-lines. The informwation itself is the accumulated bit decimal value
 * of all Interrupt-lines from which the linestate has CHANGED.
 */
//  The informwation itself is the accumulated bit decimal value of all Enabled
//  Interrupt-lines.
extern int intEnabledByteValue;

/// Enum pl_io_num contains the list of constants that refer to available GPIO
/// lines. Use these constants when selecting the line with the io. object (see
/// the io.num property).
typedef enum {
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
  PL_IO_NUM_16_INT0, /*Belongs to S1*/
  PL_IO_NUM_17_INT1, /*Belongs to S5*/
  PL_IO_NUM_18_INT2, /*Belongs to S9*/
  PL_IO_NUM_19_INT3, /*Belongs to S13*/
  PL_IO_NUM_20_INT4, /*Belongs to S3*/
  PL_IO_NUM_21_INT5, /*Belongs to S7*/
  PL_IO_NUM_22_INT6, /*Belongs to S11*/
  PL_IO_NUM_23_INT7, /*Belongs to S15*/
  PL_IO_NUM_24,
  PL_IO_NUM_25,
  PL_IO_NUM_26,
  PL_IO_NUM_27,
  PL_IO_NUM_28,
  PL_IO_NUM_29,
  PL_IO_NUM_30,
  PL_IO_NUM_31,
  PL_IO_NUM_32, /*Belongs to S3*/
  PL_IO_NUM_33, /*Belongs to S4*/
  PL_IO_NUM_34, /*Belongs to S7*/
  PL_IO_NUM_35, /*Belongs to S7*/
  PL_IO_NUM_36, /*Belongs to S11*/
  PL_IO_NUM_37, /*Belongs to S11*/
  PL_IO_NUM_38, /*Belongs to S15*/
  PL_IO_NUM_39, /*Belongs to S15*/
  PL_IO_NUM_40,
  PL_IO_NUM_41,
  PL_IO_NUM_42,
  PL_IO_NUM_43,
  PL_IO_NUM_44,
  PL_IO_NUM_45_CO,
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
  PL_IO_NUM_NULL
} pl_io_num;

typedef enum {
  PL_IO_PORT_NUM_0,
  PL_IO_PORT_NUM_1,
  PL_IO_PORT_NUM_2,
  PL_IO_PORT_NUM_3,
  PL_IO_PORT_NUM_NULL
} pl_io_port_num;

typedef enum { LOW = 0, HIGH = 1, STATE_UNSET = 255 } low_high;

//--NAMESPACE
namespace ntios {

//------MACROS
#ifndef INTUNSET
#define INTUNSET (-1)
#endif

#ifndef UNSET
#define UNSET "UNSET"
#endif

//------ENUMERATES
typedef enum { STRINGTYPE, INTEGERTYPE } outputType_num;

typedef enum {
  PL_LINUX_IO_8 = 8,
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
  PL_LINUX_IO_NUM_NULL
} pl_linux_io_num;

typedef enum {
  PL_IO_PORT_NUM_LINENUM_0,
  PL_IO_PORT_NUM_LINENUM_1,
  PL_IO_PORT_NUM_LINENUM_2,
  PL_IO_PORT_NUM_LINENUM_3,
  PL_IO_PORT_NUM_LINENUM_4,
  PL_IO_PORT_NUM_LINENUM_5,
  PL_IO_PORT_NUM_LINENUM_6,
  PL_IO_PORT_NUM_LINENUM_7,
  PL_IO_PORT_NUM_LINENUM_8,
  PL_IO_PORT_NUM_LINENUM_9,
  PL_IO_PORT_NUM_LINENUM_10,
  PL_IO_PORT_NUM_LINENUM_11,
  PL_IO_PORT_NUM_LINENUM_12,
  PL_IO_PORT_NUM_LINENUM_13,
  PL_IO_PORT_NUM_LINENUM_14,
  PL_IO_PORT_NUM_LINENUM_15,
  PL_IO_PORT_NUM_LINENUM_16,
  PL_IO_PORT_NUM_LINENUM_17,
  PL_IO_PORT_NUM_LINENUM_18,
  PL_IO_PORT_NUM_LINENUM_19,
  PL_IO_PORT_NUM_LINENUM_20,
  PL_IO_PORT_NUM_LINENUM_21,
  PL_IO_PORT_NUM_LINENUM_22,
  PL_IO_PORT_NUM_LINENUM_23,
  PL_IO_PORT_NUM_LINENUM_24,
  PL_IO_PORT_NUM_LINENUM_25,
  PL_IO_PORT_NUM_LINENUM_26,
  PL_IO_PORT_NUM_LINENUM_27,
  PL_IO_PORT_NUM_LINENUM_28,
  PL_IO_PORT_NUM_LINENUM_29,
  PL_IO_PORT_NUM_LINENUM_30,
  PL_IO_PORT_NUM_LINENUM_31,
  PL_IO_PORT_NUM_LINENUM_NULL
} pl_io_port_num_linenum;

typedef enum {
  PL_INT_NUM_0, /*Interrupt line 0 (mapped to I/O line 16, bit-dec-val: 1)*/
  PL_INT_NUM_1, /*Interrupt line 1 (mapped to I/O line 17, bit-dec-val: 2)*/
  PL_INT_NUM_2, /*Interrupt line 2 (mapped to I/O line 18, bit-dec-val: 3)*/
  PL_INT_NUM_3, /*Interrupt line 3 (mapped to I/O line 19, bit-dec-val: 8)*/
  PL_INT_NUM_4, /*Interrupt line 4 (mapped to I/O line 20, bit-dec-val: 16)*/
  PL_INT_NUM_5, /*Interrupt line 5 (mapped to I/O line 21, bit-dec-val: 32)*/
  PL_INT_NUM_6, /*Interrupt line 6 (mapped to I/O line 22, bit-dec-val: 64)*/
  PL_INT_NUM_7, /*Interrupt line 7 (mapped to I/O line 23, bit-dec-val: 128)*/
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

//------STUCTURES for 1D-ARRAY
/**
 * @brief Structure containing I/O related information.
 */
typedef struct {
  pl_io_port_num _portNum;
  pl_io_port_num_linenum _portLineNum;
  pl_bit_dec_value _portBitDecValue;
  pl_int_num _intnum;
  pl_bit_dec_value _intBitDecValue;
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
  pl_bit_dec_value _intBitDecValue;
  bool _intIsEnabled;
  low_high _intState;
  pl_io_num _num;
} pl_int_struct;

//------CLASS
class io {
 public:
  io();

  //----------<enabled> PROPERTY
  /**
   * @brief Sets/Returns the 'direction' of the currently selected I/O-line.
   *
   * @remarks
   * Default value = false.
   * If an I/O-line is 'disabled', thus set to false', then the direction is
   * 'in'. If an I/O-line is 'enabled', thus set to true', then the direction is
   * 'out'. The I/O-line selection is made through the 'io.num' property.
   */
  Property<bool, io> enabled{this, &io::EnabledSetter, &io::EnabledGetter,
                             PropertyPermissions::ReadWrite};

  //----------<num> PROPERTY
  /**
   * @brief Property to set/return the 'number' of the currently selected
   * I/O-line. This selection is related to io.enabled and io.state properties.
   *
   * @remarks Default value = PL_IO_NUM_0.
   */
  Property<pl_io_num, io> num{this, &io::NumSetter, &io::NumGetter,
                              PropertyPermissions::ReadWrite};

  //----------<state> PROPERTY
  /**
   * @brief Property to set/return the 'state' of the currently selected
   * I/O-line. The I/O-line selection is made through the 'io.num' property.
   *
   * @remark Default value = LOW.
   */
  Property<low_high, io> state{this, &io::StateSetter, &io::StateGetter,
                               PropertyPermissions::ReadWrite};

  //----------<portenabled> PROPERTY
  /**
   * @brief Sets/returns the 'direction' of the currently selected 8-bit
   * I/O-port consisting of 8 I/O-lines.
   *
   * @remarks
   * For each bit (line) '0' means 'input' and '1' means 'output'.
   * Default value = 0.
   * If 'portenabled = 0', then ALL I/O-lines' direction are set to 'in' (unless
   * certain I/O lines are already reserved for TX, RX, RTS, CTS). If
   * 'portenabled = 255', then ALL I/O-lines' direction are set to 'out' (unless
   * certain I/O lines are already reserved for TX, RX, RTS, CTS). The I/O-port
   * selection is made through the 'io.portnum' property.
   */
  Property<bool, io> portenabled{this, &io::PortEnabledSetter,
                                 &io::PortEnabledGetter,
                                 PropertyPermissions::ReadWrite};

  //----------<portnum> PROPERTY
  /**
   * @brief Property to set/return the currently selected 8-bit I/O-port.
   * This selection is related to io.portenabled and io.portstate properties.
   *
   * @remarks
   * Default value = PL_IO_PORT_NUM_0.
   */
  Property<pl_io_port_num, io> portnum{this, &io::PortNumSetter,
                                       &io::PortNumGetter,
                                       PropertyPermissions::ReadWrite};

  //----------<portstate> PROPERTY
  /**
   * @brief Property to set/return the 8-bit I/O port's state for the currently
   * selected I/O-port number. The I/O-line selection is made through the
   * 'io.num' property.
   *
   * @remarks
   * Ech individual bit in this byte value sets/returns the state of the
   * corresponding I/O-line within the port. Default value = 255.
   */
  Property<U8, io> portstate{this, &io::PortStateSetter, &io::PortStateGetter,
                             PropertyPermissions::ReadWrite};

  //----------<intenabled> PROPERTY
  /**
   * @brief Property to enable/disable the 'on_io_int' event for the currently
   * selected Interrupt-line number.
   *
   * @remarks
   * Default value = false.
   * The Interrupt-line selection is made through the 'io.intnum' property.
   */
  Property<bool, io> intenabled{this, &io::intIsEnabledSetter,
                                &io::intIsEnabledGetter,
                                PropertyPermissions::ReadWrite};

  //----------<intnum> PROPERTY
  /**
   * @brief Property to set/return the Interrupt-line's 'number' of the
   * currently selected Interrupt-line number. This selection is related to
   * io.intenabled property.
   *
   * @remark Default value = PL_INT_NUM_0.
   */
  Property<pl_int_num, io> intnum{this, &io::intNumSetter, &io::intNumGetter,
                                  PropertyPermissions::ReadWrite};

  //----------<lineget> FUNCTION
  /**
   * @brief Returns the 'state' of the currently selected i/o-line.
   *
   * @param num The specified I/O-line.
   *
   * @return low_high.
   */
  low_high lineget(pl_io_num num);

  //----------<linset> FUNCTION
  /**
   * @brief Sets the 'state' of the currently selected I/O-line.
   *
   * @remark
   * 1. The line must be configured as 'output' (io.enabled = true) for this
   * method to have any effect.
   * 2. The io.num and io.enabled will not be set implicitely by this function.
   *
   * @param num The specified I/O-line's 'number'.
   * @param state The I/0-line's state (0-LOW/1-HIGH).
   */
  void lineset(pl_io_num num, low_high state);

  //----------<invert> FUNCTION
  /**
 * @brief Inverts the 'state' of the currently selected i/o-line.

* @remark
* 1. The line must be configured as 'output' (io.enabled = true) for this
method to have any effect.
* 2. The io.num and io.enabled will not be set implicitely by this function.
* @param num   I/O-line.
*/
  void invert(pl_io_num num);

  //----------<portget> FUNCTION
  /**
   * @brief Returns the 8-bit I/O port's state for the currently selected
   * I/O-port number.
   *
   * @param portnum The specified I/O-port number.
   *
   * @return int
   */
  U8 portget(pl_io_port_num portnum);

  //----------<portset> FUNCTION
  /**
   * @brief Sets the 8-bit I/O port's state for the currently selected I/O-port
   * number. Each individual bit of the state argument defines the state of the
   * corresponding I/O-line within the port.
   *
   * @remark I/O-line(s) must be configured as 'output' for writes to this
   * property to have (full) effect. This means that I/O-line(s), which are set
   * as 'input', are ignored.
   *
   * @param portnum The specified I/O-port number.
   * @param state The 8-bit I/O-port's state.
   */
  void portset(pl_io_port_num portnum, U8 state);

  //-----------FUNCTIONS CALLED BY OTHER FILES
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

 private:  // any definition Above 'private' belongs to 'public'
  struct mon_ctx {
    /****** FROM LIBGPIOD***********/
    unsigned int offset;
    unsigned int events_wanted;
    unsigned int events_done;

    bool silent;
    char *fmt;

    int sigfd;
  };

  struct gpiod_chip *chip;
  struct gpiod_line *iolines[NUM_IO];
  low_high linestates[NUM_IO];
  struct mon_ctx ctx;

  //----------<num> PROPERTY variables & FUNCTIONS
  pl_io_num numValue = PL_IO_NUM_0;

  //----------<portenabled> PROPERTY variables & FUNCTIONS
  int portenabledValue[NUM_IO_PORT] = {0};

  //----------<portstate> PROPERTY variables & FUNCTIONS
  int portStateValue[NUM_IO_PORT] = {0};

  //----------<state> PROPERTY variables & FUNCTIONS
  low_high ioStateValue[NUM_IO] = {LOW};

  /**
   * @brief Sets the 'direction' of the currently selected I/O-line.
   *
   * @param isEnabled Boolean (true/false).
   */
  void EnabledSetter(bool isEnabled);

  /**
   * @brief Returns the 'direction' of the currently selected I/O-line.
   *
   * @return bool
   */
  bool EnabledGetter() const;

  /**
   * @brief Sets the'number' of the currently set I/O-line.
   *
   * @param num The specified I/O-line's 'number'.
   */
  void NumSetter(pl_io_num num);

  /**
   * @brief Returns the 'number' of the currently set I/O-line.
   *
   * @return pl_io_num
   */
  pl_io_num NumGetter() const;

  /**
   * @brief Sets the 'state' of the currently selected I/O-line.
   *
   * @param state The specified I/O-line's state.
   */
  void StateSetter(low_high state);

  /**
   * @brief Returns the 'state' of the currently set I/O-line.
   *
   * @page The line must be configured as 'output' (io.enabled = true) for this
   * method to have any effect
   *
   * @return low_high
   */
  low_high StateGetter() const;

  /**
   * @brief Sets the 'direction' of the currently selected 8-bit I/O-Port.
   *
   * @param isEnabledValue
   */
  void PortEnabledSetter(bool isEnabledValue);

  /**
   * @brief Returns the 'direction' of the currently selected 8-bit I/O-Port.
   *
   * @return int
   */
  bool PortEnabledGetter() const;

  //----------<portnum> PROPERTY variables & FUNCTIONS
  pl_io_port_num portNum = PL_IO_PORT_NUM_0;

  /**
   * @brief Sets the 'number' of the currently selected 8-bit I/O-port.
   *
   * @param portnum The specified 8-bit I/O-port's 'number'.
   */
  void PortNumSetter(pl_io_port_num portnum);

  /**
   * @brief Returns the 'number' of the currently selected 8-bit I/O-port.
   *
   * @return pl_io_port_num
   */
  pl_io_port_num PortNumGetter() const;

  /**
   * @brief Sets the 'state' of the currently selected 8-bit I/O-port.
   *
   * @param state The specified 8-bit I/O-port's state.
   */
  void PortStateSetter(U8 state);

  /**
   * @brief Returns the 'state' of the currently set 8-bit I/O-port.
   *
   * @remark The line must be configured as 'output' for this method to have any
   * effect.
   *
   * @return int.
   */
  U8 PortStateGetter() const;

  //----------<intenabled> PROPERTY variables & FUNCTIONS
  bool intIsEnabledValue = false;

  /**
   * @brief Property to enable/disable the 'on_io_int' event for the currently
   * selected Interrupt-line number.
   *
   * @param isIntEnabled Boolean (true/false) .
   */
  void intIsEnabledSetter(bool isIntEnabled);

  /**
   * @brief Returns the boolean (true/false) indicating whether the 'on_io_int'
   * event is enabled or disabled.
   *
   * @return bool.
   */
  bool intIsEnabledGetter() const;

  //----------<intnum> PROPERTY variables & FUNCTIONS
  pl_int_num intNumSetValue = PL_INT_NUM_0;

  // /**
  //  * @brief Gets the bit decimal value for the currently selected
  //  Interrupt-line number.
  //  *
  //  * @param intnum The specified Interrupt-line number.
  //  */
  // int intNumBitDecValueGetter(pl_int_num intnum);

  /**
   * @brief Sets the Integer-'number' of the currently selected Interrupt-line
   * number.
   *
   * @param intnum The specified Interrupt-line number.
   */
  void intNumSetter(pl_int_num intnum);

  /**
   * @brief Returns the 'number' of the currently set Interrupt-line number.
   *
   * @return pl_int_num.
   */
  pl_int_num intNumGetter() const;

  //----------VARIABLES
  std::string linuxIoFolder;
  int linuxIoNum;
  std::string getFileContentStrValue;
  int getFileContentIntValue;

  //----------ARRAYS
  static pl_io_struct ioArray[];
  static pl_int_struct intArray[];

  //-----------FUNCTIONS
  /**
   * @brief Returns the IO-Information based on the specified 'num' argument.
   *
   * @param num The selected I/O-line number.
   * @param int_num The selected Interrupt-line number.
   *
   * @remark
   * @return pl_io_struct.
   */
  pl_io_struct ioNumInfoGet(pl_io_num &num, pl_int_num &int_num);

  /**
   * @brief Updates the table containing the Interrupt-line numbers and their
   * active-status (true/false) respectively.
   *
   * @param intnum The specified Interrupt-line number.
   * @param isIntEnabled Boolean (true/false) .
   */
  void intUpdateVariables(pl_int_num &intnum, bool &isIntEnabled);

  /**
   * @brief Checks whether the directory specified by 'targetDir' argument
   * exists.
   *
   * @param targetDir Target directory which needs to be checked.
   *
   * @return bool.
   */
  bool dirExists(std::string &targetDir);  // note: '&' means 'pass by
                                           // Reference'

  /**
   * @brief Gets the file-content for a specified file.
   *
   * @param targetFullPath  Target file from which the content needs to be
   * retrieved.
   * @param valueLineNum  Line-number containing the content which needs to be
   * retrieved.
   * @param outputType  Specify whether the output will be an INTEGER or STRING.
   */
  void fileContentGetter(std::string &targetFullPath, int valueLineNum,
                         outputType_num outputType);

  /**
   * @brief Writes an integer or string value to the specified 'targetFullPath'
   * file.
   *
   * @param targetFullPath  Target file to which the content needs to be
   * written.
   * @param intValue  Integer value which needs to be written.
   * @param strValue  String value which needs to be written.
   */
  void writeToFile(
      std::string &targetFullPath, int intValue,
      std::string strValue);  // note: '&' means 'pass by Reference'

  /**
   * @brief Sets the 'direction' of the specified argument 'num' whether to in
   * or out. Remark: The 'direction' depends on the boolean 'isEnabled'. If
   * true, then the 'direction' is set to 'out'. If false, then the 'direction'
   * is set to 'in'.
   *
   * @param num   The specified I/O-line's 'number'.
   * @param isEnabled Boolean (true/false) .
   */
  void SetDirection(pl_io_num &num,
                    bool &isEnabled);  // note: '&' means 'pass by Reference'
};
}  // namespace ntios
#endif