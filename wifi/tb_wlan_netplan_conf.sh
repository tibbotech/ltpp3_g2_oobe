#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#   INPUT ARGS
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#To run this script in interactive-mode, do not provide any input arguments
wlanSelectIntf=${1}             #optional
pattern_wlan=${2}               #optional
yaml_fpath=${3}                 #optional
ssid_input=${4}                 #optional
ssidPwd_input=${5}              #optional
ssid_isHidden=${6}              #optional
ipv4_addrNetmask_input=${7}     #optional
ipv4_gateway_input=${8}         #optional
ipv6_addrNetmask_input=${9}     #optional
ipv6_gateway_input=${10}        #optional
dns_input=${11}}                #optional



#---VARIABLES FOR 'input_args_handler__sub'
argsTotal=$#
arg1=${wlanSelectIntf}



#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="1.0.0"




#---TRAP ON EXIT
# trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT




#---COLORS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFLIGHTRED=$'\e[30;38;5;131m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_DARKBLUE=$'\e[30;38;5;33m'
FG_SOFTDARKBLUE=$'\e[30;38;5;38m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_SOFTLIGHTBLUE=$'\e[30;38;5;80m'
FG_GREEN=$'\e[30;38;5;76m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
FG_LIGHTPINK=$'\e[30;38;5;224m'
TIBBO_FG_WHITE=$'\e[30;38;5;15m'

TIBBO_BG_ORANGE=$'\e[30;48;5;209m'



#---CONSTANTS
TITLE="TIBBO"

EMPTYSTRING=""

ASTERISK_CHAR="*"
CARROT_CHAR="^"
COMMA_CHAR=","
DOLLAR_CHAR="$"
DOT_CHAR="."
ENTER_CHAR=$'\x0a'
QUESTION_CHAR="?"
QUOTE_CHAR="\""
TAB_CHAR=$'\t'

ONE_SPACE=" "
TWO_SPACES="  "
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

ZERO=0
ONE=1

TRUE=1
FALSE=0

EXITCODE_0=0
EXITCODE_99=99

INPUT_ALL="a"
INPUT_BACK="b"
INPUT_DHCP="d"
INPUT_SKIP="s"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_YES="y"
INPUT_NO="n"

SLEEP_TIMEOUT=1

RETRY_MAX=3
ARGSTOTAL_MAX=11

NUMOF_ROWS_0=0
NUMOF_ROWS_1=1
NUMOF_ROWS_2=2
NUMOF_ROWS_3=3
NUMOF_ROWS_4=4
NUMOF_ROWS_5=5
NUMOF_ROWS_6=6
NUMOF_ROWS_7=7

PREPEND_EMPTYLINES_0=0
PREPEND_EMPTYLINES_1=1

IEEE_80211="IEEE 802.11"
IW="iw"
# IWCONFIG="iwconfig"
SCAN_SSID_IS_1="scan_ssid=1"

STATUS_UP="UP"
STATUS_DOWN="DOWN"
TOGGLE_UP="up"
TOGGLE_DOWN="down"

PATTERN_INTERFACE="Interface"
PATTERN_PASSWORD="password:"
PATTERN_SSID="ssid"
PATTERN_PSK="#psk="
PATTERN_WIFIS="wifis"
# PATTERN_WLAN="wlan"
# PATTERN_FOUR_SPACES_WLAN="^${ONE_SPACE}{4}${PATTERN_WLAN}"
# PATTERN_ANY_STRING_W_LEADING_FOUR_SPACES="^${ONE_SPACE}{4}[a-z]"

PRINTF_ADDING="${FG_GREEN}ADDING:${NOCOLOR}:"
PRINTF_APPLYING="APPLYING"
PRINTF_COMPLETED="COMPLETED:"
PRINTF_CREATING="CREATING:"
PRINTF_DELETING="${FG_LIGHTRED}DELETING:${NOCOLOR}:"
PRINTF_INFO="INFO:"
PRINTF_INPUT="INPUT:"
PRINTF_QUESTION="QUESTION:"
PRINTF_READING="READING:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_SUMMARY="SUMMARY:"
PRINTF_TOGGLE="TOGGLE:"
PRINTF_WARNING="${FG_PURPLERED}WARNING${NOCOLOR}:"
# PRINTF_UPDATE="UPDATE:"
# PRINTF_WRITING="WRITING:"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
ERRMSG_UNABLE_TO_APPLY_NETPLAN="UNABLE TO APPLY NETPLAN"
ERRMSG_WPA_SUPPLICANT_SERVICE_NOT_PRESENT="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"

ERRMSG_INVALID_IPV4_ADDR_FORMAT="(${FG_LIGHTRED}Invalid IPv4 Address Format${NOCOLOR})"
ERRMSG_INVALID_IPV4_NETMASK_FORMAT="(${FG_LIGHTRED}Invalid IPv4 Netmask Value${NOCOLOR})"
ERRMSG_INVALID_IPV4_GATEWAY_FORMAT="(${FG_LIGHTRED}Invalid IPv4 Gateway Format${NOCOLOR})"
ERRMSG_INVALID_IPV4_GATEWAY_DUPLICATE="(${FG_LIGHTRED}Duplicate IPv4 Address${NOCOLOR})"
ERRMSG_INVALID_IPV6_ADDR_FORMAT="(${FG_LIGHTRED}Invalid IPv6 Address Format${NOCOLOR})"
ERRMSG_INVALID_IPV6_NETMASK_FORMAT="(${FG_LIGHTRED}Invalid IPv6 Netmask Value${NOCOLOR})"
ERRMSG_INVALID_IPV6_GATEWAY_FORMAT="(${FG_LIGHTRED}Invalid IPv6 Gateway Format${NOCOLOR})"
ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE="(${FG_LIGHTRED}Duplicate IPv6 Address${NOCOLOR})"
ERRMSG_IPV46_INPUT_VALUES_ARE_EMPTY_STRINGS="ALL IPV4 AND IPV6 INPUT VALUES ARE EMPTY STRINGS"

PRINTF_APPLYING_NETPLAN_START="APPLYING NETPLAN"
PRINTF_APPLYING_NETPLAN_SUCCESSFULLY="APPLYING NETPLAN ${FG_GREEN}SUCCESSFULLY${NOCOLOR}"
PRINTF_EXITING_NOW="EXITING NOW..."
PRINTF_FILE="FILE:"
PRINTF_IF_PRESENT_DATA_WILL_BE_LOST="IF PRESENT, DATA WILL BE LOST!"
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

PRINTF_WIFI_YOUR_IPV4_INPUT="YOUR IPV4 INPUT"
PRINTF_WIFI_YOUR_IPV6_INPUT="YOUR IPV6 INPUT"
PRINTF_IPV4_ADDRESS="${FG_LIGHTBLUE}IPV4-ADDRESS${NOCOLOR}: "
PRINTF_IPV4_NETMASK="${FG_SOFTLIGHTBLUE}IPV4-NETMASK${NOCOLOR}: "
PRINTF_IPV4_GATEWAY="${FG_LIGHTBLUE}IPV4-GATEWAY${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV4_DNS="${FG_LIGHTBLUE}IPV4-DNS${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV6_ADDRESS="${FG_LIGHTBLUE}IPV6-ADDRESS${NOCOLOR}: "
PRINTF_IPV6_NETMASK="${FG_SOFTLIGHTBLUE}IPV6-NETMASK${NOCOLOR}: "
PRINTF_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV6_DNS="${FG_LIGHTBLUE}IPV6-DNS${NOCOLOR}${NOCOLOR}: "

PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO="STATIC IPV4 NETWORK INFO"
PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO="STATIC IPV6 NETWORK INFO"
PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_LIGHTRED}INACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_GREEN}RUNNING${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_NOT_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_LIGHTRED}NOT${NOCOLOR} RUNNING"

QUESTION_ACCEPT_INPUT_VALUES_OR_REDO_INPUT="ACCEPT INPUT VALUES (${FG_YELLOW}y${NOCOLOR}es), or REDO INPUT (${FG_YELLOW}a${NOCOLOR}ll/ipv${FG_YELLOW}4${NOCOLOR}/ipv${FG_YELLOW}6${NOCOLOR})"
QUESTION_ENABLE_DHCP_INSTEAD_OR_REDO_INPUT="ENABLE ${FG_PURPLERED}DHCP${NOCOLOR} INSTEAD (${FG_YELLOW}y${NOCOLOR}es), or REDO INPUT (${FG_YELLOW}a${NOCOLOR}ll/ipv${FG_YELLOW}4${NOCOLOR}/ipv${FG_YELLOW}6${NOCOLOR})"
QUESTION_ADD_REPLACE_WIFI_ENTRIES="ADD/REPLACE WIFI ENTRIES (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)"
QUESTION_ENABLE_DHCP="ENABLE ${FG_PURPLERED}DHCP${NOCOLOR} (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"

