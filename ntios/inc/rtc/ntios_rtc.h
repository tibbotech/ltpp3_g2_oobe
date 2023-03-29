                
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_RTC_NTIOS_RTC_H_
#define NTIOS_XPAT_RTC_NTIOS_RTC_H_

#include "base/ntios_property.h"
#include "base/ntios_types.h"

/* NAMESPACES */
namespace ntios {
namespace rtc {

class RTC {
public:
 RTC();
 Property<no_yes, RTC> running{this, nullptr, &RTC::runningGetter, PropertyPermissions::Read};
 void getdata(word& daycount, word& mincount, byte& seconds);
 void setdata( word daycount, word mincount, byte seconds);
private:

    no_yes mrunning;
    no_yes runningGetter() const;

};
}  // namespace rtc
} /* namespace ntios */
#endif  // NTIOS_XPAT_RTC_NTIOS_RTC_H_
