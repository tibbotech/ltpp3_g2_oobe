
/*Copyright 2021 Tibbo Technology Inc.*/

#ifndef BASE_NTIOS_TYPES_H_
#define BASE_NTIOS_TYPES_H_

#include <cstdint>
#include <string>

typedef std::uint8_t U8;
typedef std::uint16_t U16;
typedef std::uint32_t U32;
typedef std::uint64_t U64;

typedef std::int8_t S8;
typedef std::int16_t S16;
typedef std::int32_t S32;
typedef std::int64_t S64;

typedef std::uint32_t TIOS_ADDR;

typedef std::uint8_t byte;
typedef std::int16_t integer;
typedef std::uint16_t word;
typedef std::uint32_t dword;
typedef std::uint64_t qword;

typedef float real;
typedef bool boolean;

#define YES2 2

#define LED_OFF 1
#define LED_ON 0

#define BUFF_SIZE_TYPE std::uint16_t
#define BUFF_PAGE_TYPE std::uint16_t

#define TPP2WG2 25
#define TPP3WG2 26

#define WM2000 44
#define WS1101 45
#define WS1102 46
#define TPP3WG3 47

enum pl_wln_association_states {
  PL_WLN_NOT_ASSOCIATED,
  PL_WLN_ASSOCIATED,
  PL_WLN_OWN_NETWORK,
  PL_WLN_ASSOCIATION_INPROG
};

typedef enum : uint8_t { PL_OFF, PL_ON } off_on;

typedef enum : uint8_t { NO, YES } no_yes;

typedef enum : uint8_t { DISABLED, ENABLED } dis_en;

typedef enum : uint8_t { LOW, HIGH } low_high;

typedef enum : uint8_t {
  PL_INT_EDGE_NULL = 0,
  PL_INT_EDGE_LOW =  1,
  PL_INT_EDGE_HIGH = 2,
  PL_INT_EDGE_BOTH = 3
} pl_int_edge;

typedef enum : uint8_t { OK, NG } ok_ng;

typedef enum : uint8_t { WLN_OK, WLN_NG, WLN_REJ } wln_ok_ng_rej;

typedef enum : uint8_t { VALID, INVALID } valid_invalid;

typedef enum : uint8_t { ACCEPTED, REJECTED } accepted_rejected;

enum pl_wln_phy_modes {
  WIFI_PHY_11BG_MIXED,
  WIFI_PHY_11B,
  WIFI_PHY_11A,
  WIFI_PHY_11ABG_MIXED,
  WIFI_PHY_11G,
  WIFI_PHY_11ABGN_MIXED,
  WIFI_PHY_11N_2_4G,
  WIFI_PHY_11GN_MIXED,
  WIFI_PHY_11AN_MIXED,
  WIFI_PHY_11BGN_MIXED,
  WIFI_PHY_11AGN_MIXED,
  WIFI_PHY_11N_5G
};

enum pl_wln_bss_modes {
  PL_WLN_BSS_MODE_INFRASTRUCTURE,
  PL_WLN_BSS_MODE_ADHOC,
};

enum pl_wln_upgrade_regions {
  PL_WLN_UPGRADE_REGION_MAIN,
  PL_WLN_UPGRADE_REGION_MONITOR
};

enum pl_wln_wep_modes {
  PL_WLN_WEP_MODE_DISABLED,
  PL_WLN_WEP_MODE_64,
  PL_WLN_WEP_MODE_128
};

enum pl_wln_wpa_algorithms {
  PL_WLN_WPA_ALGORITHM_TKIP,
  PL_WLN_WPA_ALGORITHM_AES
};

enum pl_wln_wpa_unicast_multicast {
  PL_WLN_WPA_CAST_UNICAST,
  PL_WLN_WPA_CAST_MULTICAST
};

enum pl_wln_wpa_modes {
  PL_WLN_WPA_DISABLED,
  PL_WLN_WPA_WPA1_PSK,
  PL_WLN_WPA_WPA2_PSK,
};

enum pl_wln_peap_phase1 { PL_WLN_PEAP_PHASE2_0, PL_WLN_PEAP_PHASE2_1 };

