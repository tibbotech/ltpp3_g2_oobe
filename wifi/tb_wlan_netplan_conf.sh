#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
wlanSelectIntf=${1}             #optional
yaml_fpath=${2}                 #optional
ipv4_addrNetmask_input=${3}     #optional
ipv4_gateway_input=${4}         #optional
ipv4_dns_input=${5}             #optional
ipv6_addrNetmask_input=${6}     #optional
ipv6_gateway_input=${7}         #optional
ipv6_dns_input=${8}             #optional


#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${wlanSelectIntf}

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=8
ARGSTOTAL_IP_RELATED=6

if [[ ${argsTotal} == ${ARGSTOTAL_MAX} ]]; then
    interactive_isEnabled=${FALSE}
else
    interactive_isEnabled=${TRUE}
fi

#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---TRAP ON EXIT
# trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
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



#---CHAR CONSTANTS
TITLE="TIBBO"

EMPTYSTRING=""

ASTERISK_CHAR="*"
BACKSLASH_CHAR="\\"
BACKSPACE_CHAR=$'\b'
CARROT_CHAR="^"
COMMA_CHAR=","
COMMA_CHAR=","
COLON_CHAR=":"
DOLLAR_CHAR="$"
DOT_CHAR=$'\.'
ENTER_CHAR=$'\x0a'
ESCAPEKEY_CHAR=$'\x1b'   #note: this escape key is ^[
QUESTION_CHAR="?"
QUOTE_CHAR=$'\"'
SLASH_CHAR="/"
SPACE_CHAR=$' '
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"
TAB_CHAR=$'\t'



#---SPACE CONSTANTS
ONE_SPACE=" "
TWO_SPACES="  "
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}



#---EXIT CODES
EXITCODE_0=0
EXITCODE_99=99



#---COMMAND RELATED CONSTANTS
IW_CMD="iw"
IWLIST_CMD="iwlist"
IEEE_80211="IEEE 802.11"
SCAN_SSID_IS_1="scan_ssid=1"
LSMOD_CMD="lsmod"
SYSTEMCTL_CMD="systemctl"
WPA_SUPPLICANT="wpa_supplicant"

IS_ENABLED="is-enabled"
IS_ACTIVE="is-active"
STATUS="status"

MODPROBE_BCMDHD="bcmdhd"



#---READ INPUT CONSTANTS
ZERO=0
ONE=1

INPUT_ALL="a"
INPUT_BACK="b"
INPUT_SEMICOLON_BACK=";b"
INPUT_DHCP="d"
INPUT_SKIP="s"
INPUT_SEMICOLON_SKIP=";s"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_YES="y"
INPUT_NO="n"
INPUT_QUIT="q"



#---RETRY CONSTANTS
RETRY_MAX=30



#---TIMEOUT CONSTANTS
SLEEP_TIMEOUT=1



#---LINE CONSTANTS
NUMOF_ROWS_0=0
NUMOF_ROWS_1=1
NUMOF_ROWS_2=2
NUMOF_ROWS_3=3
NUMOF_ROWS_2=4
NUMOF_ROWS_5=5
NUMOF_ROWS_6=6
NUMOF_ROWS_7=7

EMPTYLINES_0=0
EMPTYLINES_1=1



#---STATUS/BOOLEANS
ENABLED="enabled"
DISABLED="disabled"
ACTIVE="active"
INACTIVE="inactive"

STATUS_UP="UP"
STATUS_DOWN="DOWN"
TOGGLE_UP="up"
TOGGLE_DOWN="down"

CHECK_OK="OK"
CHECK_DISABLED="DISABLED"
CHECK_ENABLED="ENABLED"
CHECK_FAILED="FAILED"
CHECK_PRESENT="PRESENT"
CHECK_NOTAVAILABLE="N/A"
CHECK_RUNNING="RUNNING"
CHECK_NOTRUNNING="NOT-RUNNING"
CHECK_SET="SET"
CHECK_BLANK="BLANK"
CHECK_STOPPED="STOPPED"
CHECK_TRUE="TRUE"
CHECK_FALSE="FALSE"



#---PATTERN CONSTANTS
PATTERN_COULD_NOT_BE_FOUND="could not be found"
PATTERN_DHCP="dhcp"
PATTERN_GREP="grep"
PATTERN_INTERFACE="Interface"
PATTERN_IW="iw"
PATTERN_PASSWORD="password:"
PATTERN_SSID="ssid"
PATTERN_PSK="#psk="
PATTERN_USAGE="usage"
PATTERN_WIFIS="wifis"
PATTERN_WIRELESS_TOOLS="wireless-tools"
PATTERN_WPASUPPLICANT="wpasupplicant"



#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"



#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_PLEASE_SET_ALL_IP_RELATED_INPUT_ARGS_TO_DHCP="PLEASE SET ALL IP-RELATED INPUT ARGS TO ${FG_SOFTLIGHTRED}dhcp${NOCOLOR}"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"
ERRMSG_SLASH_MISSING_IN_ARG3="SLASH MISSING IN ARG3: ${ipv4_addrNetmask_input}"



#---HELPER/USAGE PRINTF MESSAGES
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to setup & apply netplan."



#---PRINTF PHASES
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
PRINTF_UPDATE="UPDATE:"



#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
ERRMSG_UNABLE_TO_APPLY_NETPLAN="UNABLE TO APPLY NETPLAN"
ERRMSG_WPA_SUPPLICANT_SERVICE_NOT_PRESENT="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"

# ERRMSG_INVALID_IPV4_ADDRESS_NETMASK_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv4 Address/Netmask Format${NOCOLOR})"
# ERRMSG_INVALID_IPV4_ADDR_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv4 Address Format${NOCOLOR})"
# ERRMSG_INVALID_IPV4_NETMASK_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv4 Netmask Value${NOCOLOR})"
# ERRMSG_INVALID_IPV4_GATEWAY_DUPLICATE_W_COLOR="(${FG_LIGHTRED}Duplicate IPv4 Address${NOCOLOR})"

ERRMSG_INVALID_IPV4_ADDRESS_NETMASK_FORMAT_NO_COLOR="(Invalid IPv4 Address/Netmask Format)"
ERRMSG_INVALID_IPV4_ADDR_FORMAT_NO_COLOR="(Invalid IPv4 Address Format)"
ERRMSG_INVALID_IPV4_NETMASK_FORMAT_NO_COLOR="(Invalid IPv4 Netmask Value)"
ERRMSG_INVALID_IPV4_GATEWAY_FORMAT_NO_COLOR="(Invalid IPv4 Gateway Format)"
ERRMSG_INVALID_IPV4_GATEWAY_DUPLICATE_NO_COLOR="(Duplicate IPv4 Address)"
ERRMSG_INVALID_IPV4_DNS_FORMAT_NO_COLOR="(Invalid IPv4 DNS Format)"

# ERRMSG_INVALID_IPV6_ADDRESS_NETMASK_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv6 Address/Netmask Format${NOCOLOR})"
# ERRMSG_INVALID_IPV6_ADDR_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv6 Address Format${NOCOLOR})"
# ERRMSG_INVALID_IPV6_NETMASK_FORMAT_W_COLOR="(${FG_LIGHTRED}Invalid IPv6 Netmask Value${NOCOLOR})"
# ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE_W_COLOR="(${FG_LIGHTRED}Duplicate IPv6 Address${NOCOLOR})"

ERRMSG_INVALID_IPV6_ADDRESS_NETMASK_FORMAT_NO_COLOR="(Invalid IPv6 Address/Netmask Format)"
ERRMSG_INVALID_IPV6_ADDR_FORMAT_NO_COLOR="(Invalid IPv6 Address Format)"
ERRMSG_INVALID_IPV6_NETMASK_FORMAT_NO_COLOR="(Invalid IPv6 Netmask Value)"
ERRMSG_INVALID_IPV6_GATEWAY_FORMAT_NO_COLOR="(Invalid IPv6 Gateway Format)"
ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE_NO_COLOR="(Duplicate IPv6 Address)"
ERRMSG_INVALID_IPV6_DNS_FORMAT_NO_COLOR="(Invalid IPv6 DNS Format)"
ERRMSG_ONLY_ONE_GATEWAY_ENTRY_ALLOWED_NO_COLOR="(Only *1* gateway entry allowed)"
ERRMSG_IPV46_INPUT_VALUES_ARE_EMPTY_STRINGS="(All IPv4 and IPv6 input values are empty strings)"

ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"



#---PRINTF MESSAGES
PRINTF_CONFIGURE_NETPLAN_WITH_DHCP="CONFIGURE NETPLAN WITH DHCP"
PRINTF_CONFIGURE_NETPLAN_WITH_STATIC_IP_ENTRIES="CONFIGURE NETPLAN WITH STATIC IP ENTRIES"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

PRINTF_APPLYING_NETPLAN="---:APPLYING NETPLAN"
# PRINTF_APPLYING_NETPLAN_SUCCESSFULLY="APPLYING NETPLAN ${FG_GREEN}SUCCESSFULLY${NOCOLOR}"
PRINTF_EXITING_NOW="EXITING NOW..."
PRINTF_FILE="FILE:"
PRINTF_IF_PRESENT_DATA_WILL_BE_LOST="IF PRESENT, DATA WILL BE LOST!"
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

PRINTF_IPV4_ADDRESS_NETMASK="${FG_LIGHTBLUE}IPV4-ADDRESS/NETMASK${NOCOLOR}: "
PRINTF_IPV4_NETMASK="${FG_SOFTLIGHTBLUE}IPV4-NETMASK${NOCOLOR}: "
PRINTF_IPV4_GATEWAY="${FG_LIGHTBLUE}IPV4-GATEWAY${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV4_DNS="${FG_LIGHTBLUE}IPV4-DNS${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV6_ADDRESS_NETMASK="${FG_LIGHTBLUE}IPV6-ADDRESS/NETMASK${NOCOLOR}: "
PRINTF_IPV6_NETMASK="${FG_SOFTLIGHTBLUE}IPV6-NETMASK${NOCOLOR}: "
PRINTF_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR}${NOCOLOR}: "
PRINTF_IPV6_DNS="${FG_LIGHTBLUE}IPV6-DNS${NOCOLOR}${NOCOLOR}: "
PRINTF_YOUR_IPV4_INPUT="YOUR IPV4 INPUT"
PRINTF_YOUR_IPV6_INPUT="YOUR IPV6 INPUT"

PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO="STATIC IPV4 NETWORK INFO"
PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO="STATIC IPV6 NETWORK INFO"
PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_LIGHTRED}IN-ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_GREEN}RUNNING${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_NOT_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_LIGHTRED}NOT${NOCOLOR} RUNNING"



#---QUESTION MESSAGES
QUESTION_ACCEPT_INPUT_VALUES_OR_REDO_INPUT="ACCEPT INPUT VALUES (${FG_YELLOW}y${NOCOLOR}es), or REDO INPUT (${FG_YELLOW}a${NOCOLOR}ll/ipv${FG_YELLOW}4${NOCOLOR}/ipv${FG_YELLOW}6${NOCOLOR}/${FG_YELLOW}q${NOCOLOR}uit)?"
QUESTION_ENABLE_DHCP_INSTEAD_OR_REDO_INPUT="ENABLE ${FG_SOFTLIGHTRED}DHCP${NOCOLOR} INSTEAD (${FG_YELLOW}y${NOCOLOR}es), or REDO INPUT (${FG_YELLOW}a${NOCOLOR}ll/ipv${FG_YELLOW}4${NOCOLOR}/ipv${FG_YELLOW}6${NOCOLOR}/${FG_YELLOW}q${NOCOLOR}uit)?"
QUESTION_ADD_REPLACE_WIFI_ENTRIES="ADD/REPLACE WIFI ENTRIES (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}q${NOCOLOR}uit)?"
QUESTION_ENABLE_DHCP="ENABLE ${FG_SOFTLIGHTRED}DHCP${NOCOLOR} (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}q${NOCOLOR}uit)?"



#---READ INPUT MESSAGES
READ_IPV4_ADDRESS_NETMASK="${FG_SOFTLIGHTBLUE}IPV4/NETMASK${NOCOLOR} (ex: 192.168.1.10/24) (${FG_YELLOW};s${NOCOLOR}kip): "
READ_IPV4_GATEWAY="${FG_LIGHTBLUE}IPV4-GATEWAY${NOCOLOR} (ex: 19.45.7.254) (${FG_YELLOW};b${NOCOLOR}ack): "
READ_IPV4_DNS="${FG_SOFTLIGHTBLUE}IPV4-DNS${NOCOLOR} (ex: 8.8.4.4,8.8.8.8) (${FG_YELLOW};b${NOCOLOR}ack): "
READ_IPV6_ADDRESS_NETMASK="${FG_SOFTLIGHTBLUE}IPV6/NETMASK${NOCOLOR} (ex: 2001:b33f::10/64) (${FG_YELLOW};s${NOCOLOR}kip): "
READ_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR} (ex: 2001:19:46:10::254) (${FG_YELLOW};b${NOCOLOR}ack): "
READ_IPV6_DNS="${FG_SOFTLIGHTBLUE}IPV6-DNS${NOCOLOR} (ex: 8:8:4::8,8:8:8::8) (${FG_YELLOW};b${NOCOLOR}ack): "



