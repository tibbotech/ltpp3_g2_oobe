#ifndef __TIOS_SER_OBJ_H__
#define __TIOS_SER_OBJ_H__

//#include "tios.h"
/*
void p2_sc_ser_num_get(void);
void p2_sc_ser_num_set(void);
void p2_sc_ser_enabled_s(void);
void p2_ser_enabled_g(void);
void p2_sc_ser_txbuffrq(void);
void p2_sc_ser_rxbuffrq(void);
void p2_sc_ser_div9600_get(void);
void p2_sc_baudrate_s(void);
void p2_sc_brate_g(void);
void p2_sc_parity_s(void);
void p2_sc_par_g(void);
void p2_sc_bits_s(void);
void p2_sc_bb_g(void);
void p2_sc_ser_getdata(void);
void p2_sc_ser_setdata(void);
void p2_sc_ser_send(void);
void p2_sc_ser_if_s(void);
void p2_sc_ser_if_g(void);
void p2_sc_ser_fc_s(void);
void p2_sc_ser_fc_g(void);
void p2_sc_ser_ctsmap_s(void);
void p2_sc_ser_ctsmap_g(void);
void p2_sc_ser_rtsmap_s(void);
void p2_sc_ser_rtsmap_g(void);
void p2_sc_ser_mode_s(void);
void p2_sc_ser_mode_g(void);
void p2_sc_ser_dircontrol_s(void);
void p2_sc_ser_dircontrol_g(void);
void p2_ser_xonchar_g(void);
void p2_ser_xonchar_s(void);
void p2_ser_xoffchar_g(void);
void p2_ser_xoffchar_s(void);
void p2_sc_ser_icdel_s(void);
void p2_sc_ser_icdel_g(void);
void p2_sc_ser_autoclose_g(void);
void p2_sc_ser_autoclose_s(void);
void p2_sc_ser_escchar_g(void);
void p2_sc_ser_escchar_s(void);
void p2_sc_ser_esctype_g(void);
void p2_sc_ser_esctype_s(void);
void p2_get_etype(U8 pnum);
void p2_set_etype(U8 pnum);
void p2_sc_ser_numofports_get(void);
void p2_sc_ser_rxbuffsize_g(void);
void p2_sc_ser_txbuffsize_g(void);
void p2_get_buffer_size(U8 rxtx,U8 pnum);
void p2_sc_ser_notifysent(void);
void p2_set_notify_sent(U8 pnum);
void p2_sc_ser_rxlen_g(void);
void p2_sc_ser_txlen_g(void);
void p2_get_len(U8 rxtx,U8 pnum);
void p2_sc_ser_newtxlen(void);
void p2_get_nlen(U8 pnum);
void p2_sc_ser_txfree_get(void);
void p2_get_free(U8 rxtx,U8 pnum);
void p2_sc_ser_txclear(void);
void p2_sc_ser_rxclear(void);
void p2_sc_ser_sinkdata_g(void);
void p2_sc_ser_sinkdata_s(void);
void p2_sc_ser_redir(void);
void p2_sc_ser_peekdata(void);
*/
extern U8 ser_num;

/*
extern U8 en_ev2_ser_data[MAX_UARTS];      //for EV2_SER_DATA event
extern U8 en_ev2_ser_sent[MAX_UARTS];      //for EV2_SER_SENT event
extern U8 en_ev2_ser_overrun[MAX_UARTS];   //for EV2_SER_OVERRUN event
extern U8 en_ev2_ser_esc[MAX_UARTS];       //for EV2_SER_ESC event
*/
void tios_check_uarts(void);
/*
void tios_check_serial_debug_data(void);

void p2_ser_gettxdata(void);
void p2_ser_setcommitrxdata(void);
*/

#endif