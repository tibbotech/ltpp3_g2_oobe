/*Copyright 2021 Tibbo Technology Inc.*/

//***********************************************************************************************************
//            SUPER SPI
//***********************************************************************************************************
#include "global.h"

#define SSPI_STAMP "SSPI> "
#define SSPI_CR_LF  "\r\n"  // chr(13)+chr(10)
#define SSPI_MAX_SLOTS 16
#define SSPI_UNUSED_SIGNATURE "----"
#define SSPI_INIT_SIGNATURE 0x9503

void sspi_init();
void sspi_debugprint(const string &print_data);

no_yes sspi_in_use[SSPI_MAX_SLOTS];
// string sspi_user_signature[SSPI_MAX_SLOTS];
std::array<string, SSPI_MAX_SLOTS> sspi_user_signature;
pl_ssi_mode sspi_mode[SSPI_MAX_SLOTS];
unsigned int sspi_init_flag;
U8 sspi_num;

pl_io_num sspi_mosi[SSPI_MAX_SLOTS], \
                        sspi_miso[SSPI_MAX_SLOTS], \
                            sspi_scl[SSPI_MAX_SLOTS];

//==============================================================================
U8 sspi_register(const string &signature, \
                    pl_io_num mosi, \
                    pl_io_num miso, \
                    pl_io_num scl, \
                    pl_ssi_mode mode, \
                    no_yes use_ssi) {
// Returns a free spi number or 255 if no free spi slots left.
    U8 f;
    if (sspi_init_flag != SSPI_INIT_SIGNATURE) {
        sspi_init();
        sspi_init_flag = SSPI_INIT_SIGNATURE;
    }

    for (f=0; f <= SSPI_MAX_SLOTS-1; f++) {
        if (sspi_user_signature[f] == signature) {
            // sspi_register = f;
            return f;
        }
    }

    if (use_ssi == NO) {
register_normal_slot:
        for (f=4; f <= SSPI_MAX_SLOTS-1; f++) {
            if (sspi_in_use[f] == NO) {
                sspi_in_use[f] = YES;
                sspi_user_signature[f] = signature;
                sspi_mode[f] = mode;
                sspi_mosi[f] = mosi;
                sspi_miso[f] = miso;
                sspi_scl[f] = scl;
                // sspi_register = f;

                io.num = scl;
                if (mode > PL_SSI_MODE_1) {
                    io.state = HIGH;
                } else {
                    io.state = LOW;
                }
                io.enabled = YES;
                io.num = mosi;
                io.state = HIGH;
                io.enabled = YES;
                io.num = miso;
                io.state = HIGH;
                io.enabled = NO;
                #if SSPI_DEBUG_PRINT
                    sspi_debugprint("'" + \
                                    sspi_user_signature[f] + \
                                    "' register spi #" + \
                                    str(f));
                #endif

                return f;
            }
        }
    } else {
        // hi speed (SSI-based) mode
        f = ssi_get(signature);
        if (f == 255) {
            /* 
            * could not register a i2c hi-speed (SSI-based) mode, change to normal mode.
            */
            #if SSPI_DEBUG_PRINT
                sspi_debugprint("could not register a spi hi-speed" + \
                                    "(SSI-based) mode, change to normal mode.");
            #endif
            goto register_normal_slot;
        }

        sspi_in_use[f] = YES;
        sspi_user_signature[f] = signature;
        sspi_mosi[f] = mosi;
        sspi_miso[f] = miso;
        sspi_scl[f] = scl;
        // sspi_register = f;

        io.num = scl;
        io.state = HIGH;
        io.enabled = YES;
        io.num = mosi;
        io.state = HIGH;
        io.enabled = YES;
        io.num = miso;
        io.state = HIGH;
        io.enabled = NO;

        if (mode <= PL_SSI_MODE_1) {
            io.lineset(scl, LOW);
        } else {
            io.lineset(scl, HIGH);
        }

        #if SSPI_DEBUG_PRINT
            sspi_debugprint("'" + \
                                sspi_user_signature[f] + \
                                "' register spi #" + \
                                str(f));
        #endif
        return f;
    }
    // no free spi slot found
    #if SSPI_DEBUG_PRINT
        sspi_debugprint("'" + \
                        signature + \
                        "' could not register a spi slot: no free slots left");
    #endif

    return 255;
}

string sspi_who_uses(U8 num) {
// Returns the signature of the specified socket's user.
    if (sspi_init_flag != SSPI_INIT_SIGNATURE) {
        sspi_init();
        sspi_init_flag = SSPI_INIT_SIGNATURE;
    }

    if (sspi_in_use[num] == NO) {
        return SSPI_UNUSED_SIGNATURE;
    } else {
        return sspi_user_signature[num];
    }
}

