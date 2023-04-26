/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef __LIBRARIES_SUPER_SPI_H__
#define __LIBRARIES_SUPER_SPI_H__

//***********************************************************************************************************
//			SUPER SPI 
//***********************************************************************************************************

#ifndef SSI_MAX_SIGNATURE_LEN
	#define SSI_MAX_SIGNATURE_LEN 5
#endif 

//1- debug output in console.
//0- no debug output.
#ifndef SSPI_DEBUG_PRINT
	#define SSPI_DEBUG_PRINT 0
#endif

//Maximum length of the SPI user's signature string
#ifndef SSPI_MAX_SIGNATURE_LEN
	#define SSPI_MAX_SIGNATURE_LEN SSI_MAX_SIGNATURE_LEN
#endif

enum spi_modes {
//For the currently SPI channel sets/returns the clock mode:<br>
//Mode 0: CPOL=0, CPHA=0<br>
//Mode 1: CPOL=0, CPHA=1<br>
//Mode 2: CPOL=1, CPHA=0<br>
//Mode 3: CPOL=1, CPHA=1<br><br><br>
//CPOL is "clock polarity",CPHA is "clock phase".<br><br>
//CPOL=0: clock line is LOW when idle:<br>
// - CPHA=0: data bits are captured on the CLK's rising edge (LOW-to-HIGH transition) and data bits are propagated on the CLK's falling edge (HIGH-to-LOW transition).<br>
// - CPHA=1: data bits are captured on the CLK's falling edge and data bits are propagated on the CLK's rising edge.<br><br>
//CPOL=1: clock line is HIGH when idle:<br>
// - CPHA=0: data bits are captured on the CLK's falling edge and data bits are propagated on the CLK's rising edge.<br>
// - CPHA=1: data bits are captured on the CLK's rising edge and data bits are propagated on the CLK's falling edge.<br>
	SPI_MODE_0,
	SPI_MODE_1,
	SPI_MODE_2,
	SPI_MODE_3
};

//------------------------------------------------------------------------------
U8 sspi_register(const string &signature, pl_io_num mosi, pl_io_num miso, pl_io_num scl, pl_ssi_mode mode, no_yes use_ssi);

string sspi_who_uses(U8 num);
void sspi_release(U8 num);

void sspi_get(U8 num);
void sspi_write(U8 data);
U8 sspi_read();

#endif  // __LIBRARIES_SUPER_SPI_H__
