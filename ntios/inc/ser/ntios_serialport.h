#ifndef NTIOS_SER_SERIALPORT_
#define NTIOS_SER_SERIALPORT_
#include <string>

//#include "io/ntios_io.h"
#include "base/ntios_base.h"
#include "base/ntios_cbuff.h"
#include "base/ntios_config.h"
#include "base/ntios_evfifo.h"
#include "base/ntios_log.h"
#include "base/ntios_property.h"
#include "base/ntios_types.h"

void dummy_global(ntios::serial::ser ser1);

typedef enum {
  PL_SER_MODE_UART = 0,
  PL_SER_MODE_WIEGAND,
  PL_SER_MODE_CLOCKDATA
} pl_ser_mode;

typedef enum {
  PL_SER_FULL_DUPLEX = 0,
  PL_SER_FULL_HALF_DUPLEX
} pl_ser_interface;

typedef enum {
  PL_SER_FC_DISABLED = 0,
  PL_SER_FC_RTSCTS,
  PL_SER_FC_XONOFF
} pl_ser_flowcontrol;

typedef enum {
  PL_SER_DCP_LOWFORINPUT = 0,
  PL_SER_DCP_HIGHFORINPUT
} pl_ser_dircontrol;

typedef enum {
  PL_SER_PR_NONE = 0,
  PL_SER_PR_EVEN,
  PL_SER_PR_ODD,
  PL_SER_PR_MARK,
  PL_SER_PR_SPACE

} pl_ser_parity;

typedef enum { PL_SER_BB_7 = 0, PL_SER_BB_8 } pl_ser_bits;

typedef enum {
  PL_SER_BAUDRATES_300,
  PL_SER_BAUDRATES_600,
  PL_SER_BAUDRATES_1200,
  PL_SER_BAUDRATES_2400,
  PL_SER_BAUDRATES_4800,
  PL_SER_BAUDRATES_9600,
  PL_SER_BAUDRATES_19200,
  PL_SER_BAUDRATES_38400,
  PL_SER_BAUDRATES_57600,
  PL_SER_BAUDRATES_115200,
  PL_SER_BAUDRATES_230400,
  PL_SER_BAUDRATES_460800,
  PL_SER_BAUDRATES_921600
} pl_ser_baudrates;

typedef enum {
  PL_SER_ET_DISABLED,
  PL_SER_ET_TYPE1,
  PL_SER_ET_TYPE2
} pl_ser_esctype;


#define ESC_ICD_CONST 10 //minimum interchar delay for escape chars

//Bit Definition
#define BIT_0 0x01
#define BIT_1 0x02
#define BIT_2 0x04
#define BIT_3 0x08
#define BIT_4 0x10
#define BIT_5 0x20
#define BIT_6 0x40
#define BIT_7 0x80

#define BIT_SET_U8(arg, bit) (arg |= bit)
#define BIT_CLR_U8(arg, bit) (arg &= ~bit)
#define BIT_READ_U8(byte, bit_number) ((byte & (1 << bit_number)) != 0)


namespace ntios {

namespace serial {

using ntios::base::CircularBuffer;
using ntios::base::logging::Logger;
using ntios::base::Ev2Queue;

class SerialPort {
 public:
  SerialPort();
  SerialPort(std::string path);
  Property<pl_ser_baudrates, SerialPort> baudrate{
      this, &SerialPort::BaudRateSetter, &SerialPort::BaudRateGetter,
      PropertyPermissions::ReadWrite};

  Property<U8, SerialPort> escchar{this, &SerialPort::EscCharSetter,
                                           &SerialPort::EscCharGetter,
                                           PropertyPermissions::ReadWrite};

  Property<pl_ser_esctype, SerialPort> esctype{this, &SerialPort::EscTypeSetter,
                                           &SerialPort::EscTypeGetter,
                                           PropertyPermissions::ReadWrite};

