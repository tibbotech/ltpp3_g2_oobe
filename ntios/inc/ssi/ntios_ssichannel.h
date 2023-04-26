/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef SSI_NTIOS_SSICHANNEL_H_
#define SSI_NTIOS_SSICHANNEL_H_

#include <string>

#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "io/ntios_io.h"
#include "ssi/ntios_ssitypes.h"

namespace ntios {
namespace ssintf {

class SSI_channel {
 public:
  SSI_channel();

#pragma region Properties

  Property<pl_ssi_baud, SSI_channel> baudrate{
      this, &SSI_channel::BaudRateSetter, &SSI_channel::BaudRateGetter,
      PropertyPermissions::ReadWrite};

  Property<pl_io_num, SSI_channel> clkmap{this, &SSI_channel::ClkmapSetter,
                                          &SSI_channel::ClkmapGetter,
                                          PropertyPermissions::ReadWrite};

  Property<pl_io_num, SSI_channel> dimap{this, &SSI_channel::DimapSetter,
                                         &SSI_channel::DimapGetter,
                                         PropertyPermissions::ReadWrite};

  Property<pl_ssi_direction_options, SSI_channel> direction{
      this, &SSI_channel::DirectionSetter, &SSI_channel::DirectionGetter,
      PropertyPermissions::ReadWrite};

  Property<pl_io_num, SSI_channel> domap{this, &SSI_channel::DomapSetter,
                                         &SSI_channel::DomapGetter,
                                         PropertyPermissions::ReadWrite};

  Property<no_yes, SSI_channel> enabled{this, &SSI_channel::EnabledSetter,
                                        &SSI_channel::EnabledGetter,
                                        PropertyPermissions::ReadWrite};

  Property<pl_ssi_mode, SSI_channel> mode{this, &SSI_channel::ModeSetter,
                                          &SSI_channel::ModeGetter,
                                          PropertyPermissions::ReadWrite};

  Property<pl_ssi_zmodes, SSI_channel> zmode{this, &SSI_channel::ZmodeSetter,
                                             &SSI_channel::ZmodeGetter,
                                             PropertyPermissions::ReadWrite};

#pragma endregion

  word value(word txdata, unsigned char len);
  std::string str(const std::string &txdata, pl_ssi_ack_modes ack_mode);

 private:
#pragma region Baudrate
  pl_ssi_baud mBaudRate;
  void BaudRateSetter(pl_ssi_baud isBaudRate);
  pl_ssi_baud BaudRateGetter() const;
#pragma endregion

#pragma region Clock Map
  pl_io_num isClkmapVal = PL_IO_NULL;
  void ClkmapSetter(pl_io_num isClkmap);
  pl_io_num ClkmapGetter() const;
#pragma endregion

  pl_io_num isDimapVal;
  void DimapSetter(pl_io_num isDimap);
  pl_io_num DimapGetter() const;

  pl_ssi_direction_options isDirectionVal;
  void DirectionSetter(pl_ssi_direction_options isDirection);
  pl_ssi_direction_options DirectionGetter() const;

  pl_io_num isDomapVal;
  void DomapSetter(pl_io_num isDomap);
  pl_io_num DomapGetter() const;

  bool isEnabledVal;
  void EnabledSetter(no_yes isEnabled);
  no_yes EnabledGetter() const;

  pl_ssi_mode isModeVal;
  void ModeSetter(pl_ssi_mode isMode);
  pl_ssi_mode ModeGetter() const;

  pl_ssi_zmodes isZmodeVal;
  void ZmodeSetter(pl_ssi_zmodes isZmode);
  pl_ssi_zmodes ZmodeGetter() const;

  U16 ssi_word_asm(U16 txdata_in, U8 len_in, U16 baudrate_in,
                   pl_io_num clkmap_in, pl_io_num dimap_in,
                   pl_ssi_direction_options direction_in, pl_io_num domap_in,
                   pl_ssi_mode mode_in, pl_ssi_zmodes zmode_in);

  /*
   * The actual function which handles the output a data word of up to 16 bits
   * and simultaneously inputs a data word of the same length. The is a software
   * implementation of spi as explained in:
   * https://en.wikipedia.org/wiki/Serial_Peripheral_Interface
   */
  U16 ssi_exe(U16 txdata_in, U8 len_in, U16 baudrate_in, pl_io_num clkmap_in,
              pl_io_num dimap_in, pl_ssi_direction_options direction_in,
              pl_io_num domap_in, pl_ssi_mode mode_in, pl_ssi_zmodes zmode_in);
}; /* class SSI_channel */

} /* namespace ssintf */
} /* namespace ntios */

#endif  // SSI_NTIOS_SSICHANNEL_H_