#---VARIABLES
define_dynamic_variables__sub()
{
    pattern_four_spaces_wlan="^${ONE_SPACE}{4}${pattern_wlan}"
    pattern_four_spaces_anyString="^${ONE_SPACE}{4}[a-z]"

    errmsg_occured_in_file_wlan_intf_updown="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_intf_updown_filename}${NOCOLOR}"
    errMsg_wpa_supplicant_file_not_found="FILE NOT FOUND: ${FG_LIGHTGREY}${wpaSupplicant_conf_fpath}${NOCOLOR}"

    printf_yaml_adding_dhcpEntries="---:ADDING DHCP ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
    printf_yaml_adding_staticIpEntries="ADDING STATIC IP ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
    printf_yaml_deleting_wifi_entries="---:DELETING WiFi ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"

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

    wlan_inst_filename="tb_wlan_inst.sh"
    wlan_inst_fpath=${current_dir}/${wlan_inst_filename}

    wlan_conn_info_filename="tb_wlan_conn_info.sh"
    wlan_conn_info_fpath=${current_dir}/${wlan_conn_info_filename}

    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

    etc_dir=/etc
    wpaSupplicant_conf_filename="wpa_supplicant.conf"
    wpaSupplicant_conf_fpath="${etc_dir}/${wpaSupplicant_conf_filename}"

    run_netplan_dir=/run/netplan
    wpa_wlan0_conf_filename="wpa-wlan0.conf"
    wpa_wlan0_conf_fpath=${run_netplan_dir}/${wpa_wlan0_conf_filename}

    lib_systemd_system_dir=/lib/systemd/system
    wpa_supplicant_service_filename="wpa_supplicant.service"
    wpa_supplicant_service_fpath=${lib_systemd_system_dir}/${wpa_supplicant_service_filename}

    etc_netplan_dir=${etc_dir}/netplan
    yaml_filename="wlan.yaml"
    if [[ -z ${yaml_fpath} ]]; then #no input provided
        yaml_fpath="${etc_netplan_dir}/${yaml_filename}"    #use the default full-path
    else
        yaml_filename=$(basename ${yaml_fpath})
    fi
}



#---FUNCTIONS
function clear_lines__func() 
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

function isNumeric__func()
{
    #Input args
    local inputVar=${1}

    #Define local variables
    local regEx="^\-?[0-9]*\.?[0-9]+$"
    local stdval_output=${EMPTYSTRING}

    #Check if numeric
    #If TRUE, then 'stdval_output' is NOT EMPTY STRING
    stdval_output=`echo "${inputVar}" | grep -E "${regEx}"`

    if [[ ! -z ${stdval_output} ]]; then    #contains data
        echo ${TRUE}
    else    #contains NO data
        echo ${FALSE}
    fi
}

function convertTo_lowercase__func()
{
    #Input args
    local orgString=${1}

    #Define local variables
    local lowerString=`echo "${orgString}" | sed "s/./\L&/g"`

    #val_output
    echo ${lowerString}
}

function combine_two_strings_with_charSeparator__func
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

    #val_output
    echo ${strCombo}
}

function get_lastTwoChars_of_string__func()
{
    #Input args
    local inputVal=${1}

    #Define local variable
    local last2Chars=`echo ${inputVal: -2}`

    #val_output
    echo ${last2Chars}
}

function checkFor_exactMatch_substr_in_string__func()
{
    #Input args
    local substr=${1}
    local string=${2}

    #Check for Exact Match
    local stdval_output=`echo "${string}" | grep -w "${substr}"`

    if [[ ! -z ${stdval_output} ]]; then
        echo ${TRUE}    #is NOT UNIQUE
    else
        echo ${FALSE}   #is UNIQUE
    fi
}

function debugPrint__func()
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

function successPrint__func()
{
    #Input args
    local successMsg=${1}

    #Print
    printf '%s%b\n' "${FG_GREEN}SUCCESSFULLY${NOCOLOR}: ${successMsg}"
}

function errExit__func() 
{
    #Input args
    local add_leading_emptyLine=${1}
    local errCode=${2}
    local errMsg=${3}
    local show_exitingNow=${4}

    #Set boolean to TRUE
    errExit_isEnabled=${TRUE}

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

function goodExit__func()
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
    echo -e "\033[?25h" #show cursor

    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_CTRL_C_WAS_PRESSED}" "${TRUE}"
}

function checkIf_software_isInstalled__func()
{
    #Input args
    local package_input=${1}

    #Define local constants
    local pattern_packageStatus_installed="ii"

    #Define local 
    local packageStatus=`dpkg -l | grep -w "${package_input}" | awk '{print $1}'`

    #If 'stdval_output' is an EMPTY STRING, then software is NOT installed yet
    if [[ ${packageStatus} == ${pattern_packageStatus_installed} ]]; then #contains NO data
        echo ${TRUE}
    else
        echo ${FALSE}
    fi
}

function moveUp__func() {
    #Input args
    local numOfLines_input=${1}

    #Define variables
    local n=0

    #Move-up
    for ((n=0;n<${numOfLines_input};n++))
    do
        # if [[ ${n} -eq ${numOfLines_input} ]]; then
        #     break
        # fi

        tput cuu1

        n=$((n+1))
    done
}
function moveUp_and_cleanLines__func() {
    #Input args
    local numOfLines_input=${1}

    #Define variables
    local n=0

    #Move-up and clean
    while true
    do
        if [[ ${n} -eq ${numOfLines_input} ]]; then
            break
        fi

        tput cuu1
        tput el

        n=$((n+1))
    done
}
function moveDown_and_cleanLines__func() {
    #Input args
    local numOfLines_input=${1}

    #Define variables
    local n=0

    #Move-down and clean
    while true
    do
        if [[ ${n} -eq ${numOfLines_input} ]]; then
            break
        fi

        tput cud1
        tput el

        n=$((n+1))
    done
}
function moveDown_then_up_and_then_cleanLines__func() {
    #Input args
    local numOfLines_input=${1}

    #Define variables
    local n=0

    #Move-down and clean
    while true
    do
        if [[ ${n} -eq ${numOfLines_input} ]]; then
            break
        fi

        tput cud1
        tput cuu1
        tput el

        n=$((n+1))
    done
}
function moveUp_and_moveRight__func() {
    #Input args
    local numOfLines_input=${1}
    local numOfCols_input=${2}

    #Move-right
    #Define variables
    local n=0

    #Move-up
    while true
    do
        if [[ ${n} -eq ${numOfLines_input} ]]; then
            break
        fi

        tput cuu1

        n=$((n+1))
    done
    
    #Move-right
    tput cuf ${numOfCols_input}
}

function backspace_handler__func() {
    #Input args
    str_input=${1}

    #CHeck if 'str_input' is an EMPTYSTRING
    if [[ -z ${str_input} ]]; then
        return
    fi

    #Constants
    OFFSET=0

    #Lengths
    str_input_len=${#str_input}
    str_output_len=$((str_input_len-1))

    #Get result
    str_output=${str_input:${OFFSET}:${str_output_len}}

    #Output
    echo "${str_output}"
}
function read_handler__func() {
    #Input args
    local msg_input=${1}
    local val_input=${2}

    #Define constants
    local val_output=${EMPTYSTRING}
    local val_output_tot=${val_input}
    local val_output_tot_bck=${val_input}
    local echoMsg=${EMPTYSTRING}
    local echoMsg_wo_color=${EMPTYSTRING}
    local echoMsg_wo_color_len=${EMPTYSTRING}
    local errMsg=${EMPTYSTRING}

    #Hide cursor
    echo -e "\033[?25l"

    while true
    do
        #Update echo message
        echoMsg="${msg_input}${val_output_tot}"

        echo -e "\r"
        #Do NOT use '-e' in the 'echo' command as shown below.
        #Reason:
        #   when using '-e' any leading spaces will be omitted!
        echo "${echoMsg}"

        #Get echo message WITHOUT COLOR notation
        echoMsg_wo_color=$(echo -e "$echoMsg" | sed "s/$(echo -e "\e")[^m]*m//g")
        #Get echo message length WITHOUT COLOR notation
        echoMsg_wo_color_len=${#echoMsg_wo_color}

        #Move cursor up & right
        moveUp_and_moveRight__func "${NUMOF_ROWS_1}" "${echoMsg_wo_color_len}"

#-------Key input
        IFS=''  #this will distinguish ENTER from SPACE, ARROW KEYS
        read -n1 -r -s val_output

        #Move-down
        moveDown_and_cleanLines__func "${NUMOF_ROWS_1}"

        #Move-up
        moveUp__func "${NUMOF_ROWS_1}"

        if [[ -z ${val_output} ]]; then #Enter was pressed
            if [[ ! -z ${val_output_tot} ]]; then
                echo -e "${echoMsg}"

                break
            else
                moveUp__func "${NUMOF_ROWS_1}"
            fi
        else
            if [[ ${val_output} == ${ESCAPEKEY_CHAR} ]]; then #ARROW-KEY Up/DOWN
                read -n1 -t0.01 -r -s tmp   #clear the bracket '['
                read -n1 -t0.01 -r -s tmp   #clear the letters 'A, B, C, or D'

                moveDown_then_up_and_then_cleanLines__func "${NUMOF_ROWS_1}"
            elif [[ ${val_output} == ${BACKSPACE_CHAR} ]]; then
                if [[ ! -z "${val_output_tot}" ]]; then
                    val_output_tot=`backspace_handler__func "${val_output_tot}"`

                    moveDown_then_up_and_then_cleanLines__func "${NUMOF_ROWS_1}"
                fi
            elif [[ ${val_output} == ${TAB_CHAR} ]]; then #TAB input not allowed
                val_output_tot="${val_output_tot}"
            elif [[ ${val_output} == ${SPACE_CHAR} ]]; then #SPACE was pressed
                val_output_tot="${val_output_tot}"
            else
                val_output_tot="${val_output_tot}${val_output}"
            fi

            moveUp__func "${NUMOF_ROWS_1}"
        fi
    done

    #Show cursor
    echo -e "\033[?25h"

    #Output
    if [[ ${msg_input} == ${READ_IPV4_ADDRESS_NETMASK} ]]; then
        ipv4_address_netmask=${val_output_tot}
    elif [[ ${msg_input} == ${READ_IPV4_GATEWAY} ]]; then
        ipv4_gateway=${val_output_tot}
    elif [[ ${msg_input} == ${READ_IPV4_DNS} ]]; then
        ipv4_dns=${val_output_tot}
    elif [[ ${msg_input} == ${READ_IPV6_ADDRESS_NETMASK} ]]; then
        ipv6_address_netmask=${val_output_tot}
    elif [[ ${msg_input} == ${READ_IPV6_GATEWAY} ]]; then
        ipv6_gateway=${val_output_tot}
    elif [[ ${msg_input} == ${READ_IPV6_DNS} ]]; then
        ipv6_dns=${val_output_tot}
    else
        errMsg="An error has occured in func '$0: read_handler__func')"
        printf '%s%b\n' "***${FG_LIGHTRED}ERROR${NOCOLOR}(${errCode}): ${errMsg}"
        errMsg="unknown value '${msg_input}' for input parameter 'msg_input' (func: read_handler__func)"
        printf '%s%b\n' "***${FG_LIGHTRED}ERROR${NOCOLOR}(${errCode}): ${errMsg}"
    fi
}



#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

checkIfisRoot__sub()
{
    local currUser=`whoami`
    local ROOTUSER="root"

    if [[ ${currUser} != ${ROOTUSER} ]]; then   #not root
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_USER_IS_NOT_ROOT}" "${TRUE}"    
    fi
}

init_variables__sub()
{
    show_prePostCheck_ConnectInfo__isDisabled=${FALSE}
    isAllowed_toChange_netplan=${TRUE}
    errExit_isEnabled=${TRUE}
    exitCode=0

    check_missing_isFound=${FALSE}
    check_netplanConfig_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_netplanDaemon_failedToRun_isFound=${FALSE}

    ipv4_address_netmask=${EMPTYSTRING}
	ipv4_address_netmask_clean=${EMPTYSTRING}
    ipv4_gateway=${EMPTYSTRING}
	ipv4_gateway_clean=${EMPTYSTRING}
	ipv4_dns=${EMPTYSTRING}
	ipv4_dns_clean=${EMPTYSTRING}
    ipv4_address_isValid=${FALSE}
    ipv4_netmask_isValid=${FALSE}
    ipv4_gateway_isValid=${FALSE}
    ipv4_dns_isValid=${EMPTYSTRING}

    ipv6_address_netmask=${EMPTYSTRING}
	ipv6_address_netmask_clean=${EMPTYSTRING}
    ipv6_gateway=${EMPTYSTRING}
	ipv6_gateway_clean=${EMPTYSTRING}
	ipv6_dns=${EMPTYSTRING}
	ipv6_dns_clean=${EMPTYSTRING}
    ipv6_address_isValid=${FALSE}
    ipv6_netmask_isValid=${FALSE}
    ipv6_gateway_isValid=${FALSE}
    ipv6_dns_isValid=${EMPTYSTRING}    

    ipv4_address_netmask_accept=${EMPTYSTRING}
    ipv4_gateway_accept=${EMPTYSTRING}
    ipv4_dns_accept=${EMPTYSTRING}
    ipv6_address_netmask_accept=${EMPTYSTRING}
    ipv6_gateway_accept=${EMPTYSTRING}
    ipv6_dns_accept=${EMPTYSTRING}

    lastTwoChars=${EMPTYSTRING}
    match_isFound=${EMPTYSTRING}
    myChoice=${EMPTYSTRING}
    numOf_entries=0
    ssid=${EMPTYSTRING}
    ssidPasswd=${EMPTYSTRING}
    ssidScan_isFound=${FALSE}
    trapDebugPrint_isEnabled=${TRUE}
    netplan_toBeDeleted_targetLineNum=0
    netplan_toBeDeleted_numOfLines=0
}


input_args_case_select__sub()
{
    #Define local variable
    local arg1_isNumeric=`isNumeric__func "${arg1}"`

    case "${arg1}" in
        --help | -h | ${QUESTION_CHAR})
            #Somehow when a one-digit numeric value is inputted...
            #...the FIRST case-item is selected.
            #To counteract this behaviour the following condition is used
            if [[ ${arg1_isNumeric} == ${FALSE} ]]; then
               input_args_print_info__sub
            else
                input_args_print_unknown_option__sub
            fi
            
            exit 0
            ;;

        --version | -v)
            input_args_print_version__sub

            exit 0
            ;;

        ${TRUE})
            show_prePostCheck_ConnectInfo__isDisabled=${TRUE}
            ;;

        *)
            if [[ ${argsTotal} -eq 0 ]]; then   #no input arg provided
                input_args_print_usage__sub
            elif [[ ${argsTotal} -eq 1 ]]; then #1 input arg provided
                input_args_print_unknown_option__sub

                exit 0
            elif [[ ${argsTotal} -gt ${ARGSTOTAL_MIN} ]]; then  #at more than 1 input arg provided
                if [[ ${argsTotal} -ne ${ARGSTOTAL_MAX} ]]; then    #not all input args provided
                    input_args_print_incomplete_args__sub

                    exit 0
                else    #all input args provided
                    input_args_handling__sub
                fi
            fi
            ;;
    esac
}