enum pl_wln_peap_phase2 {
  PL_WLN_PEAP_PHASE2_MSCHAPV2,
  PL_WLN_PEAP_PHASE2_TLS,
  PL_WLN_PEAP_PHASE2_GTC,
  PL_WLN_PEAP_PHASE2_OTP,
  PL_WLN_PEAP_PHASE2_MD5
};

enum pl_wln_ttls_phase2 {
  PL_WLN_TTLS_PHASE2_EAP_MD5,
  PL_WLN_TTLS_PHASE2_EAP_GTC,
  PL_WLN_TTLS_PHASE2_EAP_OTP,
  PL_WLN_TTLS_PHASE2_EAP_MSCHAPV2,
  PL_WLN_TTLS_PHASE2_EAP_TLS,
  PL_WLN_TTLS_PHASE2_MSCHAPV2,
  PL_WLN_TTLS_PHASE2_MSCHAP,
  PL_WLN_TTLS_PHASE2_PAP,
  PL_WLN_TTLS_PHASE2_CHAP
};

enum pl_wln_domains {
  PL_WLN_DOMAIN_FCC,
  PL_WLN_DOMAIN_EU,
  PL_WLN_DOMAIN_JAPAN,
};

enum pl_wln_scan_filter {
  PL_WLN_SCAN_ALL,
  PL_WLN_ASCAN_INFRASTRUCTURE,
  PL_WLN_OWN_ADHOC,
};

enum pl_wln_events {
  PL_WLN_EVENT_DISABLED,
  PL_WLN_EVENT_DISASSOCIATED,
};

enum pl_wln_tasks {
  PL_WLN_TASK_IDLE,
  PL_WLN_TASK_SCAN,
  PL_WLN_TASK_ASSOCIATE,
  PL_WLN_TASK_SETTXPOWER,
  PL_WLN_TASK_SETWEP,
  PL_WLN_TASK_DISASSOCIATE,
  PL_WLN_TASK_NETWORK_START,
  PL_WLN_TASK_NETWORK_STOP,
  PL_WLN_TASK_SETWPA,
  PL_WLN_TASK_ACTIVESCAN,
  PL_WLN_TASK_UPDATERSSI,
  PL_WLN_TASK_SET_EAP_TLS,
  PL_WLN_TASK_SET_EAP_PEAP,
  PL_WLN_TASK_SET_EAP_TTLS,
};

enum pl_wln_module_types {
  PL_WLN_MODULE_TYPE_GA1000,
  PL_WLN_MODULE_TYPE_WA2000
};

enum pl_sock_interfaces {
  PL_SOCK_INTERFACE_NULL,
  PL_SOCK_INTERFACE_NET,
  PL_SOCK_INTERFACE_WLN,
  PL_SOCK_INTERFACE_PPP,
  PL_SOCK_INTERFACE_PPPOE,
};

enum pl_wln_bt_emulation_modes {
  PL_WLN_BT_EMULATION_MODE_TI,
  PL_WLN_BT_EMULATION_MODE_NORDIC,
  PL_WLN_BT_EMULATION_MODE_MICROCHIP
};

enum pl_bt_flowcontrol { PL_BT_FC_DISABLED, PL_BT_FC_ENABLED };

enum i2c_ack_nack {
  ACK = 0,
  NACK = 1,
};

enum i2c_state {
  I2C_IDLE = 0,
  I2C_STARTED = 1,
  I2C_STRETCHING_ERROR = 2,
  I2C_ARBITRATION_ERROR = 3
};

enum pl_sock_reconmode {
  PL_SOCK_RECONMODE_0,
  PL_SOCK_RECONMODE_1,
  PL_SOCK_RECONMODE_2,
  PL_SOCK_RECONMODE_3
};

enum pl_sock_protocol {
  PL_SOCK_PROTOCOL_UDP,
  PL_SOCK_PROTOCOL_TCP,
  PL_SOCK_PROTOCOL_RAW
};

enum pl_sock_state_simple {
  PL_SSTS_CLOSED,
  PL_SSTS_ARP,
  PL_SSTS_PO,
  PL_SSTS_AO,
  PL_SSTS_EST,
  PL_SSTS_PC,
  PL_SSTS_AC,
};

