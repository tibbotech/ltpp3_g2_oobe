/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_IO_IO_H_
#define NTIOS_XPAT_IO_IO_H_

#include <memory>

#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "io/ntios_io_config.h"
#include "io/ntios_io_map.h"

namespace ntios {
namespace io {

using ntios::io::internal::NUM_IO;

class Io {
  //   /*
  //    * Remarks
  //    * Functions starting with 'gpiod' (e.g. gpiod_chip_open_by_name,
  //    * gpiod_chip_get_line, etc.) are included in the 'gpiod.h' library
  //    */

 public:
#pragma region Properties
  Io();
  /**
   * @brief Sets/returns the state of the output buffer for the currently
   *        selected I/O line (selection is made through the io.num property).
   *
   * @remarks 0 — NO: (default): disabled, I/O line works as an input
   *          1 — YES: enabled, I/O line works as an output
   *
   */
  Property<no_yes, Io> enabled{this, &Io::EnabledSetter, &Io::EnabledGetter,
                               PropertyPermissions::ReadWrite};

  /**
   * @brief Sets/returns the interrupt edge for the currently selected I/O
   */
  Property<pl_int_edge, Io> intedge{this, &Io::IntEdgeSetter, &Io::IntEdgeGetter,
                                 PropertyPermissions::ReadWrite};

  /**
   * @brief Property to enable/disable the 'on_io_int' event for the
   *        currently selected Interrupt-line number.
   *
   * @remarks Default value = false. The Interrupt-line selection is made
   *          through the 'io.intnum' property.
   */
  Property<no_yes, Io> intenabled{this, &Io::IntEnabledSetter,
                                  &Io::IntEnabledGetter,
                                  PropertyPermissions::ReadWrite};

  /**
   * @brief Property to set/return the Interrupt-line's 'number' of the
   * currently selected Interrupt-line number. This selection is related to
   * io.intenabled property.
   *
   * @remark Default value = PL_INT_NUM_0.
   */
  Property<pl_int_num, Io> intnum{this, &Io::IntNumSetter, &Io::IntNumGetter,
                                  PropertyPermissions::ReadWrite};

  /**
   * @brief Sets/returns the number of currently selected I/O line.
   *
   * @remarks Default value = PL_IO_NUM_0.
   */
  Property<pl_io_num, Io> num{this, &Io::NumSetter, &Io::NumGetter,
                              PropertyPermissions::ReadWrite};

  /**
   * @brief Sets/returns the 'direction' of the currently selected 8-bit
   * Io-port consisting of 8 Io-lines.
   *
   * @remarks For each bit (line) '0' means 'input' and '1' means 'output'.
   *          Default value = 0.
   *          If 'portenabled = 0', then ALL Io-lines' direction are set to 'in'
   *          (unless certain Io lines are already reserved for TX, RX, RTS,
   *          CTS). If 'portenabled = 255', then ALL Io-lines' direction are set
   *          to 'out' (unless certain Io lines are already reserved for TX, RX,
   *          RTS, CTS). The Io-port selection is made through the 'io.portnum'
   *          property.
   */
  Property<byte, Io> portenabled{this, &Io::PortEnabledSetter,
                                 &Io::PortEnabledGetter,
                                 PropertyPermissions::ReadWrite};

  /**
   * @brief Property to set/return the currently selected 8-bit Io-port.
   *        This selection is related to io.portenabled and io.portstate
   *        properties.
   *
   * @remarks Default value = PL_IO_PORT_NUM_0.
   */
  Property<pl_io_port_num, Io> portnum{this, &Io::PortNumSetter,
                                       &Io::PortNumGetter,
                                       PropertyPermissions::ReadWrite};

