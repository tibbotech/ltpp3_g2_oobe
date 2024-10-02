/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef SER_NTIOS_SER_H_
#define SER_NTIOS_SER_H_

#include <string>

#include "base/ntios_cbuff.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"
#include "io/ntios_io.h"
// #include "ser/ntios_ser.h"
#include "ser/ntios_serialport.h"

TIOS_WEAK void On_ser_data_arrival();
TIOS_WEAK void On_ser_data_sent();
TIOS_WEAK void On_ser_esc();

void dummy_global(ntios::serial::ser ser1);
namespace ntios {
namespace serial {

using ntios::base::CircularBuffer;
using ntios::serial::SerialPort;


class ser {
 public:
    ser();

    Property<U8, ser> num{this,
                            &ser::NumSetter,
                            &ser::NumGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_io_num, ser> rxmap{this,
                            &ser::rxmapSetter,
                            &ser::rxmapGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_io_num, ser> txmap{this,
                            &ser::txmapSetter,
                            &ser::txmapGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_io_num, ser> rtsmap{this,
                            &ser::rtsmapSetter,
                            &ser::rtsmapGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_io_num, ser> ctsmap{this,
                            &ser::ctsmapSetter,
                            &ser::ctsmapGetter,
                            PropertyPermissions::ReadWrite};

    Property<no_yes, ser> enabled{this,
                            &ser::EnabledSetter,
                            &ser::EnabledGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_ser_baudrates, ser> baudrate{this,
                            &ser::BaudRateSetter,
                            &ser::BaudRateGetter,
                            PropertyPermissions::ReadWrite};

    Property<U8, ser> escchar{this,
                            &ser::EscCharSetter,
                            &ser::EscCharGetter,
                            PropertyPermissions::ReadWrite};

    Property<pl_ser_esctype, ser> esctype{this,
                            &ser::EscTypeSetter,
                            &ser::EscTypeGetter,
                            PropertyPermissions::ReadWrite};

    Property<U32, ser> txbuffsize{this,
                            nullptr,
                            &ser::txbuffsizeGetter,
                            PropertyPermissions::Read};

    Property<pl_ser_flowcontrol, ser> flowcontrol{this,
                            &ser::FlowcontrolSetter,
                            &ser::FlowcontrolGetter,
                            PropertyPermissions::ReadWrite};

    Property<U8, ser> interchardelay{this,
                            &ser::InterchardelaySetter,
                            &ser::InterchardelayGetter,
                            PropertyPermissions::ReadWrite};

    Property<U32, ser> rxlen{this,
                            nullptr,
                            &ser::rxlenGetter,
                            PropertyPermissions::Read};
    U16 rxbuffrq(int cap);

    U16 txbuffrq(int cap);

    U32 setdata(std::string dt);

    void txclear();
    void rxclear();

    std::string getdata(U32 maxlen);

    void send();
    void notifysent(U16 threshold);

 private:
    friend class ntios::base::P1;
    friend class ntios::base::P2;
    friend class ntios::base::Periodic;
    U8 ser_num = 0;

    SerialPort sp[NUM_UARTS];

    void EnabledSetter(no_yes serBits);
    no_yes EnabledGetter() const;

    void NumSetter(uint8_t num);
    uint8_t NumGetter() const;

    uint32_t txbuffsizeGetter() const;

    U32 rxlenGetter() const;

    void BaudRateSetter(pl_ser_baudrates baudRate);
    pl_ser_baudrates BaudRateGetter() const;

    void EscCharSetter(U8 escChar);
    U8 EscCharGetter() const;

    void EscTypeSetter(pl_ser_esctype escType);
    pl_ser_esctype EscTypeGetter() const;


    void FlowcontrolSetter(pl_ser_flowcontrol fc);
    pl_ser_flowcontrol FlowcontrolGetter() const;

    void InterchardelaySetter(U8 delay);
    U8 InterchardelayGetter() const;

    void rxmapSetter(pl_io_num io_num);
    pl_io_num rxmapGetter() const;

    void txmapSetter(pl_io_num io_num);
    pl_io_num txmapGetter() const;

    void rtsmapSetter(pl_io_num io_num);
    pl_io_num rtsmapGetter() const;

    void ctsmapSetter(pl_io_num io_num);
    pl_io_num ctsmapGetter() const;

    void check_uarts();
    void comm_serv_ichar_delay();

    friend void dummy_global(ntios::serial::ser ser1);
    friend void dummy_global1();
};
}  // namespace serial
}  // namespace ntios

#endif  // SER_NTIOS_SER_H_