input_args_handling__sub()
{
    ipv4_address=${EMPTYSTRING}
    ipv4_netmask=${EMPTYSTRING}
    ipv4_gateway=${EMPTYSTRING}
    ipv4_dns=${EMPTYSTRING}

    ipv6_address=${EMPTYSTRING}
    ipv6_netmask=${EMPTYSTRING}
    ipv6_gateway=${EMPTYSTRING}
    ipv6_dns=${EMPTYSTRING}    

    #Convert to 'lowercase'
    input_args_convertTo_lowercase__sub

    #Check if input args contain the value 'dhcp'
    #If TRUE, set 'dhcp_isSelected = TRUE'
    input_args_checkIf_dhcp_isSet__sub
}

input_args_convertTo_lowercase__sub()
{
    #Convert 'ipv4_addrNetmask_input' to LOWERCASE (regardless the input value)
    ipv4_addrNetmask_input=`convertTo_lowercase__func "${ipv4_addrNetmask_input}"`

    #Convert 'ipv4_gateway_input' to LOWERCASE (regardless the input value)
    ipv4_gateway_input=`convertTo_lowercase__func "${ipv4_gateway_input}"`

    #Convert 'ipv4_dns_input' to LOWERCASE (regardless the input value)
    ipv4_dns_input=`convertTo_lowercase__func "${ipv4_dns_input}"`

    #Convert 'ipv6_addrNetmask_input' to LOWERCASE (regardless the input value)
    ipv6_addrNetmask_input=`convertTo_lowercase__func "${ipv6_addrNetmask_input}"`

    #Convert 'ipv6_gateway_input' to LOWERCASE (regardless the input value)
    ipv6_gateway_input=`convertTo_lowercase__func "${ipv6_gateway_input}"`

    #Convert 'ipv6_dns_input' to LOWERCASE (regardless the input value)
    ipv6_dns_input=`convertTo_lowercase__func "${ipv6_dns_input}"`
}