READ_IPV4_ADDRESS="${FG_LIGHTBLUE}IPV4-ADDRESS${NOCOLOR} (ex: 19.45.7.10) (${FG_YELLOW}s${NOCOLOR}kip): "
READ_IPV4_NETMASK="${FG_SOFTLIGHTBLUE}IPV4-NETMASK (0 ~ 32)${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV4_GATEWAY="${FG_LIGHTBLUE}IPV4-GATEWAY${NOCOLOR} (ex: 19.45.7.254) (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV4_DNS="${FG_LIGHTBLUE}IPV4-DNS (ex: 8.8.4.4,8.8.8.8)${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV6_ADDRESS="${FG_LIGHTBLUE}IPV6-ADDRESS${NOCOLOR} (ex: 2001:19:46:10::12) (${FG_YELLOW}s${NOCOLOR}kip): "
READ_IPV6_NETMASK="${FG_SOFTLIGHTBLUE}IPV6-NETMASK (0 ~ 128)${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR} (ex: 2001:19:46:10::254) (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV6_DNS="${FG_LIGHTBLUE}IPV6-DNS${NOCOLOR} (ex: 8:8:4::8,8:8:8::8) (${FG_YELLOW}b${NOCOLOR}ack): "


#---VARIABLES
wifi_define_dynamic_variables__sub()
{
    pattern_four_spaces_wlan="^${ONE_SPACE}{4}${pattern_wlan}"
    pattern_four_spaces_anyString="^${ONE_SPACE}{4}[a-z]"

    errmsg_occured_in_file_wlan_intf_updown="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_intf_updown_filename}${NOCOLOR}"
    errMsg_wpa_supplicant_file_not_found="FILE NOT FOUND: ${FG_LIGHTGREY}${wpaSupplicant_fpath}${NOCOLOR}"

    printf_yaml_adding_dhcpEntries="ADDING DHCP ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
    printf_yaml_adding_staticIpEntries="ADDING STATIC IP ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
    printf_yaml_deleting_wifi_entries="DELETING WiFi ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"

    printf_no_entries_found_for="NO ENTRIES FOUND FOR: ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR}"

    printf_no_changes_were_made_to_yaml="NO CHANGES WERE MADE TO ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"

    printf_successfully_set_wlan_to_up="${FG_GREEN}SUCCESSFULLY${NOCOLOR} SET ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} TO ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

    printf_wifi_entries_found="WiFi ENTRIES FOUND IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}" 
    printf_wifi_entries_not_found="WiFi ENTRIES *NOT* FOUND IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}" 

    printf_wifi_intf_is_down="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} IS ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    printf_wifi_intf_is_up="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} IS ${FG_GREEN}${STATUS_UP}${NOCOLOR}"


    printf_yaml_file_not_found="FILE NOT FOUND: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
}



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

    wpaSupplicant_filename="wpa_supplicant.conf"
    wpaSupplicant_fpath=/etc/${wpaSupplicant_filename}

    if [[ -z ${yaml_fpath} ]]; then #no input provided
        yaml_fpath="/etc/netplan/*.yaml"    #use the default full-path
    fi
}



#---FUNCTIONS
clear_lines__func() 
{
    #Input args
    local rMax=${1}

    #Clear line(s)
    if [[ ${rMax} -eq ${NUMOF_ROWS_0} ]]; then  #clear current line
        tput el1
    else    #clear specified number of line(s)
        tput el1

        for ((r=0; r<${rMax}; r++))
        do  
            tput cuu1
            tput el
        done
    fi
}
function lastLine_isNewLine()
{
    #Input args
    local fpath=${1}

    #Define local variables
    local isNewLine=${EMPTYSTRING}

    #Check if the last line of the 'fpath' contains a 'new line (\n)'
    isNewLine=`tail -c 1 ${fpath}`
    if [[ "${isNewLine}" == ${EMPTYSTRING} ]]; then
        echo ${TRUE}
    else
        echo ${FALSE}
    fi
}
function combine_two_strings_separated_by_char__func
{
    #Input args
    local strA=${1}
    local strB=${2}
    local charSeparator=${3}

    #Define local variables
    local strCombo=${EMPTYSTRING}

    #Check if 'strA' and 'strB' are EMPTY STRINGS
    #If TRUE, then exit function
    if [[ -z ${strA} ]] && [[ -z ${strB} ]]; then
        return
    fi

    #Compose 'strCombo' by combining 'strA' and 'strB'
    if [[ ! -z ${strA} ]]; then #'strA' is NOT an EMPTY STRING
        strCombo=${strA}
    fi
    if [[ ! -z ${strB} ]]; then #'strA' is NOT an EMPTY STRING
        if [[ -z ${strCombo} ]]; then   #'strCombo' is an EMPTY STRING
            strCombo=${strB}
        else    #'strCombo' is NOT an EMPTY STRING
            strCombo="${strA}${charSeparator}${strB}"
        fi
    fi

    #Output
    echo ${strCombo}
}

debugPrint__func()
{
    #Input args
    local topic=${1}
    local msg=${2}
    local numOfEmptyLines=${3}

    #Print
    if [[ ${numOfEmptyLines} -gt 0 ]]; then
        for ((n=0;n<${numOfEmptyLines};n++))
        do
            printf '%s%b\n' ""
        done
    fi
    printf '%s%b\n' "${FG_ORANGE}${topic} ${NOCOLOR}${msg}"
}

successPrint__func()
{
    #Input args
    local successMsg=${1}

    #Print
    printf '%s%b\n' "${FG_GREEN}SUCCESSFULLY${NOCOLOR}: ${successMsg}"
}

errExit__func() 
{
    #Input args
    local add_leading_emptyLine=${1}
    local errCode=${2}
    local errMsg=${3}
    local show_exitingNow=${4}

    #Print
    if [[ ${add_leading_emptyLine} == ${TRUE} ]]; then
        printf '%s%b\n' ""
    fi

    printf '%s%b\n' "***${FG_LIGHTRED}ERROR${NOCOLOR}(${errCode}): ${errMsg}"
    if [[ ${show_exitingNow} == ${TRUE} ]]; then
        printf '%s%b\n' "${FG_ORANGE}EXITING:${NOCOLOR} ${thisScript_filename}"
        printf '%s%b\n' ""
        
        exit ${EXITCODE_99}
    fi
}
errTrap__sub()
{
    if [[ ${trapDebugPrint_isEnabled} == ${TRUE} ]]; then
        #Input args
        #The input args are retrieved from the trap which is set with the command (see top of script)
        #   trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
        bash_lineNum=${1}
        bash_command=${2}

        #PRINT
        printf '%s%b\n' ""
        printf '%s%b\n' ""
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: START"
        printf '%s%b\n' ""
        printf '%s%b\n' "BASH COMMAND: ${FG_LIGHTGREY}${bash_command}${NOCOLOR}"
        printf '%s%b\n' "LINE-NUMBER: ${FG_LIGHTGREY}${bash_lineNum}${NOCOLOR}"
        printf '%s%b\n' ""
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: END"
        printf '%s%b\n' ""
        printf '%s%b\n' ""
    fi
}

goodExit__func()
{
    #Input args
    local exitMsg=${1}

    printf '%s%b\n' ""
    printf '%s%b\n' "${FG_ORANGE}${PRINTF_INFO}${NOCOLOR} ${exitMsg}"
    printf '%s%b\n' "${FG_ORANGE}${PRINTF_INFO}${NOCOLOR} ${PRINTF_EXITING_NOW}"
    printf '%s%b\n' ""
    
    exit ${EXITCODE_0}
}

function CTRL_C_func() {
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_CTRL_C_WAS_PRESSED}" "${TRUE}"
}



#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

wifi_init_variables__sub()
{
    allowedToChange_netplan=${TRUE}
    dhcp_isSelected=${TRUE}
    exitCode=0
    ipv4_address=${EMPTYSTRING}
    ipv4_netmask=${EMPTYSTRING}
    ipv4_gateway=${EMPTYSTRING}
    ipv4_dns=${EMPTYSTRING}
    ipv4_address_isValid=${FALSE}
    ipv4_netmask_isValid=${FALSE}
    ipv4_gateway_isValid=${FALSE}
    ipv4_dns_isValid=${EMPTYSTRING}

    ipv6_address=${EMPTYSTRING}
    ipv6_netmask=${EMPTYSTRING}
    ipv6_gateway=${EMPTYSTRING}
    ipv6_dns=${EMPTYSTRING}
    ipv6_address_isValid=${FALSE}
    ipv6_netmask_isValid=${FALSE}
    ipv6_gateway_isValid=${FALSE}
    ipv6_dns_isValid=${EMPTYSTRING}    

    ipv4_address_accept=${EMPTYSTRING}
    ipv4_netmask_accept=${EMPTYSTRING}
    ipv4_gateway_accept=${EMPTYSTRING}
    ipv4_dns_accept=${EMPTYSTRING}
    ipv6_address_accept=${EMPTYSTRING}
    ipv6_netmask_accept=${EMPTYSTRING}
    ipv6_gateway_accept=${EMPTYSTRING}
    ipv6_dns_accept=${EMPTYSTRING}

    myChoice=${EMPTYSTRING}
    retry_param=0
    ssid=${EMPTYSTRING}
    ssidPasswd=${EMPTYSTRING}
    ssidScan_isFound=${FALSE}
    trapDebugPrint_isEnabled=${TRUE}
    wlanX_toBeDeleted_targetLineNum=0
    wlanX_toBeDeleted_numOfLines=0
    wlan_isPresent=${FALSE}
    wlan_isUP=${FALSE}

}

input_args_handler__sub()
{
    case "${arg1}" in
        --help | -h | ${QUESTION_CHAR})
            input_args_print_usage__sub
            
            exit 0
            ;;

        --version | -v)
            input_args_print_version__sub

            exit 0
            ;;
        
        *)
            if [[ ${argsTotal} -eq 1 ]]; then
                input_args_print_unknown_option__sub

                exit 0
            elif [[ ${argsTotal} -gt 3 ]]; then
                if [[ ${argsTotal} -ne ${ARGSTOTAL_MAX} ]]; then
                    input_args_print_incomplete_args__sub

                    exit 0
                fi
            fi
            ;;
    esac
}


