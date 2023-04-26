//***********************************************************************************************************
//			Tibbit #29 (temperature sensor)
//***********************************************************************************************************

#include "global.h"

//--------------------------------------------------------------------
#define TBT29_INIT_SIGNATURE 0xF083
#define TBT29_STAMP "TBT29> "
#define TBT29_CR_LF chr(13) + chr(10)

#define TBT29_MFG_ID 0x54
#define TBT29_DEVID 0x400
#define TBT29_WRITE_ADDR 0x30
#define TBT29_READ_ADDR 0x31

enum tbt29_resolution
{
    TBT29_RESOLUSION_MODE_0 = 0x00, // 0.5C (tCONV = 30 ms typical)
    TBT29_RESOLUSION_MODE_1 = 0x01, // 0.25C (tCONV = 65 ms typical)
    TBT29_RESOLUSION_MODE_2 = 0x02, // 0.125C (tCONV = 130 ms typical)
    TBT29_RESOLUSION_MODE_3 = 0x03  // 0.0625C (power-up default, tCONV = 250 ms typical)
};

enum tbt29_regs
{
    TBT29_REG_CONF = 0x01,
    TBT29_REG_TUP = 0x02,
    TBT29_REG_TLO = 0x03,
    TBT29_REG_TCRIT = 0x04,
    TBT29_REG_TA = 0x05,
    TBT29_REG_MFGID = 0x06,
    TBT29_REG_IDREV = 0x07,
    TBT29_REG_RESOL = 0x08
};

unsigned int tbt29_read_data(tbt29_regs op, unsigned char *channel);
void tbt29_write_data(tbt29_regs op, unsigned int data, unsigned char channel);
void tbt29_delay_msecond(unsigned int value);

#if TBT29_DEBUG_PRINT == 1
void tbt29_debug_print(string data);
#endif

unsigned char i2c_num_tbt29;
unsigned int tbt29_init_flag;

//==============================================================================
tbt29_errcheck tbt29_init(const string &signature, no_yes use_ssi, pl_io_num pin_clk, pl_io_num pin_data, unsigned char *channel)
{
    tbt29_errcheck tbt29_init;
    // Call this function to initialize the Tibbit.
    // Use_ssi argument specifies whether you want to communicate with this Tibbit using the SSI channel running in the I2C mode (YES), or
    // go for direct I/O manipulation a.k.a. bit-banging (NO).
    // Note that there is a limited number of SSI channels so if you set use_ssi=YES this function may return TBT29_NO_SSI_AVAILABLE, meaning that
    // there are no free SSI channels left. This doesn't mean failure. Rather, it means that comms will proceed in bit banging mood.
    // Other error codes (TBT29_WRONG_MFGID and TBT29_WRONG_DEVID_REVISION) indicate failure.

    tbt29_init = TBT29_OK;
#if TBT29_DEBUG_PRINT == 1
    tbt29_debug_print("++++++++++");
#endif
    tbt29_init_flag = TBT29_INIT_SIGNATURE;

    *channel = si2c_register(signature, pin_data, pin_clk, use_ssi);
#if TBT29_DEBUG_PRINT == 1
    tbt29_debug_print("i2c num:" + str(*channel));
#endif

    if (*channel < 4)
    {
        ssi.channel = *channel;
        ssi.enabled = NO;
        ssi.baudrate = PL_SSI_BAUD_100kHz;
        ssi.clkmap = pin_clk;
        ssi.dimap = pin_data;
        ssi.domap = pin_data;
        ssi.direction = PL_SSI_DIRECTION_LEFT;
        ssi.mode = PL_SSI_MODE_2;
        ssi.zmode = PL_SSI_ZMODE_ENABLED_ON_ZERO;
        ssi.enabled = YES;
    }
    else
    {
        tbt29_init = TBT29_NO_SSI_AVAILABLE;
    }

    // check the TBT29_MFG_ID
    if (tbt29_read_data(TBT29_REG_MFGID, &*channel))
    {
#if TBT29_DEBUG_PRINT == 1
        tbt29_debug_print("MFG_ID ERROR");
#endif
        tbt29_init = TBT29_WRONG_MFGID;
        goto leave;
    }

    // check the TBT29_DEVID+MCP9808_DEFAULT_REVISION
    if (tbt29_read_data(TBT29_REG_IDREV, &*channel))
    {
#if TBT29_DEBUG_PRINT == 1
        tbt29_debug_print("DEVICE ID & REVISION ERROR");
#endif
        tbt29_init = TBT29_WRONG_DEVID_REVISION;
        goto leave;
    }

    // resolution :+0.25 C (tCONV = 65 ms typical)
    tbt29_write_data(TBT29_REG_RESOL, TBT29_RESOLUSION_MODE_1, *channel);
leave:
#if TBT29_DEBUG_PRINT == 1
    tbt29_debug_print("----------");
#endif
    return tbt29_init;
}

