/*Copyright 2021 Tibbo Technology Inc.*/

#include "global.h"

#define SI2C_STAMP "SI2C> "
#define SI2C_CR_LF (chr(13)+chr(10))
#define SI2C_MAX_SLOTS 16
#define SI2C_UNUSED_SIGNATURE "----"
#define SI2C_INIT_SIGNATURE 0x9502

void si2c_init();
void si2c_debugprint(const string &print_data);

no_yes si2c_in_use[SI2C_MAX_SLOTS];
// string<SI2C_MAX_SIGNATURE_LEN> si2c_user_signature[SI2C_MAX_SLOTS];
std::array<string, SI2C_MAX_SLOTS> si2c_user_signature;
U16 si2c_init_flag;
U8 si2c_num;
pl_io_num si2c_sda[SI2C_MAX_SLOTS], si2c_scl[SI2C_MAX_SLOTS];

//==============================================================================
U8 si2c_register(const string &signature, \
                    pl_io_num sda, \
                    pl_io_num scl, \
                    no_yes use_ssi) {
    /*
    * Returns a free i2c number or 255 if no free i2c slots left.
    */
    U8 ret;
    U8 f;

    if (si2c_init_flag != SI2C_INIT_SIGNATURE) {
        si2c_init();
        si2c_init_flag = SI2C_INIT_SIGNATURE;
    }

    for (f=0; f <= SI2C_MAX_SLOTS-1; f++) {
        if (si2c_user_signature[f] == signature) {
            ret = f;
            return ret;
        }
    }

    if (use_ssi == NO) {
register_normal_slot:
        for (f = 4; f <= SI2C_MAX_SLOTS - 1; f++) {
            if (si2c_in_use[f] == NO) {
                si2c_in_use[f] = YES;
                si2c_user_signature[f] = signature;
                si2c_sda[f] = sda;
                si2c_scl[f] = scl;
                ret = f;

                /*
                * NOTE: IO-line must be 'enabled' FIRST, before changing 'state'!
                */
                io.num = scl;
                io.enabled = YES;
                io.state = HIGH;
                io.num = sda;
                io.enabled = NO;
                io.state = HIGH;

                #if SI2C_DEBUG_PRINT
                    si2c_debugprint("'" + \
                                    si2c_user_signature[f] + \
                                    "'" + \
                                    "register i2c #" + str(f));
                #endif

                return ret;
            }
        }
    } else {
        /* hi speed (SSI-based) mode */
        f = ssi_get(signature); /* Get the channel */

        if (f == 255) {
            /* 
            * could not register a i2c hi-speed (SSI-based) mode, change to normal mode.
            */
            #if SI2C_DEBUG_PRINT
                si2c_debugprint("could not register a i2c "
                                    "hi-speed (SSI-based) mode,"
                                    " change to normal mode.");
            #endif
            goto register_normal_slot;
        }

        si2c_in_use[f] = YES;
        si2c_user_signature[f] = signature;
        si2c_sda[f] = sda;
        si2c_scl[f] = scl;
        ret = f;

        /* CLKMAP */
        io.num = scl;
        io.enabled = YES;
        io.state = HIGH;

        /* DOMAP/DIMAP */
        io.num = sda;
        io.enabled = YES;
        io.state = HIGH;

        #if SI2C_DEBUG_PRINT
            si2c_debugprint("'" + \
                            si2c_user_signature[f] + \
                            "' register i2c #" + \
                            str(f));
        #endif

        return ret;
    }

    /* no free i2c slot found */
    #if SI2C_DEBUG_PRINT
        si2c_debugprint("'" + \
                        signature + \
                        "' could not register a i2c slot: no free slots left");
    #endif

    ret = 255;

    return ret;
}

string si2c_who_uses(U8 num) {
    /*
    * Returns the signature of the specified socket's user.
    */
    string ret;

    if (si2c_init_flag != SI2C_INIT_SIGNATURE) {
        si2c_init();
        si2c_init_flag = SI2C_INIT_SIGNATURE;
    }

    if (si2c_in_use[num] == NO) {
        ret = SI2C_UNUSED_SIGNATURE;
    } else {
        ret = si2c_user_signature[num];
    }

    return ret;
}

void si2c_release(U8 num) {
    /* Releases the si2c (number) */
    if (si2c_init_flag != SI2C_INIT_SIGNATURE) {
        si2c_init();
        si2c_init_flag = SI2C_INIT_SIGNATURE;
    }

    #if SI2C_DEBUG_PRINT
        si2c_debugprint("'" + \
                        si2c_user_signature[num] + \
                        "'" + \
                        "released slot #" + \
                        str(num));
    #endif

    si2c_in_use[num] = NO;
    si2c_user_signature[num] = SI2C_UNUSED_SIGNATURE;

    io.num = si2c_scl[num];
    io.enabled = NO;
    io.num = si2c_sda[num];
    io.enabled = NO;

    si2c_sda[num] = PL_IO_NULL;
    si2c_scl[num] = PL_IO_NULL;

    if (num <= 3) {
        ssi_release(num);
    }
}

void si2c_get(U8 num) {
    si2c_num = num;
    #if SI2C_DEBUG_PRINT
        si2c_debugprint("channel#:"+str(num)+" got slot");
    #endif
}