input_args_print_unknown_option__sub()
{
    local versionMsg=(
        "${FOUR_SPACES}${FG_LIGHTRED}***ERROR:${NOCOLOR} unknown option: '${arg1}'"
        ""
        "${FOUR_SPACES}For more information, please run '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
    )

    printf "%s\n" ""
    printf "%s\n" "${versionMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}

input_args_print_incomplete_args__sub()
{
    local versionMsg=(
        "${FOUR_SPACES}${FG_LIGHTRED}***ERROR:${NOCOLOR} not enough input arguments (${argsTotal} out-of ${ARGSTOTAL_MAX})."
        ""
        "${FOUR_SPACES}For more information, please run '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
    )

    printf "%s\n" ""
    printf "%s\n" "${versionMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}

input_args_print_usage__sub()
{
    local usageMsg=(
        "${FG_ORANGE}Utility to setup WiFi-interface and establish connection${NOCOLOR}."
        ""
        "Usage #1: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR}"
        ""
        "${FOUR_SPACES}Runs this tool in interactive-mode."
        ""
        ""
        "Usage #2: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} [${FG_LIGHTGREY}options${NOCOLOR}]"
        ""
        "${FOUR_SPACES}--help, -h${TAB_CHAR}${TAB_CHAR}Print help."
        "${FOUR_SPACES}--version, -v${TAB_CHAR}Print version."
        ""
        ""
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\" \"${FG_LIGHTGREY}arg3${NOCOLOR}\" \"${FG_LIGHTGREY}arg4${NOCOLOR}\" \"${FG_LIGHTGREY}arg5${NOCOLOR}\" \"${FG_LIGHTGREY}arg6${NOCOLOR}\" \"${FG_LIGHTPINK}arg7${NOCOLOR}\" \"${FG_LIGHTGREY}arg8${NOCOLOR}\" \"${FG_LIGHTPINK}arg9${NOCOLOR}\" \"${FG_LIGHTGREY}arg10${NOCOLOR}\" \"${FG_LIGHTPINK}arg11${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}WiFi-interface (e.g. wlan0)."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}WiFi-interface search pattern (e.g. wlan)"
        "${FOUR_SPACES}arg3${TAB_CHAR}${TAB_CHAR}Path-to Netplan configuration file (e.g. /etc/netplan/*.yaml)."
        "${FOUR_SPACES}arg4${TAB_CHAR}${TAB_CHAR}SSID to connect onto."
        "${FOUR_SPACES}arg5${TAB_CHAR}${TAB_CHAR}SSID password."
        "${FOUR_SPACES}arg6${TAB_CHAR}${TAB_CHAR}Bool {${FG_LIGHTGREEN}true${FG_LIGHTGREY}|${FG_SOFLIGHTRED}false${NOCOLOR}}."
        "${FOUR_SPACES}arg7${TAB_CHAR}${TAB_CHAR}IPv4 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}192.168.1.10${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}24${NOCOLOR})."
        "${FOUR_SPACES}arg8${TAB_CHAR}${TAB_CHAR}IPv4 gateway (e.g. 192.168.1.254)."
        "${FOUR_SPACES}arg9${TAB_CHAR}${TAB_CHAR}IPv6 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}2001:beef::15:5${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}64${NOCOLOR})."
        "${FOUR_SPACES}arg10${TAB_CHAR}${TAB_CHAR}IPv4 gateway (e.g. 2001:beef::15:900d)."
        "${FOUR_SPACES}arg11${TAB_CHAR}${TAB_CHAR}Name servers (e.g. 8.8.8.8${FG_SOFLIGHTRED},${NOCOLOR}2001:4860:4860::8888)."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}${FOUR_SPACES}- Do NOT forget to surround each argument with ${FG_LIGHTGREY}\"${NOCOLOR}double quotes${FG_LIGHTGREY}\"${NOCOLOR}."
        "${FOUR_SPACES}${FOUR_SPACES}- Some arguments (${FG_LIGHTPINK}arg7${NOCOLOR},${FG_LIGHTPINK}arg9${NOCOLOR},${FG_LIGHTPINK}arg11${NOCOLOR}) allow multiple input values separated by a comma-separator (${FG_SOFLIGHTRED},${NOCOLOR})."
    )

    printf "%s\n" ""
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}