  Property<pl_ser_bits, SerialPort> bits{this, &SerialPort::BitsSetter,
                                         &SerialPort::BitsGetter,
                                         PropertyPermissions::ReadWrite};
  /*
  Property<no_yes, SerialPort> num{this, &SerialPort::EnabledSetter,
                                   &SerialPort::EnabledGetter,
                                   PropertyPermissions::ReadWrite};
  */
  Property<no_yes, SerialPort> enable{this, &SerialPort::EnabledSetter,
                                   &SerialPort::EnabledGetter,
                                   PropertyPermissions::ReadWrite};

  Property<pl_ser_parity, SerialPort> parity{this, &SerialPort::ParitySetter,
                                             &SerialPort::ParityGetter,
                                             PropertyPermissions::ReadWrite};

  Property<pl_ser_flowcontrol, SerialPort> flowcontrol{
      this, &SerialPort::FlowControlSetter, &SerialPort::FlowControlGetter,
      PropertyPermissions::ReadWrite};

  Property<U32, SerialPort>txbuffsize{this, 
                              nullptr, 
                              &SerialPort::txbuffsizeGetter,
                              PropertyPermissions::Read};
  Property<pl_io_num, SerialPort> rxmap{this, &SerialPort::rxmapSetter, &SerialPort::rxmapGetter,
                            PropertyPermissions::ReadWrite};                              

  Property<pl_io_num, SerialPort> txmap{this, &SerialPort::txmapSetter, &SerialPort::txmapGetter,
                            PropertyPermissions::ReadWrite};                              

  Property<pl_io_num, SerialPort> rtsmap{this, &SerialPort::rtsmapSetter, &SerialPort::rtsmapGetter,
                            PropertyPermissions::ReadWrite};                              

  Property<pl_io_num, SerialPort> ctsmap{this, &SerialPort::ctsmapSetter, &SerialPort::ctsmapGetter,
                            PropertyPermissions::ReadWrite};                              

  U16 rxbuffrq(int cap);
  U16 txbuffrq(int cap);
  U32 setdata(std::string dt);
  std::string getdata(U32 maxlen);
  void send(void);
  void notifysent(U16 threshold);

 void txclear(); 
void rxclear(); 
 private:
  friend class ser;
  //friend class ntios::base::P1;
  friend class ntios::base::P2;
  CircularBuffer txbuffer;
  CircularBuffer rxbuffer;
  Logger serLog;
  int serfd = -1;
  U8 num=0;
  void BaudRateSetter(pl_ser_baudrates baudRate);
  pl_ser_baudrates BaudRateGetter() const;

  void EscCharSetter(U8 escChar);
  U8 EscCharGetter() const;

  void EscTypeSetter(pl_ser_esctype escType);
  pl_ser_esctype EscTypeGetter() const;
  
  void comm_restart_ser_esc();
  void set_etype(pl_ser_esctype escType);
  pl_ser_esctype get_etype()const;

  void BitsSetter(pl_ser_bits serBits);
  pl_ser_bits BitsGetter() const;

  void EnabledSetter(no_yes serBits);
  no_yes EnabledGetter() const;

  void FlowControlSetter(pl_ser_flowcontrol serFlowControl);
  pl_ser_flowcontrol FlowControlGetter() const;

  void ParitySetter(pl_ser_parity serBits);
  pl_ser_parity ParityGetter() const;

  uint32_t txbuffsizeGetter() const;
  //uint32_t txbuffsizeGetter();

  void rxmapSetter(pl_io_num io_num);
  pl_io_num rxmapGetter() const; 

  void txmapSetter(pl_io_num io_num);
  pl_io_num txmapGetter() const; 

  void rtsmapSetter(pl_io_num io_num);
  pl_io_num rtsmapGetter() const; 

  void ctsmapSetter(pl_io_num io_num);
  pl_io_num ctsmapGetter() const; 

  U32 ConvertBaud();

  //U32 ConvertParity();
  void ConvertParity(void* serialPortSettings);
  U32 ConvertCharacterSize();  
  void ConvertPortSettings(void* serialPortSettings);
  void ConvertFlowControl(void* serialPortSettings);
  void ser_init();
  


