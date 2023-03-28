/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef STOR_NTIOS_ROMFILE_H_
#define STOR_NTIOS_ROMFILE_H_

#include <string>
#include "base/ntios_property.h"
#include "base/ntios_types.h"


namespace ntios {
namespace romFile {

class ROMFILE{
 public:
   Property<U32, ROMFILE>size{this, 
                              nullptr, 
                              &ROMFILE::sizeGetter,
                              PropertyPermissions::Read};

   Property<U32, ROMFILE>offset{this, 
                              nullptr, 
                              &ROMFILE::offsetGetter,
                              PropertyPermissions::Read};

   Property<U16, ROMFILE>pointer{this,&ROMFILE::PointerSetter,
                           &ROMFILE::PointerGetter,
                           PropertyPermissions::ReadWrite};

   void open(std::string filename);  
   U16 find(U32 frompos,std::string substr,U16 num);  
   U32 find32(U32 frompos,std::string substr,U16 num);
   std::string getdata(U8 maxinplen);
 private:
   U32 r_ptr;
   U32 r_fllen;
   U32 r_flofs;

   static U8 rfl_arr[];

   U32 sizeGetter() const; 
   U32 offsetGetter() const;

   void PointerSetter(U16 rptr);
   U16 PointerGetter() const;
   U32 find_common(U32 frompos,std::string substr,U16 num,U8 mode);
   void rfl_get(U32 base, U32 len, U8 *ptr);

};

}  // namespace romfile
}  // namespace ntios 

#endif  // STOR_NTIOS_ROMFILE_H_