input_args_print_version__sub()
{
    local versionMsg=(
        "${FOUR_SPACES}${scriptName} version: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
    )

    printf "%s\n" ""
    printf "%s\n" "${versionMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}

wifi_get_wifi_pattern__func()
{
    #Only execute this function if 'pattern_wlan' is an Empty String
    if [[ ! -z ${pattern_wlan} ]]; then
        return
    fi

    #Define local variables
    local arrNum=0
    local pattern_wlan_string=${EMPTYSTRING}
    local pattern_wlan_array=()
    local pattern_wlan_arrayLen=0
    local pattern_wlan_arrayItem=${EMPTYSTRING}
    local seqNum=0

    #Get all wifi interfaces
    #EXPLANATION:
    #   grep "${IEEE_80211}": find a match for 'IEEE 802.11'
    #   grep "${PATTERN_INTERFACE}": find a match for 'Interface
    #   awk '{print $1}': get the first column
    #   sed 's/[0-9]*//g': exclude all numeric values from string
    #   xargs -n 1: convert string to array
    #   sort -u: get unique values
    #   xargs: convert back to string
    pattern_wlan_string=`{ ${IW} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | sed 's/[0-9]*//g' | xargs -n 1 | sort -u | xargs; } 2> /dev/null`
    # pattern_wlan_string=`{ ${IWCONFIG} | grep "${IEEE_80211}" | awk '{print $1}' | sed 's/[0-9]*//g' | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

    #Convert from String to Array
    eval "pattern_wlan_array=(${pattern_wlan_string})"

    #Get Array Length
    pattern_wlan_arrayLen=${#pattern_wlan_array[*]}

    #Select wlan-pattern
    if [[ ${pattern_wlan_arrayLen} -eq 1 ]]; then
         pattern_wlan=${pattern_wlan_array[0]}
    else
        #Show available WLAN interface
        printf '%s%b\n' ""
        printf '%s%b\n' "${FG_ORANGE}AVAILABLE WLAN PATTERNS:${NOCOLOR}"
        for pattern_wlan_arrayItem in "${pattern_wlan_array[@]}"; do
            seqNum=$((seqNum+1))    #increment sequence number

            printf '%b\n' "${EIGHT_SPACES}${seqNum}. ${pattern_wlan_arrayItem}"   #print
        done

        #Print empty line
        printf '%s%b\n' ""
        
         #Save cursor position
        tput sc

        #Choose WLAN interface
        while true
        do
            read -N1 -p "${FG_LIGHTBLUE}Your choice${NOCOLOR}: " myChoice

            if [[ ${myChoice} =~ [1-9,0] ]]; then
                if [[ ${myChoice} -ne ${ZERO} ]] && [[ ${myChoice} -le ${seqNum} ]]; then
                    arrNum=$((myChoice-1))   #get array-number based on the selected sequence-number

                    pattern_wlan=${pattern_wlan_array[arrNum]}  #get array-item

                    printf '%s%b\n' ""  #print an empty line

                    break
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            else
                if [[ ${myChoice} == ${ENTER_CHAR} ]]; then
                    clear_lines__func ${NUMOF_ROWS_1}
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            fi
        done
    fi
}

wifi_wlan_select__func()
{
    #Only execute this function if 'wlanSelectIntf' is an Empty String
    if [[ ! -z ${wlanSelectIntf} ]]; then
        return
    fi

    #Define local variables
    local seqNum=0
    local arrNum=0
    local wlanList_string=${EMPTYSTRING}
    local wlanList_array=()
    local wlanList_arrayLen=0
    local wlanItem=${EMPTYSTRING}

    #Get ALL available WLAN interface
    wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1`

    #Check if 'wlanList_string' contains any data
    #If no data, then exit...
    if [[ -z $wlanList_string ]]; then  
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTERFACE_FOUND}" "${TRUE}"       
    fi


    #Convert string to array
    eval "wlanList_array=(${wlanList_string})"   

    #Get Array Length
    wlanList_arrayLen=${#wlanList_array[*]}

    #Select WLAN interface
    if [[ ${wlanList_arrayLen} -eq 1 ]]; then
         wlanSelectIntf=${wlanList_array[0]}
    else
        #Show available WLAN interface
        printf '%s%b\n' ""
        printf '%s%b\n' "${FG_ORANGE}AVAILABLE WiFi INTEFACES:${NOCOLOR}"
        for wlanItem in "${wlanList_array[@]}"; do
            seqNum=$((seqNum+1))    #increment sequence number

            printf '%b\n' "${EIGHT_SPACES}${seqNum}. ${wlanItem}"   #print
        done

        #Print empty line
        printf '%s%b\n' ""
        
         #Save cursor position
        tput sc

        #Choose WLAN interface
        while true
        do
            read -N1 -p "${FG_LIGHTBLUE}Your choice${NOCOLOR}: " myChoice

            if [[ ${myChoice} =~ [1-9,0] ]]; then
                if [[ ${myChoice} -ne ${ZERO} ]] && [[ ${myChoice} -le ${seqNum} ]]; then
                    arrNum=$((myChoice-1))   #get array-number based on the selected sequence-number

                    wlanSelectIntf=${wlanList_array[arrNum]}  #get array-item

                    printf '%s%b\n' ""  #print an empty line

                    break
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            else
                if [[ ${myChoice} == ${ENTER_CHAR} ]]; then
                    clear_lines__func ${NUMOF_ROWS_1}
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            fi
        done
    fi
}

wifi_toggle_intf__func()
{
    #Input arg
    local set_wifi_intf_to=${1}

    #Run script 'tb_wlan_stateconf.sh'
    #IMPORTANT: set interface to 'UP'
    #REMARK: this is required for the 'iwlist' scan to get the SSID-list
    ${wlan_intf_updown_fpath} "${wlanSelectIntf}" "${set_wifi_intf_to}" "${pattern_wlan}" "${yaml_fpath}"
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_occured_in_file_wlan_intf_updown}" "${TRUE}"
    fi  
}

wifi_netplan_print_retrieve_main__func()
{
    #Define local variables
    local doNot_read_yaml=${FALSE}
    local stdOutput=${EMPTYSTRING}

    #Initialization
    wlanX_toBeDeleted_targetLineNum=0   #reset parameter
    wlanX_toBeDeleted_numOfLines=0    #reset parameter

    #Check if file '*.yaml' is present
    if [[ ! -f ${yaml_fpath} ]]; then
        debugPrint__func "${PRINTF_INFO}" "${printf_yaml_file_not_found}" "${PREPEND_EMPTYLINES_1}" #print

        return  #exit function
    fi

    #Check if 'line' contains the string 'wlanSelectIntf' (e.g. wlan0)
    stdOutput=`cat ${yaml_fpath} | grep "${wlanSelectIntf}" 2>&1`
    if [[ -z ${stdOutput} ]]; then  #contains NO data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_not_found}" "${PREPEND_EMPTYLINES_1}" #print

        wlanX_toBeDeleted_targetLineNum=0   #reset parameter
        wlanX_toBeDeleted_numOfLines=0    #reset parameter

        #Set boolean to TRUE
        #REMARK: this means SKIP READING of file '*.yaml'
        doNot_read_yaml=${TRUE}
    else    #contains data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_found}" "${PREPEND_EMPTYLINES_1}" #print
    fi

    #REMARK: if TRUE, then skip
    if [[ ${doNot_read_yaml} == ${FALSE} ]]; then
        wifi_netplan_print_retrieve_toBeDeleted_lines__func
    fi

    #Check if there are any lines to be deleted.
    #If NONE, then exit function.
    if [[ ${wlanX_toBeDeleted_numOfLines} -eq 0 ]]; then
        return
    fi

    wifi_netplan_question_add_replace_wifi_entries__func
}
wifi_netplan_print_retrieve_toBeDeleted_lines__func()
{
    #Define local variables
    local line=${EMPTYSTRING}
    local lineNum=1
    local stdOutput=${EMPTYSTRING}

    #Initialize variables
    wlanX_toBeDeleted_targetLineNum=0
    wlanX_toBeDeleted_numOfLines=0

    #Read each line of '*.yaml'
    #IMPORTANT ADDITION:
    #With the addition of '|| [ -n "$line" ]', the lines which does NOT END...
    #...with a 'new line (\n)' will also be read
    IFS=""  #use this command to KEEP LEADING SPACES (IMPORTANT)
    while read -r line || [ -n "$line" ]
    do
        # Check if 'line' contains the string 'wifis'
        # stdOutput=`echo ${line} | grep "${PATTERN_WIFIS}"`
        # if [[ ! -z ${stdOutput} ]]; then  #'wifis' string is found
        #     debugPrint__func "${PRINTF_READING}" "${line}" "${PREPEND_EMPTYLINES_0}" #print
        # fi

        #Check if 'line' contains the string 'wlawlanSelectIntfnx' (e.g. wlan0)
        stdOutput=`echo ${line} | grep "${wlanSelectIntf}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then  #'wlanx' is found (with x=0,1,2,...)
            debugPrint__func "${PRINTF_READING}" "${line}" "${PREPEND_EMPTYLINES_0}" #print

            wlanX_toBeDeleted_targetLineNum=${lineNum}    #update value (which will be used later on to delete these entries)

            wlanX_toBeDeleted_numOfLines=$((wlanX_toBeDeleted_numOfLines+1))    #increment parameter
        else
            #This condition ONLY APPLIES once a match for 'wlanSelectIntf' is found.
            #In other words: 'wlanX_toBeDeleted_targetLineNum > 0'
            #Keep on READING the lines TILL 
            #1. 'any string with exactly 4 leading spaces' is found.
            #Why exactly 4 leading spaces?
            #Because according to 'netplan' notation convention, all interface names starts with 4 leading spaces
            #For example:
            #<2 SPACES>  ethernets:
            #<4 SPACES>    eth0:
            #<2 SPACES>  wifis:
            #<4 SPACES>    wlan0:
            #2. end of file (in this case no match was found for a string with 4 leading spaces)
            if [[ ${wlanX_toBeDeleted_targetLineNum} -gt 0 ]]; then
                #Check if 'line' contains 'pattern_four_spaces_anyString'
                stdOutput=`echo ${line} | egrep "${pattern_four_spaces_anyString}"`
                if [[ -z ${stdOutput} ]]; then #match NOT found
                    debugPrint__func "${PRINTF_READING}" "${line}" "${PREPEND_EMPTYLINES_0}" #print

                    wlanX_toBeDeleted_numOfLines=$((wlanX_toBeDeleted_numOfLines+1))    #increment parameter
                else    #match is found
                    break
                fi
            fi
        fi

        #Increment line-number
        lineNum=$((lineNum+1))
    done < "${yaml_fpath}"
}
wifi_netplan_question_add_replace_wifi_entries__func()
{
    #Show 'read-input message'
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_REPLACE_WIFI_ENTRIES}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${PRINTF_WARNING}" "${PRINTF_IF_PRESENT_DATA_WILL_BE_LOST}" "${PREPEND_EMPTYLINES_0}"

    #Ask if user wants to connec to a WiFi AccessPoint
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n] ]]; then
            clear_lines__func ${NUMOF_ROWS_2}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_REPLACE_WIFI_ENTRIES} ${myChoice}" "${PREPEND_EMPTYLINES_0}"
            debugPrint__func "${PRINTF_WARNING}" "${PRINTF_IF_PRESENT_DATA_WILL_BE_LOST}" "${PREPEND_EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    if [[ ${myChoice} == ${INPUT_NO} ]]; then
        #reset to '0'
        #REMARK: this actually means that all other functions will be skipped from being executed
        allowedToChange_netplan=${FALSE}
    else
        allowedToChange_netplan=${TRUE}
    fi    
}

wifi_netplan_del_wlan_entries__func()
{
    #Define local variables
    local lineDeleted_count=0
    local lineDeleted=${EMPTYSTRING}
    local numOf_wlanIntf=0

    #Check the number of lines to be deleted
    if [[ ${wlanX_toBeDeleted_numOfLines} -eq 0 ]]; then    #no lines to be deleted
        return
    else    #there are lines to be deleted
        #Check the number of configured wlan-interfaces in '*.yaml'
        numOf_wlanIntf=`cat /etc/netplan/\*.yaml | egrep "${pattern_four_spaces_wlan}" | wc -l`

        if [[ ${numOf_wlanIntf} -eq 1 ]]; then  #only 1 interface configured
            #In this case DECREMENT 'wlanX_toBeDeleted_targetLineNum' by 1:
            #This means move-up 1 line-number, because entry 'wifis' also HAS TO BE REMOVED
            wlanX_toBeDeleted_targetLineNum=$((wlanX_toBeDeleted_targetLineNum-1))

            #INCREMENT 'wlanX_toBeDeleted_numOfLines' by 1:
            #This is because of the additional deletion of entry 'wifis'.
            wlanX_toBeDeleted_numOfLines=$((wlanX_toBeDeleted_numOfLines+1))
        fi
    fi

    #Check if file '*.yaml' is present
    #If FALSE, then exit function
    if [[ ! -f ${yaml_fpath} ]]; then
        return  #exit function
    fi

    #Print
    debugPrint__func "${PRINTF_START}" "${printf_yaml_deleting_wifi_entries}" "${PREPEND_EMPTYLINES_1}"

    #Read each line of '*.yaml'
    while true
    do
        #Delete current line-number 'wlanX_toBeDeleted_targetLineNum'
        #REMARK:
        #   After the deletion of a line, all the contents BELOW this line will be...
        #   ... shifted up one line.
        #   Because of this 'shift-up' the variable 'wlanX_toBeDeleted_targetLineNum' can be used again, again, and again...
        lineDeleted=`sed "${wlanX_toBeDeleted_targetLineNum}q;d" ${yaml_fpath}`   #GET line specified by line number 'wlanX_toBeDeleted_targetLineNum'
        
        debugPrint__func "${PRINTF_DELETING}" "${lineDeleted}" "${PREPEND_EMPTYLINES_0}" #print

        sed -i "${wlanX_toBeDeleted_targetLineNum}d" ${yaml_fpath}   #DELETE line specified by line number 'wlanX_toBeDeleted_targetLineNum'

        lineDeleted_count=$((lineDeleted_count+1))    #increment parameter    

        #Check if all lines belonging to wlan0 have been deleted
        #If TRUE, then exit function
        if [[ ${lineDeleted_count} -eq ${wlanX_toBeDeleted_numOfLines} ]]; then
            break  #exit function
        fi
    done < "${yaml_fpath}"

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_deleting_wifi_entries}" "${PREPEND_EMPTYLINES_0}"
}

