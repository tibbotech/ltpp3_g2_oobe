/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef SSI_NTIOS_SSI_H_
#define SSI_NTIOS_SSI_H_

/* INCLUDES */
#include <string>

#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "ssi/ntios_ssichannel.h"

namespace ntios {
namespace ssintf {

class SSI {
 public:
  SSI() : mChannel(0) {}

#pragma region Properties

  /**
   * @brief For the currently selected SSI channel (see ssi.channel)
   * sets/returns the clock rate on the CLK line.
   *
   * @remark The actual clock rate is device-dependent;
   *         This property can only be changed when ssi.enabled = 0 — NO.
   * @return pl_ssi_baud The clock rate on the CLK line.
   */
  Property<pl_ssi_baud, SSI> baudrate{this, &SSI::BaudRateSetter,
                                      &SSI::BaudRateGetter,
                                      PropertyPermissions::ReadWrite};

  /**
   * @brief Sets or returns the number of the currently selected SSI channel.
   * @details Channels are enumerated from 0. All other properties and methods
   *          of the ssi object relate to the channel selected through this
   * property.
   * @note The default channel is 0 (channel #0 selected).
   * @return unsigned char
   *         The number of the currently selected SSI channel.
   */
  Property<U8, SSI> channel{this, &SSI::ChannelSetter, &SSI::ChannelGetter,
                            PropertyPermissions::ReadWrite};

  /**
   * @brief Sets or returns the number of the general-purpose I/O line to serve
   *        as the 'Clock' (CLK) line for the currently selected SSI channel.
   *@details This property can only be changed when ssi.enabled is set to 0. The
   *         CLK line must be configured as an output (io.enabled is set to 1).
   * @return pl_io_num The number of the general-purpose I/O line to serve as
   *the 'Clock' (CLK) line for the currently selected SSI channel.
   */
  Property<pl_io_num, SSI> clkmap{this, &SSI::ClkmapSetter, &SSI::ClkmapGetter,
                                  PropertyPermissions::ReadWrite};

  /**
   * @brief Sets or returns the number of the general-purpose I/O line to serve
   *        as the data in (DI) line for the currently selected SSI channel.
   * @details This property can only be changed when ssi.enabled is set to 0.
   *          The DI line must be configured as an input (io.enabled is set to
   * 0).
   * @return pl_io_num The number of the general-purpose I/O line to serve as
   * the data in (DI) line for the currently selected SSI channel.
   */
  Property<pl_io_num, SSI> dimap{this, &SSI::DimapSetter, &SSI::DimapGetter,
                                 PropertyPermissions::ReadWrite};

  /**
   * @brief Sets or returns the direction of data input and output (least
   *         significant bit first or most significant bit first) for the
   *         currently selected SSI channel.
   * @details This property can only be changed when ssi.enabled is set to 0.
   *          0 - PL_SSI_DIRECTION_RIGHT (default): Least significant bit first.
   *          1 - PL_SSI_DIRECTION_LEFT: Most significant bit first.
   * @return pl_ssi_direction_options The direction of data input and output for
   * the currently selected SSI channel.
   */
  Property<pl_ssi_direction_options, SSI> direction{
      this, &SSI::DirectionSetter, &SSI::DirectionGetter,
      PropertyPermissions::ReadWrite};

  /**
   * @brief For the currently selected SSI channel (see ssi.channel),
   *        sets/returns the number of the general-purpose I/O line to serve as
   *        the data out (DO) line of this channel.
   * @details: This property can only be changed when ssi.enabled = 0 — NO.
   *           The DO line must be configured as an output (io.enabled = 1 —
   *           YES).
   * @return pl_io_num The number of the general-purpose I/O line to serve as
   * the data out (DO) line for the currently selected SSI channel.
   */
  Property<pl_io_num, SSI> domap{this, &SSI::DomapSetter, &SSI::DomapGetter,
                                 PropertyPermissions::ReadWrite};

