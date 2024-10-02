/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef SSI_NTIOS_SSI_H_
#define SSI_NTIOS_SSI_H_

/* INCLUDES */
#include <string>

#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "ssi/ntios_ssichannel.h"   /* ssi/ntios_ssitypes.h is included in here */



/* NAMESPACES */
namespace ntios {
namespace ssintf {

/* CLASS */
class SSI {
 public:
    /* CONTRUCTOR: Initialization */
    SSI() : isChannelVal(0) {
        isBaudRateVal = PL_SSI_BAUD_FASTEST;
        isClkmapVal = PL_IO_NUM_NULL;
        isDimapVal = PL_IO_NUM_NULL;
        isDirectionVal = PL_SSI_DIRECTION_RIGHT;
        isDomapVal = PL_IO_NUM_NULL;
        isEnabledVal = NO;
        isModeVal = PL_SSI_MODE_0;
        isZmodeVal = PL_SSI_ZMODE_ALWAYS_ENABLED;

        for (U32 i = 0; i < NUM_SSI_CHANNELS; i++) {
            SSI_channels[i].channel = i;
        }
    }

    /* DESTRUCTOR: Deallocate Memory */
    ~SSI() {}



    /* PROPERTIES */

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the clock rate on the CLK line.
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 1-65535.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; fastest rate → set to 1.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; slowest rate → set to 65535.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; default value → 65535.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Actual clock rate is device-dependent. See Baudrate topic for details.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; It is actually permissible to set the property to 0 — this will be like setting it to 256 (slowest possible clock rate).
    */
    Property<pl_ssi_baud, SSI> baudrate{this, \
                &SSI::BaudRateSetter,
                    &SSI::BaudRateGetter,
                        PropertyPermissions::ReadWrite};

