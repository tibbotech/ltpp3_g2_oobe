/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef SSI_NTIOS_SSICHANNEL_H_
#define SSI_NTIOS_SSICHANNEL_H_

/* INCLUDES */
#include <string>

#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "io/ntios_io.h"
#include "ssi/ntios_ssitypes.h"
#include "gpiodfunc/ntios_gpiodfunc.h"



/* NAMESPACES */
namespace ntios {
namespace ssintf {



/* CLASS */
class SSI_channel {
 public:
    /* CONSTRUCTOR */
    /*
    * Initializes (const) parameters
    * isChannelVal = 0
    * isBaudRateVal = PL_SSI_BAUD_FASTEST
    * etc.
    */
    SSI_channel() : isChannelVal(0) {
        isBaudRateVal = PL_SSI_BAUD_FASTEST;
        isClkmapVal = PL_IO_NUM_NULL;
        isDimapVal = PL_IO_NUM_NULL;
        isDirectionVal = PL_SSI_DIRECTION_RIGHT;
        isDomapVal = PL_IO_NUM_NULL;
        isEnabledVal = NO;
        isModeVal = PL_SSI_MODE_0;
        isZmodeVal = PL_SSI_ZMODE_ALWAYS_ENABLED;
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~SSI_channel() {}



    /* PROPERTIES */
    Property<pl_ssi_baud, SSI_channel> baudrate{this, \
                &SSI_channel::BaudRateSetter,
                    &SSI_channel::BaudRateGetter,
                        PropertyPermissions::ReadWrite};

    Property<U8, SSI_channel> channel{this, \
                &SSI_channel::ChannelSetter, \
                    &SSI_channel::ChannelGetter, \
                        PropertyPermissions::ReadWrite};

    Property<pl_io_num, SSI_channel> clkmap{this, \
                &SSI_channel::ClkmapSetter, \
                    &SSI_channel::ClkmapGetter, \
                        PropertyPermissions::ReadWrite};

    Property<pl_io_num, SSI_channel> dimap{this, \
                &SSI_channel::DimapSetter, \
                    &SSI_channel::DimapGetter, \
                        PropertyPermissions::ReadWrite};

    Property<pl_ssi_direction_options, SSI_channel> direction{this, \
                &SSI_channel::DirectionSetter, \
                    &SSI_channel::DirectionGetter, \
                        PropertyPermissions::ReadWrite};

    Property<pl_io_num, SSI_channel> domap{this, \
                &SSI_channel::DomapSetter, \
                    &SSI_channel::DomapGetter, \
                        PropertyPermissions::ReadWrite};

    Property<no_yes, SSI_channel> enabled{this, \
                &SSI_channel::EnabledSetter, \
                    &SSI_channel::EnabledGetter,
                        PropertyPermissions::ReadWrite};

    Property<pl_ssi_mode, SSI_channel> mode{this, \
                &SSI_channel::ModeSetter, \
                    &SSI_channel::ModeGetter, \
                        PropertyPermissions::ReadWrite};

    Property<pl_ssi_zmodes, SSI_channel> zmode{this, \
                &SSI_channel::ZmodeSetter, \
                    &SSI_channel::ZmodeGetter, \
                        PropertyPermissions::ReadWrite};



    /* FUNCTIONS */
    U16 value(U16 txdata, U8 len);
    std::string str(const std::string &txdata, \
                        pl_ssi_ack_modes ack_mode);

    // U8 value(U8 txdata);



 private:
    /* <enabled> PROPERTY parameters & functions */
    pl_ssi_baud isBaudRateVal;   /* default = 1 */
    void BaudRateSetter(pl_ssi_baud isBaudRate);
    pl_ssi_baud BaudRateGetter() const;

    /* <channel> PROPERTY parameters & functions */
    U8 isChannelVal;  /* Initialized */
    void ChannelSetter(U8 isChannel);
    U8 ChannelGetter() const;

    /* <clkmap> PROPERTY parameters & functions */
    pl_io_num isClkmapVal;
    void ClkmapSetter(pl_io_num isClkmap);
    pl_io_num ClkmapGetter() const;

    /* <dimap> PROPERTY parameters & functions */
    pl_io_num isDimapVal;
    void DimapSetter(pl_io_num isDimap);
    pl_io_num DimapGetter() const;

    /* <direction> PROPERTY parameters & functions */
    pl_ssi_direction_options isDirectionVal;
    void DirectionSetter(pl_ssi_direction_options isDirection);
    pl_ssi_direction_options DirectionGetter() const;

    /* <domap> PROPERTY parameters & functions */
    pl_io_num isDomapVal;
    void DomapSetter(pl_io_num isDomap);
    pl_io_num DomapGetter() const;

    /* <enabled> PROPERTY parameters & functions */
    bool isEnabledVal;
    void EnabledSetter(no_yes isEnabled);
    no_yes EnabledGetter() const;

    /* <mode> PROPERTY parameters & functions */
    pl_ssi_mode isModeVal;
    void ModeSetter(pl_ssi_mode isMode);
    pl_ssi_mode ModeGetter() const;

    /* <zmode> PROPERTY parameters & functions */
    pl_ssi_zmodes isZmodeVal;
    void ZmodeSetter(pl_ssi_zmodes isZmode);
    pl_ssi_zmodes ZmodeGetter() const;



    /* FUNCTIONS */
    U16 ssi_word_asm(U16 txdata_in, \
                    U8 len_in, \
                    U16 baudrate_in, \
                    pl_io_num clkmap_in, \
                    pl_io_num dimap_in, \
                    pl_ssi_direction_options direction_in, \
                    pl_io_num domap_in, \
                    pl_ssi_mode mode_in, \
                    pl_ssi_zmodes zmode_in);

    /*
    * The actual function which handles the output a data word of up to 16 bits and simultaneously inputs a data word of the same length.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; In TiOS, a dedicated 'ssi_exec' function is used for each channel (0-3).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; It appears that ssi_exec1, ssi_exec2, and ssi_exec3 are all the same.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The difference between ssi_exec0 and the other 3 functions is the moment WHEN
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; the SECOND DELAY happens:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; In ssi_exec0, the delay happens BEFORE the 'READ MISO'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; For the other functions, the delay happens AFTER the 'READ MISO'.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; This is according to the example as shown in the wiki: https://en.wikipedia.org/wiki/Serial_Peripheral_Interface
    */
    U16 ssi_exe(U16 txdata_in, \
                    U8 len_in, \
                    U16 baudrate_in, \
                    pl_io_num clkmap_in, \
                    pl_io_num dimap_in, \
                    pl_ssi_direction_options direction_in, \
                    pl_io_num domap_in, \
                    pl_ssi_mode mode_in, \
                    pl_ssi_zmodes zmode_in);
}; /* class SSI_channel */

} /* namespace ssintf */
} /* namespace ntios */

#endif  // SSI_NTIOS_SSICHANNEL_H_
