//***********************************************************************************************************
//			SUPER I2C 
//***********************************************************************************************************
#ifndef _LIBRARIES_SUPER_I2C_H_
#define _LIBRARIES_SUPER_I2C_H_

#ifndef SSI_MAX_SIGNATURE_LEN
#define SSI_MAX_SIGNATURE_LEN 5
#endif 


//1- debug output in console.
//0- no debug output.
#ifndef SI2C_DEBUG_PRINT
	#define SI2C_DEBUG_PRINT 0
#endif

//Maximum length of the I2C user's signature string
#ifndef SI2C_MAX_SIGNATURE_LEN
	#define SI2C_MAX_SIGNATURE_LEN SSI_MAX_SIGNATURE_LEN
#endif

//------------------------------------------------------------------------------
U8 si2c_register(const string &signature, \
					pl_io_num sda, \
					pl_io_num scl, \
					no_yes use_ssi);

string si2c_who_uses(U8 num);
void si2c_release(U8 num);

void si2c_get(U8 num);
void si2c_start();
void si2c_stop();
void si2c_write(U8 data);
U8 si2c_read(bool acknak_request);
no_yes si2c_is_busy(U8 num);

#endif // _LIBRARIES_SUPER_I2C_H_