void si2c_start() {
    /*
    * REMARKS:
    *   si2c_sda and si2c_scl are registered in function 'si2c_register'
    */
    io.num = si2c_sda[si2c_num];
    io.enabled = YES;

    io.lineset(si2c_scl[si2c_num], HIGH);
    io.lineset(si2c_sda[si2c_num], HIGH);
    io.lineset(si2c_sda[si2c_num], LOW);
    io.lineset(si2c_scl[si2c_num], LOW);
}

void si2c_stop() {
    io.num = si2c_sda[si2c_num];
    io.enabled = YES;

    io.lineset(si2c_sda[si2c_num], LOW);
    io.lineset(si2c_scl[si2c_num], HIGH);
    io.lineset(si2c_sda[si2c_num], HIGH);
}

void si2c_write(U8 data) {
    U8 bitCnt;  // Bits counter
    U8 compval;  // Value to compare - MASK
    bool BitData;   // Comparison result (1 or 0)

    if (si2c_num > 3) {
        compval = 0x80;  // Initialize the MASK

        io.num = si2c_scl[si2c_num];  // Select SSI_CLK line
        io.state = LOW;  // Initialize the transmition

        io.num = si2c_sda[si2c_num];  // Select SSI_SDA line
        io.enabled = YES;  // Set as output

        for (bitCnt = 0; bitCnt <= 7; bitCnt++) {
            // Define the state of the bit(MSB-->LSB)
            BitData = data & compval;
            // Move the comparision to the next bit(MSB-->LSB)
            compval = compval/2;

            if ((BitData)) {
                io.state = HIGH;  // Bit is 1
            } else {
                io.state = LOW;  // Bit is 0
            }

            io.num = si2c_scl[si2c_num];  // Write the bit to I2C device
            io.state = HIGH;
            io.invert(si2c_scl[si2c_num]);

            /*
            * Select SSI_SDA line, NOTE: this must be the last
            * statement in the loop so we can release the SSI_SDA
            * line as soon as possible to alow for the ack
            */
            io.num = si2c_sda[si2c_num];
        }

        io.num = si2c_sda[si2c_num];
        io.enabled = NO;  // Set SSI_SDA as input to allow ack receive

        io.num = si2c_scl[si2c_num];  // Emulate the ACK frame
        io.state = HIGH;
        io.invert(si2c_scl[si2c_num]);  // Finish the ACK frame
    } else {
        ssi.channel = si2c_num;
        ssi.str(chr(data), PL_SSI_ACK_RX);
    }
}

U8 si2c_read(bool acknak_request) {
    U8 si2c_read;
    U8 bitCnt;  // Bit counter
    U8 compval;  // Value to compare - MASK

    if (si2c_num > 3) {
        si2c_read = 0;
        compval = 0x80;  // Initialize the MASK

        io.num = si2c_sda[si2c_num];  // Select SSI_SDA line
        io.enabled = NO;  // Set as input

        io.num = si2c_scl[si2c_num];  // Select SSI_CLK line
        io.state = LOW;  // Initialize the transmition

        for (bitCnt=0; bitCnt <= 7; bitCnt += 1) {
            io.state = HIGH;  // Read one bit from I2C device
            io.num = si2c_sda[si2c_num];
            if ((io.state == HIGH)) {  // Devine the state of the bit
                si2c_read = si2c_read | compval;  // Store the value of the bit
            }

            // Move the comparision to the next bit(MSB-->LSB)
            compval = compval/2;

            io.num = si2c_scl[si2c_num];
            // Clear the clock line (the data can change now...)
            io.state = LOW;
        }

        io.num = si2c_sda[si2c_num];  // Select SSI_SDA line

        if (acknak_request == true) {  // Does user want to send an ack or not
            io.state = LOW;  // Bring Low for ACK
        } else {
            io.state = HIGH;  // Bring high for NACK
        }

        io.enabled = YES;  // Enable SSI_DO as output

        io.num = si2c_scl[si2c_num];  // Select SSI_CLK line
        io.state = HIGH;  // Set SSI_CLK line
        io.invert(si2c_scl[si2c_num]);  // Clear SSI_CLK line


        #if SI2C_DEBUG_PRINT
            si2c_debugprint("i2c read data:"+hex(si2c_read));
        #endif
    } else {
        U16 tmp;
        ssi.channel = si2c_num;
        if (acknak_request == true) {
            tmp = ssi.value(0xFFFE, 9)/2;
        } else {
            tmp = ssi.value(0xFFFF, 9)/2;
        }
        si2c_read = tmp & 0x00FF;
    }
    return si2c_read;
}

void si2c_init() {
    U8 f;
    for (f=0; f <= SI2C_MAX_SLOTS-1; f++) {
        si2c_in_use[f] = NO;
        si2c_user_signature[f] = SI2C_UNUSED_SIGNATURE;
        si2c_sda[f] = PL_IO_NULL;
        si2c_scl[f] = PL_IO_NULL;
    }
}

no_yes si2c_is_busy(U8 num) {
    no_yes si2c_is_busy;
    if (io.lineget(si2c_scl[num]) == LOW) {
        si2c_is_busy = YES;
    } else {
        si2c_is_busy = NO;
    }
    return si2c_is_busy;
}

#if SI2C_DEBUG_PRINT
    void si2c_debugprint(const string &print_data) {
        sys.debugprint(SI2C_STAMP + print_data + SI2C_CR_LF);
    }
#endif