wifi_netplan_get_ssid_info__func()
{
    #Check if file 'wpaSupplicant_fpath' is present
    if [[ ! -f ${wpaSupplicant_fpath} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_wpa_supplicant_file_not_found}" "${TRUE}"
    fi

    #Retrieve SSID
    ssid=`cat ${wpaSupplicant_fpath} | grep -w "${PATTERN_SSID}" | cut -d"\"" -f2 2>&1`

    #Retrieve Password
    ssidPasswd=`cat ${wpaSupplicant_fpath} | grep -w "${PATTERN_PSK}" | cut -d"\"" -f2 2>&1`

    #Retrieve ssid_scan=1 (if any)
    #if 'scan_ssid=1' is present in file 'wpa_supplicant.conf' then 'ssidScan_isFound' is NOT an EMPTY STRING
    ssidScan_isFound=`cat ${wpaSupplicant_fpath} | grep -w "${SCAN_SSID_IS_1}"`
}

wifi_netplan_choose_dhcp_or_static__func()
{
    #Check if file '*.yaml' is present
    #If FALSE, then create an empty file
    if [[ ! -f ${yaml_fpath} ]]; then
        touch ${yaml_fpath}
    fi

    #Print question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ENABLE_DHCP}" "${PREPEND_EMPTYLINES_1}"

    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            #Print question + answer
            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ENABLE_DHCP} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    if [[ ${myChoice} == ${INPUT_YES} ]]; then
        dhcp_isSelected=${TRUE}
    else    #myChoice == 'n'
        dhcp_isSelected=${FALSE}
    fi
}

wifi_netplan_add_dhcp_entries__func()
{
    #Define local variables
    local dhcp_entry1=${EMPTYSTRING}
    local dhcp_entry2=${EMPTYSTRING}
    local dhcp_entry3=${EMPTYSTRING}
    local dhcp_entry4=${EMPTYSTRING}
    local dhcp_entry5=${EMPTYSTRING}
    local dhcp_entry6=${EMPTYSTRING}
    local dhcp_entry6_with_scanssid=${EMPTYSTRING}
    local dhcp_entry6_without_scanssid=${EMPTYSTRING}
    local isNewLine=${FALSE}
    local stdOutput=${EMPTYSTRING}

    #Compose Netplan entries
    dhcp_entry1="  wifis:"
    dhcp_entry2="    ${wlanSelectIntf}:"
    dhcp_entry3="      dhcp4: true"
    dhcp_entry4="      dhcp6: true"
    dhcp_entry5="      access-points:"

    dhcp_entry6_without_scanssid="        \"${ssid}\":"

    #MANDATORY HACK: for HIDDEN SSID use 'dhcp_entry6_with_scanssid'
    #Without this so called 'hack', after executing 'netplan apply'...
    #...the NETPLAN DAEMON config file '/run/netplan/wpa-wlan0.conf'...
    #...is missing the KEY component 'scan_ssid=1' which is CRUCIAL to find HIDDEN SSID.
    #See: https://askubuntu.com/questions/1276517/how-to-connect-raspberry-pi-4-to-a-hidden-wifi-network-on-ubuntu-server-20-04
    dhcp_entry6_with_scanssid="        \"${ssid}\\\"\\\n  ${SCAN_SSID_IS_1}\\\n# \\\"hack!\":"
    
    if [[ ! -z ${ssidScan_isFound} ]]; then
        dhcp_entry6=${dhcp_entry6_with_scanssid}
    else
        dhcp_entry6=${dhcp_entry6_without_scanssid}
    fi
    dhcp_entry7="          password: \"${ssidPasswd}\""

    #Print START
    debugPrint__func "${PRINTF_START}" "${printf_yaml_adding_dhcpEntries}" "${PREPEND_EMPTYLINES_1}"

    #Print and Add entries:
    #Check if '*.yaml' contains a 'new line (\n)'
    #If 'last line' of '*.yaml' is NOT a 'new line (\n)'...
    #...then append a 'new line'
    isNewLine=`lastLine_isNewLine "${yaml_fpath}"`
    if [[ ${isNewLine} == ${FALSE} ]]; then 
        printf '%b%s\n' "" >> ${yaml_fpath}   #write to file        
    fi

    #Check if entry 'wifis' is present in '*.yaml'
    stdOutput=`cat ${yaml_fpath} | grep "${PATTERN_WIFIS}" 2>&1`
    if [[ -z ${stdOutput} ]]; then  #entry 'wifis' is not present
        debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry1}" "${PREPEND_EMPTYLINES_0}"  #print
        printf '%b%s\n' "${dhcp_entry1}" >> ${yaml_fpath}   #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry2}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry2}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry3}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry3}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry4}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry4}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry5}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry5}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry6}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry6}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry7}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s' "${dhcp_entry7}" >> ${yaml_fpath}    #write to file (do not add new line '\n')

    #Print COMPLETED
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_adding_dhcpEntries}" "${PREPEND_EMPTYLINES_0}"
}

wifi_netplan_static_ipv46_input_and_validate__func()
{
    #Initial values
    myChoice=${INPUT_ALL} #IMPORTANT to set this value

    #Start input
    while true
    do
        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV4} ]]; then
            wifi_netplan_static_ipv4_address_input__func
        fi

        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV6} ]]; then
            wifi_netplan_static_ipv6_address_input__func
        fi

        #Double-check IPv4 and IPv6 Input Values
        wifi_netplan_static_ipv46_inputValues_doubleCheck__func

        #Print input values
        wifi_netplan_static_ipv46_print__func

        #Confirmation
        #Output:
        #   myChoice(y/4/6/a)
        #   dhcp_isSelected(TRUE/FALSE)
        wifi_netplan_static_ipv46_question__func

        if [[ ${myChoice} == ${INPUT_YES} ]]; then
            break
        fi
    done
}
wifi_netplan_static_ipv4_address_input__func()
{
    #Print START
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO}" "${PREPEND_EMPTYLINES_1}"

    #Input IPv4 related info (address, netmask, gateway)