  /**
   * @brief Property to set/return the 8-bit Io port's state for the currently
   *        selected Io-port number. The Io-line selection is made through the
   *        'io.num' property.
   *
   * @remarks Each individual bit in this byte value sets/returns the state of
   *          the corresponding Io-line within the port. Default value = 255.
   */
  Property<U8, Io> portstate{this, &Io::PortStateSetter, &Io::PortStateGetter,
                             PropertyPermissions::ReadWrite};

  /**
   * @brief Sets/returns the state of the currently selected I/O line (selection
   * is made through the io.num property).
   *
   * @remark Default value = LOW.
   */
  Property<low_high, Io> state{this, &Io::StateSetter, &Io::StateGetter,
                               PropertyPermissions::ReadWrite};
#pragma endregion Properties

#pragma region Methods

  /**
   * @brief Inverts the state of the I/O line specified by the num argument.
   *
   * @param num I/O line number to invert.
   */
  void invert(pl_io_num num);

  /**
   * @brief Returns the state of the I/O line specified by the num argument.
   *
   * @param num Platform-specific. See the list of pl_io_num constants in the
   * platform specifications.
   *
   * @return Current line state as LOW or HIGH (low_high enum values)
   */
  low_high lineget(pl_io_num num);

  /**
   * @brief Sets the I/O line specified by the num argument HIGH or LOW as
   *        specified by the state argument.
   *
   * @param num Platform-specific. See the list of pl_io_num constants in the
   * platform specifications.
   *
   * @param state LOW or HIGH (low_high enum values).
   */
  void lineset(pl_io_num num, low_high state);

  /**
   * @brief Returns the 8-bit Io port's state for the currently selected
   *        Io-port number.
   *
   * @param portnum The specified Io-port number.
   *
   * @return byte The 8-bit Io-port's state.
   */
  byte portget(pl_io_port_num portnum);

  /* <portset> FUNCTION */
  /**
   * @brief Sets the 8-bit Io port's state for the currently selected Io-port
   *        number. Each individual bit of the state argument defines the state
   *        of the corresponding Io-line within the port.
   *
   * @remark Io-line(s) must be configured as 'output' for writes to this
   *         property to have (full) effect. This means that Io-line(s), which
   *         are set as 'input', are ignored.
   *
   * @param portnum The specified Io-port number.
   * @param state The 8-bit Io-port's state.
   */
  void portset(pl_io_port_num portnum, byte state);

#pragma endregion Methods

 private:
  /**
   * @brief Checks whether the specified IO-line num is valid for the platform
   *
   * @param num  The specified IO-line num.
   * @return true -  The specified IO-line num is valid for the platform
   *         false - The specified IO-line num is not valid for the platform
   */
  static bool NumIsValid(byte num);
  static bool IntNumIsValid(byte intnum);
  static bool PortNumIsValid(byte portnum);

  byte mNum = (byte)PL_IO_NUM_0;
  byte mIntNum[NUM_IO];
  pl_int_edge mIntEdge[NUM_IO];

  byte mPortNum = (byte)PL_IO_PORT_NUM_0;

#pragma region Properties

  /**
   * @brief Sets the 'direction' of the currently selected Io-line.
   *
   * @param isEnabled Boolean (YES/NO).
   */
  void EnabledSetter(no_yes isEnabled);

  /**
   * @brief Returns the 'direction' of the currently selected Io-line.
   *
   * @return no_yes
   */
  no_yes EnabledGetter() const;

  /**
   * @brief Returns the 'edge' of the currently selected interrupt line.
   *
   * @return pl_int_edge
   */
  pl_int_edge IntEdgeGetter() const;

  /**
   * @brief Sets the 'edge' of the currently selected interrupt line.
   *
   * @param edge pl_int_edge
   */
  void IntEdgeSetter(pl_int_edge edge);

  /**
   * @brief  enables or disables the interrupt number
   *         io line pair that is selected.
   */
  void IntEnabledSetter(no_yes isEnabled);

  /**
   * @brief Returns if the current io/interrupt pair is enabled.
   *
   * @return no_yes
   */
  no_yes IntEnabledGetter() const;

