
/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_TYPES_H_
#define NTIOS_TYPES_H_

#include <cstdint>

#define U8 ::uint8_t
#define U16 ::uint16_t
#define U32 ::uint32_t

#define S8 ::int8_t
#define S16 ::int16_t
#define S32 ::int32_t

#define TIOS_ADDR ::uint32_t

typedef std::uint8_t byte;
typedef std::int16_t integer;
typedef std::uint16_t word;
typedef std::uint32_t dword;
typedef float real;
typedef bool boolean;

#define YES true
#define NO false

typedef bool no_yes;

#endif  // NTIOS_TYPES_H_