#---Input ipv4-address
    while true
    do
        read -e -p "${READ_IPV4_ADDRESS}" -i "${ipv4_address_accept}" ipv4_address

        #Check if input is a valid ipv4-address
        if [[ ! -z ${ipv4_address} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv4_address} != ${INPUT_SKIP} ]]; then   #key 's' was NOT inputted
                ipv4_address=`ipv46_subst_multiChars_with_oneChar__func "${ipv4_address}"`

                ipv4_address_isValid=`checkIf_ipv4_address_isValid__func "${ipv4_address}"`
                if [[ ${ipv4_address_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
#-------------------Update valid ipv4-address
                    ipv4_address_accept=${ipv4_address}

#-------------------Input ipv4-netmask
                    wifi_netplan_static_ipv4_netmask_input__func
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV4_ADDRESS}" "${ipv4_address}" "${ERRMSG_INVALID_IPV4_ADDR_FORMAT}"
                fi
            else    #key 's' was inputted
                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi

        #Break while-loop
        if [[ ${ipv4_address_isValid} == ${TRUE} ]]; then
            break
        fi
    done
}

wifi_netplan_static_ipv4_netmask_input__func()
{
	while true
	do
		read -e -p "${READ_IPV4_NETMASK}" -i "${ipv4_netmask_accept}" ipv4_netmask

		#Check if input is a valid ipv4-netmask
		if [[ ! -z ${ipv4_netmask} ]]; then #is NOT an EMPTY STRING
			if [[ ${ipv4_netmask} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                ipv4_netmask=`ipv46_subst_multiChars_with_oneChar__func "${ipv4_netmask}"`

				ipv4_netmask_isValid=`checkIf_ipv4_netmask_isValid__func "${ipv4_netmask}"`
				if [[ ${ipv4_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
#-------------------Update valid ipv4-netmask
                    ipv4_netmask_accept=${ipv4_netmask}

#-------------------Input ipv4-gateway
					wifi_netplan_static_ipv4_gateway_input__func
				else
					wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV4_NETMASK}" "${ipv4_netmask}" "${ERRMSG_INVALID_IPV4_NETMASK_FORMAT}"
				fi
			else    #key 'b' was inputted      
				ipv4_address_isValid=${FALSE}

				break
			fi
		else    #is an EMPTY STRING
			clear_lines__func "${NUMOF_ROWS_1}"
		fi

        #Break while-loop
		if [[ ${ipv4_netmask_isValid} == ${TRUE} ]]; then
			break
		fi
	done
}
wifi_netplan_static_ipv4_gateway_input__func()
{
    while true
    do
        read -e -p "${READ_IPV4_GATEWAY}" -i "${ipv4_gateway_accept}" ipv4_gateway

        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv4_gateway} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv4_gateway} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                if [[ ${ipv4_gateway} != ${ipv4_address} ]]; then    #not the same as 'ipv4-address'
                    ipv4_gateway=`ipv46_subst_multiChars_with_oneChar__func "${ipv4_gateway}"`

                    ipv4_gateway_isValid=`checkIf_ipv4_address_isValid__func "${ipv4_gateway}"`
                    if [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-gateway
#-----------------------Update valid ipv4-gateway
                        ipv4_gateway_accept=${ipv4_gateway}

#-----------------------Input ipv4-gateway
                        wifi_netplan_static_ipv4_dns_input__func
                    else
                        wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway}" "${ERRMSG_INVALID_IPV4_GATEWAY_FORMAT}"
                    fi
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway}" "${ERRMSG_INVALID_IPV4_GATEWAY_DUPLICATE}"
                fi
            else    #key 'b' was inputted
                ipv4_netmask_isValid=${FALSE}

                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi

        #Break while-loop
		if [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then
			break
		fi
    done
}
wifi_netplan_static_ipv4_dns_input__func()
{
    while true
    do
        read -e -p "${READ_IPV4_DNS}" -i "${ipv4_dns_accept}" ipv4_dns

        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv4_dns} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv4_dns} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                #REPLACE MULTIPLE SPACES to ONE SPACE
                ipv4_dns=`ipv46_subst_multiChars_with_oneChar__func "${ipv4_dns}"`

                ipv4_dns_isValid=`checkIf_ipv4_address_isValid__func "${ipv4_dns}"`
                if [[ ${ipv4_dns_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-gateway
#-------------------Update valid ipv4-gateway
                    ipv4_dns_accept=${ipv4_dns}

                    break
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV4_DNS}" "${ipv4_dns}" "${ERRMSG_INVALID_IPV4_GATEWAY_FORMAT}"
                fi
            else    #key 'b' was inputted
                ipv4_gateway_isValid=${FALSE}

                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi
    done
}
function checkIf_ipv4_address_isValid__func()
{
    #Input args
    local ipv4Addr=${1}

    #Define local variables
    local ipv4Addr_array=()
    local ipv4Addr_arrayItem=${EMPTYSTRING}
    local ipv4Addr_subst=${EMPTYSTRING}
    local regEx=${EMPTYSTRING}
    local isValid=${FALSE}

    #Regular expression
    regEx="^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$"

    #'ipv4Addr' could contain multiple ip-addresses,...
    #...where each ip-address are separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    ipv4Addr_subst=`ipv46_subst_comma_with_space__func "${ipv4Addr}"`

    #Convert from String to Array
    eval "ipv4Addr_array=(${ipv4Addr_subst})"

    #Check if ip-address is valid
    for ipv4Addr_arrayItem in "${ipv4Addr_array[@]}"
    do
        if [[ "${ipv4Addr_arrayItem}" =~ ${regEx} ]]; then  #ip-address is valid
            isValid=${TRUE}
        else    #ip-address is NOT valid
            isValid=${FALSE}

            break  #as soon as an Invalid ip-address input is found, exit loop
        fi
    done

    #Output
    echo ${isValid}
}
function checkIf_ipv4_netmask_isValid__func()
{
    #Input args
    local ipv4Netmask=${1}

    #Define local constants
    local IPV4_NETMASK_MAX=32

    #Define local variables
    local regEx="^[0-9]+$"    #used to check if value is numeric

    #Condition
    if [[ "${ipv4Netmask}" =~ ${regEx} ]]; then    #values is numeric
        if [[ ${ipv4Netmask} -le ${IPV4_NETMASK_MAX} ]]; then  #not allowed to exceed 32
            echo "${TRUE}"
        else    #exceeded 32
            echo "${FALSE}"
        fi
    else    #value is not numeric
        echo "${FALSE}"
    fi
}

wifi_netplan_static_ipv6_address_input__func()
{
    #Print START
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO}" "${PREPEND_EMPTYLINES_1}"

    #Input ipv6 related info (address, netmask, gateway)
#---Input ipv6-address
    while true
    do
        read -e -p "${READ_IPV6_ADDRESS}" -i "${ipv6_address_accept}" ipv6_address

        #Check if input is a valid ipv6-address
        if [[ ! -z ${ipv6_address} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv6_address} != ${INPUT_SKIP} ]]; then   #key 's' was NOT inputted
                #REPLACE MULTIPLE SPACES to ONE SPACE
                ipv6_address=`ipv46_subst_multiChars_with_oneChar__func "${ipv6_address}"`

                ipv6_address_isValid=`checkIf_ipv6_address_isValid__func "${ipv6_address}"`
                if [[ ${ipv6_address_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
#-------------------Update valid ipv4-address
                	ipv6_address_accept=${ipv6_address}

#-------------------Input ipv6-netmask
                    wifi_netplan_static_ipv6_netmask_input__func
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV6_ADDRESS}" "${ipv6_address}" "${ERRMSG_INVALID_IPV6_ADDR_FORMAT}"
                fi
            else    #key 's' was inputted
                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi

        #Break while-loop
        if [[ ${ipv6_address_isValid} == ${TRUE} ]]; then
            break
        fi
    done
}
wifi_netplan_static_ipv6_netmask_input__func()
{
	while true
	do
		read -e -p "${READ_IPV6_NETMASK}" -i "${ipv6_netmask_accept}" ipv6_netmask

		#Check if input is a valid ipv6-netmask
		if [[ ! -z ${ipv6_netmask} ]]; then #is NOT an EMPTY STRING
			if [[ ${ipv6_netmask} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
				ipv6_netmask=`ipv46_subst_multiChars_with_oneChar__func "${ipv6_netmask}"`

				ipv6_netmask_isValid=`checkIf_ipv6_netmask_isValid__func "${ipv6_netmask}"`
				if [[ ${ipv6_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
#-------------------Update valid ipv6-netmask
                	ipv6_netmask_accept=${ipv6_netmask}

#-------------------Input ipv6-gateway
					wifi_netplan_static_ipv6_gateway_input__func
				else
					wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV6_NETMASK}" "${ipv6_netmask}" "${ERRMSG_INVALID_IPV6_NETMASK_FORMAT}"
				fi
			else    #key 'b' was inputted      
				ipv6_address_isValid=${FALSE}

				break
			fi
		else    #is an EMPTY STRING
			clear_lines__func "${NUMOF_ROWS_1}"
		fi

        #Break while-loop
		if [[ ${ipv6_netmask_isValid} == ${TRUE} ]]; then
			break
		fi
	done
}
wifi_netplan_static_ipv6_gateway_input__func()
{
    while true
    do
        read -e -p "${READ_IPV6_GATEWAY}" -i "${ipv6_gateway_accept}" ipv6_gateway

        #Check if input is a valid ipv6-gateway
        if [[ ! -z ${ipv6_gateway} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv6_gateway} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                if [[ ${ipv6_gateway} != ${ipv6_address} ]]; then    #not the same as 'ipv6-address'
                    #REPLACE MULTIPLE SPACES to ONE SPACE
                    ipv6_gateway=`ipv46_subst_multiChars_with_oneChar__func "${ipv6_gateway}"`
                                        
                    ipv6_gateway_isValid=`checkIf_ipv6_address_isValid__func "${ipv6_gateway}"`
                    if [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
#-----------------------Update valid ipv6-gateway
                	    ipv6_gateway_accept=${ipv6_gateway}

#-----------------------Input ipv6-gateway
                        wifi_netplan_static_ipv6_dns_input__func
                    else
                        wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway}" "${ERRMSG_INVALID_IPV6_GATEWAY_FORMAT}"
                    fi
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway}" "${ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE}"
                fi
            else    #key 'b' was inputted
                ipv6_netmask_isValid=${FALSE}

                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi

        #Break while-loop
		if [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then
			break
		fi
    done
}
wifi_netplan_static_ipv6_dns_input__func()
{
    while true
    do
        read -e -p "${READ_IPV6_DNS}" -i "${ipv6_dns_accept}" ipv6_dns

        #Check if input is a valid ipv6-gateway
        if [[ ! -z ${ipv6_dns} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv6_dns} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                #REPLACE MULTIPLE SPACES to ONE SPACE
                ipv6_dns=`ipv46_subst_multiChars_with_oneChar__func "${ipv6_dns}"`

                ipv6_dns_isValid=`checkIf_ipv6_address_isValid__func "${ipv6_dns}"`
                if [[ ${ipv6_dns_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-gateway
#-------------------Update valid ipv6-gateway
                    ipv6_dns_accept=${ipv6_dns}

                    break
                else
                    wifi_netplan_static_ipv46_print_errmsg__func "${READ_IPV6_DNS}" "${ipv6_dns}" "${ERRMSG_INVALID_IPV6_GATEWAY_FORMAT}"
                fi
            else    #key 'b' was inputted
                ipv6_gateway_isValid=${FALSE}

                break
            fi
        else    #is an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi
    done
}
function checkIf_ipv6_address_isValid__func()
{
    #Input args
    local ipv6Addr=${1}

    #Define local constants
    local PATTERN_DOUBLECOLONS="::"
    local PATTERN_TRIPLECOLONS_PLUS=":::+"
    local PATTERN_ATSIGN="@"

    #Define local variables
    local ipv6Addr_array=()
    local ipv6Addr_arrayItem=${EMPTYSTRING}
    local ipv6Addr_subst=${EMPTYSTRING}
    local ipv6Addr_modified=${EMPTYSTRING}
    local numOf_atChar=0
    local moreThan_twoConsecutiveColons_areFound=${EMPTYSTRING}
    local regEx=${EMPTYSTRING}
    local isValid=${FALSE}

    #Regular expression
    regEx="^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$"

    #'ipv6Addr' could contain multiple ip-addresses,...
    #...where each ip-address are separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    ipv6Addr_subst=`ipv46_subst_comma_with_space__func "${ipv6Addr}"`

    #Convert from String to Array
    eval "ipv6Addr_array=(${ipv6Addr_subst})"

    #Check if ipv6-address is valid
    for ipv6Addr_arrayItem in "${ipv6Addr_array[@]}"
    do
        if [[ "${ipv6Addr_arrayItem}" =~ ${regEx} ]]; then  #ipv6-address is valid
            #Replace double-colons(::) with at-sign(@)  
            ipv6Addr_modified=`echo ${ipv6Addr_arrayItem} | sed "s/${PATTERN_DOUBLECOLONS}/${PATTERN_ATSIGN}/"g`
            
            #Count the number of at-sign(@) in 'ipv6Addr_modified'
            numOf_atSign=`echo "${ipv6Addr_modified}" | tr -cd "${PATTERN_ATSIGN}" | wc -c`
            #For IPv6 address to be valid, ONLY 1 at-sign is allowed in the IPv6 address
            if [[ ${numOf_atSign} -le 1 ]]; then    #none or 1 at-sign found

                #Check if there are more than 2 consecutive colons (e.g., :::, ::::, :::::, etc...)
                moreThan_twoConsecutiveColons_areFound=`echo "${ipv6Addr_arrayItem}" | grep -oE "${PATTERN_TRIPLECOLONS_PLUS}" | awk '{ print $0, length}'`
                #For IPv6 address to valid, no more than 2 consecutive colons are allowed
                if [[ -z ${moreThan_twoConsecutiveColons_areFound} ]]; then  #2 consecutive colons found and NO MORE
                    isValid=${TRUE}
                else    #more than 2 consecutive colons found
                    isValid=${FALSE}

                    break   #as soon as an Invalid ip-address input is found, exit loop
                fi
            else    #more than 1 add-sign found
                isValid=${FALSE}

                break   #as soon as an Invalid ip-address input is found, exit loop
            fi
        else    #ipv6-address is NOT valid
            isValid=${FALSE}

            break   #as soon as an Invalid ip-address input is found, exit loop
        fi
    done

    #Output
    echo ${isValid}
}

function checkIf_ipv6_netmask_isValid__func()
{
    #Input args
    local ipv6Netmask=${1}

    #Define local constants
    local IPV6_NETMASK_MAX=128

    #Define local variables
    local regEx="^[0-9]+$"    #used to check if value is numeric

    #Condition
    if [[ "${ipv6Netmask}" =~ ${regEx} ]]; then    #values is numeric
        if [[ ${ipv6Netmask} -le ${IPV6_NETMASK_MAX} ]]; then  #not allowed to exceed 32
            echo "${TRUE}"
        else    #exceeded 32
            echo "${FALSE}"
        fi
    else    #value is not numeric
        echo "${FALSE}"
    fi
}

function ipv46_subst_multiChars_with_oneChar__func()
{
    #Input args
    local ipv46Addr=${1}

    #Define local variables
    local ipv46Addr_input=${EMPTYSTRING}
    local ipv46Addr_clean1=${EMPTYSTRING}
    local ipv46Addr_clean2=${EMPTYSTRING}
    local ipv46Addr_clean3=${EMPTYSTRING}
    local ipv46Addr_clean4=${EMPTYSTRING}
    # local ipv46Addr_clean5=${EMPTYSTRING}
    local ipv46Addr_clean6=${EMPTYSTRING}
    local ipv46Addr_output=${EMPTYSTRING}


    #Start Substitution
    ipv46Addr_input=${ipv46Addr}

    while true
    do
        #Remove Leading SPACES
        ipv46Addr_clean1=`echo ${ipv46Addr_input} | xargs`

        #Remove Trailing SPACES
        ipv46Addr_clean2=`echo ${ipv46Addr_clean1} | sed "s/${ONE_SPACE}${ASTERISK_CHAR}${DOLLAR_CHAR}//"`

        #Subsitute MULTIPLE SPACEs with ONE SPACE
        ipv46Addr_clean3=`echo ${ipv46Addr_clean2} | sed "s/${ONE_SPACE}//g"`

        #Subsitute MULTIPLE COMMAs with ONE COMMA
        ipv46Addr_clean4=`echo ${ipv46Addr_clean3} | sed "s/${COMMA_CHAR}${COMMA_CHAR}*/${COMMA_CHAR}/g"`

        #Substitute MULTIPLE SPACEs next to the comma (leading or trailing) with ONE SPACE 
        # ipv46Addr_clean5=`echo ${ipv46Addr_clean4} | sed "s/${ONE_SPACE}${ASTERISK_CHAR}${COMMA_CHAR}${ONE_SPACE}${ASTERISK_CHAR}/${COMMA_CHAR}/g"`

        #Remove any leading character
        ipv46Addr_clean6=`echo ${ipv46Addr_clean4} | sed "s/${CARROT_CHAR}${COMMA_CHAR}//"`

        #Remove any trailing character
        ipv46Addr_output=`echo ${ipv46Addr_clean6} | sed "s/${COMMA_CHAR}${DOLLAR_CHAR}//"`

        #Check if 'ipv46Addr_input' is EQUAL to 'ipv46Addr_output'
        #If TRUE, then exit while-loop
        #If FALSE, then update 'ipv46Addr_input', and go back to the beginning of the loop
        if [[ ${ipv46Addr_output} != ${ipv46Addr_input} ]]; then    #strings are different
            ipv46Addr_input=${ipv46Addr_output}
        else    #strings are the same
            break
        fi
    done


    #Output
    echo ${ipv46Addr_output}
}
function ipv46_subst_comma_with_space__func()
{
    #Input args
    local ipv46Addr=${1}

    #Subsitute MULTIPLE SPACES with ONE SPACE
    local ipv46Addr_subst=`echo ${ipv46Addr} | sed "s/${COMMA_CHAR}/${ONE_SPACE}/g"`

    #Output
    echo ${ipv46Addr_subst}    
}
function ipv46_combine_ip_with_netmask__func()
{
    #Input args
    local ipv46Addr=${1}
    local netmask=${2}

    #Define local variables
    local ipv46Addr_array=()
    local ipv46Addr_arrayItem=${EMPTYSTRING}
    local ipv46Addr_netmask=${EMPTYSTRING}
    local ipv46Addr_netmask_accum=${EMPTYSTRING}
    local ipv46Addr_subst=${EMPTYSTRING}

    #Check if 'ipv46Addr' is NOT an EMPTY STRING
    #If FALSE, then exit function
    if [[ -z ${ipv46Addr} ]]; then
        return
    fi

    #'ipv46Addr' could contain multiple ip-addresses,...
    #...where each ip-address are separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    ipv46Addr_subst=`ipv46_subst_comma_with_space__func "${ipv46Addr}"`

    #Convert from String to Array
    eval "ipv46Addr_array=(${ipv46Addr_subst})"

    #Check if ipv6-address is valid
    for ipv46Addr_arrayItem in "${ipv46Addr_array[@]}"
    do
        #Combine 'ip-address' with the 'netmask'
        ipv46Addr_netmask=${ipv46Addr_arrayItem}/${netmask}

        if [[ -z  ${ipv46Addr_netmask_accum} ]]; then
            ipv46Addr_netmask_accum="${ipv46Addr_netmask}"
        else
            ipv46Addr_netmask_accum="${ipv46Addr_netmask_accum},${ipv46Addr_netmask}"
        fi
    done

    #Output
    echo ${ipv46Addr_netmask_accum}
}

wifi_netplan_static_ipv46_print_errmsg__func()
{
    #Input args
    local readmsg=${1}
    local inputmsg=${2}
    local errmsg=${3}

    #Print the existing READ and INPUT MESSAGE including the ERROR message
    tput cuu1   #move-up one line
    printf '%b%n\n' "${readmsg} ${inputmsg} ${errmsg}"
}
wifi_netplan_static_ipv46_inputValues_doubleCheck__func()
{
    #Check if at least one of the IPv4 Input Values  is an EMPTY STRING
    #If TRUE, then set all the IPv4 Input Values to an EMPTY STRING
    if [[ ${ipv4_address_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv4_netmask_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv4_gateway_accept} == "${EMPTYSTRING}" ]] || \
                    [[ ${ipv4_dns_accept} == "${EMPTYSTRING}" ]]; then

        ipv4_address_accept=${EMPTYSTRING}
        ipv4_netmask_accept=${EMPTYSTRING}
        ipv4_gateway_accept=${EMPTYSTRING}
        ipv4_dns_accept=${EMPTYSTRING}
    fi

    #Check if at least one of the IPv6 Input Values  is an EMPTY STRING
    if [[ ${ipv6_address_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv6_netmask_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv6_gateway_accept} == "${EMPTYSTRING}" ]] || \
                    [[ ${ipv6_dns_accept} == "${EMPTYSTRING}" ]]; then

        ipv6_address_accept=${EMPTYSTRING}
        ipv6_netmask_accept=${EMPTYSTRING}
        ipv6_gateway_accept=${EMPTYSTRING}
        ipv6_dns_accept=${EMPTYSTRING}
    fi
}

wifi_netplan_static_ipv46_print__func()
{
    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_WIFI_YOUR_IPV4_INPUT}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_ADDRESS}${ipv4_address_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_NETMASK}${ipv4_netmask_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_GATEWAY}${ipv4_gateway_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_DNS}${ipv4_dns_accept}" "${PREPEND_EMPTYLINES_0}"


    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_WIFI_YOUR_IPV6_INPUT}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_ADDRESS}${ipv6_address_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_NETMASK}${ipv6_netmask_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_GATEWAY}${ipv6_gateway_accept}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_DNS}${ipv6_dns_accept}" "${PREPEND_EMPTYLINES_0}"
}

function wifi_netplan_static_ipv46_inputValues_areValid__func()
{
    #Check if IPv4 Input Values  are an EMPTY STRING
    if [[ ${ipv4_address_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv4_netmask_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv4_gateway_accept} == "${EMPTYSTRING}" ]] || \
                    [[ ${ipv4_dns_accept} == "${EMPTYSTRING}" ]]; then

        #IPv4 Input Values are an EMPTY STRING, but...
        #...check if IPv6 Input Values  are an EMPTYSTRING
        if [[ ${ipv6_address_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv6_netmask_accept} == "${EMPTYSTRING}" ]] || \
                    [[ ${ipv6_gateway_accept} == "${EMPTYSTRING}" ]] || \
                        [[ ${ipv6_dns_accept} == "${EMPTYSTRING}" ]]; then

            echo ${FALSE}

            return
        fi
    fi

    #IPv4 and/or IPv6 Input Values are NOT an EMPTY STRING
    echo ${TRUE}
}

wifi_netplan_static_ipv46_question__func()
{
    #Define local variables
    local inputValues_areValid=`wifi_netplan_static_ipv46_inputValues_areValid__func`
    local questionMsg=${EMPTYSTRING}

    if [[ ${inputValues_areValid} == ${TRUE} ]]; then
        questionMsg=${QUESTION_ACCEPT_INPUT_VALUES_OR_REDO_INPUT}
    else
        questionMsg=${QUESTION_ENABLE_DHCP_INSTEAD_OR_REDO_INPUT}
    fi

    #Print question
    debugPrint__func "${PRINTF_QUESTION}" "${questionMsg}" "${PREPEND_EMPTYLINES_1}"

    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,a,4,6] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            #Print question + answer
            debugPrint__func "${PRINTF_QUESTION}" "${questionMsg} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    #Set the 'dhcp_isSelected' to TRUE or FALSE (this depends on 'myChoice')
    if [[ ${myChoice} == ${INPUT_YES} ]]; then
        if [[ ${inputValues_areValid} == ${TRUE} ]]; then
            dhcp_isSelected=${FALSE}
        else
            dhcp_isSelected=${TRUE}
        fi
    else
        dhcp_isSelected=${FALSE}
    fi
}

wifi_netplan_add_static_ipv46_entries__func()
{
    #Define local variables
    local inputValues_areValid=${FALSE}
    local ipv4_address_netmask_accept=${EMPTYSTRING}
    local ipv6_address_netmask_accept=${EMPTYSTRING}
    local ipv46_address_netmask_accept=${EMPTYSTRING}
    local ipv46_dns_accept=${EMPTYSTRING}
    local ipv46_entry1=${EMPTYSTRING}
    local ipv46_entry2=${EMPTYSTRING}
    local ipv46_entry3=${EMPTYSTRING}
    local ipv46_entry4=${EMPTYSTRING}
    local ipv46_entry5=${EMPTYSTRING}
    local ipv46_entry6=${EMPTYSTRING}
    local ipv46_entry7=${EMPTYSTRING}
    local ipv46_entry8=${EMPTYSTRING}
    local ipv46_entry9=${EMPTYSTRING}
    local ipv46_entry9_with_scanssid=${EMPTYSTRING}
    local ipv46_entry9_without_scanssid=${EMPTYSTRING}
    local ipv46_entry10=${EMPTYSTRING}

    #Check if IPv4 and/or IPv6 Values are NOT EMPTY STRINGs
    inputValues_areValid=`wifi_netplan_static_ipv46_inputValues_areValid__func`
    if [[ ${inputValues_areValid} == ${FALSE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_IPV46_INPUT_VALUES_ARE_EMPTY_STRINGS}" "${TRUE}"

        return
    fi

    #Combine IP-addresses with Netmask
    ipv4_address_netmask_accept=`ipv46_combine_ip_with_netmask__func "${ipv4_address_accept}" "${ipv4_netmask_accept}"`
    ipv6_address_netmask_accept=`ipv46_combine_ip_with_netmask__func "${ipv6_address_accept}" "${ipv6_netmask_accept}"`

    #Combine IPv4 and IPv6 Addresses
    ipv46_address_netmask_accept=`combine_two_strings_separated_by_char__func "${ipv4_address_netmask_accept}" \
                                                                                "${ipv6_address_netmask_accept}" \
                                                                                    "${COMMA_CHAR}"`

    #Combine IPv4 and IPv6 DNS
    ipv46_dns_accept=`combine_two_strings_separated_by_char__func "${ipv4_dns_accept}" \
                                                                    "${ipv6_dns_accept}" \
                                                                        "${COMMA_CHAR}"`

    #Compose Netplan Entries
    ipv46_entry1="  wifis:"
    ipv46_entry2="    ${wlanSelectIntf}:"
    ipv46_entry3="      addresses: [${ipv46_address_netmask_accept}]"
    if [[ ! -z ${ipv4_gateway_accept} ]]; then
        ipv46_entry4="      gateway4: \"${ipv4_gateway_accept}\""
    fi
    if [[ ! -z ${ipv6_gateway_accept} ]]; then    
        ipv46_entry5="      gateway6: \"${ipv6_gateway_accept}\""
    fi
    ipv46_entry6="      nameservers:"
    ipv46_entry7="        addresses: [${ipv46_dns_accept}]"
    ipv46_entry8="      access-points:"
    ipv46_entry9_without_scanssid="        \"${ssid}\":"
    #MANDATORY HACK: for HIDDEN SSID use 'ipv46_entry9_with_scanssid'
    #Without this so called 'hack', after executing 'netplan apply'...
    #...the NETPLAN DAEMON config file '/run/netplan/wpa-wlan0.conf'...
    #...is missing the KEY component 'scan_ssid=1' which is CRUCIAL to find HIDDEN SSID.
    #See: https://askubuntu.com/questions/1276517/how-to-connect-raspberry-pi-4-to-a-hidden-wifi-network-on-ubuntu-server-20-04
    ipv46_entry9_with_scanssid="        \"${ssid}\\\"\\\n  ${SCAN_SSID_IS_1}\\\n# \\\"hack!\":"
    if [[ ! -z ${ssidScan_isFound} ]]; then
        ipv46_entry9=${ipv46_entry9_with_scanssid}
    else
        ipv46_entry9=${ipv46_entry9_without_scanssid}
    fi
    ipv46_entry10="          password: \"${ssidPasswd}\""


    #Print START
    debugPrint__func "${PRINTF_START}" "${printf_yaml_adding_dhcpEntries}" "${PREPEND_EMPTYLINES_1}"

    #Print and Add entries:
    #Check if '*.yaml' contains a 'new line (\n)'
    #If 'last line' of '*.yaml' is NOT a 'new line (\n)'...
    #...then append a 'new line'
    isNewLine=`lastLine_isNewLine "${yaml_fpath}"`
    if [[ ${isNewLine} == ${FALSE} ]]; then 
        printf '%b%s\n' "" >> ${yaml_fpath}   #write to file        
    fi

    #Check if entry 'wifis' is present in '*.yaml'
    stdOutput=`cat ${yaml_fpath} | grep "${PATTERN_WIFIS}" 2>&1`
    if [[ -z ${stdOutput} ]]; then  #entry 'wifis' is not present
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry1}" "${PREPEND_EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry1}" >> ${yaml_fpath}   #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry2}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry2}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry3}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry3}" >> ${yaml_fpath}    #write to file

    if [[ ! -z ${ipv4_gateway_accept} ]]; then
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry4}" "${PREPEND_EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry4}" >> ${yaml_fpath}    #write to file
    fi

    if [[ ! -z ${ipv6_gateway_accept} ]]; then
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry5}" "${PREPEND_EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry5}" >> ${yaml_fpath}    #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry6}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry6}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry7}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry7}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry8}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry8}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry9}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry9}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipvipv46_entry1046_entry7}" "${PREPEND_EMPTYLINES_0}"  #print
    printf '%b%s' "${ipv46_entry10}" >> ${yaml_fpath}    #write to file (do not add new line '\n')

    #Print COMPLETED
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_adding_dhcpEntries}" "${PREPEND_EMPTYLINES_0}"
}

wifi_netplan_apply__func()
{
    #Define local variables
    local yaml_containsErrors=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_APPLYING_NETPLAN_START}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}" "${PREPEND_EMPTYLINES_0}"

    #FIRST: run 'netplay apply' and capture stdErr ONLY with 2>&1 > /dev/null`
    #REMARK: if '2>&1', then both stdOut and stdErr are captured
    stdError=`netplan apply 2>&1 > /dev/null`
    exitCode=$? #get exit-code
    if [[ ! -z ${stdError} ]]; then    #string contains data
        errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_UNABLE_TO_APPLY_NETPLAN}" "${TRUE}"
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_APPLYING_NETPLAN_SUCCESSFULLY}" "${PREPEND_EMPTYLINES_0}"
}