    /*
    * Sets/returns the number of the currently selected SSI channel (channels are enumerated from 0).
    *
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 0 - 3
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; All other properties and methods of this object relate to the specified channel.
    */
    Property<U8, SSI> channel{this, \
                &SSI::ChannelSetter, \
                    &SSI::ChannelGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the number of the general-purpose I/O line to serve as the 'Clock' (CLK) line of this channel.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: platform-specific. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; See the list of pl_io_num constants in the platform specifications.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Default= PL_IO_NUM_NULL (NULL-line).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; On devices with unidirectional I/O lines, the CLK line must be "manually" configured as output (io.enabled= YES(1)).
    */
    Property<pl_io_num, SSI> clkmap{this, \
                &SSI::ClkmapSetter, \
                    &SSI::ClkmapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the number of the general-purpose I/O line to serve as the 'Data In' (DI) line of this channel.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: platform-specific. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; See the list of pl_io_num constants in the platform specifications.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Default= PL_IO_NUM_NULL (NULL-line).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; On devices with unidirectional I/O lines, the CLK line must be "manually" configured as output (io.enabled= YES(1)).
    */
    Property<pl_io_num, SSI> dimap{this, \
                &SSI::DimapSetter, \
                    &SSI::DimapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the direction of data input and output (LSB or MSB first).
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Two directions:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_SSI_DIRECTION_RIGHT (default): data input/output least significant bit first
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_SSI_DIRECTION_LEFT: data input/output most significant bit first
    */
    Property<pl_ssi_direction_options, SSI> direction{this, \
                &SSI::DirectionSetter, \
                    &SSI::DirectionGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the number of the general-purpose I/O line to serve as the 'Data Out' (DO) line of this channel.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: platform-specific. 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; See the list of pl_io_num constants in the platform specifications.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Default= PL_IO_NUM_NULL (NULL-line).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; On devices with unidirectional I/O lines, the CLK line must be "manually" configured as output (io.enabled= YES(1)).
    */
    Property<pl_io_num, SSI> domap{this, \
                &SSI::DomapSetter, \
                    &SSI::DomapGetter, \
                        PropertyPermissions::ReadWrite};

    /*
    * Enables/disables the currently selected SSI channel (see ssi.channel).
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - NO (default): disabled.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; Default= PL_IO_NUM_NULL (NULL-line).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; SSI channel's operating parameters (ssi.baudrate, ssi.mode, etc.) can only be changed when the channel is disabled.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; You can only send and receive the data (ssi.value, ssi.str) when the channel is enabled.   
    */
    Property<no_yes, SSI> enabled{this, \
                    &SSI::EnabledSetter, \
                        &SSI::EnabledGetter, \
                            PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the clock mode.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_SSI_MODE_0 (default).
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_SSI_MODE_1.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 2 - PL_SSI_MODE_2.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 3 - PL_SSI_MODE_3.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull;For detailed explanation of clock modes see SSI Modes.
    */
    Property<pl_ssi_mode, SSI> mode{this, \
                    &SSI::ModeSetter, \
                        &SSI::ModeGetter, \
                            PropertyPermissions::ReadWrite};

    /*
    * For the currently selected SSI channel (see ssi.channel) sets/returns the mode of the Data Out (DO) line.
    * 
    * Remarks:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property can only be changed when ssi.enabled= NO(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Value range: 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 0 - PL_SSI_ZMODE_ALWAYS_ENABLED (default): 
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- DO-line toggles normally by setting the output buffer to LOW or HIGH.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; 1 - PL_SSI_ZMODE_ENABLED_ON_ZERO:
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- HIGH state → output buffer of the DO-line is turned OFF.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- LOW state → output buffer of DO-line is turned ON and set to LOW.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; This property is only useful on devices with unidirectional IO-lines and in case the DO- and DI-lines are joined together, as necessary for the I2C and similar interfaces. See More on I2C for more details.
    */
    Property<pl_ssi_zmodes, SSI> zmode{this, \
                &SSI::ZmodeSetter, \
                    &SSI::ZmodeGetter, \
                        PropertyPermissions::ReadWrite};



    /* FUNCTIONS */

    /*
    * For the currently selected SSI channel (see ssi.channel), outputs a data word of up to 16 bits and simultaneously inputs a data word of the same length.
    * 
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; txdata: Data to output TO SLAVE device. The number of rightmost bits equal to the length argument will be sent.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; len: Number of data bits to send to and receive from the SLAVE device.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; Received data FROM SLAVE.
    * Remark:
	*&nbsp;&nbsp;&nbsp;&nbsp;&bull; This method can be invoked only when ssi.enabled = YES(1). In case of an error, the result will be a zero(0).
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The 'len' can not be greater than 16. If greater than 16, then the 'len' will be automatically set to 16.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The data input/output direction (LSB first or MSB first) is defined by the ssi.direction property.
    */
    U16 value(U16 txdata, U8 len);

    /*
	* For the currently selected SSI channel (see ssi.channel) outputs a string of byte data to the slave device and simultaneously inputs the same amount of data from the slave device.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; txdata: string to be sent to the Slave device.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; ack_bit: whether to send data with or without ackknowledgement bit.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; NO(0): transmit/receive byte data as 8-bit words, without the use of the acknowledgement bit.
    *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&divide; YES(1): transmit/receive byte data as 9-bit words comprising 8 bits of data and the acknowledgement bit.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; A string of the same length as txdata or less if the transmission ended prematurely due to the acknowledgement error.
    * Remark:
	*&nbsp;&nbsp;&nbsp;&nbsp;&bull; This method can be invoked only when ssi.enabled= YES(1). In case of an error, the result will be an Empty String.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The String-length can NOT be longer than 65535 characters in length. In case of an error, in case of an error, the result will be an Empty String.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The data input/output direction (LSB first or MSB first) is defined by the ssi.direction property.
    */
    std::string str(const std::string &txdata, pl_ssi_ack_modes ack_bit);



 private:
    /* Define Array-Instance */
    ntios::ssintf::SSI_channel SSI_channels[NUM_SSI_CHANNELS];

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
};

} /* namespace ssintf */
} /* namespace ntios */

#endif  // SSI_NTIOS_SSI_H_