input_args_checkIf_dhcp_isSet__sub()
{
    #Define local variables
    local count_dhcp_isTrue=0
    local debugMsg=${EMPTYSTRING}

    #Check if all 5 input args (arg3 to arg8) contain the 'dhcp' value
    #If TRUE, then:
    #1. set 'dhcp_isSelected = TRUE'
    #2. exit function
    if [[ "${ipv4_addrNetmask_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    if [[ "${ipv4_gateway_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    if [[ "${ipv4_dns_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    if [[ "${ipv6_addrNetmask_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    if [[ "${ipv6_gateway_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    if [[ "${ipv6_dns_input}" =~ .*"${PATTERN_DHCP}"* ]]; then   #does contain TRUE
        count_dhcp_isTrue=$((count_dhcp_isTrue+1))
    fi

    #DHCP or STATIC
    if [[ ${count_dhcp_isTrue} -gt 0 ]]; then   #at least one input arg is set to 'dhcp'
        if [[ ${count_dhcp_isTrue} -eq ${ARGSTOTAL_IP_RELATED} ]]; then #all input args are set to 'dhcp'
            dhcp_isSelected=${TRUE} #IMPORTANT: set boolean to TRUE

            debugMsg=${PRINTF_CONFIGURE_NETPLAN_WITH_DHCP}
        else    #not all input args are set to 'dhcp'
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_SET_ALL_IP_RELATED_INPUT_ARGS_TO_DHCP}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"     
        fi
    else    #no input arg is set to 'dhcp'
        dhcp_isSelected=${FALSE}    #IMPORTANT: set boolean to FALSE

        debugMsg=${PRINTF_CONFIGURE_NETPLAN_WITH_STATIC_IP_ENTRIES}
    fi


    #Print message
    debugPrint__func "${PRINTF_UPDATE}" "${debugMsg}" "${EMPTYLINES_1}"    
}

input_args_print_usage__sub()
{
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_INTERACTIVE_MODE_IS_ENABLED}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_FOR_HELP_PLEASE_RUN}" "${EMPTYLINES_0}"
}

input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_incomplete_args__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNMATCHED_INPUT_ARGS}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_info__sub()
{
    debugPrint__func "${PRINTF_DESCRIPTION}" "${PRINTF_USAGE_DESCRIPTION}" "${EMPTYLINES_1}"

    local usageMsg=(
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\" \"${FG_LIGHTPINK}arg3${NOCOLOR}\" \"${FG_LIGHTGREY}arg4${NOCOLOR}\" \"${FG_LIGHTPINK}arg5${NOCOLOR}\" \"${FG_LIGHTPINK}arg6${NOCOLOR}\" \"${FG_LIGHTGREY}arg7${NOCOLOR}\" \"${FG_LIGHTPINK}arg8${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}WiFi-interface (e.g. wlan0)."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}Path-to Netplan configuration file (e.g. /etc/netplan/*.yaml)."
        "${FOUR_SPACES}arg3${TAB_CHAR}${TAB_CHAR}IPv4 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}192.168.1.10${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}24${NOCOLOR})."
        "${FOUR_SPACES}arg4${TAB_CHAR}${TAB_CHAR}IPv4 gateway (e.g. 192.168.1.254)."
        "${FOUR_SPACES}arg5${TAB_CHAR}${TAB_CHAR}IPv4 DNS (e.g., 8.8.8.8${FG_SOFTLIGHTRED},${NOCOLOR}8.8.4.4)."
        "${FOUR_SPACES}arg6${TAB_CHAR}${TAB_CHAR}IPv6 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}2001:beef::15:5${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}64${NOCOLOR})."
        "${FOUR_SPACES}arg7${TAB_CHAR}${TAB_CHAR}IPv6 gateway (e.g. 2001:beef::15:900d)."
        "${FOUR_SPACES}arg8${TAB_CHAR}${TAB_CHAR}IPv6 DNS (e.g., 2001:4860:4860::8888${FG_SOFTLIGHTRED},${NOCOLOR}2001:4860:4860::8844)."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFTLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFTLIGHTRED}\"${NOCOLOR} each argument."
        "${FOUR_SPACES}- Some arguments (${FG_LIGHTPINK}arg4${NOCOLOR},${FG_LIGHTPINK}arg5${NOCOLOR},${FG_LIGHTPINK}arg6${NOCOLOR},${FG_LIGHTPINK}arg8${NOCOLOR}) allow multiple input values separated by a comma-separator (${FG_SOFTLIGHTRED},${NOCOLOR})."
        "${FOUR_SPACES}- If DHCP is used, please set argruments arg3, arg4, arg5, arg6, arg7, and arg8 to ${FG_SOFTLIGHTRED}dhcp${NOCOLOR}"
    )

    printf "%s\n" ""
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${EMPTYLINES_1}"
    
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
}

preCheck_handler__sub()
{
    #Define local constants
    local PRINTF_PRECHECK="${FG_PURPLERED}PRE${NOCOLOR}${FG_ORANGE}-CHECK:${NOCOLOR}"
    local PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES="STATUS OF MODULES/SOFTWARE/SERVICES"

    #Reset variable
    check_missing_isFound=${FALSE}
    check_netplanConfig_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_netplanDaemon_failedToRun_isFound=${FALSE}

    #Print
    debugPrint__func "${PRINTF_PRECHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Pre-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func "${PATTERN_IW}"
    software_preCheck_isInstalled__func "${PATTERN_WIRELESS_TOOLS}"
    software_preCheck_isInstalled__func "${PATTERN_WPASUPPLICANT}"
    intf_preCheck_isPresent__func
    services_preCheck_isPresent_isEnabled_isActive__func "${wpa_supplicant_service_filename}"
    # wlan_preCheck_isConfigured__func
    daemon_preCheck_isRunning__func "${wpaSupplicant_conf_fpath}"
    daemon_preCheck_isRunning__func "${wpa_wlan0_conf_fpath}"
}
function mods_preCheck_arePresent__func()
{
    #Define local constants
    local PRINTF_STATUS_MOD="STATUS(MOD):"

    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}

    #Check if module 'bcmdhd' is present
    local stdval_output=`${LSMOD_CMD} | grep ${MODPROBE_BCMDHD}`
    if [[ ! -z ${stdval_output} ]]; then    #module is present
        printf_toBeShown="${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}"
    else    #module is NOT present
        printf_toBeShown="${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE
    fi
    debugPrint__func "${PRINTF_STATUS_MOD}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function software_preCheck_isInstalled__func() 
{
    #Input args
    local software_input=${1}

    #Define local constants
    local PRINTF_STATUS_SOF="STATUS(SOF):"

    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}
    local statusVal=${EMPTYSTRING}
    
    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${software_input}"`
    if [[ ${software_isPresent} == ${TRUE} ]]; then
        statusVal="${FG_GREEN}${CHECK_OK}${NOCOLOR}" 
    else
        check_missing_isFound=${TRUE}   #set boolean to TRUE
        
        statusVal="${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
    fi
    printf_toBeShown="${FG_LIGHTGREY}${software_input}${NOCOLOR}: ${statusVal}"
    debugPrint__func "${PRINTF_STATUS_SOF}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function intf_preCheck_isPresent__func() {
    #Define local constants
    local PRINTF_STATUS_PER="STATUS(PER):"
    local INTF="Intf"

    #Define local variables
    local wlanIntf=${EMPTYSTRING}
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}

    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_IW}"`
    if [[ ${software_isPresent} == ${FALSE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${INTF}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE       

        return
    fi

    #Get ALL available WLAN interface
    wlanList_string=`{ ${IW_CMD} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | xargs -n 1 | sort -u | xargs; } 2> /dev/null`
    if [[ -z ${wlanList_string} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${INTF}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE       

        return
    fi

    #Convert string to array
    eval "wlanList_array=(${wlanList_string})"

    #Show available BT-interface(s)
    for wlanList_arrayItem in "${wlanList_array[@]}"
    do
        if [[ -z ${wlanIntf} ]]; then
            wlanIntf=${wlanList_arrayItem}
        else
            wlanIntf="${wlanIntf}, ${btList_arrayItem}"
        fi
    done   


    #Print
    printf_toBeShown="${FG_LIGHTGREY}${INTF}${NOCOLOR}: ${FG_GREEN}${wlanIntf}${NOCOLOR}"
    debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function services_preCheck_isPresent_isEnabled_isActive__func()
{
    #Input args
    local service_input=${1}  

    #Define local constants
    local PRINTF_STATUS_SRV="STATUS(SRV):"

    local FOUR_DOTS="...."
    local EIGHT_DOTS=${FOUR_DOTS}${FOUR_DOTS}
    local TWELVE_DOTS=${FOUR_DOTS}${EIGHT_DOTS}


    #Check if the services are present
    #REMARK: if a service is present then it means that...
    #........its corresponding variable would CONTAIN DATA.
    local printf_toBeShown=${EMPTYSTRING}
    local service_isPresent=${FALSE}
    local service_isEnabled_val=${FALSE}
    local service_isActive_val=${FALSE}
    local statusVal=${EMPTYSTRING}

    #Print
    # printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}:"
    # debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #systemctl status <service>
    #All services should be always present after the Bluetooth Installation
    service_isPresent=`checkIf_service_isPresent__func "${service_input}"`
    if [[ ${service_isPresent} == ${TRUE} ]]; then  #service is present
        printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    else    #service is NOT present
        check_missing_isFound=${TRUE}   #set boolean to TRUE
        
        # clear_lines__func "${NUMOF_ROWS_1}"

        printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        return  #exit function
    fi
    

    #systemctl is-enabled <service>
    service_isEnabled_val=`checkIf_service_isEnabled__func "${service_input}"`  #check if 'is-enabled'
    if [[ ${service_isEnabled_val} == ${TRUE} ]]; then  #service is enabled
        statusVal=${FG_GREEN}${CHECK_ENABLED}${NOCOLOR}
    else    #service is NOT enabled
        check_failedToEnable_isFound=${TRUE}

        statusVal=${FG_LIGHTRED}${CHECK_DISABLED}${NOCOLOR}
    fi
    printf_toBeShown="${FG_LIGHTGREY}${EIGHT_DOTS}${NOCOLOR}${statusVal}"
    debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"


    #systemctl is-active <service>
    service_isActive_val=`checkIf_service_isActive__func "${service_input}"`  #check if 'is-active'
    if [[ ${service_isActive_val} == ${TRUE} ]]; then   #service is started
        statusVal=${FG_GREEN}${CHECK_RUNNING}${NOCOLOR}
    else    #service is NOT started
        check_failedToStart_isFound=${TRUE}

        statusVal=${FG_LIGHTRED}${CHECK_STOPPED}${NOCOLOR}
    fi
    printf_toBeShown="${FG_LIGHTGREY}${EIGHT_DOTS}${NOCOLOR}${statusVal}"  
    debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function checkIf_service_isPresent__func()
{
    #Input args
    local service_input=${1}

    #Check if service is enabled
    local stdval_output=`${SYSTEMCTL_CMD} ${STATUS} ${service_input} 2>&1 | grep "${PATTERN_COULD_NOT_BE_FOUND}"`
    if [[ -z ${stdval_output} ]]; then #contains NO data (service is present)
        echo ${TRUE}
    else    #service is NOT enabled
        echo ${FALSE}
    fi
}
function checkIf_service_isEnabled__func()
{
    #Input args
    local service_input=${1}

    #Check if service is enabled
    local service_activeState=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${service_input} 2>&1`
    if [[ ${service_activeState} == ${ENABLED} ]]; then    #service is enabled
        echo ${TRUE}
    else    #service is NOT enabled
        echo ${FALSE}
    fi
}
function checkIf_service_isActive__func()
{
    #Input args
    local service_input=${1}

    #Check if service is active (in other words, running)
    local service_activeState=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${service_input} 2>&1`
    if [[ ${service_activeState} == ${ACTIVE} ]]; then    #service is running
        echo ${TRUE}
    else    #service is NOT running
        echo ${FALSE}
    fi
}
function wlan_preCheck_isConfigured__func()
{
    #Define local constants
    local PRINTF_STATUS_CFG="STATUS(CFG):"

    local CHAR_ASTERISK="*"
    local HIDDEN="hidden"
    local FIELDNAME_SSID="ssid"
    local FIELDNAME_PASSWORD="password"
    local WPA="wpa"

    local FOUR_DOTS="...."
    local EIGHT_DOTS=${FOUR_DOTS}${FOUR_DOTS}
    local TWELVE_DOTS=${FOUR_DOTS}${EIGHT_DOTS}


    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}
    local repetitive_template=${EMPTYSTRING}
    local wpa_ssid=${EMPTYSTRING}
    local wpa_ssidScan_isFound=${EMPTYSTRING}
    local wpa_ssidPasswd=${EMPTYSTRING}
    local wpa_ssidPasswd_len=0
    local netplan_ssid=${EMPTYSTRING}
    local netplan_ssidScan_isFound=${EMPTYSTRING}
    local netplan_ssidPasswd=${EMPTYSTRING}
    local netplan_ssidPasswd_len=0
    local statusVal=${EMPTYSTRING}


#---WPA_SUPPLICANT
    #Print
    # printf_toBeShown="${FG_LIGHTGREY}${wpaSupplicant_conf_filename}${NOCOLOR}:"
    # debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #Check if 'wpa_supplicant.conf' does exist
    if [[ ! -f ${wpaSupplicant_conf_fpath} ]]; then #file does NOT exist
        #Set boolean to TRUE
        check_missing_isFound=${TRUE}

        #wpa_supplicant.conf: set to N/A
        printf_toBeShown="${FG_LIGHTGREY}${wpaSupplicant_conf_filename}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    
        #ssid: set to N/A
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_SSID}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #password: set to N/A
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_PASSWORD}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    else    #file does exist
        #wpa_supplicant.conf: set to N/A
        printf_toBeShown="${FG_LIGHTGREY}${wpaSupplicant_conf_filename}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #Retrieve SSID
        wpa_ssid=`cat ${wpaSupplicant_conf_fpath} | grep -w "${PATTERN_SSID}" | cut -d"\"" -f2 2>&1`
        if [[ ! -z ${wpa_ssid} ]]; then #contains data
            #Check if 'scan_ssid=1' is present in file 'wpa_supplicant.conf'=
            wpa_ssidScan_isFound=`cat ${wpaSupplicant_conf_fpath} | grep -w "${SCAN_SSID_IS_1}"`
            if [[ ! -z ${wpa_ssidScan_isFound} ]]; then #SSID is hidden
                statusVal="${FG_GREEN}${wpa_ssid}${NOCOLOR} (${FG_LIGHTGREY}${HIDDEN}${NOCOLOR})"
            else    #SSID is NOT hidden
                statusVal=${FG_GREEN}${wpa_ssid}${NOCOLOR}
            fi
        else    #contains NO data
            statusVal=${EMPTYSTRING}
        fi
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_SSID}${NOCOLOR}: ${statusVal}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #Retrieve Password
        wpa_ssidPasswd=`cat ${wpaSupplicant_conf_fpath} | grep -w "${PATTERN_PSK}" | cut -d"\"" -f2 2>&1`
        if [[ ! -z ${wpa_ssidPasswd} ]]; then   #contains data
            wpa_ssidPasswd_len=${#wpa_ssidPasswd}   #get string-length
            repetitive_template=$(printf "%-${wpa_ssidPasswd_len}s" "${CHAR_ASTERISK}")  #calculate the number of times to repeat a char

            statusVal=$(echo "${repetitive_template// /*}")
        else    #contains NO data
            statusVal=${EMPTYSTRING}
        fi
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_PASSWORD}${NOCOLOR}: ${statusVal}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi


#---NETPLAN
    #Print
    # printf_toBeShown="${FG_LIGHTGREY}${yaml_filename}${NOCOLOR}:"
    # debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #Check if '*.yaml' does exist
    if [[ ! -f ${yaml_fpath} ]]; then #file does NOT exist
        #Set boolean to TRUE
        check_netplanConfig_missing_isFound=${TRUE}
        
        #*.yaml: set to N/A
        printf_toBeShown="${FG_LIGHTGREY}${yaml_filename}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #ssid: set to N/A
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_SSID}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #password: set to N/A
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_PASSWORD}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    else
        #wpa_supplicant.conf: set to N/A
        printf_toBeShown="${FG_LIGHTGREY}${yaml_filename}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #Check if 'wpa_ssid' value is present in '*.yaml'
        if [[ ! -z ${wpa_ssid} ]]; then #contains data
            netplan_ssid=`cat ${yaml_fpath} | grep -w "${wpa_ssid}" 2>&1`
            if [[ ! -z ${netplan_ssid} ]]; then #contains data
                netplan_ssid=${wpa_ssid}    #set 'netplan_ssid' to 'wpa_ssid' value

                #Check if 'scan_ssid=1' is present in '*.yaml'
                netplan_ssidScan_isFound=`cat ${yaml_fpath} | grep -w "${SCAN_SSID_IS_1}"`
                if [[ ! -z ${netplan_ssidScan_isFound} ]]; then #SSID is hidden
                    statusVal="${FG_GREEN}${netplan_ssid}${NOCOLOR} (${FG_LIGHTGREY}${HIDDEN}${NOCOLOR})"
                else    #SSID is NOT hidden
                    statusVal=${FG_GREEN}${netplan_ssid}${NOCOLOR}
                fi
            else    #contains NO data
                #Set boolean to TRUE
                check_netplanConfig_missing_isFound=${TRUE}

                statusVal="${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
            fi
        else    #contains NO data
            statusVal="${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        fi

        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_SSID}${NOCOLOR}: ${statusVal}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        #Check if 'wpa_ssidPasswd' value is present in '*.yaml'
        if [[ ! -z ${wpa_ssidPasswd} ]]; then #contains data
            netplan_ssidPasswd=`cat ${yaml_fpath} | grep -w "${wpa_ssidPasswd}"`
            if [[ ! -z ${netplan_ssidPasswd} ]]; then   #contains data
                netplan_ssidPasswd=${wpa_ssidPasswd}    #set variable to 'wpa_ssidPasswd' value

                netplan_ssidPasswd_len=${#netplan_ssidPasswd}   #get string-length
                repetitive_template=$(printf "%-${netplan_ssidPasswd_len}s" "${CHAR_ASTERISK}")  #calculate the number of times to repeat a char

                statusVal=$(echo "${repetitive_template// /*}")
            else    #contains NO data
                check_netplanConfig_missing_isFound=${TRUE}

                statusVal="${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
            fi
        else    #contains NO data
            statusVal="${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        fi
        printf_toBeShown="${EIGHT_DOTS}${FG_LIGHTGREY}${FIELDNAME_PASSWORD}${NOCOLOR}: ${statusVal}"
        debugPrint__func "${PRINTF_STATUS_CFG}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi
}
function daemon_preCheck_isRunning__func()
{
    #Input args
    local configFpath_input=${1}

    #Define local constants
    local PRINTF_STATUS_DAE="STATUS(DAE):"
    local WPA_SUPPLICANT_DAEMON="wpa_supplicant daemon"
    local NEPLAN_DAEMON="netplan daemon"

    #Define local variables
    local fieldName=${EMPTYSTRING}
    local ps_pidList_string=${EMPTYSTRING}
    local statusVal=${EMPTYSTRING}

    #Check if wpa_supplicant test daemon is running
    #REMARK:
    #TWO daemons could be running:
    #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
    #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
    if [[ ! -f ${configFpath_input} ]]; then  #file does NOT exist
        check_netplanDaemon_failedToRun_isFound=${TRUE}

        statusVal=${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}
    else    #file does exist
        ps_pidList_string=`ps axf | grep -E "${configFpath_input}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            statusVal=${FG_GREEN}${CHECK_RUNNING}${NOCOLOR}
        else    #daemon is NOT running
            #Only 'SET FLAG' for 'netplan daemon'
            if [[ ${configFpath_input} == ${wpa_wlan0_conf_fpath} ]]; then  #netplan daemon
                check_netplanDaemon_failedToRun_isFound=${TRUE}
            fi

            if [[ ${configFpath_input} == ${wpa_wlan0_conf_fpath} ]]; then  #netplan daemon
                statusVal=${FG_LIGHTRED}${CHECK_STOPPED}${NOCOLOR}
            else    #wpa_supplicant daemon (this info is NOT mandatory)
                statusVal=${CHECK_STOPPED}
            fi
        fi
    fi

    #Determine the 'field-name'
    if [[ ${configFpath_input} == ${wpaSupplicant_conf_fpath} ]]; then
        fieldName="${FG_LIGHTGREY}${WPA_SUPPLICANT_DAEMON}${NOCOLOR}:"
    else
        fieldName="${FG_LIGHTGREY}${NEPLAN_DAEMON}${NOCOLOR}:"
    fi

    printf_toBeShown="${fieldName} ${statusVal}"  
    debugPrint__func "${PRINTF_STATUS_DAE}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}

wlan_intf_selection__sub()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
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
    # wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1 2>&1` (OLD CODE)
    wlanList_string=`{ ${IW_CMD} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

    #Check if 'wlanList_string' contains any data
    if [[ -z $wlanList_string ]]; then  #contains NO data
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

get_wifi_pattern__sub()
{
    #Get 'pattern_wlan'
    pattern_wlan=`echo ${wlanSelectIntf} | sed -e "s/[0-9]*$//"`

    # #Define local variables
    # local arrNum=0
    # local pattern_wlan_string=${EMPTYSTRING}
    # local pattern_wlan_array=()
    # local pattern_wlan_arrayLen=0
    # local pattern_wlan_arrayItem=${EMPTYSTRING}
    # local seqNum=0

    # #Get all wifi interfaces
    # #EXPLANATION:
    # #   grep "${IEEE_80211}": find a match for 'IEEE 802.11'
    # #   grep "${PATTERN_INTERFACE}": find a match for 'Interface
    # #   awk '{print $1}': get the first column
    # #   sed -e "s/[0-9]*$//": exclude all numeric values from string starting from the end '$'
    # #   xargs -n 1: convert string to array
    # #   sort -u: get unique values
    # #   xargs: convert back to string
    # pattern_wlan_string=`{ ${IW} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | sed -e "s/[0-9]*$//" | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

    # #Convert from String to Array
    # eval "pattern_wlan_array=(${pattern_wlan_string})"

    # #Get Array Length
    # pattern_wlan_arrayLen=${#pattern_wlan_array[*]}

    # #Select wlan-pattern
    # if [[ ${pattern_wlan_arrayLen} -eq 1 ]]; then
    #      pattern_wlan=${pattern_wlan_array[0]}
    # else
    #     #Show available WLAN interface
    #     printf '%s%b\n' ""
    #     printf '%s%b\n' "${FG_ORANGE}AVAILABLE WLAN PATTERNS:${NOCOLOR}"
    #     for pattern_wlan_arrayItem in "${pattern_wlan_array[@]}"; do
    #         seqNum=$((seqNum+1))    #increment sequence number

    #         printf '%b\n' "${EIGHT_SPACES}${seqNum}. ${pattern_wlan_arrayItem}"   #print
    #     done

    #     #Print empty line
    #     printf '%s%b\n' ""
        
    #      #Save cursor position
    #     tput sc

    #     #Choose WLAN interface
    #     while true
    #     do
    #         read -N1 -p "${FG_LIGHTBLUE}Your choice${NOCOLOR}: " myChoice

    #         if [[ ${myChoice} =~ [1-9,0] ]]; then
    #             if [[ ${myChoice} -ne ${ZERO} ]] && [[ ${myChoice} -le ${seqNum} ]]; then
    #                 arrNum=$((myChoice-1))   #get array-number based on the selected sequence-number

    #                 pattern_wlan=${pattern_wlan_array[arrNum]}  #get array-item

    #                 printf '%s%b\n' ""  #print an empty line

    #                 break
    #             else
    #                 clear_lines__func ${NUMOF_ROWS_0}

    #                 tput rc #restore cursor position
    #             fi
    #         else
    #             if [[ ${myChoice} == ${ENTER_CHAR} ]]; then
    #                 clear_lines__func ${NUMOF_ROWS_1}
    #             else
    #                 clear_lines__func ${NUMOF_ROWS_0}

    #                 tput rc #restore cursor position
    #             fi
    #         fi
    #     done
    # fi
}

function toggle_intf__func()
{
    #Input arg
    local set_wifi_intf_to=${1}

    #Run script 'tb_wlan_stateconf.sh'
    #IMPORTANT: set interface to 'UP'
    #REMARK: this is required for the 'iwlist' scan to get the SSID-list
    ${wlan_intf_updown_fpath} "${wlanSelectIntf}" "${set_wifi_intf_to}" "${yaml_fpath}"
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_occured_in_file_wlan_intf_updown}" "${TRUE}"
    fi  
}

function netplan_print_retrieve_main__func()
{
    #Define local variables
    local doNot_read_yaml=${FALSE}
    local stdval_output=${EMPTYSTRING}

    #Initialization
    netplan_toBeDeleted_targetLineNum=0   #reset parameter
    netplan_toBeDeleted_numOfLines=0    #reset parameter

    #Check if file '*.yaml' is present
    if [[ ! -f ${yaml_fpath} ]]; then
        debugPrint__func "${PRINTF_INFO}" "${printf_yaml_file_not_found}" "${EMPTYLINES_1}" #print

        return  #exit function
    fi

    #Check if 'line' contains the string 'wlanSelectIntf' (e.g. wlan0)
    stdval_output=`cat ${yaml_fpath} | grep "${wlanSelectIntf}" 2>&1`
    if [[ -z ${stdval_output} ]]; then  #contains NO data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_not_found}" "${EMPTYLINES_1}" #print

        netplan_toBeDeleted_targetLineNum=0   #reset parameter
        netplan_toBeDeleted_numOfLines=0    #reset parameter

        #Set boolean to TRUE
        #REMARK: this means SKIP READING of file '*.yaml'
        doNot_read_yaml=${TRUE}
    else    #contains data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_found}" "${EMPTYLINES_1}" #print
    fi

    #REMARK: if TRUE, then skip
    if [[ ${doNot_read_yaml} == ${FALSE} ]]; then
        netplan_print_retrieve_toBeDeleted_lines__func
    fi

    #Check if there are any lines to be deleted.
    #If NONE, then exit function.
    if [[ ${netplan_toBeDeleted_numOfLines} -eq 0 ]]; then
        return
    fi

    #In case all of the above if-conditions have been skipped...
    #...show question
    #val_output: isAllowed_toChange_netplan
    netplan_question_add_replace_wifi_entries__func
}
function netplan_print_retrieve_toBeDeleted_lines__func()
{
    #Define local variables
    local line=${EMPTYSTRING}
    local lineNum=1
    local stdval_output=${EMPTYSTRING}

    #Initialize variables
    netplan_toBeDeleted_targetLineNum=0
    netplan_toBeDeleted_numOfLines=0

    #Read each line of '*.yaml'
    #IMPORTANT ADDITION:
    #With the addition of '|| [ -n "$line" ]', the lines which does NOT END...
    #...with a 'new line (\n)' will also be read
    IFS=""  #use this command to KEEP LEADING SPACES (IMPORTANT)
    while read -r line || [ -n "$line" ]
    do
        # Check if 'line' contains the string 'wifis'
        # stdval_output=`echo ${line} | grep "${PATTERN_WIFIS}"`
        # if [[ ! -z ${stdval_output} ]]; then  #'wifis' string is found
        #     debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print
        # fi

        #Check if 'line' contains the string 'wlawlanSelectIntfnx' (e.g. wlan0)
        stdval_output=`echo ${line} | grep "${wlanSelectIntf}" 2>&1`
        if [[ ! -z ${stdval_output} ]]; then  #'wlanx' is found (with x=0,1,2,...)
            debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print

            netplan_toBeDeleted_targetLineNum=${lineNum}    #update value (which will be used later on to delete these entries)

            netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))    #increment parameter
        else
            #This condition ONLY APPLIES once a match for 'wlanSelectIntf' is found.
            #In other words: 'netplan_toBeDeleted_targetLineNum > 0'
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
            if [[ ${netplan_toBeDeleted_targetLineNum} -gt 0 ]]; then
                #Check if 'line' contains 'pattern_four_spaces_anyString'
                stdval_output=`echo ${line} | egrep "${pattern_four_spaces_anyString}"`
                if [[ -z ${stdval_output} ]]; then #match NOT found
                    debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print

                    netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))    #increment parameter
                else    #match is found
                    break
                fi
            fi
        fi

        #Increment line-number
        lineNum=$((lineNum+1))
    done < "${yaml_fpath}"
}
function netplan_question_add_replace_wifi_entries__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
        isAllowed_toChange_netplan=${TRUE} #set boolean to TRUE

        return
    fi

    #Show 'read-input message'
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_REPLACE_WIFI_ENTRIES}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_WARNING}" "${PRINTF_IF_PRESENT_DATA_WILL_BE_LOST}" "${EMPTYLINES_0}"

    #Ask if user wants to connec to a WiFi AccessPoint
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n,q] ]]; then
            clear_lines__func ${NUMOF_ROWS_2}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_REPLACE_WIFI_ENTRIES} ${myChoice}" "${EMPTYLINES_0}"
            debugPrint__func "${PRINTF_WARNING}" "${PRINTF_IF_PRESENT_DATA_WILL_BE_LOST}" "${EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    
    #Take action based on 'myChoice'
    if [[ ${myChoice} == ${INPUT_QUIT} ]]; then
        exit 0
    elif [[ ${myChoice} == ${INPUT_NO} ]]; then
        isAllowed_toChange_netplan=${FALSE}
    else
        isAllowed_toChange_netplan=${TRUE}
    fi    
}

function netplan_add_header_entries__func()
{
    #Define local variables
    local dhcp_header_entry1=${EMPTYSTRING}
    local dhcp_header_entry2=${EMPTYSTRING}
    local dhcp_header_entry3=${EMPTYSTRING}

    #Set Netplan header entries
    dhcp_header_entry1="network:"
    dhcp_header_entry2="  version: 2"
    dhcp_header_entry3="  renderer: networkd"

    #Write to file
    debugPrint__func "${PRINTF_ADDING}" "${dhcp_header_entry1}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_header_entry1}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_header_entry2}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_header_entry2}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_header_entry3}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_header_entry3}" >> ${yaml_fpath}    #write to file
}

function netplan_del_wlan_entries__func()
{
    #Define local variables
    local lineDeleted_count=0
    local lineDeleted=${EMPTYSTRING}
    local numOf_wlanIntf=0

    #Check if file '*.yaml' is present
    #If FALSE, then exit function
    if [[ ! -f ${yaml_fpath} ]]; then
        return  #exit function
    fi

    #Check the number of lines to be deleted
    if [[ ${netplan_toBeDeleted_numOfLines} -eq 0 ]]; then    #no lines to be deleted
        return
    else    #there are lines to be deleted
        #Check the number of configured wlan-interfaces in '*.yaml'
        numOf_wlanIntf=`cat ${yaml_fpath} | egrep "${pattern_four_spaces_wlan}" | wc -l`

        if [[ ${numOf_wlanIntf} -eq 1 ]]; then  #only 1 interface configured
            #In this case DECREMENT 'netplan_toBeDeleted_targetLineNum' by 1:
            #This means move-up 1 line-number, because entry 'wifis' also HAS TO BE REMOVED
            netplan_toBeDeleted_targetLineNum=$((netplan_toBeDeleted_targetLineNum-1))

            #INCREMENT 'netplan_toBeDeleted_numOfLines' by 1:
            #This is because of the additional deletion of entry 'wifis'.
            netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))
        fi
    fi

    # #Check if file '*.yaml' is present
    # #If FALSE, then exit function
    # if [[ ! -f ${yaml_fpath} ]]; then
    #     return  #exit function
    # fi

    #Print
    debugPrint__func "${PRINTF_START}" "${printf_yaml_deleting_wifi_entries}" "${EMPTYLINES_1}"

    #Read each line of '*.yaml'
    while true
    do
        #Delete current line-number 'netplan_toBeDeleted_targetLineNum'
        #REMARK:
        #   After the deletion of a line, all the contents BELOW this line will be...
        #   ... shifted up one line.
        #   Because of this 'shift-up' the variable 'netplan_toBeDeleted_targetLineNum' can be used again, again, and again...
        lineDeleted=`sed "${netplan_toBeDeleted_targetLineNum}q;d" ${yaml_fpath}`   #GET line specified by line number 'netplan_toBeDeleted_targetLineNum'
        
        debugPrint__func "${PRINTF_DELETING}" "${lineDeleted}" "${EMPTYLINES_0}" #print

        sed -i "${netplan_toBeDeleted_targetLineNum}d" ${yaml_fpath}   #DELETE line specified by line number 'netplan_toBeDeleted_targetLineNum'

        lineDeleted_count=$((lineDeleted_count+1))    #increment parameter    

        #Check if all lines belonging to wlan0 have been deleted
        #If TRUE, then exit function
        if [[ ${lineDeleted_count} -eq ${netplan_toBeDeleted_numOfLines} ]]; then
            break  #exit function
        fi
    done < "${yaml_fpath}"

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_deleting_wifi_entries}" "${EMPTYLINES_0}"
}

function netplan_get_ssid_info__func()
{
    #Check if file 'wpaSupplicant_conf_fpath' is present
    if [[ ! -f ${wpaSupplicant_conf_fpath} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_wpa_supplicant_file_not_found}" "${TRUE}"
    fi

    #Retrieve SSID
    ssid=`cat ${wpaSupplicant_conf_fpath} | grep -w "${PATTERN_SSID}" | cut -d"\"" -f2 2>&1`

    #Retrieve Password
    ssidPasswd=`cat ${wpaSupplicant_conf_fpath} | grep -w "${PATTERN_PSK}" | cut -d"\"" -f2 2>&1`

    #Retrieve ssid_scan=1 (if any)
    #if 'scan_ssid=1' is present in file 'wpa_supplicant.conf' then 'ssidScan_isFound' is NOT an EMPTY STRING
    ssidScan_isFound=`cat ${wpaSupplicant_conf_fpath} | grep -w "${SCAN_SSID_IS_1}"`
}

function netplan_choose_dhcp_or_static__func()
{
    #Check if file '*.yaml' is present
    #If FALSE, then create an empty file
    if [[ ! -f ${yaml_fpath} ]]; then
        touch ${yaml_fpath}
    fi


    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
        #'dhcp_isSelected' is set in function 'input_args_handling__sub'

        return
    fi


    #Print question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ENABLE_DHCP}" "${EMPTYLINES_1}"

    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n,q] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            #Print question + answer
            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ENABLE_DHCP} ${myChoice}" "${EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    if [[ ${myChoice} == ${INPUT_QUIT} ]]; then
        exit 0
    elif [[ ${myChoice} == ${INPUT_YES} ]]; then
        dhcp_isSelected=${TRUE}
    else    #myChoice == 'n'
        dhcp_isSelected=${FALSE}
    fi
}

function netplan_add_dhcp_entries__func()
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
    local stdval_output=${EMPTYSTRING}

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
    debugPrint__func "${PRINTF_START}" "${printf_yaml_adding_dhcpEntries}" "${EMPTYLINES_1}"

    # #Print and Add entries:
    # #Check if '*.yaml' contains a 'new line (\n)'
    # #If 'last line' of '*.yaml' is NOT a 'new line (\n)'...
    # #...then append a 'new line'
    # isNewLine=`lastLine_isNewLine "${yaml_fpath}"`
    # if [[ ${isNewLine} == ${FALSE} ]]; then 
    #     printf '%b%s\n' "" >> ${yaml_fpath}   #write to file        
    # fi

    #Check if entry 'wifis' is present in '*.yaml'
    stdval_output=`cat ${yaml_fpath} | grep "${PATTERN_WIFIS}" 2>&1`
    if [[ -z ${stdval_output} ]]; then  #entry 'wifis' is not present
        debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry1}" "${EMPTYLINES_0}"  #print
        printf '%b%s\n' "${dhcp_entry1}" >> ${yaml_fpath}   #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry2}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry2}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry3}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry3}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry4}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry4}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry5}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry5}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry6}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${dhcp_entry6}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${dhcp_entry7}" "${EMPTYLINES_0}"  #print
    printf '%b%s' "${dhcp_entry7}" >> ${yaml_fpath}    #write to file (do not add new line '\n')

    #Print COMPLETED
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_adding_dhcpEntries}" "${EMPTYLINES_0}"
}

function netplan_static_input_and_validate__func()
{
    #Initial values
    myChoice=${INPUT_ALL} #IMPORTANT to set this value

    #Start input
    while true
    do
        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV4} ]]; then
            netplan_static_ipv4_network_info_input__func
        fi

        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV6} ]]; then
            netplan_static_ipv6_network_info_input__func
        fi

        #Double-check IPv4 and IPv6 Input Values
        netplan_static_ipv46_inputValues_doubleCheck__func

        #Print input values
        netplan_static_ipv46_print__func

        #Ask for user's confirmation
        #val_output:
        #1. exitCode={0|90}
        #   REMARK:
        #       if exitCode=0, then break loop
        #       if exitCode=90, then restart loop
        #2. dhcp_isSelected (true|false)
        netplan_static_ipv46_confirm__func

        if [[ ${exitCode} == ${EXITCODE_0} ]]; then
            break
        fi
    done
}

function netplan_static_ipv4_network_info_input__func()
{
    #Define constants
    local PHASE_ADDR_NETMASK=1
    local PHASE_GATEWAY=2
    local PHASE_DNS=3

    #Define local variables
    local phase=${PHASE_ADDR_NETMASK}

    #Print
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO}" "${EMPTYLINES_1}"

    while true
    do
        moveUp__func "${NUMOF_ROWS_2}"

        case ${phase} in
            ${PHASE_ADDR_NETMASK})
                netplan_static_ipv4_address_netmask_input__func
                if [[ ${ipv4_address_netmask_isValid} == ${INPUT_SEMICOLON_SKIP} ]]; then #skip was flagged
                    return  #exit function
                elif [[ ${ipv4_address_netmask_isValid} == ${TRUE} ]]; then
                    phase=${PHASE_GATEWAY}
                else    #ipv4_address_netmask_isValid == FALSE
                    phase=${PHASE_ADDR_NETMASK}
                fi

                ;;

            ${PHASE_GATEWAY})
                netplan_static_ipv4_gateway_input__func
                if [[ ${ipv4_gateway_isValid} == ${INPUT_SEMICOLON_BACK} ]]; then #skip was flagged
                    phase=${PHASE_ADDR_NETMASK}
                elif [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then
                    phase=${PHASE_DNS}
                else    #ipv4_gateway_isValid == FALSE
                    phase=${PHASE_GATEWAY}
                fi

                ;;

            ${PHASE_DNS})
                netplan_static_ipv4_dns_input__func
                if [[ ${ipv4_dns_isValid} == ${INPUT_SEMICOLON_BACK} ]]; then #skip was flagged
                    phase=${PHASE_GATEWAY}
                elif [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then
                    #REMARK: once this phase has been reached...
                    #........it means that all the 3 booleans are set to TRUE:
                    #1. ipv4_address_netmask_isValid == TRUE
                    #2. ipv4_gateway_isValid == TRUE
                    #3. ipv4_dns_isValid == TRUE
                    return  #exit function
                else    #ipv4_dns_isValid == FALSE
                    phase=${PHASE_GATEWAY}
                fi

                ;;
        esac
    done
}

function netplan_static_ipv4_address_netmask_input__func()
{
    #Define constants
    local echoMsg=${EMPTYSTRING}

#---Input ipv4-address + netmask
    while true
    do
        #Check if NON-INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv4_address_netmask=${ipv4_addrNetmask_input}

        else    #interactive mode
            # read -r -e -p "${READ_IPV4_ADDRESS_NETMASK}" -i "${ipv4_address_netmask_accept}" ipv4_address_netmask

            read_handler__func "${READ_IPV4_ADDRESS_NETMASK}" "${ipv4_address_netmask_accept}"   
        fi

        #Check if input is a valid ipv4-address
        if [[ ! -z ${ipv4_address_netmask} ]]; then #is NOT an EMPTY STRING
            lastTwoChars=`get_lastTwoChars_of_string__func ${ipv4_address_netmask}`
            if [[ ${lastTwoChars} != ${INPUT_SEMICOLON_SKIP} ]]; then   #key 's' was NOT inputted
                #Clean 'ipv4_address_netmask' from any unwanted characters
                ipv4_address_netmask_clean=`ip46_cleanup__func "${ipv4_address_netmask}"`

                #Validate 'ipv4_address_netmask_clean'
                #This function will val_output 'ipv4_address_netmask_isValid' (true|false)
                ipv4_checkIf_address_netmask_isValid__func "${ipv4_address_netmask_clean}"

                if [[ ${ipv4_address_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
                    #Update variable
                    ipv4_address_netmask_accept=${ipv4_address_netmask_clean}

                    moveUp__func "${NUMOF_ROWS_1}"

                    break
                else
                    moveUp__func "${NUMOF_ROWS_2}"
                fi
            else    #key 's' was inputted
                ipv4_address_netmask_isValid=${INPUT_SEMICOLON_SKIP}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv4_address_netmask_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}

function netplan_static_ipv4_gateway_input__func()
{
    #Define local variables
    local echoMsg=${EMPTYSTRING}
    local errMsg=${EMPTYSTRING}

    while true
    do
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv4_gateway=${ipv4_gateway_input}
        else    #interactive mode
            # read -e -p "${READ_IPV4_GATEWAY}" -i "${ipv4_gateway_accept}" ipv4_gateway

            read_handler__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway_accept}"  
        fi
        
        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv4_gateway} ]]; then #is NOT an EMPTY STRING
            lastTwoChars=`get_lastTwoChars_of_string__func ${ipv4_gateway}`
            if [[ ${lastTwoChars} != ${INPUT_SEMICOLON_BACK} ]]; then   #key 'b' was NOT inputted
                #No more than 1 gateway input allowed!!!
                numOf_entries=`ipv46_get_numOf_entries__func "${ipv4_gateway}"`

                if [[ ${numOf_entries} -ne 1 ]]; then   #number of entry is MORE THAN '1'
                    netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway}" "${ERRMSG_ONLY_ONE_GATEWAY_ENTRY_ALLOWED_NO_COLOR}"
                
                    moveUp__func "${NUMOF_ROWS_2}"
                else    #number of entry is '1'
                    #Clean 'ipv4_gateway_clean' from any unwanted characters
                    ipv4_gateway_clean=`ip46_cleanup__func "${ipv4_gateway}"`

                    match_isFound=`checkFor_exactMatch_substr_in_string__func "${ipv4_gateway_clean}" "${ipv4_address_netmask_accept}"`
                    if [[ ${match_isFound} == ${TRUE} ]]; then    #'ipv4_gateway' is NOT unique
                        netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway}" "${ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE_NO_COLOR}"
                    
                        moveUp__func "${NUMOF_ROWS_2}"
                    else    #'ipv4_gateway' is unique
                        #Check if 'ipv4_gateway' is a valid
                        ipv4_gateway_isValid=`ipv4_checkIf_address_isValid__func "${ipv4_gateway_clean}"`
                        
                        if [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-gateway
                            #Update valid ipv4-gateway
                            ipv4_gateway_accept=${ipv4_gateway_clean}

                            moveUp__func "${NUMOF_ROWS_1}"

                            break
                        else
                            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_GATEWAY}" "${ipv4_gateway}" "${ERRMSG_INVALID_IPV4_GATEWAY_FORMAT_NO_COLOR}"
                            
                            moveUp__func "${NUMOF_ROWS_2}"
                        fi
                    fi
                fi
            else    #key 'b' was inputted
                ipv4_gateway_isValid=${INPUT_SEMICOLON_BACK}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv4_gateway_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}
function netplan_static_ipv4_dns_input__func()
{
    while true
    do
        #Check if NON-INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv4_dns=${ipv4_dns_input}           
        else    #interactive mode
            # read -e -p "${READ_IPV4_DNS}" -i "${ipv4_dns_accept}" ipv4_dns

            read_handler__func "${READ_IPV4_DNS}" "${ipv4_dns_accept}"  
        fi

        #Check if input is a valid ipv4-dns
        if [[ ! -z ${ipv4_dns} ]]; then #is NOT an EMPTY STRING
            lastTwoChars=`get_lastTwoChars_of_string__func ${ipv4_dns}`
            if [[ ${lastTwoChars} != ${INPUT_SEMICOLON_BACK} ]]; then   #key 'b' was NOT inputted
                #REPLACE MULTIPLE SPACES to ONE SPACE
                ipv4_dns_clean=`ip46_cleanup__func "${ipv4_dns}"`

                ipv4_dns_isValid=`ipv4_checkIf_address_isValid__func "${ipv4_dns_clean}"`
                if [[ ${ipv4_dns_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-dns
#-------------------Update valid ipv4-dns
                    ipv4_dns_accept=${ipv4_dns_clean}

                    moveUp__func "${NUMOF_ROWS_1}"

                    break
                else
                    netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_DNS}" "${ipv4_dns}" "${ERRMSG_INVALID_IPV4_DNS_FORMAT_NO_COLOR}"

                    moveUp__func "${NUMOF_ROWS_2}"
                fi
            else    #key 'b' was inputted
                ipv4_dns_isValid=${INPUT_SEMICOLON_BACK}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv4_dns_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}
function ipv4_checkIf_address_netmask_isValid__func()
{
    #Input args
    local address_netmask_input=${1}

    #Define local variables
    local address=${EMPTYSTRING}
    local netmask=${EMPTYSTRING}
    local address_netmask_subst=${EMPTYSTRING}
    local address_netmask_array=()
    local address_netmask_arrayItem=${EMPTYSTRING}
    local errMsg=${EMPTYSTRING}

    #Check if 'address_netmask_input' is an EMPTY STRING
    if [[ -z ${address_netmask_input} ]]; then
        netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_ADDRESS_NETMASK}" "${address_netmask_input}" "${ERRMSG_INVALID_IPV4_ADDRESS_NETMASK_FORMAT_NO_COLOR}"

        return
    fi

    #'address_netmask_input' could contain multiple address/netmask entries,...
    #...where each entry is separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    address_netmask_subst=`ipv46_subst_comma_with_space__func "${address_netmask_input}"`

    #Convert from String to Array
    eval "address_netmask_array=(${address_netmask_subst})"

    #Cycle through Array
    for address_netmask_arrayItem in "${address_netmask_array[@]}"
    do
        #Get address
        address=`echo ${address_netmask_arrayItem} | cut -d"${SLASH_CHAR}" -f1`

        #Check if address is valid
        ipv4_address_isValid=`ipv4_checkIf_address_isValid__func "${address}"`
        if [[ ${ipv4_address_isValid} == ${FALSE} ]]; then  #is a VALID ipv4-address
            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_ADDRESS_NETMASK}" "${address}" "${ERRMSG_INVALID_IPV4_ADDR_FORMAT_NO_COLOR}"

            ipv4_address_netmask_isValid=${FALSE}   #val_output

            return  #exit function
        fi

        #Get netmask
        netmask=`echo ${address_netmask_arrayItem} | cut -d"${SLASH_CHAR}" -f2`

        #Check if netmask is valid
        ipv4_netmask_isValid=`ipv4_checkIf_netmask_isValid__func "${netmask}"`
        if [[ ${ipv4_netmask_isValid} == ${FALSE} ]]; then  #is a VALID ipv4-address
            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV4_ADDRESS_NETMASK}" "${netmask}" "${ERRMSG_INVALID_IPV4_NETMASK_FORMAT_NO_COLOR}"

            ipv4_address_netmask_isValid=${FALSE}   #val_output

            return  #exit function
        fi
    done

    #val_output (if everything went well)
    ipv4_address_netmask_isValid=${TRUE}
}
function ipv4_checkIf_address_isValid__func()
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

    #val_output
    echo ${isValid}
}
function ipv4_checkIf_netmask_isValid__func()
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

function netplan_static_ipv6_network_info_input__func()
{
    #Define constants
    local PHASE_ADDR_NETMASK=1
    local PHASE_GATEWAY=2
    local PHASE_DNS=3

    #Define local variables
    local phase=${PHASE_ADDR_NETMASK}


    #Print
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO}" "${EMPTYLINES_1}"

    while true
    do
        moveUp__func "${NUMOF_ROWS_2}"

        case ${phase} in
            ${PHASE_ADDR_NETMASK})
                netplan_static_ipv6_address_netmask_input__func
                if [[ ${ipv6_address_netmask_isValid} == ${INPUT_SEMICOLON_SKIP} ]]; then #skip was flagged
                    return  #exit function
                elif [[ ${ipv6_address_netmask_isValid} == ${TRUE} ]]; then
                    phase=${PHASE_GATEWAY}
                else    #ipv6_address_netmask_isValid == FALSE
                    phase=${PHASE_ADDR_NETMASK}
                fi

                ;;

            ${PHASE_GATEWAY})
                netplan_static_ipv6_gateway_input__func
                if [[ ${ipv6_gateway_isValid} == ${INPUT_SEMICOLON_BACK} ]]; then #skip was flagged
                    phase=${PHASE_ADDR_NETMASK}
                elif [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then
                    phase=${PHASE_DNS}
                else    #ipv6_gateway_isValid == FALSE
                    phase=${PHASE_GATEWAY}
                fi

                ;;

            ${PHASE_DNS})
                netplan_static_ipv6_dns_input__func
                if [[ ${ipv6_dns_isValid} == ${INPUT_SEMICOLON_BACK} ]]; then #skip was flagged
                    phase=${PHASE_GATEWAY}
                elif [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then
                    #REMARK: once this phase has been reached...
                    #........it means that all the 3 booleans are set to TRUE:
                    #1. ipv6_address_netmask_isValid == TRUE
                    #2. ipv6_gateway_isValid == TRUE
                    #3. ipv6_dns_isValid == TRUE
                    return  #exit function
                else    #ipv6_dns_isValid == FALSE
                    phase=${PHASE_GATEWAY}
                fi

                ;;
        esac
    done
}

function netplan_static_ipv6_address_netmask_input__func()
{
#---Input ipv6-address + netmask
    while true
    do
        #Check if NON-INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv6_address_netmask=${ipv6_addrNetmask_input}
        else    #interactive mode
            # read -e -r -p "${READ_IPV6_ADDRESS_NETMASK}" -i "${ipv6_address_netmask_accept}" ipv6_address_netmask

            read_handler__func "${READ_IPV6_ADDRESS_NETMASK}" "${ipv6_address_netmask_accept}"  
        fi
      
        #Check if input is a valid ipv6-address
        if [[ ! -z ${ipv6_address_netmask} ]]; then #is NOT an EMPTY STRING
            lastTwoChars=`get_lastTwoChars_of_string__func ${ipv6_address_netmask}`
            if [[ ${lastTwoChars} != ${INPUT_SEMICOLON_SKIP} ]]; then   #key 's' was NOT inputted
                #Clean 'ipv6_address_netmask' from any unwanted characters
                ipv6_address_netmask_clean=`ip46_cleanup__func "${ipv6_address_netmask}"`

                #Validate 'ipv6_address_netmask_clean'
                #This function will val_output 'ipv6_address_netmask_isValid' (true|false)
                ipv6_checkIf_address_netmask_isValid__func "${ipv6_address_netmask_clean}"

                if [[ ${ipv6_address_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
                    #Update variable
                    ipv6_address_netmask_accept=${ipv6_address_netmask_clean}

                    moveUp__func "${NUMOF_ROWS_1}"

                    break
                else
                    moveUp__func "${NUMOF_ROWS_2}"
                fi
            else    #key 's' was inputted
                ipv6_address_netmask_isValid=${INPUT_SEMICOLON_SKIP}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else    #is an EMPTY STRING
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv6_address_netmask_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}
function ipv6_checkIf_address_netmask_isValid__func()
{
    #Input args
    local address_netmask_input=${1}

    #Define local variables
    local address=${EMPTYSTRING}
    local netmask=${EMPTYSTRING}
    local address_netmask_subst=${EMPTYSTRING}
    local address_netmask_array=()
    local address_netmask_arrayItem=${EMPTYSTRING}

    #Check if 'address_netmask_input' is an EMPTY STRING
    if [[ -z ${address_netmask_input} ]]; then
        netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_ADDRESS_NETMASK}" "${address_netmask_input}" "${ERRMSG_INVALID_IPV6_ADDRESS_NETMASK_FORMAT_NO_COLOR}"

        return
    fi

    #'address_netmask_input' could contain multiple address/netmask entries,...
    #...where each entry is separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    address_netmask_subst=`ipv46_subst_comma_with_space__func "${address_netmask_input}"`

    #Convert from String to Array
    eval "address_netmask_array=(${address_netmask_subst})"

    #Cycle through Array
    for address_netmask_arrayItem in "${address_netmask_array[@]}"
    do
        #Get address
        address=`echo ${address_netmask_arrayItem} | cut -d"${SLASH_CHAR}" -f1`

        #Check if address is valid
        ipv6_address_isValid=`ipv6_checkIf_address_isValid__func "${address}"`
        if [[ ${ipv6_address_isValid} == ${FALSE} ]]; then  #is a VALID ipv6-address
            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_ADDRESS_NETMASK}" "${address}" "${ERRMSG_INVALID_IPV6_ADDR_FORMAT_NO_COLOR}"

            ipv6_address_netmask_isValid=${FALSE}   #val_output

            return  #exit function
        fi

        #Get netmask
        netmask=`echo ${address_netmask_arrayItem} | cut -d"${SLASH_CHAR}" -f2`

        #Check if netmask is valid
        ipv6_netmask_isValid=`ipv6_checkIf_netmask_isValid__func "${netmask}"`
        if [[ ${ipv6_netmask_isValid} == ${FALSE} ]]; then  #is a VALID ipv6-address
            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_ADDRESS_NETMASK}" "${netmask}" "${ERRMSG_INVALID_IPV6_NETMASK_FORMAT_NO_COLOR}"

            ipv6_address_netmask_isValid=${FALSE}   #val_output

            return  #exit function   
        fi
    done

    #val_output (if everything went well)
    ipv6_address_netmask_isValid=${TRUE}
}
function netplan_static_ipv6_gateway_input__func()
{
    while true
    do
        #Check if NON-INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv6_gateway=${ipv6_gateway_input}
        else    #interactive mode
            # read -e -p "${READ_IPV6_GATEWAY}" -i "${ipv6_gateway_accept}" ipv6_gateway

            read_handler__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway_accept}"
        fi    

        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv6_gateway} ]]; then #is NOT an EMPTY STRING
            #REMARK: 'echo ${ipv6_gateway: -1': 
            if [[ `get_lastTwoChars_of_string__func ${ipv6_gateway}` != ${INPUT_SEMICOLON_BACK} ]]; then   #key 'b' was NOT inputted
                #No more than 1 gateway input allowed!!!
                numOf_entries=`ipv46_get_numOf_entries__func "${ipv6_gateway}"`

                if [[ ${numOf_entries} -ne 1 ]]; then   #number of entry is MORE THAN '1'
                    netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway}" "${ERRMSG_ONLY_ONE_GATEWAY_ENTRY_ALLOWED_NO_COLOR}"
                
                    moveUp__func "${NUMOF_ROWS_2}"
                else    #number of entry is '1'
                    #Clean 'ipv6_gateway_clean' from any unwanted characters
                    ipv6_gateway_clean=`ip46_cleanup__func "${ipv6_gateway}"`

                    match_isFound=`checkFor_exactMatch_substr_in_string__func "${ipv6_gateway_clean}" "${ipv6_address_netmask_accept}"`
                    if [[ ${match_isFound} == ${TRUE} ]]; then    #'ipv6_gateway' is NOT unique
                        netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway}" "${ERRMSG_INVALID_IPV6_GATEWAY_DUPLICATE_NO_COLOR}"
                    
                        moveUp__func "${NUMOF_ROWS_2}"
                    else    #'ipv6_gateway' is unique
                        #Check if 'ipv6_gateway' is a valid
                        ipv6_gateway_isValid=`ipv6_checkIf_address_isValid__func "${ipv6_gateway_clean}"`
                        
                        if [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-gateway
                            #Update valid ipv4-gateway
                            ipv6_gateway_accept=${ipv6_gateway_clean}

                            moveUp__func "${NUMOF_ROWS_1}"

                            break
                        else
                            netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_GATEWAY}" "${ipv6_gateway}" "${ERRMSG_INVALID_IPV6_GATEWAY_FORMAT_NO_COLOR}"
                        
                            moveUp__func "${NUMOF_ROWS_2}"
                        fi
                    fi
                fi
            else    #key 'b' was inputted
                ipv6_gateway_isValid=${INPUT_SEMICOLON_BACK}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv6_gateway_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}
function netplan_static_ipv6_dns_input__func()
{
    while true
    do
        #Check if NON-INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
            ipv6_dns=${ipv6_dns_input}
        else    #interactive mode
            # read -e -p "${READ_IPV6_DNS}" -i "${ipv6_dns_accept}" ipv6_dns

            read_handler__func "${READ_IPV6_DNS}" "${ipv6_dns_accept}"
        fi
        
        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv6_dns} ]]; then #is NOT an EMPTY STRING
            lastTwoChars=`get_lastTwoChars_of_string__func ${ipv6_dns}`
            if [[ ${lastTwoChars} != ${INPUT_SEMICOLON_BACK} ]]; then   #key 'b' was NOT inputted
                #REPLACE MULTIPLE SPACES to ONE SPACE
                ipv6_dns_clean=`ip46_cleanup__func "${ipv6_dns}"`

                ipv6_dns_isValid=`ipv6_checkIf_address_isValid__func "${ipv6_dns_clean}"`
                if [[ ${ipv6_dns_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-gateway
#-------------------Update valid ipv4-gateway
                    ipv6_dns_accept=${ipv6_dns_clean}

                    moveUp__func "${NUMOF_ROWS_1}"

                    break
                else
                    netplan_static_ipv46_errPrint_or_errExit__func "${READ_IPV6_DNS}" "${ipv6_dns}" "${ERRMSG_INVALID_IPV6_DNS_FORMAT_NO_COLOR}"
                
                    moveUp__func "${NUMOF_ROWS_2}"
                fi
            else    #key 'b' was inputted
                ipv6_dns_isValid=${INPUT_SEMICOLON_BACK}

                moveUp__func "${NUMOF_ROWS_1}"

                break
            fi
        else
            #Check if NON-INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
                ipv6_dns_isValid=${TRUE}

                break   #exit loop
            fi
        fi
    done
}
function ipv6_checkIf_address_isValid__func()
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

    #val_output
    echo ${isValid}
}

function ipv6_checkIf_netmask_isValid__func()
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

function ip46_cleanup__func()
{
    #Input args
    local address=${1}

    #Define local variables
    local address_input=${EMPTYSTRING}
    local address_clean0=${EMPTYSTRING}
    local address_clean1=${EMPTYSTRING}
    local address_clean2=${EMPTYSTRING}
    local address_clean3=${EMPTYSTRING}
    local address_clean4=${EMPTYSTRING}
    local address_clean5=${EMPTYSTRING}
    local address_clean6=${EMPTYSTRING}
    local address_val_output=${EMPTYSTRING}
    local numOf_dots=0
    local numOf_colons=0
    local regEx=${EMPTYSTRING}
    local regEx_blank=${EMPTYSTRING}
    local regex_leadingComma=${EMPTYSTRING}
    local regex_trailingComma=${EMPTYSTRING}

    #Count number of dots
    numOf_dots=`echo ${address} | grep -o "${DOT_CHAR}" | wc -l`

    #Count number of colons
    numOf_colons=`echo ${address} | grep -o "${COLON_CHAR}" | wc -l`

    #Define 'regEx' for 'sed'
    #The difference between an IPv4 and IPv6 is to keep a dot '.' or colon ':' respectively
    if [[ ${numOf_dots} -gt ${numOf_colons} ]]; then    #it's IPv4 address
        regEx="[^0-9.,/]"               #keep numbers, dot, comma
        regEx_Leading="^[^0-9]"         #Begin from the START (^), but KEEP numbers ([^0-9])
        regEx_Trailing="[^0-9]$"        #Begin from the END ($), but KEEP numbers ([^0-9])
    else    #it's IPv6 address
        regEx="[^0-9a-f:/,]"            #keep numbers, colon, comma
        regEx_Leading="^[^0-9a-f:]"     #Begin from the START (^), but KEEP numbers and colon (^0-9a-f:)
        regEx_Trailing="[^0-9a-f]$"     #Begin from the END ($), but KEEP numbers and colon (^0-9a-f)
    fi

    #Start Substitution
    address_input=${address}

    while true
    do
        #Remove ALL SPACES
        address_clean0=`echo ${address_input} | tr -d ' '`

        #Replace 'backslash' with 'slash'
        address_clean1=`echo ${address_clean0} | tr '\\\' '\/'`

        #Remove all unwanted characters
        address_clean2=`echo ${address_clean1} | sed "s/${regEx}/${EMPTYSTRING}/g"`

        #Subsitute MULTIPLE COMMAs with ONE COMMA
        address_clean3=`echo ${address_clean2} | sed "s/${COMMA_CHAR}${COMMA_CHAR}*/${COMMA_CHAR}/g"`

        #Subsitute MULTIPLE DOTs with ONE DOT
        address_clean4=`echo ${address_clean3} | sed "s/${DOT_CHAR}${DOT_CHAR}*/${DOT_CHAR}/g"`

        #Subsitute MULTIPLE SLASHes with ONE SLASH
        address_clean5=`echo ${address_clean4} | sed "s/${BACKSLASH_CHAR}${SLASH_CHAR}${BACKSLASH_CHAR}${SLASH_CHAR}*/${BACKSLASH_CHAR}${SLASH_CHAR}/g"`

        #Remove any leading comma
        address_clean6=`echo ${address_clean5} | sed "s/${regEx_Leading}/${EMPTYSTRING}/g"`

        #Remove any trailing comma
        address_val_output=`echo ${address_clean6} | sed "s/${regEx_Trailing}/${EMPTYSTRING}/g"`

        #Check if 'address_input' is EQUAL to 'address_val_output'
        #If TRUE, then exit while-loop
        #If FALSE, then update 'address_input', and go back to the beginning of the loop
        if [[ ${address_val_output} != ${address_input} ]]; then    #strings are different
            address_input=${address_val_output}
        else    #strings are the same
            break
        fi
    done

    #val_output
    echo ${address_val_output}
}
function ipv46_get_numOf_entries__func()
{
    #REMARK: it is assumed that if there are more than 1 input, that...
    #........the inputs are separated by a 'comma'.
    #Input args
    local inputVal=${1}

    #Substitute 'comma' to 'space'
    local inputVal_subst=`ipv46_subst_comma_with_space__func "${inputVal}"`

    #Convert from String to Array
    local inputVal_arrayItem=${EMPTYSTRING}
    local inputVal_array=()
    eval "inputVal_array=(${inputVal_subst})"

    #Cycle thru the array and count the number of array-items which are NOT an EMPTY STRING
    local count_nonEmptyString_values=0
    for inputVal_arrayItem in "${inputVal_array[@]}"
    do
        if [[ ! -z ${inputVal_arrayItem} ]]; then  #ip-address is valid
            count_nonEmptyString_values=$((count_nonEmptyString_values+1))
        fi
    done

	#val_output
	echo ${count_nonEmptyString_values}
}
function ipv46_subst_comma_with_space__func()
{
    #Input args
    local address=${1}

    #Subsitute MULTIPLE SPACES with ONE SPACE
    local address_subst=`echo ${address} | sed "s/${COMMA_CHAR}/${ONE_SPACE}/g"`

    #val_output
    echo ${address_subst}    
}
function ipv46_combine_ip_with_netmask__func()
{
    #Input args
    local address=${1}
    local netmask=${2}

    #Define local variables
    local address_array=()
    local address_arrayItem=${EMPTYSTRING}
    local address_netmask=${EMPTYSTRING}
    local address_netmask_accum=${EMPTYSTRING}
    local address_subst=${EMPTYSTRING}

    #Check if 'address' is NOT an EMPTY STRING
    #If FALSE, then exit function
    if [[ -z ${address} ]]; then
        return
    fi

    #'address' could contain multiple ip-addresses,...
    #...where each ip-address are separated from each other by a comma,...
    #In order to convert 'string' to 'array',...
    #...substitute 'comma' with 'space'
    address_subst=`ipv46_subst_comma_with_space__func "${address}"`

    #Convert from String to Array
    eval "address_array=(${address_subst})"

    #Check if ipv6-address is valid
    for address_arrayItem in "${address_array[@]}"
    do
        #Combine 'ip-address' with the 'netmask'
        address_netmask=${address_arrayItem}/${netmask}

        if [[ -z  ${address_netmask_accum} ]]; then
            address_netmask_accum="${address_netmask}"
        else
            address_netmask_accum="${address_netmask_accum},${address_netmask}"
        fi
    done

    #val_output
    echo ${address_netmask_accum}
}

function netplan_static_ipv46_errPrint_or_errExit__func()
{
    #Input args
    local readmsg=${1}	#this is the 'read input message'
    local inputmsg=${2}	#this could be an ip-address, netmask, gateway, dns
    local errmsg=${3}	#error-message

	#Check if NON-INTERACTIVE MODE is ENABLED
	if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
		errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg} '${FG_LIGHTRED}${inputmsg}${NOCOLOR}'" "${TRUE}"		
	else    #interactive mode
		#Print the existing READ and INPUT MESSAGE including the ERROR message
		tput cuu1   #move-up one line

		printf '%b%n\n' "${readmsg} ${inputmsg} ${FG_LIGHTRED}${errmsg}${NOCOLOR}"
	fi	
}
function netplan_static_ipv46_inputValues_doubleCheck__func()
{
    #Check if at least one of the IPv4 Input Values  is an EMPTY STRING
    #If TRUE, then set all the IPv4 Input Values to an EMPTY STRING
    if [[ ${ipv4_address_netmask_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv4_gateway_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv4_dns_accept} == "${EMPTYSTRING}" ]]; then

        ipv4_address_netmask_accept=${EMPTYSTRING}
        ipv4_gateway_accept=${EMPTYSTRING}
        ipv4_dns_accept=${EMPTYSTRING}
    fi

    #Check if at least one of the IPv6 Input Values  is an EMPTY STRING
    if [[ ${ipv6_address_netmask_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv6_gateway_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv6_dns_accept} == "${EMPTYSTRING}" ]]; then

        ipv6_address_netmask_accept=${EMPTYSTRING}
        ipv6_gateway_accept=${EMPTYSTRING}
        ipv6_dns_accept=${EMPTYSTRING}
    fi
}

function netplan_static_ipv46_print__func()
{
    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_YOUR_IPV4_INPUT}" "${EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_ADDRESS_NETMASK}${ipv4_address_netmask_accept}" "${EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_GATEWAY}${ipv4_gateway_accept}" "${EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_DNS}${ipv4_dns_accept}" "${EMPTYLINES_0}"


    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_YOUR_IPV6_INPUT}" "${EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_ADDRESS_NETMASK}${ipv6_address_netmask_accept}" "${EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_GATEWAY}${ipv6_gateway_accept}" "${EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_DNS}${ipv6_dns_accept}" "${EMPTYLINES_0}"
}

function netplan_static_ipv46_inputValues_areValid__func()
{
    #Check if IPv4 Input Values  are an EMPTY STRING
    if [[ ${ipv4_address_netmask_accept} == "${EMPTYSTRING}" ]] || \
            [[ ${ipv4_gateway_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv4_dns_accept} == "${EMPTYSTRING}" ]]; then

        #IPv6 Input Values are an EMPTY STRING, but...
        #...check if IPv6 Input Values  are an EMPTYSTRING
        if [[ ${ipv6_address_netmask_accept} == "${EMPTYSTRING}" ]] || \
                [[ ${ipv6_gateway_accept} == "${EMPTYSTRING}" ]] || \
                    [[ ${ipv6_dns_accept} == "${EMPTYSTRING}" ]]; then

            echo ${FALSE}

            return
        fi
    fi

    #IPv4 and/or IPv6 Input Values are NOT an EMPTY STRING
    echo ${TRUE}
}

function netplan_static_ipv46_confirm__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
        exitCode=${EXITCODE_0}

        return  #exit function    
    fi  
    
    #Define local variables
    local inputValues_areValid=`netplan_static_ipv46_inputValues_areValid__func`
    local questionMsg=${EMPTYSTRING}

    if [[ ${inputValues_areValid} == ${TRUE} ]]; then   #input values are valid
        questionMsg=${QUESTION_ACCEPT_INPUT_VALUES_OR_REDO_INPUT}
    else    #all input values are empty strings
        questionMsg=${QUESTION_ENABLE_DHCP_INSTEAD_OR_REDO_INPUT}
    fi

    #Print question
    debugPrint__func "${PRINTF_QUESTION}" "${questionMsg}" "${EMPTYLINES_1}"

    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,a,4,6,q] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            #Print question + answer
            debugPrint__func "${PRINTF_QUESTION}" "${questionMsg} ${myChoice}" "${EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    #Set the 'dhcp_isSelected' to TRUE or FALSE (this depends on 'myChoice')
    if [[ ${myChoice} == ${INPUT_QUIT} ]]; then
        exit 0
    elif [[ ${myChoice} == ${INPUT_YES} ]]; then
        if [[ ${inputValues_areValid} == ${TRUE} ]]; then   #input values are valid
            dhcp_isSelected=${FALSE}
        else    #all input values are empty strings
            dhcp_isSelected=${TRUE}
        fi

        exitCode=${EXITCODE_0}
    else
        dhcp_isSelected=${FALSE}

        exitCode=${EXITCODE_90}
    fi
}

