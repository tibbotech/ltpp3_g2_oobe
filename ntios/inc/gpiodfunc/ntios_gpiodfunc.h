/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef GPIODFUNC_NTIOS_GPIODFUNC_H_
#define GPIODFUNC_NTIOS_GPIODFUNC_H_

/* INCLUDES */
#include <string>

#include "base/ntios_types.h"
#include "io/ntios_iotypes.h"



/* NAMESPACES */
namespace ntios {
namespace libgpiod {

/* CLASS */
class GPIOD_func {
    friend class IO;
    friend class SSI_channel;
    friend class PAT_channel;

 public:
    /* CONSTRUCTOR */
    /*
    * Initializes (const) parameters
    * isChannelVal = 0
    * isBaudRateVal = PL_SSI_BAUD_FASTEST
    * etc.
    */
    GPIOD_func() {}



    /* DESTRUCTOR: Deallocate Memory */
    ~GPIOD_func() {}



    /* FUNCTIONS */
    U8 GetActivestate(pl_io_num num);
    U8 LineGet(pl_io_num num);
    void LineSet(pl_io_num num, U8 stateVal);
    U8 GetDirectionDecVal(pl_io_num num);
    void SetDirection(pl_io_num num, U8 isEnabledDecVal);
    void Signal_LineSet(pl_io_num clknum, \
                    pl_io_num datanum, \
                    U8 stateDecVal);
    void LedSet(pl_io_num num, \
                    U8 stateDecVal);

 private:
}; /* class GPIOD_func */

} /* namespace libgpiod */
} /* namespace ntios */

#endif  // GPIODFUNC_NTIOS_GPIODFUNC_H_