#---MAIN SUBROUTINE
main__sub()
{
    if [[ -z ${wlanSelectIntf} ]]; then
        load_header__sub
    fi

    wifi_init_variables__sub

    input_args_handler__sub

    load_env_variables__sub

    wifi_get_wifi_pattern__func

    wifi_wlan_select__func

    wifi_define_dynamic_variables__sub

    wifi_toggle_intf__func ${TOGGLE_UP}

    #This function will the following output:
    #   wlanX_toBeDeleted_numOfLines
    #   wlanX_toBeDeleted_targetLineNum
    wifi_netplan_print_retrieve_main__func

    #Check the number of lines to be deleted
    #If 'wlanX_toBeDeleted_numOfLines == 0', then it means that:
    #...you have answered 'n' previously in function 'wifi_netplan_print_and_get_toBeDeleted_lines__func'
    if [[ ${allowedToChange_netplan} == ${TRUE} ]]; then    #no lines to be deleted
        wifi_netplan_del_wlan_entries__func

        #Retrieve SSID & SSID-PASSWD
        #Output of this function are: 
        #1. ssid
        #2. ssidPasswd
        wifi_netplan_get_ssid_info__func

        #This function will output 'dhcp_isSelected'    
        wifi_netplan_choose_dhcp_or_static__func

        while true
        do
            if [[ ${dhcp_isSelected} == ${TRUE} ]]; then
                wifi_netplan_add_dhcp_entries__func

                break
            else
                #This function INDIRECTLY OUTPUTS value for 'dhcp_isSelected'
                #The function which CHANGES 'dhcp_isSelected' is 'wifi_netplan_static_ipv46_question__func'
                wifi_netplan_static_ipv46_input_and_validate__func

                if [[ ${dhcp_isSelected} == ${FALSE} ]]; then
                    wifi_netplan_add_static_ipv46_entries__func

                    break
                fi
            fi
        done

        #Netplan Apply
        wifi_netplan_apply__func
    fi
}


#---EXECUTE
main__sub