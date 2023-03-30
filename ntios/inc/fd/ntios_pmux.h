/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_PMUX_H_
#define NTIOS_PMUX_H_

#include "base/ntios_log.h"
#include "base/ntios_property.h"

namespace ntios {
typedef struct {
  uint32_t peripheral_type;
  uint32_t peripheral_num;
  uint32_t peripheral_pin_func;
  uint32_t peripheral_pin_num;
} tios_peripheral_struct_t;

typedef enum {
  PMUX_PERIHERAL_TYPE_SERIAL,
  PMUX_PERIHERAL_TYPE_I2C,
  PMUX_PERIHERAL_TYPE_SPI,
  PMUX_PERIHERAL_TYPE_INPUT_CAPTURE,
  PMUX_PERIHERAL_TYPE_IO,
  PMUX_PERIHERAL_TYPE_PWM,
  
} pmux_peripheral_type;

typedef enum {
  // UART
  PMUX_PERIHERAL_PIN_FUNC_UART_PIN_RX,
  PMUX_PERIHERAL_PIN_FUNC_UART_PIN_TX,
  PMUX_PERIHERAL_PIN_FUNC_UART_PIN_CTS,
  PMUX_PERIHERAL_PIN_FUNC_UART_PIN_RTS,
  PMUX_PERIHERAL_PIN_FUNC_UART_PINS_DIR,
  // I2C
  PMUX_PERIHERAL_PIN_FUNC_I2C_PIN_CLK,
  PMUX_PERIHERAL_PIN_FUNC_I2C_PIN_DAT,
  // SPI
  PMUX_PERIHERAL_PIN_FUNC_SPI_PINS_INT,
  PMUX_PERIHERAL_PIN_FUNC_SPI_PINS_CLK,
  PMUX_PERIHERAL_PIN_FUNC_SPI_PINS_EN,
  PMUX_PERIHERAL_PIN_FUNC_SPI_PINS_MOSI,
  PMUX_PERIHERAL_PIN_FUNC_SPI_PINS_MISO,
  // PWM
  PMUX_PERIHERAL_PIN_FUNC_PWM_0,
  PMUX_PERIHERAL_PIN_FUNC_PWM_1,
  PMUX_PERIHERAL_PIN_FUNC_PWM_2,
  PMUX_PERIHERAL_PIN_FUNC_PWM_3,
  PMUX_PERIHERAL_PIN_FUNC_PWM_4,
  PMUX_PERIHERAL_PIN_FUNC_PWM_5,  
  PMUX_PERIHERAL_PIN_FUNC_PWM_6,    
  //ICM
  PMUX_PERIHERAL_PIN_FUNC_ICM_PINS_D,
  PMUX_PERIHERAL_PIN_FUNC_ICM_PINS_CLK,
  //
  PMUX_PERIHERAL_PIN_FUNC_NULL  
} pmux_peripheral_pin_func;

typedef enum {
  PMUX_PERIPHERAL_NUM_0,
  PMUX_PERIPHERAL_NUM_1,
  PMUX_PERIPHERAL_NUM_2,
  PMUX_PERIPHERAL_NUM_3,
  PMUX_PERIPHERAL_NUM_NULL
} pmux_periphral_num;

typedef enum {
  PMUX_LINUX_IO_8 = 8,
  PMUX_LINUX_IO_9,
  PMUX_LINUX_IO_10,
  PMUX_LINUX_IO_11,
  PMUX_LINUX_IO_12,
  PMUX_LINUX_IO_13,
  PMUX_LINUX_IO_14,
  PMUX_LINUX_IO_15,
  PMUX_LINUX_IO_16,
  PMUX_LINUX_IO_17,
  PMUX_LINUX_IO_18,
  PMUX_LINUX_IO_19,
  PMUX_LINUX_IO_20,
  PMUX_LINUX_IO_21,
  PMUX_LINUX_IO_22,
  PMUX_LINUX_IO_23,
  PMUX_LINUX_IO_24,
  PMUX_LINUX_IO_25,
  PMUX_LINUX_IO_26,
  PMUX_LINUX_IO_27,
  PMUX_LINUX_IO_28,
  PMUX_LINUX_IO_29,
  PMUX_LINUX_IO_30,
  PMUX_LINUX_IO_31,
  PMUX_LINUX_IO_32,
  PMUX_LINUX_IO_33,
  PMUX_LINUX_IO_34,
  PMUX_LINUX_IO_35,
  PMUX_LINUX_IO_36,
  PMUX_LINUX_IO_37,
  PMUX_LINUX_IO_38,
  PMUX_LINUX_IO_39,
  PMUX_LINUX_IO_40,
  PMUX_LINUX_IO_41,
  PMUX_LINUX_IO_42,
  PMUX_LINUX_IO_43,
  PMUX_LINUX_IO_44,
  PMUX_LINUX_IO_45,
  PMUX_LINUX_IO_46,
  PMUX_LINUX_IO_47,
  PMUX_LINUX_IO_48,
  PMUX_LINUX_IO_49,
  PMUX_LINUX_IO_50,
  PMUX_LINUX_IO_51,
  PMUX_LINUX_IO_52,
  PMUX_LINUX_IO_53,
  PMUX_LINUX_IO_54,
  PMUX_LINUX_IO_55,
  PMUX_LINUX_IO_56,
  PMUX_LINUX_IO_57,
  PMUX_LINUX_IO_58,
  PMUX_LINUX_IO_59,
  PMUX_LINUX_IO_60,
  PMUX_LINUX_IO_61,
  PMUX_LINUX_IO_62,
  PMUX_LINUX_IO_63,
  PMUX_LINUX_IO_NUM_NULL=254
} pmux_linux_io_num;

using ntios::base::logging::DbgColorBlue;
using ntios::base::logging::DbgColorCyan;
using ntios::base::logging::DbgColorGreen;
using ntios::base::logging::DbgColorMagenta;
using ntios::base::logging::DbgColorRed;
using ntios::base::logging::DbgColorReset;
using ntios::base::logging::DbgColorYellow;

using ntios::base::logging::Logger;
class pmux {
 private:
  int fd;
  const char *devfile = "/dev/tpd";
  Logger pmuxLog;

 public:
  pmux();
  ~pmux();
  void set(pmux_peripheral_type periph_type, pmux_periphral_num periph_num,
           pmux_peripheral_pin_func periph_pin_func,
           pmux_linux_io_num periph_pin_num);

  void set (tios_peripheral_struct_t* periph_struct);
  
};
}  // namespace ntios

#endif  // NTIOS_PMUX_H_