float tbt29_get_c(unsigned char *channel)
{
    float tbt29_get_c;
    // Returns the signed floating point value expressing the temperature in deg. C.
    tbt29_get_c = tbt29_get(*channel);
    tbt29_get_c = tbt29_get_c / 4;
    return tbt29_get_c;
}

int tbt29_get(unsigned char channel)
{
    int tbt29_get;
    // Returns the signed integer value expressing the temperature in 0.25 deg. C steps.

#if PLATFORM_TYPE_32
#define DELAY_IN_65_MS 7
#else
#define DELAY_IN_65_MS 130
#endif
    unsigned int r;
    unsigned int t_integer;
    unsigned char t_fraction;

    if (tbt29_init_flag != TBT29_INIT_SIGNATURE)
    {
#if TBT29_DEBUG_PRINT == 1
        tbt29_debug_print("The lib is not initialized, call tbt29_init() first");
#endif
        return tbt29_get;
    }

    si2c_get(channel);

    tbt29_delay_msecond(DELAY_IN_65_MS);

    r = tbt29_read_data(TBT29_REG_TA, &channel);

#if TBT29_DEBUG_PRINT == 1
    tbt29_debug_print("Raw temperature:" + hex(r));
#endif

    if (r && 0x1000)
    {
        // temperature is negative
        t_integer = (r & 0x0FFF) / 16;
        t_fraction = (r & 0x000F) / 4;
        tbt29_get = 1024 - ((t_integer * 4) + t_fraction);
    }
    else
    {
        // temperature is positive
        t_integer = (r & 0x0FFF) / 16;
        t_fraction = (r & 0x000F) / 4;
        tbt29_get = (t_integer * 4) + t_fraction;
    }
    return tbt29_get;
}

unsigned int tbt29_read_data(tbt29_regs op, unsigned char *channel)
{
    unsigned int tbt29_read_data;
    unsigned char upper, lower = 0;

    upper = 0;
    lower = 0;
    si2c_get(*channel);
    si2c_start();

    // send address + op
    si2c_write(TBT29_WRITE_ADDR);
    si2c_write(op);

    si2c_start();

    si2c_write(TBT29_READ_ADDR);

    if (op == TBT29_REG_RESOL)
    {
        lower = si2c_read(true);
    }
    else
    {
        upper = si2c_read(true);
        lower = si2c_read(false);
    }

    si2c_stop();
    tbt29_read_data = upper * 256 + lower;
    return tbt29_read_data;
}

void tbt29_write_data(tbt29_regs op, unsigned int data, unsigned char channel)
{
    unsigned char value;
    si2c_get(channel);
    si2c_start();

    si2c_write(TBT29_WRITE_ADDR);
    si2c_write(op);

    if (op == TBT29_REG_RESOL)
    {
        value = data & 0x00FF;
        si2c_write(value);
    }
    else
    {
        value = (data & 0xFF00) / 256;
        si2c_write(value);
        value = data & 0x00FF;
        si2c_write(value);
    }
    si2c_stop();
}

void tbt29_delay_msecond(unsigned int value)
{
    unsigned int ax, bx;

#if PLATFORM_TYPE_32
    unsigned long target = sys.timercountms + value;
    while (sys.timercountms < target)
    {
    }
#else
    for (ax = 0; ax <= value; ax++)
    {
        for (bx = 0; bx <= 10; bx++)
        {
        }
    }
#endif
}

#if TBT29_DEBUG_PRINT == 1
void tbt29_debug_print(string data)
{
    sys.debugprint(TBT29_STAMP + data + TBT29_CR_LF);
}
#endif
