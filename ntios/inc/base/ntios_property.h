/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef NTIOS_XPAT_BASE_NTIOS_PROPERTY_H_
#define NTIOS_XPAT_BASE_NTIOS_PROPERTY_H_
#include <cstdint>
#include <stdexcept>
#include <string>

#include "ntios_types.h"



enum class PropertyPermissions : std::uint8_t {
  Read = 1,
  Write = 2,
  ReadWrite = 3
};

template <typename T, typename C>

class Property {
  using setter_t = void (C::*)(T);
  using getter_t = T (C::*)() const;

 public:
  Property(C* parentPtr, setter_t setterPtr, getter_t getterPtr,
           PropertyPermissions propertyPermissions)
      : parent(parentPtr),
        setterFuncPtr(setterPtr),
        getterFuncPtr(getterPtr),
        propertyMode(propertyPermissions) {}

  operator T() const {
    if ((static_cast<::std::uint8_t>(propertyMode) &
         static_cast<::std::uint8_t>(PropertyPermissions::Read)) > 0) {
      return (parent->*getterFuncPtr)();
    } else {
      throw std::runtime_error("This property is write only");
    }
  }

  C& operator=(const T& value) {
    if ((static_cast<::std::uint8_t>(propertyMode) &
         static_cast<::std::uint8_t>(PropertyPermissions::Write)) > 0) {
      (parent->*setterFuncPtr)(value);
      return *parent;
    }
    throw std::runtime_error("This property is read only");
  }

  Property& operator=(const Property& value) {
    if ((static_cast<::std::uint8_t>(propertyMode) &
         static_cast<::std::uint8_t>(PropertyPermissions::Write)) > 0) {
      T pval = ((value.parent)->*getterFuncPtr)();
      (parent->*setterFuncPtr)(pval);

      return *this;
    }
    throw std::runtime_error("This property is read only");
  }



 private:
  C* const parent;
  setter_t const setterFuncPtr;
  getter_t const getterFuncPtr;
  PropertyPermissions propertyMode;
};

#pragma region String Property to String Equality Operators
template <typename C>
bool operator==(const std::string& s, const Property<std::string, C>& p) {
  std::string pval = p;
  return pval == s;
}

template <typename C>
bool operator==(const Property<std::string, C>& p, const std::string& s) {
  std::string pval = p;
  return pval == s;
}

template <typename C>
bool operator==(const char* s, const Property<std::string, C>& p) {
  std::string pval = p;
  return pval == (std::string)s;
}

template <typename C>
bool operator==(const Property<std::string, C>& p, const char* s) {
  std::string pval = p;
  return pval == (std::string)s;
}
#pragma endregion

#pragma region String Property to String Not Equal Operators
template <typename C>
bool operator!=(const std::string& s, const Property<std::string, C>& p) {
  std::string pval = p;
  return pval != s;
}

template <typename C>
bool operator!=(const char* s, const Property<std::string, C>& p) {
  std::string pval = p;
  return pval != (std::string)s;
}

template <typename C>
bool operator!=(const Property<std::string, C>& p, const std::string& s) {
  std::string pval = p;
  return pval != s;
}

template <typename C>
bool operator!=(const Property<std::string, C>& p, const char* s) {
  std::string pval = p;
  return pval != (std::string)s;
}
#pragma endregion 


// string Property
template <typename C>
std::string operator+(const std::string& s, const Property<std::string, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<std::string, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, Property<std::string, C>& p) {
  std::string pval = p;
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<std::string, C>& p, const char* s) {
  std::string pval = p;
  return (std::string)pval + s;
}

// Byte Property
template <typename C>
std::string operator+(const std::string& s, const Property<byte, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<byte, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<byte, C>& p) {
  std::string pval = p;
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<byte, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}

// integer Property
template <typename C>
std::string operator+(const std::string& s, const Property<integer, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<integer, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<integer, C>& p) {
  std::string pval = std::to_string(p);
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<integer, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}

// word Property
template <typename C>
std::string operator+(const std::string& s, const Property<word, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<word, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<word, C>& p) {
  std::string pval = std::to_string(p);
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<word, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}

// Dword Property
template <typename C>
std::string operator+(const std::string& s, const Property<dword, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<dword, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<dword, C>& p) {
  std::string pval = std::to_string(p);
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<dword, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}

// qword Property
template <typename C>
std::string operator+(const std::string& s, const Property<qword, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<qword, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<qword, C>& p) {
  std::string pval = p;
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<qword, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}


// Long Property
template <typename C>
std::string operator+(const std::string& s, const Property<long, C>& p) {
  std::string pval = std::to_string(p);
  return s + pval;
}

template <typename C>
std::string operator+(const Property<long, C>& p, const std::string& s) {
  std::string pval = std::to_string(p);
  return pval + s;
}

template <typename C>
std::string operator+(const char* s, const Property<long, C>& p) {
  std::string pval = p;
  return (std::string)s + pval;
}

template <typename C>
std::string operator+(const Property<long, C>& p, const char* s) {
  std::string pval = std::to_string(p);
  return pval + (std::string)s;
}





#endif  // NTIOS_XPAT_BASE_NTIOS_PROPERTY_H_