  /**
   * @brief Sets the currently selected Io-Line
   *
   * @param num The selected Io-line number.
   */
  void NumSetter(pl_io_num num);

  /**
   * @brief Returns the 'number' of the currently selected Io-line.
   *
   * @return pl_io_num
   */
  pl_io_num NumGetter() const;

  /**
   * @brief Returns the 'number' of the currently selected 8-bit Io-port.
   *
   * @return pl_io_port_num
   */
  pl_io_port_num PortNumGetter() const;

  /**
   * @brief Sets the 'number' of the currently selected 8-bit Io-port.
   *
   * @param portnum The specified 8-bit Io-port's 'number'.
   */
  void PortNumSetter(pl_io_port_num portnum);

  /**
   * @brief Sets the 'direction' of the currently selected 8-bit Io-Port.
   *
   * @param isEnabledVal
   */
  void PortEnabledSetter(byte enabled);  // 0 - 255

  /**
   * @brief Returns the 'direction' of the currently selected 8-bit Io-Port.
   *
   * @return byte decimal value
   *
   */
  byte PortEnabledGetter() const;

  /**
   * @brief Sets the 'state' of the currently selected 8-bit Io-port.
   *
   * @param state The specified 8-bit Io-port's state.
   */
  void PortStateSetter(byte state);  // 0 - 255

  /**
   * @brief Returns the 'state' of the currently set 8-bit Io-port.
   *
   * @remark The line must be configured as 'output' for this method to have any
   *         effect.
   *
   * @return int.
   */
  byte PortStateGetter() const;

  /**
   * @brief Sets the 'state' of the currently selected Io-line.
   *
   * @param state 0 — LOW
   *              1 — HIGH
   */
  void StateSetter(low_high state);

  /**
   * @brief Returns the 'state' of the currently selected Io-line.
   *
   * @return low_high
   */
  low_high StateGetter() const;

#pragma endregion Properties

  /**
 * @brief Sets the Integer-'number' of the currently selected
 Interrupt-line
 * number.
 *
 * @param intnum The specified Interrupt-line number.
 */
  void IntNumSetter(pl_int_num intnum);

  /**
   * @brief Returns the 'number' of the currently set Interrupt-line
   number.
   *
   * @return pl_int_num.
   */
  pl_int_num IntNumGetter() const;

};  // class Io

}  // namespace io
}  // namespace ntios

template <typename C>
std::string operator+(const std::string& s, const Property<pl_io_num, C>& p) {
  pl_io_num pval = p;
  return s + std::to_string((int)pval);
  ;
}

template <typename C>
std::string operator+(const char* s, const Property<pl_io_num, C>& p) {
  pl_io_num pval = p;
  return (string)s + std::to_string((int)pval);
  ;
}

template <typename C>
std::string operator+(const Property<pl_io_num, C>& p, const std::string& s) {
  pl_io_num pval = p;
  return std::to_string((int)pval) + s;
}

template <typename C>
std::string operator+(const Property<pl_io_num, C>& p, const char* s) {
  pl_io_num pval = p;
  return std::to_string((int)pval) + (string)s;
}

template <typename C>
std::string operator+(const std::string& s, const Property<low_high, C>& p) {
  low_high pval = p;
  return s + std::to_string((int)pval);
  ;
}

template <typename C>
std::string operator+(const char* s, const Property<low_high, C>& p) {
  low_high pval = p;
  return (string)s + std::to_string((int)pval);
  ;
}

template <typename C>
std::string operator+(const Property<low_high, C>& p, const std::string& s) {
  low_high pval = p;
  return std::to_string((int)pval) + s;
}

template <typename C>
std::string operator+(const Property<low_high, C>& p, const char* s) {
  low_high pval = p;
  return std::to_string((int)pval) + (string)s;
}

#endif  // NTIOS_XPAT_IO_IO_H_