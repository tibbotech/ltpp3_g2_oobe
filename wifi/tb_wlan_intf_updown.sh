#!/bin/bash
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#   INPUT ARGS
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#To run this script in interactive-mode, do not provide any input arguments
wlanSelectIntf=${1}             #optional
wifi_preSetTo=${2}              #optional
pattern_wlan=${3}               #optional
yaml_fpath=${4}                 #optional



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

BCMDHD="bcmdhd"

TWO_SPACES="  "
FOUR_SPACES=${TWO_SPACES}${TWO_SPACES}
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

EMPTYSTRING=""

ENTER_CHAR=$'\x0a'
QUESTION_CHAR="?"
QUOTE_CHAR="\""
TAB_CHAR=$'\t'
SLASH="/"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"

TRUE=1
FALSE=0

INPUT_ALL="a"
INPUT_BACK="b"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_NO="n"
INPUT_REDO="r"
INPUT_REFRESH="r"
INPUT_SKIP="s"
INPUT_YES="y"

EXITCODE_99=99
INTF_STATUS_TIMEOUT=1
INTF_STATUS_RETRY=10
SLEEP_TIMEOUT=1

ARGSTOTAL_MAX=4
PASSWD_MIN_LENGTH=8

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
WPA_SUPPLICANT="wpa_supplicant"

TOGGLE_UP="up"
TOGGLE_DOWN="down"
STATUS_UP="UP"
STATUS_DOWN="DOWN"

PATTERN_ADDRESSES="addresses"
PATTERN_GLOBAL="global"
PATTERN_INET="inet"
PATTERN_INET6="inet6"
# PATTERN_WLAN="wlan"
PATTERN_INTERFACE="Interface"
PATTERN_SSID="ssid"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_NO_WIFI_INTF_FOUND="NO WiFi INTERFACES FOUND"
ERRMSG_TO_RESOLVE_THIS_ISSUE_PLEASE_REBOOT_DEVICE="TO RESOLVE THIS ISSUE, PLEASE REBOOT DEVICE..."

ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="${FG_LIGHTRED}FAILED${NOCOLOR} TO LOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="${FG_LIGHTRED}FAILED${NOCOLOR} TO UNLOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
# ERRMSG_UNABLE_TO_LOAD_WIFI_MODULE_BCMDHD="Unable to LOAD WiFi MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"

PRINTF_INFO="INFO:"
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_TOGGLE="TOGGLE:"
PRINTF_IP_ADDRESS="IP ADDRESS:"
PRINTF_IP_ADDRESS_NA="IP ADDRESS: N/A"
PRINTF_RELOADING_WIFI_MODULE_MAY_RESOLVE_ISSUE="RELOADING WIFI MODULE MAY RESOLVE ISSUE"

PRINTF_RESTARTING_NETWORK_SERVICE="RESTARTING NETWORK SERVICE"
PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