void sspi_release(U8 num) {
// Releases the sspi (number).
    if (sspi_init_flag != SSPI_INIT_SIGNATURE) {
        sspi_init();
        sspi_init_flag = SSPI_INIT_SIGNATURE;
    }

    #if SSPI_DEBUG_PRINT
        sspi_debugprint("'" + \
                        sspi_user_signature[num] + \
                        "' released slot #" + \
                        str(num));
    #endif

    sspi_in_use[num] = NO;
    sspi_user_signature[num] = SSPI_UNUSED_SIGNATURE;

    io.num = sspi_scl[num];
    io.enabled = NO;
    io.num = sspi_mosi[num];
    io.enabled = NO;
    io.num = sspi_miso[num];
    io.enabled = NO;


    sspi_scl[num] = PL_IO_NULL;
    sspi_mosi[num] = PL_IO_NULL;
    sspi_miso[num] = PL_IO_NULL;

    if (num <= 3) {
        ssi_release(num);
    }
}

void sspi_get(U8 num) {
    sspi_num = num;
    #if SSPI_DEBUG_PRINT
        sspi_debugprint("#"+str(num)+" got slot");
    #endif
}

void sspi_write(U8 data) {
    U8 bitCnt;  // Bits counter
    U8 compval;  // Value to compare - MASK
    U8 BitData;  // Comparison result (1 or 0)

    if (sspi_num > 3) {
        compval = 0x80;  // Initialize the MASK

        io.num = sspi_scl[sspi_num];    // Select SSI_CLK line

        if (sspi_mode[sspi_num] == PL_SSI_MODE_0 || \
            sspi_mode[sspi_num] == PL_SSI_MODE_2) {
            io.state = HIGH;    // Initialize the transmition
        } else {
            io.state = LOW;
        }

        for (bitCnt=0; bitCnt <= 7; bitCnt += 1) {
            // Define the state of the bit(MSB-->LSB)
            BitData = data & compval;

            // Move the comparision to the next bit(MSB-->LSB)
            compval = compval >> 1;

            if ((BitData)) {
                io.lineset(sspi_mosi[sspi_num], HIGH);  // Bit is 1
            } else {
                io.lineset(sspi_mosi[sspi_num], LOW);   // Bit is 0
            }

            // io.lineset(sspi_scl(sspi_num),HIGH)'Write the bit to SPI device
            io.invert(sspi_scl[sspi_num]);
            io.invert(sspi_scl[sspi_num]);
        }
    } else {
        ssi.channel = sspi_num;
        ssi.str(chr(data), PL_SSI_ACK_OFF);
    }
}

U8 sspi_read() {
    U8 sspi_read;
    U8 bitCnt;  // Bit counter
    U8 compval;  // Value to compare - MASK

    io.lineset(sspi_mosi[sspi_num], LOW);
    if (sspi_num > 3) {
        sspi_read = 0;
        compval = 0x80;  // Initialize the MASK

        for (bitCnt=0; bitCnt <= 7; bitCnt += 1) {
            if (sspi_mode[sspi_num] == PL_SSI_MODE_0 || \
                    sspi_mode[sspi_num] == PL_SSI_MODE_2) {
                // Read one bit from SPI device
                io.lineset(sspi_scl[sspi_num], LOW);
            } else {
                // Read one bit from SPI device
                io.lineset(sspi_scl[sspi_num], HIGH);
            }

            // Devine the state of the bit
            if ((io.lineget(sspi_miso[sspi_num]))) {
                // Store the value of the bit
                sspi_read = sspi_read | compval;
            }

            // Move the comparision to the next bit(MSB-->LSB)
            compval = compval >> 1;
            if (sspi_mode[sspi_num] == PL_SSI_MODE_0 || \
                    sspi_mode[sspi_num] == PL_SSI_MODE_2) {
                // Clear the clock line (the data can change now...)
                io.lineset(sspi_scl[sspi_num], HIGH);
            } else {
                // Clear the clock line (the data can change now...)
                io.lineset(sspi_scl[sspi_num], LOW);
            }
        }

        io.lineset(sspi_mosi[sspi_num], HIGH);
        #if SSPI_DEBUG_PRINT
            sspi_debugprint("spi read data:"+hex(sspi_read));
        #endif
    } else {
        unsigned int tmp;
        ssi.channel = sspi_num;
        tmp = ssi.value(0xFFFF, 8);
        sspi_read = tmp & 0x00FF;
    }
    return sspi_read;
}

void sspi_init() {
    U8 f;
    for (f=0; f <= SSPI_MAX_SLOTS-1; f++) {
        sspi_in_use[f] = NO;
        sspi_user_signature[f] = SSPI_UNUSED_SIGNATURE;
        sspi_mosi[f] = PL_IO_NULL;
        sspi_miso[f] = PL_IO_NULL;
        sspi_scl[f] = PL_IO_NULL;
    }
}

#if SSPI_DEBUG_PRINT
    void sspi_debugprint(const string &print_data) {
        // sys.debugprint(SSPI_STAMP + *print_data+SSPI_CR_LF);

        printf("%s %s %s\n", SSPI_STAMP, (print_data.c_str()), SSPI_CR_LF);
    }
#endif
