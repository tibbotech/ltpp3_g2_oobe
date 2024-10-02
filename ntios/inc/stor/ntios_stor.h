/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef STOR_NTIOS_STOR_H_
#define STOR_NTIOS_STOR_H_

#include <string>
#include "base/ntios_property.h"
#include "base/ntios_types.h"

#define EEPROM_BUS "/dev/i2c-4"
#define EEPROM_SIZE 2048
#define MAC_ADDR_SIZE 8 /* Space occupied by MAC in the EEPROM. Two extra bytes are for len and cs */
#define BLOCK_SIZE 256
#define BLOCK_MAX_READ_WRITE_SIZE 16 /* I2C_SMBUS_BLOCK_MAX */
#define OPERATION_WRITE 0
#define OPERATION_READ 1


namespace ntios {
namespace storage {

class STOR {
 public:
  Property<U8, STOR> base{this,&STOR::BaseSetter,
                           &STOR::BaseGetter,
                           PropertyPermissions::ReadWrite};

  Property<U16, STOR>size{this,nullptr, 
                            &STOR::sizeGetter,
                            PropertyPermissions::Read};

  U8 setdata(std::string datatoset, U16 startaddr);  
  std::string getdata(U16 startaddr,U8 len);

 private:
  U16 eeprom_access_base=MAC_ADDR_SIZE+20+1;
  static unsigned char g_block_addresses[];

  void BaseSetter(U8 base);
  U8 BaseGetter() const;
  U16 sizeGetter() const; 
  U16 ee_size() const;
  U8 ee_set(U16 offset, U8 length, U8 *data);
  U8 ee_get(U16 offset, U8 length, U8 *data);
  int tios_api_eeprom_write( unsigned long offset, unsigned long length, const unsigned char *data);
  int tios_api_eeprom_read( unsigned long offset, unsigned long length, unsigned char *data);
  int do_eeprom_op( unsigned long offset, unsigned char *data, unsigned long data_length, int _op);
  int get_block(unsigned long offset, unsigned char *block_address, unsigned char *block_offset, unsigned char *block_read_write_size);
  int eeprom_block_W(unsigned char block_address, unsigned char block_offset, const unsigned char *data, unsigned char data_length);
  int eeprom_block_R(unsigned char block_address, unsigned char block_offset, unsigned char *data, unsigned char data_length);
  int open_bus_file(int block_address);
  int t_i2c_addr( int _fd, int _addr);
  int perform_bus_operation(int bus_file, int operation, int block_offset, union i2c_smbus_data *bus_data);
};

}  // namespace storage
}  // namespace ntios

#endif  // STOR_NTIOS_STOR_H_