enum pl_sock_state {
  PL_SST_CL_PCLOSED,
  PL_SST_CL_ACLOSED,
  PL_SST_CL_PRESET_POPENING,
  PL_SST_CL_PRESET_AOPENING,
  PL_SST_CL_PRESET_EST,
  PL_SST_CL_PRESET_PCLOSING,
  PL_SST_CL_PRESET_ACLOSING,
  PL_SST_CL_PRESET_STRANGE,
  PL_SST_CL_ARESET_CMD,
  PL_SST_CL_ARESET_RE_PO,
  PL_SST_CL_ARESET_RE_AO,
  PL_SST_CL_ARESET_RE_EST,
  PL_SST_CL_ARESET_RE_PC,
  PL_SST_CL_ARESET_RE_AC,
  PL_SST_CL_ARESET_TOUT,
  PL_SST_CL_ARESET_DERR,
  PL_SST_CL_DISCARDED_CMD,
  PL_SST_CL_DISCARDED_PO_WCS,
  PL_SST_CL_DISCARDED_AO_WCS,
  PL_SST_CL_DISCARDED_ARPFL,
  PL_SST_CL_DISCARDED_TOUT,
  PL_SST_ARP = 0x20,
  PL_SST_PO = 0x40,
  PL_SST_AO = 0x60,
  PL_SST_EST = 0x80,
  PL_SST_EST_POPENED = 0x80,
  PL_SST_EST_AOPENED,
  PL_SST_PC = 0xA0,
  PL_SST_AC = 0xC0
};

enum pl_tls_result {
  PL_TLS_SUCCESS,
  PL_TLS_REJECTED,
  PL_TLS_ERROR_IN_USE,
  PL_TLS_ERROR_CERT,
  PL_TLS_ERROR_NO_BUFF,
  PL_TLS_ERROR_INTERNAL
};

enum pl_redir {

  PL_REDIR_NONE = 0,  // INTER-OBJECT CONSTANT. Cancels redirection for the
                      // serial port or socket.
  PL_REDIR_SER,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial port
                 // or socket to the TX buffer of the serial port 0.
  PL_REDIR_SER0 = 1,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                      // port or socket to the TX buffer of the serial port 0.
  PL_REDIR_SER1,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial port
                  // or socket to the TX buffer of the serial port 1.
  PL_REDIR_SER2,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial port
                  // or socket to the TX buffer of the serial port 2.
  PL_REDIR_SER3,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial port
                  // or socket to the TX buffer of the serial port 3.
  PL_REDIR_SOCK0,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 0.
  PL_REDIR_SOCK1,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 1.
  PL_REDIR_SOCK2,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 2.
  PL_REDIR_SOCK3,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 3.
  PL_REDIR_SOCK4,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 4.
  PL_REDIR_SOCK5,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 5.
  PL_REDIR_SOCK6,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 6.
  PL_REDIR_SOCK7,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 7.
  PL_REDIR_SOCK8,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 8.
  PL_REDIR_SOCK9,   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 9.
  PL_REDIR_SOCK10,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 10.
  PL_REDIR_SOCK11,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 11.
  PL_REDIR_SOCK12,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 12.
  PL_REDIR_SOCK13,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 13.
  PL_REDIR_SOCK14,  // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 14.
  PL_REDIR_SOCK15   // INTER-OBJECT CONSTANT. Redirects RX data of the serial
                    // port or socket to the TX buffer of socket 15.
};

enum pl_http_rq_type {
  PL_SOCK_HTTP_RQ_GET,
  PL_SOCK_HTTP_RQ_POST,
};

enum pl_sock_inconmode {
  PL_SOCK_INCONMODE_NONE,
  PL_SOCK_INCONMODE_SPECIFIC_IPPORT,
  PL_SOCK_INCONMODE_SPECIFIC_IP_ANY_PORT,
  PL_SOCK_INCONMODE_ANY_IP_ANY_PORT,
};

typedef enum {
  PL_NET_LINKSTAT_NOLINK,
  PL_NET_LINKSTAT_10BASET,
  PL_NET_LINKSTAT_100BASET,
} pl_net_linkstate;

typedef enum {
  PL_SYS_SPEED_LOW,
  PL_SYS_SPEED_MEDIUM,
  PL_SYS_SPEED_FULL
} pl_sys_speed_choices;

using std::string;

#define PACKED __attribute__((packed))

#endif  // BASE_NTIOS_TYPES_H_
