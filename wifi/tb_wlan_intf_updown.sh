#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
wlanSelectIntf=${1}             #optional
wifi_preSetTo=${2}              #optional
yaml_fpath=${3}                 #optional



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${wlanSelectIntf}

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=3

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



#---COLORS
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




#---CONSTANTS
TITLE="TIBBO"

TWO_SPACES="  "
FOUR_SPACES=${TWO_SPACES}${TWO_SPACES}
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

EMPTYSTRING=""

ASTERISK_CHAR="*"
BACKSLASH_CHAR="\\"
CARROT_CHAR="^"
COMMA_CHAR=","
COLON_CHAR=":"
DOLLAR_CHAR="$"
DOT_CHAR=$'\.'
ENTER_CHAR=$'\x0a'
QUESTION_CHAR="?"
QUOTE_CHAR=$'\"'
SLASH_CHAR="/"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"
TAB_CHAR=$'\t'

#---EXIT CODES
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
IEEE_80211="IEEE 802.11"
WPA_SUPPLICANT="wpa_supplicant"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

PASSWD_MIN_LENGTH=8

#---READ INPUT CONSTANTS
INPUT_ALL="a"
INPUT_BACK="b"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_NO="n"
INPUT_REDO="r"
INPUT_REFRESH="r"
INPUT_SKIP="s"
INPUT_YES="y"

#---RETRY CONSTANTS
INTF_STATUS_RETRY=10

#---TIMEOUT CONSTANTS
INTF_STATUS_TIMEOUT=1
SLEEP_TIMEOUT=1

#---LINE CONSTANTS
NUMOF_ROWS_0=0
NUMOF_ROWS_1=1
NUMOF_ROWS_2=2
NUMOF_ROWS_3=3
NUMOF_ROWS_4=4
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
PATTERN_NOT_CONNECTED="Not connected"
# PATTERN_ACCESS_POINT_NOT_ASSOCIATED="Access Point: Not-Associated"
PATTERN_ESSID="ESSID"
PATTERN_EXECSTART="ExecStart="
PATTERN_GREP="grep"
PATTERN_INTERFACE="Interface"
PATTERN_IW="iw"
PATTERN_PSK="#psk="
PATTERN_SSID="ssid"
PATTERN_USAGE="usage"
PATTERN_WIRELESS_TOOLS="wireless-tools"
PATTERN_WPASUPPLICANT="wpasupplicant"

PATTERN_ADDRESSES="addresses"
PATTERN_GLOBAL="global"
PATTERN_INET="inet"
PATTERN_INET6="inet6"

#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle WiFi-interface UP/DOWN."



#---PRINTF PHASES
PRINTF_EXITING="EXITING:"
PRINTF_INFO="INFO:"
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_TOGGLE="TOGGLE:"
PRINTF_CURR_IP_ADDRESS="CURRENT IP ADDRESS:"
PRINTF_CURR_IP_ADDRESS_NA="CURRENT IP ADDRESS: ${FG_LIGHTGREY}N/A${NOCOLOR}"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="${FG_LIGHTRED}FAILED${NOCOLOR} TO LOAD MODULE: ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="${FG_LIGHTRED}FAILED${NOCOLOR} TO UNLOAD MODULE: ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
ERRMSG_NO_WIFI_INTF_FOUND="NO WiFi INTERFACES FOUND"
ERRMSG_PLEASE_REBOOT_AND_TRY_AGAIN="PLEASE REBOOT OR POWER OFF/ON LTPP3-G2, AND TRY AGAIN..."

#---PRINTF MESSAGES
PRINTF_NO_ACTION_REQUIRED="NO ACTION REQUIRED..."

PRINTF_RESTARTING_NETWORK_SERVICE="RESTARTING NETWORK SERVICE"
PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