QUESTION_RELOAD_MODULE="RELOAD MODULE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
define_dynamic_variables__sub()
{
    errmsg_failed_to_bring_wifi_intf_down="${FG_LIGHTRED}FAILED${NOCOLOR} TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
    errmsg_failed_to_bring_wifi_intf_up="${FG_LIGHTRED}FAILED${NOCOLOR} TO BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"

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
errExit_kill_wpa_supplicant_daemon__func()
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


get_wifi_pattern__func()
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

wlan_select__func()
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

    #Get ALL available wlan interface
    wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1 2>&1`

    #Check if 'wlanList_string' contains any data
    #If no data, then exit...
    if [[ -z $wlanList_string ]]; then  
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTF_FOUND}" "${TRUE}"       
    fi

    #Convert string to array
    eval "wlanList_array=(${wlanList_string})"   

    #Get Array Length
    wlanList_arrayLen=${#wlanList_array[*]}

    #Select wlan interface
    if [[ ${wlanList_arrayLen} -eq 1 ]]; then
         wlanSelectIntf=${wlanList_array[0]}
    else
        #Show available wlan interface
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

        #Choose wlan interface
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

get_wlan_intf_status__func()
{
    local stdError=`ip link show ${wlanSelectIntf} 2>&1 > /dev/null`

    if [[ ! -z ${stdError} ]]; then #an error has occurred
        wlan_isPresent=${FALSE} #set variable to 'false'

        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_wifi_int_not_present}" "${TRUE}"
    else    #no errors found
        wlan_isPresent=${TRUE} #set variable to 'true'

        local stdOutput=`ip link show ${wlanSelectIntf} | grep ${STATUS_UP} 2>&1`
        if [[ ! -z ${stdOutput} ]]; then    #wlan is 'UP'
              debugPrint__func "${PRINTF_STATUS}" "${printf_wifi_intf_is_up}" "${PREPEND_EMPTYLINES_1}"
        else    #wlan is 'DOWN'
            debugPrint__func "${PRINTF_STATUS}" "${printf_wifi_intf_is_down}" "${PREPEND_EMPTYLINES_1}"
        fi
    fi
}

function wifi_retrieve_ipaddr__Func()
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
get_wlan_ipv4_addr__func()
{
    #Define local variables
    local arrayItem=${EMPTYSTRING}
    if [[ ${wlan_isPresent} == ${TRUE} ]]; then  #interface is present
        ip46_line=`wifi_retrieve_ipaddr__Func`
        ip46_array=(`echo ${ip46_line}`)    #convert string to array

        #Print the IPv4 and IPv6 addresses which are stored in array 'ip46_array'
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_IP_ADDRESS}" "${PREPEND_EMPTYLINES_0}"
        for arrayItem in "${ip46_array[@]}"
        do
            debugPrint__func "${EIGHT_SPACES}" "${FG_LIGHTGREY}${arrayItem}${NOCOLOR}" "${PREPEND_EMPTYLINES_0}"
        done
    else    #interface is NOT present
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_IP_ADDRESS_NA}" "${PREPEND_EMPTYLINES_0}"
    fi
}

toggle_intf__func()
{
    #Local variables
    local stdOutput=${EMPTYSTRING}

#---FIRST: check if input arg 'wifi_preSetTo' is preset as input arg
    #REMARK: if FALSE, then skip this part
    if [[ -z ${wifi_preSetTo} ]]; then #No Value was set as input arg for 'wifi_preSetTo'
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
    fi

#---TOGGLE WiFi INTERFACE
    wifi_toggle_intf_handler__func
}
wifi_toggle_intf_choice__func()
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

        debugPrint__func "${PRINTF_QUESTION}" "${questionMsg}" "${PREPEND_EMPTYLINES_1}"
    fi

    #Ask user if he/she wants to change the wifi-interface to UP/DOWN
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${questionMsg} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

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
wifi_toggle_intf_handler__func()
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

    local timeout_normal_10s=10    #run command for 10 seconds
    local timeout_killafter_5s=5    #if command is still running AFTER 10 seconds, then wait for another 5 seconds and kill command

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
    debugPrint__func "${PRINTF_STATUS}" "${printfMsg}" "${PREPEND_EMPTYLINES_1}"

    #Toggle WiFi interface
    stdError=`timeout --kill-after ${timeout_killafter_5s} ${timeout_normal_10s} ip link set dev ${wlanSelectIntf} ${wifi_preSetTo} 2>&1 > /dev/null`  #set interface to UP
    exitCode=$? #get exit-code

    #Check if exit-code=0
    if [[ ${exitCode} -ne 0 ]]; then
        if [[ ${stdError} != ${EMPTYSTRING} ]]; then
            errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        fi

        errExit__func "${FALSE}" "${EXITCODE_99}" "${errMsg}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_TO_RESOLVE_THIS_ISSUE_PLEASE_REBOOT_DEVICE}" "${TRUE}"
    fi

#-------Double-check if the selected 'wlanSelectIntf' has changed to the correct state as specified by 'wifi_preSetTo=UP'

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"    

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
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 10 times
            break
        fi
    done

    if [[ ! -z ${stdOutput} ]]; then   #state has correctly changed to UP
        debugPrint__func "${PRINTF_STATUS}" "${successMsg}" "${PREPEND_EMPTYLINES_0}"
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

init_variables__sub()
{
    exitCode=0
    ip46_array=()
    ip46_line=${EMPTYSTRING}
    myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlan_isPresent=${FALSE}
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
            elif [[ ${argsTotal} -gt 1 ]]; then
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
        "${FG_ORANGE}Utility to enable/disable WiFi-interface${NOCOLOR}."
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\" \"${FG_LIGHTGREY}arg3${NOCOLOR}\" \"${FG_LIGHTGREY}arg4${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}WiFi-interface (e.g. wlan0)."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}WiFi-interface set to {${FG_LIGHTGREEN}up${FG_LIGHTGREY}|${FG_SOFLIGHTRED}down${NOCOLOR}}."
        "${FOUR_SPACES}arg3${TAB_CHAR}${TAB_CHAR}WiFi-interface search pattern (e.g. wlan)"
        "${FOUR_SPACES}arg4${TAB_CHAR}${TAB_CHAR}Path-to Netplan configuration file (e.g. /etc/netplan/*.yaml)."
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


get_stat_info__sub()
{
    get_wlan_intf_status__func

    get_wlan_ipv4_addr__func
}


#---MAIN SUBROUTINE
main__sub()
{
    if [[ -z ${wlanSelectIntf} ]]; then
        load_header__sub
    fi

    init_variables__sub

    input_args_handler__sub

    load_env_variables__sub

    get_wifi_pattern__func

    wlan_select__func

    define_dynamic_variables__sub
    
    get_stat_info__sub

    toggle_intf__func   
}



#---EXECUTE
main__sub
