                
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_NET_NTIOS_NET_H_
#define NTIOS_XPAT_NET_NTIOS_NET_H_

#include <cmath>
#include <string>

#include "base/ntios_types.h"
#include "base/ntios_base.h"
#include "base/ntios_config.h"
#include "base/ntios_property.h"


/* NAMESPACES */
namespace ntios {
namespace net {

class NET {
public:
    NET();
    ~NET();

Property<string, NET> mac{this, nullptr, &NET::macGetter,
    PropertyPermissions::Read};

Property<string, NET> ip{this, &NET::ipSetter, &NET::ipGetter,
    PropertyPermissions::ReadWrite};

Property<string, NET> netmask{this, &NET::netmaskSetter, &NET::netmaskGetter,
    PropertyPermissions::ReadWrite};

Property<string, NET> gatewayip{this, &NET::gatewayipSetter, &NET::gatewayipGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, NET> failure{this, nullptr, &NET::failureGetter,
    PropertyPermissions::Read};

Property<pl_net_linkstate, NET> linkstate{this, nullptr, &NET::linkstateGetter,
    PropertyPermissions::Read};

private:

string mmac;
string macGetter() const;

string mip;
string ipGetter() const;

void ipSetter(string ip);

string mnetmask;
string netmaskGetter() const;

void netmaskSetter(string netmask);

string mgatewayip;
string gatewayipGetter() const;

void gatewayipSetter(string gatewayip);

no_yes mfailure;
no_yes failureGetter() const;

pl_net_linkstate mlinkstate;
pl_net_linkstate linkstateGetter() const;

};
}  // namespace net
} /* namespace ntios */
#endif
