                
/*Copyright 2021 Tibbo Technology Inc.*/
#ifndef NTIOS_XPAT_SOCK_NTIOS_SOCK_H_
#define NTIOS_XPAT_SOCK_NTIOS_SOCK_H_

#include <cmath>
#include <string>

#include "base/ntios_types.h"
#include "base/ntios_base.h"
#include "base/ntios_config.h"
#include "base/ntios_property.h"
#include "io/ntios_io_map.h"

/* NAMESPACES */
namespace ntios {
namespace sock {

class SOCK {
public:
    SOCK();
    ~SOCK();

Property<unsigned char, SOCK> numofsock{this, nullptr, &SOCK::numofsockGetter,
    PropertyPermissions::Read};

Property<unsigned char, SOCK> num{this, &SOCK::numSetter, &SOCK::numGetter,
    PropertyPermissions::ReadWrite};

Property<pl_sock_state, SOCK> state{this, nullptr, &SOCK::stateGetter,
    PropertyPermissions::Read};

Property<pl_sock_state_simple, SOCK> statesimple{this, nullptr, &SOCK::statesimpleGetter,
    PropertyPermissions::Read};

Property<pl_sock_inconmode, SOCK> inconmode{this, &SOCK::inconmodeSetter, &SOCK::inconmodeGetter,
    PropertyPermissions::ReadWrite};

Property<pl_sock_reconmode, SOCK> reconmode{this, &SOCK::reconmodeSetter, &SOCK::reconmodeGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> localportlist{this, &SOCK::localportlistSetter, &SOCK::localportlistGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> httpportlist{this, &SOCK::httpportlistSetter, &SOCK::httpportlistGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned int, SOCK> localport{this, nullptr, &SOCK::localportGetter,
    PropertyPermissions::Read};

Property<unsigned int, SOCK> outport{this, &SOCK::outportSetter, &SOCK::outportGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> acceptbcast{this, &SOCK::acceptbcastSetter, &SOCK::acceptbcastGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> targetip{this, &SOCK::targetipSetter, &SOCK::targetipGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> targetmac{this, &SOCK::targetmacSetter, &SOCK::targetmacGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned int, SOCK> targetport{this, &SOCK::targetportSetter, &SOCK::targetportGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> targetbcast{this, &SOCK::targetbcastSetter, &SOCK::targetbcastGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> remotemac{this, nullptr, &SOCK::remotemacGetter,
    PropertyPermissions::Read};

Property<string, SOCK> remoteip{this, nullptr, &SOCK::remoteipGetter,
    PropertyPermissions::Read};

Property<unsigned int, SOCK> remoteport{this, nullptr, &SOCK::remoteportGetter,
    PropertyPermissions::Read};

Property<no_yes, SOCK> bcast{this, nullptr, &SOCK::bcastGetter,
    PropertyPermissions::Read};

Property<pl_sock_protocol, SOCK> protocol{this, &SOCK::protocolSetter, &SOCK::protocolGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> splittcppackets{this, &SOCK::splittcppacketsSetter, &SOCK::splittcppacketsGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> httpmode{this, &SOCK::httpmodeSetter, &SOCK::httpmodeGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> httpnoclose{this, &SOCK::httpnocloseSetter, &SOCK::httpnocloseGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned int, SOCK> connectiontout{this, &SOCK::connectiontoutSetter, &SOCK::connectiontoutGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned int, SOCK> toutcounter{this, nullptr, &SOCK::toutcounterGetter,
    PropertyPermissions::Read};

Property<no_yes, SOCK> inbandcommands{this, &SOCK::inbandcommandsSetter, &SOCK::inbandcommandsGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned char, SOCK> escchar{this, &SOCK::esccharSetter, &SOCK::esccharGetter,
    PropertyPermissions::ReadWrite};

Property<unsigned char, SOCK> endchar{this, &SOCK::endcharSetter, &SOCK::endcharGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> gendataarrivalevent{this, &SOCK::gendataarrivaleventSetter, &SOCK::gendataarrivaleventGetter,
    PropertyPermissions::ReadWrite};

Property<BUFF_SIZE_TYPE, SOCK> rxbuffsize{this, nullptr, &SOCK::rxbuffsizeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> txbuffsize{this, nullptr, &SOCK::txbuffsizeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> cmdbuffsize{this, nullptr, &SOCK::cmdbuffsizeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> rplbuffsize{this, nullptr, &SOCK::rplbuffsizeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> varbuffsize{this, nullptr, &SOCK::varbuffsizeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> tx2buffsize{this, nullptr, &SOCK::tx2buffsizeGetter,
    PropertyPermissions::Read};

Property<pl_http_rq_type, SOCK> httprqtype{this, nullptr, &SOCK::httprqtypeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> rxlen{this, nullptr, &SOCK::rxlenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> txlen{this, nullptr, &SOCK::txlenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> txfree{this, nullptr, &SOCK::txfreeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> newtxlen{this, nullptr, &SOCK::newtxlenGetter,
    PropertyPermissions::Read};

Property<string, SOCK> httprqstring{this, nullptr, &SOCK::httprqstringGetter,
    PropertyPermissions::Read};

Property<unsigned int, SOCK> rxpacketlen{this, nullptr, &SOCK::rxpacketlenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> cmdlen{this, nullptr, &SOCK::cmdlenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> varlen{this, nullptr, &SOCK::varlenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> rpllen{this, nullptr, &SOCK::rpllenGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> rplfree{this, nullptr, &SOCK::rplfreeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> tx2len{this, nullptr, &SOCK::tx2lenGetter,
    PropertyPermissions::Read};

Property<no_yes, SOCK> inconenabledmaster{this, &SOCK::inconenabledmasterSetter, &SOCK::inconenabledmasterGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> urlsubstitutes{this, &SOCK::urlsubstitutesSetter, &SOCK::urlsubstitutesGetter,
    PropertyPermissions::ReadWrite};

Property<no_yes, SOCK> sinkdata{this, &SOCK::sinkdataSetter, &SOCK::sinkdataGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> allowedinterfaces{this, &SOCK::allowedinterfacesSetter, &SOCK::allowedinterfacesGetter,
    PropertyPermissions::ReadWrite};

Property<string, SOCK> availableinterfaces{this, nullptr, &SOCK::availableinterfacesGetter,
    PropertyPermissions::Read};

Property<pl_sock_interfaces, SOCK> targetinterface{this, &SOCK::targetinterfaceSetter, &SOCK::targetinterfaceGetter,
    PropertyPermissions::ReadWrite};

Property<pl_sock_interfaces, SOCK> currentinterface{this, nullptr, &SOCK::currentinterfaceGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> tlstxfree{this, nullptr, &SOCK::tlstxfreeGetter,
    PropertyPermissions::Read};

Property<BUFF_SIZE_TYPE, SOCK> tlsrxlen{this, nullptr, &SOCK::tlsrxlenGetter,
    PropertyPermissions::Read};

Property<unsigned char, SOCK> tlscurrentnum{this, nullptr, &SOCK::tlscurrentnumGetter,
    PropertyPermissions::Read};

string gethttprqstring(unsigned int maxinplen);
                
void rxclear();
                
void txclear();
                
string getdata(unsigned int maxinplen);
                
string peekdata(unsigned int maxinplen);
                
void setdata(string txdata);
                
void send();
                
string getinband();
                
string peekinband();
                
void setsendinband(string data);
                
void notifysent(unsigned int threshold);
                
void nextpacket();
                
void connect();
                
void close();
                
void reset();
                
void discard();
                
BUFF_PAGE_TYPE rxbuffrq(BUFF_PAGE_TYPE numpages);
                
BUFF_PAGE_TYPE txbuffrq(BUFF_PAGE_TYPE numpages);
                
BUFF_PAGE_TYPE cmdbuffrq(BUFF_PAGE_TYPE numpages);
                
BUFF_PAGE_TYPE rplbuffrq(BUFF_PAGE_TYPE numpages);
                
BUFF_PAGE_TYPE varbuffrq(BUFF_PAGE_TYPE numpages);
                
BUFF_PAGE_TYPE tx2buffrq(BUFF_PAGE_TYPE numpages);
                
pl_redir redir(pl_redir redir);

pl_redir redir(std::uint8_t redir);
                
pl_tls_result tlsinit(unsigned long offset);
                
pl_tls_result tlshandshake(string server_name);
                
accepted_rejected tlsdeinit();
                
unsigned int tlssetdata(string txdata);
                
string tlsgetdata(unsigned int maxinplen);
                
BUFF_PAGE_TYPE tlsbuffrq(BUFF_PAGE_TYPE numpages);
                
string tlspeekdata(unsigned int maxinplen);
                
private:

unsigned char mnumofsock;
unsigned char numofsockGetter() const;

unsigned char mnum;
unsigned char numGetter() const;

void numSetter(unsigned char num);

pl_sock_state mstate;
pl_sock_state stateGetter() const;

pl_sock_state_simple mstatesimple;
pl_sock_state_simple statesimpleGetter() const;

pl_sock_inconmode minconmode;
pl_sock_inconmode inconmodeGetter() const;

void inconmodeSetter(pl_sock_inconmode inconmode);

pl_sock_reconmode mreconmode;
pl_sock_reconmode reconmodeGetter() const;

void reconmodeSetter(pl_sock_reconmode reconmode);

string mlocalportlist;
string localportlistGetter() const;

void localportlistSetter(string localportlist);

string mhttpportlist;
string httpportlistGetter() const;

void httpportlistSetter(string httpportlist);

unsigned int mlocalport;
unsigned int localportGetter() const;

unsigned int moutport;
unsigned int outportGetter() const;

void outportSetter(unsigned int outport);

no_yes macceptbcast;
no_yes acceptbcastGetter() const;

void acceptbcastSetter(no_yes acceptbcast);

string mtargetip;
string targetipGetter() const;

void targetipSetter(string targetip);

string mtargetmac;
string targetmacGetter() const;

void targetmacSetter(string targetmac);

unsigned int mtargetport;
unsigned int targetportGetter() const;

void targetportSetter(unsigned int targetport);

no_yes mtargetbcast;
no_yes targetbcastGetter() const;

void targetbcastSetter(no_yes targetbcast);

string mremotemac;
string remotemacGetter() const;

string mremoteip;
string remoteipGetter() const;

unsigned int mremoteport;
unsigned int remoteportGetter() const;

no_yes mbcast;
no_yes bcastGetter() const;

pl_sock_protocol mprotocol;
pl_sock_protocol protocolGetter() const;

void protocolSetter(pl_sock_protocol protocol);

no_yes msplittcppackets;
no_yes splittcppacketsGetter() const;

void splittcppacketsSetter(no_yes splittcppackets);

no_yes mhttpmode;
no_yes httpmodeGetter() const;

void httpmodeSetter(no_yes httpmode);

no_yes mhttpnoclose;
no_yes httpnocloseGetter() const;

void httpnocloseSetter(no_yes httpnoclose);

unsigned int mconnectiontout;
unsigned int connectiontoutGetter() const;

void connectiontoutSetter(unsigned int connectiontout);

unsigned int mtoutcounter;
unsigned int toutcounterGetter() const;

no_yes minbandcommands;
no_yes inbandcommandsGetter() const;

void inbandcommandsSetter(no_yes inbandcommands);

unsigned char mescchar;
unsigned char esccharGetter() const;

void esccharSetter(unsigned char escchar);

unsigned char mendchar;
unsigned char endcharGetter() const;

void endcharSetter(unsigned char endchar);

no_yes mgendataarrivalevent;
no_yes gendataarrivaleventGetter() const;

void gendataarrivaleventSetter(no_yes gendataarrivalevent);

BUFF_SIZE_TYPE mrxbuffsize;
BUFF_SIZE_TYPE rxbuffsizeGetter() const;

BUFF_SIZE_TYPE mtxbuffsize;
BUFF_SIZE_TYPE txbuffsizeGetter() const;

BUFF_SIZE_TYPE mcmdbuffsize;
BUFF_SIZE_TYPE cmdbuffsizeGetter() const;

BUFF_SIZE_TYPE mrplbuffsize;
BUFF_SIZE_TYPE rplbuffsizeGetter() const;

BUFF_SIZE_TYPE mvarbuffsize;
BUFF_SIZE_TYPE varbuffsizeGetter() const;

BUFF_SIZE_TYPE mtx2buffsize;
BUFF_SIZE_TYPE tx2buffsizeGetter() const;

pl_http_rq_type mhttprqtype;
pl_http_rq_type httprqtypeGetter() const;

BUFF_SIZE_TYPE mrxlen;
BUFF_SIZE_TYPE rxlenGetter() const;

BUFF_SIZE_TYPE mtxlen;
BUFF_SIZE_TYPE txlenGetter() const;

BUFF_SIZE_TYPE mtxfree;
BUFF_SIZE_TYPE txfreeGetter() const;

BUFF_SIZE_TYPE mnewtxlen;
BUFF_SIZE_TYPE newtxlenGetter() const;

string mhttprqstring;
string httprqstringGetter() const;

unsigned int mrxpacketlen;
unsigned int rxpacketlenGetter() const;

BUFF_SIZE_TYPE mcmdlen;
BUFF_SIZE_TYPE cmdlenGetter() const;

BUFF_SIZE_TYPE mvarlen;
BUFF_SIZE_TYPE varlenGetter() const;

BUFF_SIZE_TYPE mrpllen;
BUFF_SIZE_TYPE rpllenGetter() const;

BUFF_SIZE_TYPE mrplfree;
BUFF_SIZE_TYPE rplfreeGetter() const;

BUFF_SIZE_TYPE mtx2len;
BUFF_SIZE_TYPE tx2lenGetter() const;

no_yes minconenabledmaster;
no_yes inconenabledmasterGetter() const;

void inconenabledmasterSetter(no_yes inconenabledmaster);

string murlsubstitutes;
string urlsubstitutesGetter() const;

void urlsubstitutesSetter(string urlsubstitutes);

no_yes msinkdata;
no_yes sinkdataGetter() const;

void sinkdataSetter(no_yes sinkdata);

string mallowedinterfaces;
string allowedinterfacesGetter() const;

void allowedinterfacesSetter(string allowedinterfaces);

string mavailableinterfaces;
string availableinterfacesGetter() const;

pl_sock_interfaces mtargetinterface;
pl_sock_interfaces targetinterfaceGetter() const;

void targetinterfaceSetter(pl_sock_interfaces targetinterface);

pl_sock_interfaces mcurrentinterface;
pl_sock_interfaces currentinterfaceGetter() const;

BUFF_SIZE_TYPE mtlstxfree;
BUFF_SIZE_TYPE tlstxfreeGetter() const;

BUFF_SIZE_TYPE mtlsrxlen;
BUFF_SIZE_TYPE tlsrxlenGetter() const;

unsigned char mtlscurrentnum;
unsigned char tlscurrentnumGetter() const;

};
}  // namespace sock
} /* namespace ntios */
#endif
