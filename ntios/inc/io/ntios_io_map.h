/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_LINUX_LTPP3G2_IO_IO_PINS_H_
#define NTIOS_LINUX_LTPP3G2_IO_IO_PINS_H_
#include <cstdint>

namespace ntios {
namespace io {
namespace internal {

typedef enum : std::uint8_t {
  PL_LINUX_IO_0,
  PL_LINUX_IO_1,
  PL_LINUX_IO_2,
  PL_LINUX_IO_3,
  PL_LINUX_IO_4,
  PL_LINUX_IO_5,
  PL_LINUX_IO_6,
  PL_LINUX_IO_7,
  PL_LINUX_IO_8,
  PL_LINUX_IO_9,
  PL_LINUX_IO_10,
  PL_LINUX_IO_11,
  PL_LINUX_IO_12,
  PL_LINUX_IO_13,
  PL_LINUX_IO_14,
  PL_LINUX_IO_15,
  PL_LINUX_IO_16,
  PL_LINUX_IO_17,
  PL_LINUX_IO_18,
  PL_LINUX_IO_19,
  PL_LINUX_IO_20,
  PL_LINUX_IO_21,
  PL_LINUX_IO_22,
  PL_LINUX_IO_23,
  PL_LINUX_IO_24,
  PL_LINUX_IO_25,
  PL_LINUX_IO_26,
  PL_LINUX_IO_27,
  PL_LINUX_IO_28,
  PL_LINUX_IO_29,
  PL_LINUX_IO_30,
  PL_LINUX_IO_31,
  PL_LINUX_IO_32,
  PL_LINUX_IO_33,
  PL_LINUX_IO_34,
  PL_LINUX_IO_35,
  PL_LINUX_IO_36,
  PL_LINUX_IO_37,
  PL_LINUX_IO_38,
  PL_LINUX_IO_39,
  PL_LINUX_IO_40,
  PL_LINUX_IO_41,
  PL_LINUX_IO_42,
  PL_LINUX_IO_43,
  PL_LINUX_IO_44,
  PL_LINUX_IO_45,
  PL_LINUX_IO_46,
  PL_LINUX_IO_47,
  PL_LINUX_IO_48,
  PL_LINUX_IO_49,
  PL_LINUX_IO_50,
  PL_LINUX_IO_51,
  PL_LINUX_IO_52,
  PL_LINUX_IO_53,
  PL_LINUX_IO_54,
  PL_LINUX_IO_55,
  PL_LINUX_IO_56,
  PL_LINUX_IO_57,
  PL_LINUX_IO_58,
  PL_LINUX_IO_59,
  PL_LINUX_IO_60,
  PL_LINUX_IO_61,
  PL_LINUX_IO_62,
  PL_LINUX_IO_63,
  PL_LINUX_IO_NUM_NULL = 254
} pl_linux_io_num;

/* Enum containing the Status LED IO-lines */
typedef enum : std::uint8_t {
  PL_STATUS_REDLED = 62,
  PL_STATUS_GREENLED = 63,
  PL_STATUS_NULL = 255
} pl_status_num;

/* Enum for controlling the Signal LEDs */
typedef enum : std::uint8_t {
  PL_SIGNAL_CLKPIN = 60,
  PL_SIGNAL_DATAPIN = 61,
  PL_SIGNAL_NULL = 255
} pl_signal_num;

}  // namespace internal
}  // namespace io
}  // namespace ntios

using ntios::io::internal::pl_linux_io_num;

typedef enum : std::uint8_t {
  PL_IO_NUM_0,
  PL_IO_NUM_1,
  PL_IO_NUM_2,
  PL_IO_NUM_3,
  PL_IO_NUM_4,
  PL_IO_NUM_5,
  PL_IO_NUM_6,
  PL_IO_NUM_7,
  PL_IO_NUM_8,
  PL_IO_NUM_9,
  PL_IO_NUM_10,
  PL_IO_NUM_11,
  PL_IO_NUM_12,
  PL_IO_NUM_13,
  PL_IO_NUM_14,
  PL_IO_NUM_15,
  PL_IO_NUM_16,
  PL_IO_NUM_17,
  PL_IO_NUM_18,
  PL_IO_NUM_19,
  PL_IO_NUM_20,
  PL_IO_NUM_21,
  PL_IO_NUM_22,
  PL_IO_NUM_23,
  PL_IO_NUM_24,
  PL_IO_NUM_25,
  PL_IO_NUM_26,
  PL_IO_NUM_27,
  PL_IO_NUM_28,
  PL_IO_NUM_29,
  PL_IO_NUM_30,
  PL_IO_NUM_31,
  PL_IO_NUM_32,
  PL_IO_NUM_33,
  PL_IO_NUM_34,
  PL_IO_NUM_35,
  PL_IO_NUM_36,
  PL_IO_NUM_37,
  PL_IO_NUM_38,
  PL_IO_NUM_39,
  PL_IO_NUM_40,
  PL_IO_NUM_41,
  PL_IO_NUM_42,
  PL_IO_NUM_43,
  PL_IO_NUM_44,
  PL_IO_NUM_45,
  PL_IO_NUM_46,
  PL_IO_NUM_47,
  PL_IO_NUM_48,
  PL_IO_NUM_49,
  PL_IO_NUM_50,
  PL_IO_NUM_51,
  PL_IO_NUM_52,
  PL_IO_NUM_53,
  PL_IO_NUM_54,
  PL_IO_NUM_55,
  PL_IO_NUM_56,
  PL_IO_NUM_57,
  PL_IO_NUM_58,
  PL_IO_NUM_59,
  PL_IO_NUM_60,
  PL_IO_NUM_61,
  PL_IO_NUM_62,
  PL_IO_NUM_63,
  PL_IO_NULL = pl_linux_io_num::PL_LINUX_IO_NUM_NULL

} pl_io_num;

typedef enum : std::uint8_t {
  PL_INT_NUM_0,
  PL_INT_NUM_1,
  PL_INT_NUM_2,
  PL_INT_NUM_3,
  PL_INT_NUM_4,
  PL_INT_NUM_5,
  PL_INT_NUM_6,
  PL_INT_NUM_7,
  PL_INT_NULL
} pl_int_num;

/* Enum containing the Io-ports of Io-lines */
typedef enum : std::uint8_t {
  PL_IO_PORT_NUM_0,
  PL_IO_PORT_NUM_1,
  PL_IO_PORT_NUM_2,
  PL_IO_PORT_NUM_3,
  PL_IO_PORT_NULL
} pl_io_port_num;

#endif  // NTIOS_LINUX_LTPP3G2_IO_IO_PINS_H_