#---QUESTION MESSAGES
QUESTION_RELOAD_MODULE="RELOAD MODULE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
define_dynamic_variables__sub()
{
    errmsg_failed_to_bring_wifi_intf_down="${FG_LIGHTRED}FAILED${NOCOLOR} TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    errmsg_failed_to_bring_wifi_intf_up="${FG_LIGHTRED}FAILED${NOCOLOR} TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

    errmsg_wifi_int_not_present="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"

    # pattern_ps_axf_wpa_supplicant_1="${WPA_SUPPLICANT} -B -c ${wpaSupplicant_fpath} -i ${wlanSelectIntf}"
    # pattern_ps_axf_wpa_supplicant_2="${WPA_SUPPLICANT} -c /run/netplan/wpa-${wlanSelectIntf}.conf -i${wlanSelectIntf}"

    # printf_wifi_interface_missing="WiFi INTERFACE MISSING: ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR}"

    printf_attempting_to_bring_wifi_intf_down="ATTEMPTING TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    printf_attempting_to_bring_wifi_intf_up="ATTEMPTING TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

    printf_wifi_intf_is_down="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} IS ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    printf_wifi_intf_is_up="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} IS ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

    question_set_wifi_intf_to_down="SET ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} TO ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR} (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
    question_set_wifi_intf_to_up="SET ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} TO ${FG_GREEN}${STATUS_UP}${NOCOLOR} (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
    
    printf_successfully_brought_down_wifi_intf="${FG_GREEN}SUCCESSFULLY${NOCOLOR} BROUGHT ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    printf_successfully_brought_up_wifi_intf="${FG_GREEN}SUCCESSFULLY${NOCOLOR} BROUGHT ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
}


#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)
    
    wlan_conn_info_filename="tb_wlan_conn_info.sh"
    wlan_conn_info_fpath=${current_dir}/${wlan_conn_info_filename}

    lib_systemd_system_dir=/lib/systemd/system
    wpa_supplicant_service_filename="wpa_supplicant.service"
    wpa_supplicant_service_fpath=${lib_systemd_system_dir}/${wpa_supplicant_service_filename}

    etc_dir=/etc
    wpaSupplicant_filename="wpa_supplicant.conf"
    wpaSupplicant_fpath="${etc_dir}/${wpaSupplicant_filename}"

    wpaSupplicant_conf_filename="wpa_supplicant.conf"
    wpaSupplicant_conf_fpath="${etc_dir}/${wpaSupplicant_conf_filename}"

    run_netplan_dir=/run/netplan
    wpa_wlan0_conf_filename="wpa-wlan0.conf"
    wpa_wlan0_conf_fpath=${run_netplan_dir}/${wpa_wlan0_conf_filename}

    etc_netplan_dir=${etc_dir}/netplan
    if [[ -z ${yaml_fpath} ]]; then #no input provided
        yaml_fpath="${etc_netplan_dir}/*.yaml"    #use the default full-path
    fi
    yaml_filename=$(basename ${yaml_fpath})
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

function isNumeric__func()
{
    #Input args
    local inputVar=${1}

    #Define local variables
    local regEx="^\-?[0-9]*\.?[0-9]+$"
    local stdOutput=${EMPTYSTRING}

    #Check if numeric
    #If TRUE, then 'stdOutput' is NOT EMPTY STRING
    stdOutput=`echo "${inputVar}" | grep -E "${regEx}"`

    if [[ ! -z ${stdOutput} ]]; then    #contains data
        echo ${TRUE}
    else    #contains NO data
        echo ${FALSE}
    fi
}

function append_emptyLines__func()
{
    #Input args
    local maxOf_rows=${1}

    #Append empty lines
    local row=0

    #APPEND empty lines until 'maxOf_rows' has been reached
    while [[ $row -lt ${maxOf_rows} ]]
    do
        printf '%s%b\n' ""

        row=$((row+1))
    done
}

