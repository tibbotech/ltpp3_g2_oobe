#ifndef __TIOS_COMM_H__
#define __TIOS_COMM_H__

#include "base/ntios_config.h"
#include "base/ntios_types.h"




extern U8 uart_redir[MAX_UARTS];

extern U8 ser_iosel;
extern U8 ser_iosel_port;
extern U16 uart_buff_addr_arr[MAX_UARTS * 2];
extern U16 uart_buff_addr_arr_bup[MAX_UARTS];
extern U16 ev2_ser_sent_level[MAX_UARTS]; // data level in the TX buffer below
                                          // which EV2_SER_SENT will be generated

/*
void comm_clear_ser_params(void);
U8 comm_get_num_ints(void);
U8 comm_get_num_uarts(void);
U8 comm_get_flags(U8 uart_num);
U8 comm_get_num_lines(void);
U8 comm_get_num_8bit_ports(void);
void comm_decide_rts(U8 uart_num);
U16 comm_get_def_brate(void);
void comm_serv_ichar_delay(void);
void tios_comm_serv_ichar_delay(void);
void comm_set_tx(U8 port_num,U8 tx_state);
void comm_set_rts(U8 uart_num,U8 pinval);
void comm_set_rts_or_x(U8 uart_num, tios_ser_param *ser_par_ptr, U8 pinval);
U8 comm_get_cts(U8 uart_num);
void comm_restart_ser_esc(U8 uart_num);


void comm_disable(U8 num);
*/
#endif