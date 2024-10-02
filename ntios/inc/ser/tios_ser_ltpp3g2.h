#ifndef __TIOS_SER_WM2000_H__
#define __TIOS_SER_WM2000_H__

/*
#define ESC_ICD_CONST 10 //minimum interchar delay for escape chars

#define SER0_UART_PORT HAL_UART_1
//#define SER0_COMM_FIFO_SIZE 128
#define SER0_COMM_FIFO_SIZE 512
#define SER0_COMM_FIFO_THRESHOLD 64
#define SER0_COMM_FIFO_ALERT_SIZE 32

#define SER1_UART_PORT HAL_UART_0
//#define SER1_COMM_FIFO_SIZE 128
#define SER1_COMM_FIFO_SIZE 512
#define SER1_COMM_FIFO_THRESHOLD 64
#define SER1_COMM_FIFO_ALERT_SIZE 32

//#define SER0_TX_GPIO_NUM 4
#define SER0_TX_GPIO_NUM 1

//#define SER0_CTS_GPIO_NUM 5
#define SER0_CTS_GPIO_NUM 2

//#define SER0_RX_GPIO_NUM 3
#define SER0_RX_GPIO_NUM 0

#define SER1_TX_GPIO_NUM 8
#define SER1_CTS_GPIO_NUM 3
#define SER1_RX_GPIO_NUM 7

*/
/*
void comm_uart_init(U16 brate,U8 uart_num);
void comm_uart_init2(U8 uart_num);
void rx_data_in(U8 uart_num);
*/
void comm_tx_push(U8 uart_num);
void tx_data_out(U8 uart_num);
/*
void comm_tmr0_init(void);
void comm_tmr0_disable(void);
U8 comm_get_rx(U8 port_num);
//void check_hd_dir_to_input(void);
void check_hd_dir_to_input(U8 uart_num);
*/

#endif 