  /**
   * @brief Enables or disables the currently selected SSI channel.
   *
   * @details The SSI channel's operating parameters (ssi.baudrate, ssi.mode,
   * etc.) can only be changed when the channel is disabled. You can only send
   * and receive data (ssi.value and ssi.str) when the channel is enabled.
   *
   * @param enable A boolean value indicating whether to enable (true) or
   * disable (false) the SSI channel.
   *
   * @return no_yes The current state of the SSI channel.
   */
  Property<no_yes, SSI> enabled{this, &SSI::EnabledSetter, &SSI::EnabledGetter,
                                PropertyPermissions::ReadWrite};

  /**
   * @brief Sets or returns the clock mode for the currently selected SSI
   * channel.
   * @details This property can only be changed when ssi.enabled = 0. For a
   * detailed explanation of clock modes, see SSI Modes.
   * @return pl_ssi_mode The clock mode for the currently selected SSI channel.
   */
  Property<pl_ssi_mode, SSI> mode{this, &SSI::ModeSetter, &SSI::ModeGetter,
                                  PropertyPermissions::ReadWrite};

  /**
   * @brief For the currently selected SSI channel, sets or returns the mode of
   * the Data Out (DO) line.
   * @details This property is only useful on devices with unidirectional I/O
   * lines and, in case the DO and DI lines are joined together, as necessary
   * for the I²C and similar interfaces. See More on I2C for more details. This
   * property can only be changed when ssi.enabled = 0 — NO.
   * @return pl_ssi_zmodes The mode of
   * the Data Out (DO) line.
   */
  Property<pl_ssi_zmodes, SSI> zmode{this, &SSI::ZmodeSetter, &SSI::ZmodeGetter,
                                     PropertyPermissions::ReadWrite};

#pragma endregion

  /**
   * @brief For the currently selected SSI channel (see ssi.channel), outputs a
   * data word of up to 16 bits and simultaneously inputs a data word of the
   * same length.
   * @param txdata Data to output to the slave device. The number of rightmost
   * bits equal to the len argument will be sent.
   * @param len Number of data bits to send to and receive from the slave
   * device.
   * @return 16-bit value containing the data received from the slave device,
   * the number of bits received from the slave device will be equal to the len
   * argument, and these data bits will be right-aligned within the returned
   * 16-bit word.
   * @details The data input/output direction (least significant bit first or
   * most significant bit first) is defined by the ssi.direction property. This
   * method can be invoked only when ssi.enabled = 1 — YES.
   */
  word value(word txdata, U8 len);

  /**
   * @brief For the currently selected SSI channel (see ssi.channel), outputs a
   * string of byte data to the slave device and simultaneously inputs the same
   * amount of data from the slave device.
   *
   * @param txdata The string to send to the slave device.
   * @param ack_bit 0 — NO: transmit/receive byte data as 8-bit words, without
   * the use of the acknowledgment bit.
   * 1 — YES: transmit/receive byte data as
   * 9-bit words comprising 8 bits of data and the acknowledgment bit.
   * @return string A string of the same length as txdata or less if the
   * transmission ended prematurely due to the acknowledgment error.
   */
  std::string str(const std::string &txdata, pl_ssi_ack_modes ack_bit);

 private:
  /* Define Array-Instance */
  ntios::ssintf::SSI_channel SSI_channels[NUM_SSI_CHANNELS];

  void BaudRateSetter(pl_ssi_baud isBaudRate);
  pl_ssi_baud BaudRateGetter() const;

  U8 mChannel;
  void ChannelSetter(U8 isChannel);
  U8 ChannelGetter() const;

  void ClkmapSetter(pl_io_num isClkmap);
  pl_io_num ClkmapGetter() const;

  void DimapSetter(pl_io_num isDimap);
  pl_io_num DimapGetter() const;

  void DirectionSetter(pl_ssi_direction_options isDirection);
  pl_ssi_direction_options DirectionGetter() const;

  void DomapSetter(pl_io_num isDomap);
  pl_io_num DomapGetter() const;

  void EnabledSetter(no_yes isEnabled);
  no_yes EnabledGetter() const;

  void ModeSetter(pl_ssi_mode isMode);
  pl_ssi_mode ModeGetter() const;

  void ZmodeSetter(pl_ssi_zmodes isZmode);
  pl_ssi_zmodes ZmodeGetter() const;
};

} /* namespace ssintf */
} /* namespace ntios */

#endif  // SSI_NTIOS_SSI_H_