  std::string filepath;
  no_yes enabled = 0;  // 0- disabled
  U8 ser_mode = 0;     // 0- UART, 1- Wiegand, 2- clock/data
  pl_ser_interface si =
      PL_SER_FULL_DUPLEX;  // Serial interface: 0- full-duplex, 1- half-duplex
  pl_ser_flowcontrol fc =
      PL_SER_FC_DISABLED;  // Flow control (RTS/CTS): 0-disabled, 1-RTS/CTS,
                           // 2- XON/XOFF
  pl_ser_dircontrol dcp =
      PL_SER_DCP_LOWFORINPUT;  // dir ctrl polarity (COMM_RTS): 0-low for
                               // input,1-high for input
  U8 se = 0;                   // soft entry into programming mode
  U8 se2 = 0;                  // soft entry into programming mode (type 2)
  U8 acl = 0;  // auto-close of port (1 to enable) on data committing
  U8 txrxen = 0;
  U8 txrxen_prev = 0;                      // previous value of TXRXEN
  pl_ser_parity _parity = PL_SER_PR_NONE;  // 0- none, 1- even, 2- odd
  pl_ser_bits ubb = PL_SER_BB_8;           // bits/byte
  U8 sinkrx = 0;                           // sink RX data when set
  // U8 xonoff; //XON/XOFF
  U8 comm_esc_char = 0;  // ASCII code of escape character
  U8 comm_ser_idel = 0;  // intercharacter delay
  U8 comm_rts_map = 0;   // mapping of the RTS line
  U8 comm_cts_map = 0;   // mapping of the CTS line
  U8 comm_xon_char = 0;
  U8 comm_xoff_char = 0;
  U8 overrun = 0;
  U8 comm_esc_icd = 0;
  U8 escctr = 0;  // ESC character counter for escape sequence type1
  U8 cph = 0;  // For Wiegand and clock/data: 0- low pulse phase, 1- high pulse
               // phase
  U8 se2ph = 0;  // the phase for escape sequence type2
  U8 seresc = 0;
  U8 wcdipr = 0;  // Wiegand or clock/data output in progress (not necessary on
                  // COMM.ASM, just on COMM_X4.ASM)
  U8 xcts = 0;    // virtual CTS ("XCTS") for the XON/XOFF flow control, it is
                  // updated by incoming XON and XOFF characters
  U8 comm_ctr = 0;
  U8 comm_ichar_delay_ctr = 0;
  pl_ser_baudrates comm_brate = PL_SER_BAUDRATES_9600;
  U8 xon_sent = 0;      // 0- XON not yet sent, other - sent
  U8 xoff_sent = 0;     // 0- XON not yet sent, other - sent
  U8 xonoff_timer = 0;  // counts down to 0, when =0 repeated sending of XON or
                        // XOFF is allowed
  U8 tx_xon = 0;        // when set, indicates that XON must be sent out
  U8 tx_xoff = 0;       // when set, indicates that XON must be sent out



  U8 en_ev2_ser_data = 0;     //for EV2_SER_DATA event
  U8 en_ev2_ser_sent = 0;     //for EV2_SER_SENT event
  U8 en_ev2_ser_overrun = 0;  //for EV2_SER_OVERRUN event
  U8 en_ev2_ser_esc = 0;      //for EV2_SER_ESC event

  U16 ev2_ser_sent_level = 0; //data level in the TX buffer below which EV2_SER_SENT will be generated

  pl_io_num rxmap_value; 
  pl_io_num txmap_value;
  pl_io_num rtsmap_value; 
  pl_io_num ctsmap_value; 


  void check_uart();
  void comm_serv_ichar_delay();
  void rx_data_in();
  void comm_enable();
  void comm_disable();

  U8 comm_get_flags();
  

  friend void dummy_global(ntios::serial::ser ser1);
  friend void dummy_global1();

  Ev2Queue ev2;
 
};
}  // namespace serial
}  // namespace ntios

#endif