function netplan_add_static_entries__func()
{
    #Define local variables
    local inputValues_areValid=${FALSE}
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
    inputValues_areValid=`netplan_static_ipv46_inputValues_areValid__func`
    if [[ ${inputValues_areValid} == ${FALSE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_IPV46_INPUT_VALUES_ARE_EMPTY_STRINGS}" "${TRUE}"

        return
    fi

    #Combine IPv4 and IPv6 Addresses
    ipv46_address_netmask_accept=`combine_two_strings_with_charSeparator__func "${ipv4_address_netmask_accept}" \
                                                                                "${ipv6_address_netmask_accept}" \
                                                                                    "${COMMA_CHAR}"`

    #Combine IPv4 and IPv6 DNS
    ipv46_dns_accept=`combine_two_strings_with_charSeparator__func "${ipv4_dns_accept}" \
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
    debugPrint__func "${PRINTF_START}" "${printf_yaml_adding_dhcpEntries}" "${EMPTYLINES_1}"

    #Print and Add entries:
    #Check if '*.yaml' contains a 'new line (\n)'
    #If 'last line' of '*.yaml' is NOT a 'new line (\n)'...
    #...then append a 'new line'
    isNewLine=`lastLine_isNewLine "${yaml_fpath}"`
    if [[ ${isNewLine} == ${FALSE} ]]; then 
        printf '%b%s\n' "" >> ${yaml_fpath}   #write to file        
    fi

    #Check if entry 'wifis' is present in '*.yaml'
    stdval_output=`cat ${yaml_fpath} | grep "${PATTERN_WIFIS}" 2>&1`
    if [[ -z ${stdval_output} ]]; then  #entry 'wifis' is not present
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry1}" "${EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry1}" >> ${yaml_fpath}   #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry2}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry2}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry3}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry3}" >> ${yaml_fpath}    #write to file

    if [[ ! -z ${ipv4_gateway_accept} ]]; then
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry4}" "${EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry4}" >> ${yaml_fpath}    #write to file
    fi

    if [[ ! -z ${ipv6_gateway_accept} ]]; then
        debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry5}" "${EMPTYLINES_0}"  #print
        printf '%b%s\n' "${ipv46_entry5}" >> ${yaml_fpath}    #write to file
    fi

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry6}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry6}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry7}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry7}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry8}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry8}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry9}" "${EMPTYLINES_0}"  #print
    printf '%b%s\n' "${ipv46_entry9}" >> ${yaml_fpath}    #write to file

    debugPrint__func "${PRINTF_ADDING}" "${ipv46_entry10}" "${EMPTYLINES_0}"  #print
    printf '%b%s' "${ipv46_entry10}" >> ${yaml_fpath}    #write to file (do not add new line '\n')

    #Print COMPLETED
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_adding_dhcpEntries}" "${EMPTYLINES_0}"
}

function netplan_apply__func()
{
    #Define local variables
    local daemon_isRunning=${FALSE}
    local yaml_containsErrors=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local retry_param=1

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_APPLYING_NETPLAN}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}" "${EMPTYLINES_0}"

    #FIRST: run 'netplay apply' and capture stdErr ONLY with 2>&1 > /dev/null`
    #REMARK: if '2>&1', then both stdOut and stdErr are captured
    stdError=`netplan apply 2>&1 > /dev/null`
    exitCode=$? #get exit-code
    if [[ ! -z ${stdError} ]]; then    #string contains data
        errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_UNABLE_TO_APPLY_NETPLAN}" "${TRUE}"
    fi

    #Wait for at least 10 seconds for 'netplan daemon' to run
    while true
    do
        daemon_isRunning=`daemon_checkIf_isRunning__func "${wpa_wlan0_conf_fpath}"`
        if [[ ${daemon_isRunning} == ${TRUE} ]]; then
            break
        fi

        #Check if maximum retry has been exceeded
        if [[ ${retry_param} -eq ${RETRY_MAX} ]]; then
            errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_UNABLE_TO_APPLY_NETPLAN}" "${TRUE}"
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment parameter by 1
        retry_param=$((retry_param+1))
    done

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_APPLYING_NETPLAN}" "${EMPTYLINES_0}"
}
function daemon_checkIf_isRunning__func()
{
    #Input args
    local configFpath_input=${1}

    #Define local variables
    local ps_pidList_string=${EMPTYSTRING}

    #Check if wpa_supplicant test daemon is running
    #REMARK:
    #TWO daemons could be running:
    #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
    #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
    if [[ ! -f ${configFpath_input} ]]; then  #file does NOT exist
        echo ${FALSE}
    else    #file does exist
        ps_pidList_string=`ps axf | grep -E "${configFpath_input}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            echo ${TRUE}
        else    #daemon is NOT running
            echo ${FALSE}
        fi
    fi
}

postCheck_handler__sub()
{
    #Define local constants
    local NEPLAN_DAEMON="netplan daemon"

    #Define local constants
    local PRINTF_POSTCHECK="${FG_PURPLERED}POST${NOCOLOR}${FG_ORANGE}-CHECK:${NOCOLOR}"
    local ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA="ONE OR MORE ITEMS WERE ${FG_LIGHTRED}N/A${NOCOLOR}..."
    local ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL="PLEASE *REBOOT* AND TRY TO *REINSTALL* USING '${FG_LIGHTGREY}${wlan_inst_filename}${NOCOLOR}'"
    local ERRMSG_FAILED_TO_ENABLE_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *ENABLE* SERVICE(S)"
    local ERRMSG_FAILED_TO_START_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *START* SERVICE(S)"
    local ERRMSG_NETPLAN_NOT_CONFIGURED_FOR_WIFI="NETPLAN ${FG_LIGHTRED}NOT${NOCOLOR} CONFIGURED FOR WiFi"
    local ERRMSG_NETPLAN_DAEMON_FAILED_TO_RUN="'${FG_LIGHTGREY}${NEPLAN_DAEMON}${NOCOLOR}' ${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *RUN*"
    local ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN="*REBOOT* AND RUN '${FG_LIGHTGREY}${thisScript_filename}${NOCOLOR}' AGAIN"
    local ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT="*REBOOT* AND RUN '${FG_LIGHTGREY}${thisScript_filename}${NOCOLOR}'"
    local ERRMSG_IF_ISSUE_STILL_PERSIST="IF ISSUE STILL *PERSIST*..."
    local ERRMSG_THEN_TRY_TO_REINSTALL="...THEN TRY TO *REINSTALL* USING '${FG_LIGHTGREY}${wlan_inst_filename}${NOCOLOR}'"
    local PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES="STATUS OF MODULES/SOFTWARE/SERVICES"


    #Reset variable
    check_missing_isFound=${FALSE}
    check_netplanConfig_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_netplanDaemon_failedToRun_isFound=${FALSE}

    #Print
    debugPrint__func "${PRINTF_POSTCHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Post-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func "${PATTERN_IW}"
    software_preCheck_isInstalled__func "${PATTERN_WIRELESS_TOOLS}"
    software_preCheck_isInstalled__func "${PATTERN_WPASUPPLICANT}"
    intf_preCheck_isPresent__func
    services_preCheck_isPresent_isEnabled_isActive__func "${wpa_supplicant_service_filename}"
    # wlan_preCheck_isConfigured__func
    daemon_preCheck_isRunning__func "${wpaSupplicant_conf_fpath}"
    daemon_preCheck_isRunning__func "${wpa_wlan0_conf_fpath}"

    #Print 'failed' message(s) depending on the detected failure(s)
    if [[ ${check_missing_isFound} == ${TRUE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA}" "${FALSE}"      
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL}" "${TRUE}"
    else
        if [[ ${check_failedToEnable_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_ENABLE_SERVICES}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
        fi

        if [[ ${check_failedToStart_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_SERVICES}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"    
        fi

        # if [[ ${check_netplanConfig_missing_isFound} == ${TRUE} ]]; then
        #     errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NETPLAN_NOT_CONFIGURED_FOR_WIFI}" "${FALSE}"
        #     errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT}" "${FALSE}"
        #     errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
        #     errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
        # fi

        if [[ ${check_netplanDaemon_failedToRun_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NETPLAN_DAEMON_FAILED_TO_RUN}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
        fi
    fi
}

wlan_connect_info__sub() {
    #Execute file
    ${wlan_conn_info_fpath}
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    #Check if non-interactive mode is DISABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then
        load_header__sub

        checkIfisRoot__sub
    fi
    
    init_variables__sub

    input_args_case_select__sub

    #Show Pre-Check ONLY IF this script is...
    #...running in Interactive-mode...OR...
    #...show_prePostCheck_ConnectInfo__isDisabled = TRUE
    if [[ ${interactive_isEnabled} == ${TRUE} ]] && [[ ${show_prePostCheck_ConnectInfo__isDisabled} == ${FALSE} ]]; then
        preCheck_handler__sub
    fi

    wlan_intf_selection__sub

    get_wifi_pattern__sub

    define_dynamic_variables__sub

    toggle_intf__func ${TOGGLE_UP}

    #This function will the following val_output:
    #   netplan_toBeDeleted_numOfLines
    #   netplan_toBeDeleted_targetLineNum
    netplan_print_retrieve_main__func

    #Check the number of lines to be deleted
    #If 'netplan_toBeDeleted_numOfLines == 0', then it means that:
    #...you have answered 'n' previously in function 'netplan_print_and_get_toBeDeleted_lines__func'
    if [[ ${isAllowed_toChange_netplan} == ${TRUE} ]]; then    #no lines to be deleted
        #Check if file '*.yaml' is present
        if [[ ! -f ${yaml_fpath} ]]; then   #file does NOT exist
            netplan_add_header_entries__func
        else
            netplan_del_wlan_entries__func
        fi

        #Retrieve SSID & SSID-PASSWD
        #val_output of this function are: 
        #1. ssid
        #2. ssidPasswd
        netplan_get_ssid_info__func

        #This function will val_output 'dhcp_isSelected'    
        netplan_choose_dhcp_or_static__func

        while true
        do
            if [[ ${dhcp_isSelected} == ${TRUE} ]]; then
                netplan_add_dhcp_entries__func

                break
            else
                #This function INDIRECTLY val_outputS value for 'dhcp_isSelected (true|false)'.
                #Please note that variable 'dhcp_isSelected' is changed in 'netplan_static_ipv46_confirm__func'.
                netplan_static_input_and_validate__func

                #Execute function 'netplan_add_static_entries__func' if:
                #1. IPv4 and/or IPv6 input values are valid,
                #2. dhcp_isSelected == false
                #REMARK:
                #If 'dhcp_isSelected == true', then it would mean that 'netplan_add_dhcp_entries__func' is executed
                if [[ ${dhcp_isSelected} == ${FALSE} ]]; then
                    netplan_add_static_entries__func

                    break
                fi
            fi
        done
    fi

    #Netplan Apply
    netplan_apply__func

    #Show Post-Check and WLAN-Connection_Info ONLY IF this script is...
    #...running in Interactive-mode...OR...
    #...show_prePostCheck_ConnectInfo__isDisabled = TRUE
    if [[ ${interactive_isEnabled} == ${TRUE} ]] && [[ ${show_prePostCheck_ConnectInfo__isDisabled} == ${FALSE} ]]; then
        postCheck_handler__sub

        wlan_connect_info__sub
    fi
}


#---EXECUTE
main__sub