function convertTo_lowercase__func()
{
    #Input args
    local orgString=${1}

    #Define local variables
    local lowerString=`echo ${orgString} | tr '[:upper:]' '[:lower:]'`

    #Output
    echo ${lowerString}
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
function errExit_kill_wpa_supplicant_daemon__func()
{
    #Check Status of SSID Connection
    stdOutput=`iwconfig ${wlanSelectIntf} | egrep "${PATTERN_ACCESS_POINT_NOT_ASSOCIATED}" 2>&1`

    #Check if 'stdOutput' contains data
    #If TRUE, then this means that there is NO SSID CONNECTION
    if [[ ! -z ${stdOutput} ]]; then  #data found
        wifi_wpa_supplicant_get_daemon_status__func

        wifi_wpa_supplicant_kill_daemon__func
    fi
}

function noActionRequired_exit__func()
{
    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NO_ACTION_REQUIRED}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"

        append_emptyLines__func "${EMPTYLINES_1}"
    fi

    exit 0 
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

function CTRL_C_func() {
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

    #If 'stdOutput' is an EMPTY STRING, then software is NOT installed yet
    if [[ ${packageStatus} == ${pattern_packageStatus_installed} ]]; then #contains NO data
        echo ${TRUE}
    else
        echo ${FALSE}
    fi
}

function wlan_get_intf_state__func()
{
    # local stdError=`ip link show ${wlanSelectIntf} 2>&1 > /dev/null`
    local stdOutput=`iw dev | grep ${wlanSelectIntf} 2>&1`

    if [[ -z ${stdOutput} ]]; then #an error has occurred
        wlan_isPresent=${FALSE} #set variable to 'false'

        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_wifi_int_not_present}" "${TRUE}"
    else    #no errors found
        wlan_isPresent=${TRUE} #set variable to 'true'

        stdOutput=`ip link show ${wlanSelectIntf} | grep ${STATUS_UP} 2>&1`
        if [[ ! -z ${stdOutput} ]]; then    #wlan is 'UP'
              debugPrint__func "${PRINTF_STATUS}" "${printf_wifi_intf_is_up}" "${EMPTYLINES_1}"
        else    #wlan is 'DOWN'
            debugPrint__func "${PRINTF_STATUS}" "${printf_wifi_intf_is_down}" "${EMPTYLINES_1}"
        fi
    fi
}

function retrieve_ipaddr__Func()
{
    #Define local variables
    local ipv4=${EMPTYSTRING}
    local ipv6=${EMPTYSTRING}
    local ip46_output=${EMPTYSTRING}
    local next_lineNum=0
    local wlan0_lineNum=0

    local stdOutput=${EMPTYSTRING}

#---FIRST CHECK IN file '*.yaml'
    #Get the line-number of interface 'wlan0' 
    wlan0_lineNum=`grep -n "${wlanSelectIntf}" ${yaml_fpath} | cut -d":" -f1`
    next_lineNum=$((wlan0_lineNum+1))

    #Check if the next-line contains any pattern 'addresses'
    stdOutput=`sed "${next_lineNum}q;d" ${yaml_fpath} | grep "${PATTERN_ADDRESSES}"`
    if [[ ! -z ${stdOutput} ]]; then   #match was found
        ip46_output=`echo ${stdOutput} | cut -d"${SQUARE_BRACKET_LEFT}" -f2 | cut -d"${SQUARE_BRACKET_RIGHT}" -f1 | sed "s/,/ /g"`
    else    #no match was found
        #In case 'file '*.yaml' does not contain any ip-addresses
        #REMARK: this could happen when 'dhcp is enabled'
#-------CHECK the ip-addresses with the 'ifconfig' command
        #IPv4 Address
        ipv4=`ifconfig ${wlanSelectIntf} | grep "${PATTERN_INET}" | xargs | cut -d" " -f2`
        if [[ ! -z ${ipv4} ]]; then #NOT an EMPTY STRING
            ip46_output="${ipv4}"
        fi
   
        #IPv6 Address
        ipv6=`ifconfig ${wlanSelectIntf}  | grep "${PATTERN_INET6}" | grep "${PATTERN_GLOBAL}" | xargs | cut -d" " -f2`
        if [[ ! -z ${ipv6} ]]; then #NOT an EMPTY STRING
            if [[ -z ${ip46_output} ]]; then #an EMPTY STRING
                ip46_output="${ipv6}"
            else    #NOT an EMPTY STRING (it means that 'ip46_output' contains 'ipv4' data)
                ip46_output="${ip46_output} ${ipv6}"
            fi
        fi       
    fi

    #Output
    echo ${ip46_output}
}
function wlan_get_ipv46_addr__func()
{
    #Define local variables
    local arrayItem=${EMPTYSTRING}

    #Get IP-address (if any)
    if [[ -f ${yaml_fpath} ]]; then  #/etc/netplan/*.yaml is present
        ip46_line=`retrieve_ipaddr__Func`
        ip46_array=(`echo ${ip46_line}`)    #convert string to array

        #Print the IPv4 and IPv6 addresses which are stored in array 'ip46_array'
        if [[ ! -z ${ip46_line} ]]; then    #contains data
            debugPrint__func "${PRINTF_INFO}" "${PRINTF_CURR_IP_ADDRESS}" "${EMPTYLINES_0}"
            for arrayItem in "${ip46_array[@]}"
            do
                debugPrint__func "${EIGHT_SPACES}" "${FG_LIGHTGREY}${arrayItem}${NOCOLOR}" "${EMPTYLINES_0}"
            done
        else    #contains NO data
            debugPrint__func "${PRINTF_INFO}" "${PRINTF_CURR_IP_ADDRESS_NA}" "${EMPTYLINES_0}"
        fi
    else    #/etc/netplan/*.yaml is NOT present
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_CURR_IP_ADDRESS_NA}" "${EMPTYLINES_0}"
    fi
}

