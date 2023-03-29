                
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_WLN_NTIOS_WLN_H_
#define NTIOS_XPAT_WLN_NTIOS_WLN_H_

#include <cmath>
#include <string>

#include "base/ntios_types.h"
#include "base/ntios_base.h"
#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "io/ntios_io_map.h"

/* NAMESPACES */
namespace ntios {
namespace wln {

class WLN {
public:
    WLN();
    ~WLN();

Property<pl_wln_association_states, WLN> associationstate{this, nullptr, &WLN::associationstateGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, WLN> buffsize{this, nullptr, &WLN::buffsizeGetter,
    PropertyPermissions::Read};

Property<pl_io_num, WLN> clkmap{this, &WLN::clkmapSetter, &WLN::clkmapGetter,
    PropertyPermissions::ReadWrite};

Property<pl_io_num, WLN> csmap{this, &WLN::csmapSetter, &WLN::csmapGetter,
    PropertyPermissions::ReadWrite};

Property<pl_io_num, WLN> dimap{this, &WLN::dimapSetter, &WLN::dimapGetter,
    PropertyPermissions::ReadWrite};

Property<pl_wln_domains, WLN> domain{this, &WLN::domainSetter, &WLN::domainGetter,
    PropertyPermissions::ReadWrite};

Property<pl_io_num, WLN> domap{this, &WLN::domapSetter, &WLN::domapGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, WLN> enabled{this, nullptr, &WLN::enabledGetter,
    PropertyPermissions::Read};

Property<string, WLN> gatewayip{this, &WLN::gatewayipSetter, &WLN::gatewayipGetter,
    PropertyPermissions::ReadWrite};

Property<string, WLN> monversion{this, nullptr, &WLN::monversionGetter,
    PropertyPermissions::Read};

Property<string, WLN> fwversion{this, nullptr, &WLN::fwversionGetter,
    PropertyPermissions::Read};

Property<pl_wln_phy_modes, WLN> band{this, &WLN::bandSetter, &WLN::bandGetter,
    PropertyPermissions::ReadWrite};

Property<string, WLN> ip{this, &WLN::ipSetter, &WLN::ipGetter,
    PropertyPermissions::ReadWrite};

Property<string, WLN> mac{this, &WLN::macSetter, &WLN::macGetter,
    PropertyPermissions::ReadWrite};

Property<string, WLN> netmask{this, &WLN::netmaskSetter, &WLN::netmaskGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned char, WLN> rssi{this, nullptr, &WLN::rssiGetter,
    PropertyPermissions::Read};

Property<pl_wln_scan_filter, WLN> scanfilter{this, &WLN::scanfilterSetter, &WLN::scanfilterGetter,
    PropertyPermissions::ReadWrite};

Property<string, WLN> scanresultbssid{this, nullptr, &WLN::scanresultbssidGetter,
    PropertyPermissions::Read};

Property<pl_wln_bss_modes, WLN> scanresultbssmode{this, nullptr, &WLN::scanresultbssmodeGetter,
    PropertyPermissions::Read};

Property<unsigned char, WLN> scanresultchannel{this, nullptr, &WLN::scanresultchannelGetter,
    PropertyPermissions::Read};

Property<unsigned char, WLN> scanresultrssi{this, nullptr, &WLN::scanresultrssiGetter,
    PropertyPermissions::Read};

Property<string, WLN> scanresultssid{this, nullptr, &WLN::scanresultssidGetter,
    PropertyPermissions::Read};

Property<string, WLN> scanresultwpainfo{this, nullptr, &WLN::scanresultwpainfoGetter,
    PropertyPermissions::Read};

Property<pl_wln_tasks, WLN> task{this, nullptr, &WLN::taskGetter,
    PropertyPermissions::Read};

Property<no_yes, WLN> mfgenabled{this, nullptr, &WLN::mfgenabledGetter,
    PropertyPermissions::Read};

accepted_rejected activescan(string ssid);
                
accepted_rejected associate(string bssid, string ssid, unsigned char channel, pl_wln_bss_modes bssmode);
                
ok_ng boot(unsigned long offset);
                
BUFF_PAGE_TYPE buffrq(BUFF_PAGE_TYPE numpages);
                
accepted_rejected disassociate();
                
pl_wln_module_types getmoduletype();
                
void disable();
                
void setupgraderegion(pl_wln_upgrade_regions region);
                
accepted_rejected writeflashpage(string page);
                
void upgrade(pl_wln_upgrade_regions region, unsigned long fwlength, unsigned long checksum);
                
ok_ng waitforupgradecompletion();
                
accepted_rejected networkstart(string ssid, unsigned char channel);
                
accepted_rejected networkstop();
                
accepted_rejected scan(string ssid);
                
accepted_rejected settxpower(unsigned char level);
                
accepted_rejected setwep(string wepkey, pl_wln_wep_modes wepmode);
                
accepted_rejected setwpa(pl_wln_wpa_modes wpamode, pl_wln_wpa_algorithms algorithm, string wpakey, pl_wln_wpa_unicast_multicast cast);
                
private:

pl_wln_association_states massociationstate;
pl_wln_association_states associationstateGetter() const;

BUFF_SIZE_TYPE mbuffsize;
BUFF_SIZE_TYPE buffsizeGetter() const;

pl_io_num mclkmap;
pl_io_num clkmapGetter() const;

void clkmapSetter(pl_io_num clkmap);

pl_io_num mcsmap;
pl_io_num csmapGetter() const;

void csmapSetter(pl_io_num csmap);

pl_io_num mdimap;
pl_io_num dimapGetter() const;

void dimapSetter(pl_io_num dimap);

pl_wln_domains mdomain;
pl_wln_domains domainGetter() const;

void domainSetter(pl_wln_domains domain);

pl_io_num mdomap;
pl_io_num domapGetter() const;

void domapSetter(pl_io_num domap);

no_yes menabled;
no_yes enabledGetter() const;

string mgatewayip;
string gatewayipGetter() const;

void gatewayipSetter(string gatewayip);

string mMonVersion;
string monversionGetter() const;

string mfwversion;
string fwversionGetter() const;

pl_wln_phy_modes mband;
pl_wln_phy_modes bandGetter() const;

void bandSetter(pl_wln_phy_modes band);

string mip;
string ipGetter() const;

void ipSetter(string ip);

string mmac;
string macGetter() const;

void macSetter(string mac);

string mnetmask;
string netmaskGetter() const;

void netmaskSetter(string netmask);

unsigned char mrssi;
unsigned char rssiGetter() const;

pl_wln_scan_filter mscanfilter;
pl_wln_scan_filter scanfilterGetter() const;

void scanfilterSetter(pl_wln_scan_filter scanfilter);

string mscanresultbssid;
string scanresultbssidGetter() const;

pl_wln_bss_modes mscanresultbssmode;
pl_wln_bss_modes scanresultbssmodeGetter() const;

unsigned char mscanresultchannel;
unsigned char scanresultchannelGetter() const;

unsigned char mscanresultrssi;
unsigned char scanresultrssiGetter() const;

string mscanresultssid;
string scanresultssidGetter() const;

string mscanresultwpainfo;
string scanresultwpainfoGetter() const;

pl_wln_tasks mtask;
pl_wln_tasks taskGetter() const;

no_yes mmfgenabled;
no_yes mfgenabledGetter() const;

};
}  // namespace wln
} /* namespace ntios */
#endif
