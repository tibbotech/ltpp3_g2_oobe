#ifndef _NTIOS_IO_CONFIG_H
#define _NTIOS_IO_CONFIG_H

#include <cstdint>

namespace ntios {
namespace io {
namespace internal {

/*
 * (Linux) GPIO-lines 0-63 in Use by Tibbo.
 * Remark:
 *   1. Totally there are 100 GPIO-lines (0-99)
 *   2. On the LTPP3-G2, use command 'gpioinfo' to get the GPIO-line-info.
 */
const std::uint8_t LINUX_NUM_IO = 64;
/* Tibbo IO-num 0-55 visible to users */
const std::uint8_t NUM_IO = 56;
/* Unused IO-nums: 56 - 59 */
const std::uint8_t NUM_IO_56TO59_UNUSED = 4;
/* Tibbo IO-num 62 (PL_STATUS_REDLED) & 63 (PL_STATUS_GREENLED) */
const std::uint8_t NUM_IO_STATUS = 2;
/* Tibbo IO-num 60 (PL_SIGNAL_CLKPIN) & 61 (PL_SIGNAL_DATAPIN) */
const std::uint8_t NUM_IO_SIGNAL = 2;
/* Total of Tibbo IO-nums in use */
const std::uint8_t NUM_IO_TOTAL =
    (NUM_IO + NUM_IO_56TO59_UNUSED + NUM_IO_STATUS + NUM_IO_SIGNAL);

/* IO-PORT 0-3 visible to users */
const std::uint8_t NUM_IO_PORT = 4;

const std::uint8_t NUM_INT_TOTAL = 8;
}  // namespace internal
}  // namespace io
}  // namespace ntios

#endif /* _NTIOS_IO_CONFIG_H */