function toggle_intf__func()
{
    #Local variables
    local stdOutput=${EMPTYSTRING}

#---Check if non-interactive mode is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then
        wifi_toggle_intf_choice__func
    else    #a Value was set as input arg for 'wifi_preSetTo'
#-------PRE-check: WiFi state
        #REMARK: if the current WiFi state is already 'UP', then no further actions are required.
        stdOutput=`ip link show | grep "${wlanSelectIntf}" | grep "${STATUS_UP}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then   #state has correctly changed to UP
            if [[ ${wifi_preSetTo} == ${TOGGLE_UP} ]]; then
                return  #exit functions
            fi
        else    #'stdOutput' contains NO data
            if [[ ${wifi_preSetTo} == ${TOGGLE_DOWN} ]]; then
                return  #exit functions
            fi
        fi

        #Set variable to 'y'
        myChoice="y"
    fi

#---TOGGLE WiFi INTERFACE
    if [[ ${myChoice} == "y" ]]; then   #answer is 'yes'
        wifi_toggle_intf_handler__func

        # #Check if non-interactive mode is ENABLED
        # if [[ ${interactive_isEnabled} == ${TRUE} ]]; then
        #     wlan_connect_info__sub  #show information
        # fi
    else    #answer is 'no'
        noActionRequired_exit__func
    fi
}
function wifi_toggle_intf_choice__func()
{
    #Define local variables
    local questionMsg=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}

    #THEN: check if the selected 'wlanSelectIntf' is present
    if [[ ${wlan_isPresent} == ${FALSE} ]]; then  #the selected 'wlanSelectIntf' is NOT present
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTF_FOUND}" "${TRUE}"
    else    #the selected 'wlanSelectIntf' is present
        stdOutput=`ip link show | grep "${wlanSelectIntf}" | grep "${STATUS_UP}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then   #currently the selected 'wlanSelectIntf' is UP
            wifi_preSetTo=${TOGGLE_DOWN}   #then set interface to DOWN

            questionMsg=${question_set_wifi_intf_to_down}
        else     #currently the selected 'wlanSelectIntf' is DOWN
            wifi_preSetTo=${TOGGLE_UP} #then set interface to UP

            questionMsg=${question_set_wifi_intf_to_up}
        fi

        debugPrint__func "${PRINTF_QUESTION}" "${questionMsg}" "${EMPTYLINES_1}"
    fi

    #Ask user if he/she wants to change the wifi-interface to UP/DOWN
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${questionMsg} ${myChoice}" "${EMPTYLINES_0}"

            break
            # if [[ ${myChoice} == ${INPUT_YES} ]]; then
            #     break   #continue with the execution of this function
            # else    #myChoice == "n"
            #     return  #exit function
            # fi
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done
}
function wifi_toggle_intf_handler__func()
{
    #Local variables
    local sleep_timeout_max=$((INTF_STATUS_TIMEOUT*INTF_STATUS_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0

    local stdOutput=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}

    local status=${EMPTYSTRING}

    local errMsg=${EMPTYSTRING}
    local printfMsg=${EMPTYSTRING}
    local toggsuccessMsgle=${EMPTYSTRING}

    local timeout_normal_5s=5   #run command for 5 seconds
    local timeout_killafter_5s=5    #if command is still running AFTER 5 seconds, then wait for another 5 seconds and kill command

    #Preselection
    if [[ ${wifi_preSetTo} == ${TOGGLE_UP} ]]; then
        status=${STATUS_UP}
        
        errMsg=${errmsg_failed_to_bring_wifi_intf_up}
        printfMsg="${printf_attempting_to_bring_wifi_intf_up}"
        successMsg=${printf_successfully_brought_up_wifi_intf}
    else
        status=${STATUS_DOWN}

        errMsg=${errmsg_failed_to_bring_wifi_intf_down}
        printfMsg="${printf_attempting_to_bring_wifi_intf_down}"
        successMsg=${printf_successfully_brought_down_wifi_intf}
    fi

#---PRINT MESSAGES BEFORE TOGGLE WiFi INTERFACE
    debugPrint__func "${PRINTF_STATUS}" "${printfMsg}" "${EMPTYLINES_1}"

    #Toggle WiFi interface
    stdError=`ip link set dev ${wlanSelectIntf} ${wifi_preSetTo} 2>&1 > /dev/null`  #set interface to UP
    exitCode=$? #get exit-code

    #Check if exit-code=0
    if [[ ${exitCode} -ne 0 ]]; then
        if [[ ${stdError} != ${EMPTYSTRING} ]]; then
            errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        fi

        errExit__func "${FALSE}" "${EXITCODE_99}" "${errMsg}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_REBOOT_AND_TRY_AGAIN}" "${TRUE}"
    fi

#-------Double-check if the selected 'wlanSelectIntf' has changed to the correct state as specified by 'wifi_preSetTo=UP'

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"    

    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to whether UP or DOWN)
        stdOutput=`ip link show | grep "${wlanSelectIntf}" | grep "${status}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then  #data found
            break
        fi

        sleep ${INTF_STATUS_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        #Print
        clear_lines__func ${NUMOF_ROWS_1}
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 10 times
            break
        fi
    done

    if [[ ! -z ${stdOutput} ]]; then   #state has correctly changed to UP
        debugPrint__func "${PRINTF_STATUS}" "${successMsg}" "${EMPTYLINES_0}"
    else    #state did not change to UP
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg}" "${TRUE}"
    fi
}



#---SUBROUTINES
load_header__sub()
{
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
    errExit_isEnabled=${TRUE}
    exitCode=0
    ip46_array=()
    ip46_line=${EMPTYSTRING}
    myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlan_isPresent=${FALSE}

    check_missing_isFound=${FALSE}
    check_netplanConfig_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_netplanDaemon_failedToRun_isFound=${FALSE}
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
    #Convert 'wlanSelectIntf' to LOWERCASE (regardless the input value)
    wlanSelectIntf=`convertTo_lowercase__func ${wlanSelectIntf}`

    #Convert 'wifi_preSetTo' to LOWERCASE (regardless the input value)
    wifi_preSetTo=`convertTo_lowercase__func ${wifi_preSetTo}`
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\" \"${FG_LIGHTGREY}arg3${NOCOLOR}\" \"${FG_LIGHTGREY}arg4${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}WiFi-interface (e.g. wlan0)."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}WiFi-interface set to {${FG_LIGHTGREEN}up${FG_LIGHTGREY}|${FG_SOFTLIGHTRED}down${NOCOLOR}}."
        "${FOUR_SPACES}arg3${TAB_CHAR}${TAB_CHAR}WiFi-interface search pattern (e.g. wlan)"
        "${FOUR_SPACES}arg4${TAB_CHAR}${TAB_CHAR}Path-to Netplan configuration file (e.g. /etc/netplan/*.yaml)."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFTLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFTLIGHTRED}\"${NOCOLOR} each argument."
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

    #The following information won't be alerted and no error will be created
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
    local stdOutput=`${LSMOD_CMD} | grep ${MODPROBE_BCMDHD}`
    if [[ ! -z ${stdOutput} ]]; then    #module is present
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
        
        clear_lines__func "${NUMOF_ROWS_1}"

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
    local stdOutput=`${SYSTEMCTL_CMD} ${STATUS} ${service_input} 2>&1 | grep "${PATTERN_COULD_NOT_BE_FOUND}"`
    if [[ -z ${stdOutput} ]]; then #contains NO data (service is present)
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


    #Define local variable    
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

wlan_get_pattern__sub()
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
    # pattern_wlan_string=`{ ${IW_CMD} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | sed -e "s/[0-9]*$//" | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

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

get_stat_info__sub()
{
    wlan_get_intf_state__func

    wlan_get_ipv46_addr__func
}

postCheck_handler__sub()
{
    #Define local constants
    local NEPLAN_DAEMON="netplan daemon"

    local PRINTF_POSTCHECK="${FG_PURPLERED}POST${NOCOLOR}${FG_ORANGE}-CHECK:${NOCOLOR}"
    local ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA="ONE OR MORE ITEMS WERE ${FG_LIGHTRED}N/A${NOCOLOR}..."
    local ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL="PLEASE *REBOOT* AND TRY TO *REINSTALL* USING '${FG_LIGHTGREY}${wlan_inst_filename}${NOCOLOR}'"
    local ERRMSG_FAILED_TO_ENABLE_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *ENABLE* SERVICE(S)"
    local ERRMSG_FAILED_TO_START_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *START* SERVICE(S)"
    local ERRMSG_NETPLAN_NOT_CONFIGURED_FOR_WIFI="NETPLAN ${FG_LIGHTRED}NOT${NOCOLOR} CONFIGURED FOR WiFi"
    local ERRMSG_NETPLAN_DAEMON_FAILED_TO_RUN="'${FG_LIGHTGREY}${NEPLAN_DAEMON}${NOCOLOR}' ${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *RUN*"
    local ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN="*REBOOT* AND RUN '${FG_LIGHTGREY}${thisScript_filename}${NOCOLOR}' AGAIN"
    local ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT="*REBOOT* AND RUN '${FG_LIGHTGREY}${wlan_netplanconf_filename}${NOCOLOR}'"
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

    #The following information won't be alerted and no error will be created
    services_preCheck_isPresent_isEnabled_isActive__func "${wpa_supplicant_service_filename}"
    # wlan_preCheck_isConfigured__func
    daemon_preCheck_isRunning__func "${wpaSupplicant_conf_fpath}"
    daemon_preCheck_isRunning__func "${wpa_wlan0_conf_fpath}"

    #Print 'failed' message(s) depending on the detected failure(s)
    if [[ ${check_missing_isFound} == ${TRUE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA}" "${FALSE}"      
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL}" "${TRUE}"
    # else
    #     if [[ ${check_failedToEnable_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_ENABLE_SERVICES}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
    #     fi

    #     if [[ ${check_failedToStart_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_SERVICES}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_THIS_SCRIPT_AGAIN}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"    
    #     fi

    #     if [[ ${check_netplanConfig_missing_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NETPLAN_NOT_CONFIGURED_FOR_WIFI}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
    #     fi

    #     if [[ ${check_netplanDaemon_failedToRun_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NETPLAN_DAEMON_FAILED_TO_RUN}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REBOOT_AND_RUN_NETPLANCONFIG_SCRIPT}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IF_ISSUE_STILL_PERSIST}" "${FALSE}"
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_THEN_TRY_TO_REINSTALL}" "${TRUE}"  
    #     fi
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
    #...running in Interactive-mode.
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then
        preCheck_handler__sub
    fi


    wlan_intf_selection__sub

    wlan_get_pattern__sub

    define_dynamic_variables__sub
    
    get_stat_info__sub

    toggle_intf__func

    #Show Post-Check and WLAN-Connection_Info ONLY IF this script is...
    #...running in Interactive-mode.
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then
        postCheck_handler__sub

        wlan_connect_info__sub
    fi
}



#---EXECUTE
main__sub
