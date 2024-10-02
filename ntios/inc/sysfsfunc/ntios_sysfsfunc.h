/* Copyright 2021 Tibbo Technology Inc. */

#ifndef SYSFSFUNC_NTIOS_SYSFSFUNC_H_
#define SYSFSFUNC_NTIOS_SYSFSFUNC_H_

/* INCLUDES */
#include <sys/stat.h>   /* required for method 'dirExists' */
#include <cstring>
#include <fstream>  /* required for read from/write to file */
#include <sstream>  /* required for  read from/write to file */
#include <string>

#include "base/ntios_types.h"
#include "base/ntios_config.h"
#include "syscalls/ntios_conv.h"



/* TYPEDEF */
typedef enum {
    PWM_OPT_DUTYCYLE,
    PWM_OPT_ENABLE,
    PWM_OPT_FREQ
} pwm_opt;



/* NAMESPACES */
namespace ntios {
namespace sysfs {



/* MACROS */
#define PWM_DUTY_CYCLE "duty_cycle"
#define PWM_ENABLE "enable"
#define PWM_PERIOD "period"
#define PWMCHIP0_DIR "/sys/class/pwm/pwmchip0/"
#define PWMCHIP0_PWMX_FPATH(channel) ( \
                  "/sys/class/pwm/pwmchip0/pwm" + \
                  ntios::conv::lstr(channel) + "/")
#define PWMCHIP0_PWMX_DUTYCYCLE_FPATH ( \
                  PWMCHIP0_PWMX_FPATH(BEEP_PWM_CHANNEL) + PWM_DUTY_CYCLE)
#define PWMCHIP0_PWMX_ENABLE_FPATH ( \
                  PWMCHIP0_PWMX_FPATH(BEEP_PWM_CHANNEL) + PWM_ENABLE)
#define PWMCHIP0_PWMX_PERIOD_FPATH ( \
                  PWMCHIP0_PWMX_FPATH(BEEP_PWM_CHANNEL) + PWM_PERIOD)



/* CONSTANT */
const char *const PWM_EMPTYSTRING = "";

const U32 PWM_NULL = 0;



/* CLASS */
class PWM_func {
 public:
    /* CONSTRUCTOR */
    PWM_func() {}



    /* DESTRUCTOR: Deallocate Memory */
    ~PWM_func() {}



    /* FUNCTIONS */

    /*
    * Sets the duty_cycle/enable/frequency based on the specified 'pwmopt' value.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; isDutyCycle: the duty-cycle to be set.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; isEnabled: flag used to specify whether to enable/disable the specified pwm-channel.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; isFreq: the frequency to be set.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; pwmopt: flag to select the to-be-set property (e.g. duty_cycle, enable, frequency).
    * Remark:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The 'duty_cycle' can be used to adjust the Volume of the beep sound.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The 'enable' can be used to switch On/Off the beep sound.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; The 'frequency' can be used to adjust the Tone of the beep sound.
    */ 
    void pwm_property_setter(U32 isDutyCycle, \
                        no_yes isEnabled, \
                        U32 isFreq, \
                        pwm_opt pwmopt);

 private:
    /* FUNCTIONS */

    /*
    * Checks whether the specified directory exists or not.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; targetDir: the to-be-checked directory.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; true: the specified directory exists.
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; false: the specified directory does not exist.
    */
    bool DirExists(const string &targetDir);

    /*
    * Gets the file content for a specified file fullpath.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; targetFpath: the fullpath of the file from which the content needs to be retrieved.
    * Output:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; ret: string containing the file-content of the specified targetFpath.
    */
    string GetFileContent(const string &targetFpath);

    /*
    * Writes a specified value (whether int-type or string-type) to a specified file fullpath.
    *
    * Input:
    *&nbsp;&nbsp;&nbsp;&nbsp;&bull; targetFpath:  the fullpath of the file to which the content needs to be written to.
    */
    void WriteToFile(const string &targetFpath, const string &value);
}; /* class PWM_func */

} /* namespace sysfs */
} /* namespace ntios */

#endif  // SYSFSFUNC_NTIOS_SYSFSFUNC_H_
