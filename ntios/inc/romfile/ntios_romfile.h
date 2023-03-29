/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef STOR_NTIOS_ROMFILE_H_
#define STOR_NTIOS_ROMFILE_H_

#include <map>
#include <string>
#include <cstdint>

#include "base/ntios_property.h"
#include "base/ntios_types.h"

namespace ntios {
namespace romfile {
extern std::map<const std::string,const std::uint8_t*> romfiles; 
extern std::map<const std::string, const std::uint32_t> romfile_sizes; 
class ROMFILE {
 public:
  Property<std::uint32_t, ROMFILE> size{this, nullptr, &ROMFILE::sizeGetter,
                              PropertyPermissions::Read};

  Property<std::uint32_t, ROMFILE> offset{this, nullptr, &ROMFILE::offsetGetter,
                                PropertyPermissions::Read};

  Property<std::uint16_t, ROMFILE> pointer{this, &ROMFILE::PointerSetter,
                                 &ROMFILE::PointerGetter,
                                 PropertyPermissions::ReadWrite};

  void open(std::string filename);
  std::uint16_t find(std::uint32_t frompos, std::string substr, std::uint16_t num);
  std::uint32_t find32(std::uint32_t frompos, std::string substr, std::uint16_t num);
  std::string getdata(std::uint8_t maxinplen);

 private:
  std::uint32_t r_ptr;
  std::uint32_t r_fllen;
  std::uint32_t r_flofs;

  std::uint8_t* rfl_arr;

  std::uint32_t sizeGetter() const;
  std::uint32_t offsetGetter() const;

  void PointerSetter(std::uint16_t rptr);
  std::uint16_t PointerGetter() const;
  std::uint32_t find_common(std::uint32_t frompos, std::string substr, std::uint16_t num, std::uint8_t mode);
  void rfl_get(std::uint32_t base, std::uint32_t len, std::uint8_t *ptr);
};

}  // namespace romfile
}  // namespace ntios

#endif  // STOR_NTIOS_ROMFILE_H_
