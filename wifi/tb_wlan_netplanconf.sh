#!/bin/bash
#---TRAP ON EXIT
trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT

trap CTRL_C_func INT



#---INPUT ARGS
#When running this script as standalone, do NOT INPUT anything
wlanSelectIntf=${1} #optional
loadHeader_isNeeded=${2}    #optional
yaml_fpath=${3}     #optional
nonInterActive_isSetTo=${4}  #optional (Note: if this parameter is set, then this will have influence on function 'wifi_netplan_print_and_get_toBeDeleted_lines__func')
pattern_wlan=${5}



#---COLORS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_LIGHTBLUE=$'\e[30;38;5;45m'
FG_SOFTLIGHTBLUE=$'\e[30;38;5;51m'
FG_GREEN=$'\e[30;38;5;82m'
FG_ORANGE=$'\e[30;38;5;215m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
TIBBO_FG_WHITE=$'\e[30;38;5;15m'

TIBBO_BG_ORANGE=$'\e[30;48;5;209m'



#---CONSTANTS
TITLE="TIBBO"

EMPTYSTRING=""
CARROT_CHAR="^"
ENTER_CHAR=$'\x0a'
ONE_SPACE=" "
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

ZERO=0

TRUE=1
FALSE=0

EXITCODE_0=0
EXITCODE_99=99

INPUT_BACK="b"
INPUT_SKIP="s"
INPUT_ALL="a"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_YES="y"
INPUT_NO="n"

RETRY_MAX=3
SLEEP_TIMEOUT=1

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
IWCONFIG="iwconfig"
SCAN_SSID_IS_1="scan_ssid=1"

STATUS_UP="UP"
STATUS_DOWN="DOWN"
TOGGLE_UP="up"
TOGGLE_DOWN="down"

PATTERN_PASSWORD="password:"
PATTERN_SSID="ssid="
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
PRINTF_IPV6_ADDRESS="${FG_LIGHTBLUE}IPV6-ADDRESS${NOCOLOR}: "
PRINTF_IPV6_NETMASK="${FG_SOFTLIGHTBLUE}IPV6-NETMASK${NOCOLOR}: "
PRINTF_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR}${NOCOLOR}: "

PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO="STATIC IPV4 NETWORK INFO"
PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO="STATIC IPV6 NETWORK INFO"
PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR} IS ${FG_LIGHTRED}INACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_GREEN}RUNNING${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_NOT_RUNNING="WPA SUPPLICANT ${FG_LIGHTGREY}DAEMON${NOCOLOR} IS ${FG_LIGHTRED}NOT${NOCOLOR} RUNNING"

QUESTION_ACCEPT_AND_CONTINUE="ACCEPT AND CONTINUE (${FG_YELLOW}y${NOCOLOR}es, or redo ${FG_YELLOW}a${NOCOLOR}ll/ipv${FG_YELLOW}4${NOCOLOR}/ipv${FG_YELLOW}6${NOCOLOR})"
QUESTION_ADD_REPLACE_WIFI_ENTRIES="ADD/REPLACE WIFI ENTRIES (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)"
QUESTION_ENABLE_DHCP="ENABLE DHCP (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"

READ_IPV4_ADDRESS="${FG_LIGHTBLUE}IPV4-ADDRESS${NOCOLOR} (${FG_YELLOW}s${NOCOLOR}kip): "
READ_IPV4_NETMASK="${FG_SOFTLIGHTBLUE}IPV4-NETMASK (0 ~ 32)${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV4_GATEWAY="${FG_LIGHTBLUE}IPV4-GATEWAY${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "

READ_IPV6_ADDRESS="${FG_LIGHTBLUE}IPV6-ADDRESS${NOCOLOR} (${FG_YELLOW}s${NOCOLOR}kip): "
READ_IPV6_NETMASK="${FG_SOFTLIGHTBLUE}IPV6-NETMASK (0 ~ 128)${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "
READ_IPV6_GATEWAY="${FG_LIGHTBLUE}IPV6-GATEWAY${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): "



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
load_environmental_variables__sub()
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
    #   awk '{print $1}': get the first column
    #   sed 's/[0-9]*//g': exclude all numeric values from string
    #   xargs -n 1: convert string to array
    #   sort -u: get unique values
    #   xargs: convert back to string
    pattern_wlan_string=`{ ${IWCONFIG} | grep "${IEEE_80211}" | awk '{print $1}' | sed 's/[0-9]*//g' | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

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
    ${wlan_intf_updown_fpath} "${wlanSelectIntf}" "${FALSE}" "${yaml_fpath}" "${set_wifi_intf_to}" "${pattern_wlan}"
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

#***Check if 'nonInterActive_isSetTo == TRUE'.
    #If TRUE, then it means that this value has been already set in the input arg...
    #... Thus it is not needed to show the below Question.
    if [[ ${nonInterActive_isSetTo} == ${TRUE} ]]; then
        return
    fi

    #Check if there are any lines to be deleted.
    #If NONE, then exit function.
    if [[ ${wlanX_toBeDeleted_numOfLines} -eq 0 ]]; then
        return
    fi

    #Show Question only if:
    #1. nonInterActive_isSetTo == FALSE (which means not PRE set yet via input arg)
    #2. 'doNot_read_yaml == TRUE' 
    if [[ ${nonInterActive_isSetTo} == ${FALSE} ]]; then
        wifi_netplan_print_retrieve_question__func
    fi
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
wifi_netplan_print_retrieve_question__func()
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

    if [[ ${myChoice} == "n" ]]; then
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

    #Compose DHCP entries
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

wifi_netplan_static_ipv46_input__func()
{
    #Initial values
    myChoice=${INPUT_ALL}

    #Start input
    while true
    do
        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV4} ]]; then
            wifi_netplan_static_ipv4_input__func
        fi

        if [[ ${myChoice} == ${INPUT_ALL} ]] || [[ ${myChoice} == ${INPUT_IPV6} ]]; then
            wifi_netplan_static_ipv6_input__func
        fi

        #Show IPv4 and IPv6 Info
        wifi_netplan_print_summary_static_ipv46_input__func

        #Confirmation
        wifi_netplan_static_ipv46_question__func

        if [[ ${myChoice} == ${INPUT_YES} ]]; then
            break
        fi
    done

exit

}
wifi_netplan_static_ipv4_input__func()
{
    #Print START
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV4_NETWORK_INFO}" "${PREPEND_EMPTYLINES_1}"

    #Input IPv4 related info (address, netmask, gateway)
#---Input ipv4-address
    while true
    do
        read -p "${READ_IPV4_ADDRESS}" ipv4_address

        #Check if input is a valid ipv4-address
        if [[ ! -z ${ipv4_address} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv4_address} != ${INPUT_SKIP} ]]; then   #key 's' was NOT inputted
                
                ipv4_address_isValid=`checkIf_ipv4_address_isValid__func "${ipv4_address}"`
                if [[ ${ipv4_address_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
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
		read -p "${READ_IPV4_NETMASK}" ipv4_netmask

		#Check if input is a valid ipv4-netmask
		if [[ ! -z ${ipv4_netmask} ]]; then #is NOT an EMPTY STRING
			if [[ ${ipv4_netmask} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
				
				ipv4_netmask_isValid=`checkIf_ipv4_netmask_isValid__func "${ipv4_netmask}"`
				if [[ ${ipv4_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
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
        read -p "${READ_IPV4_GATEWAY}" ipv4_gateway

        #Check if input is a valid ipv4-gateway
        if [[ ! -z ${ipv4_gateway} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv4_gateway} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                if [[ ${ipv4_gateway} != ${ipv4_address} ]]; then    #not the same as 'ipv4-address'
                    
                    ipv4_gateway_isValid=`checkIf_ipv4_address_isValid__func "${ipv4_gateway}"`
                    if [[ ${ipv4_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv4-address
                        break
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
    done
}
function checkIf_ipv4_address_isValid__func()
{
    #Input args
    local ipv4Addr=${1}

    #Define variables
    local regEx="^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$"

    #Condition
    if [[ "${ipv4Addr}" =~ ${regEx} ]]; then
        echo "${TRUE}"
    else
        echo "${FALSE}"
    fi
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

wifi_netplan_static_ipv6_input__func()
{
    #Print START
    debugPrint__func "${PRINTF_INPUT}" "${PRINTF_WIFI_INPUT_IPV6_NETWORK_INFO}" "${PREPEND_EMPTYLINES_1}"

    #Input ipv6 related info (address, netmask, gateway)
#---Input ipv6-address
    while true
    do
        read -p "${READ_IPV6_ADDRESS}" ipv6_address

        #Check if input is a valid ipv6-address
        if [[ ! -z ${ipv6_address} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv6_address} != ${INPUT_SKIP} ]]; then   #key 's' was NOT inputted
                
                ipv6_address_isValid=`checkIf_ipv6_address_isValid__func "${ipv6_address}"`
                if [[ ${ipv6_address_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
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
		read -p "${READ_IPV6_NETMASK}" ipv6_netmask

		#Check if input is a valid ipv6-netmask
		if [[ ! -z ${ipv6_netmask} ]]; then #is NOT an EMPTY STRING
			if [[ ${ipv6_netmask} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
				
				ipv6_netmask_isValid=`checkIf_ipv6_netmask_isValid__func "${ipv6_netmask}"`
				if [[ ${ipv6_netmask_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
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
        read -p "${READ_IPV6_GATEWAY}" ipv6_gateway

        #Check if input is a valid ipv6-gateway
        if [[ ! -z ${ipv6_gateway} ]]; then #is NOT an EMPTY STRING
            if [[ ${ipv6_gateway} != ${INPUT_BACK} ]]; then   #key 'b' was NOT inputted
                if [[ ${ipv6_gateway} != ${ipv6_address} ]]; then    #not the same as 'ipv6-address'
                    
                    ipv6_gateway_isValid=`checkIf_ipv6_address_isValid__func "${ipv6_gateway}"`
                    if [[ ${ipv6_gateway_isValid} == ${TRUE} ]]; then  #is a VALID ipv6-address
                        break
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

    #Define variables
    local ipv6_address_modified=${EMPTYSTRING}
    local numOf_atChar=0
    local moreThan_twoConsecutiveColons_areFound=${EMPTYSTRING}
    local regEx='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

    #Condition
    if [[ "${ipv6Addr}" =~ ${regEx} ]]; then
        #Replace double-colons(::) with at-sign(@)  
        ipv6_address_modified=`echo ${ipv6Addr} | sed "s/${PATTERN_DOUBLECOLONS}/${PATTERN_ATSIGN}/"g`
        
        #Count the number of at-sign(@) in 'ipv6_address_modified'
        numOf_atSign=`echo "${ipv6_address_modified}" | tr -cd "${PATTERN_ATSIGN}" | wc -c`
        #For IPv6 address to be valid, ONLY 1 at-sign is allowed in the IPv6 address
        if [[ ${numOf_atSign} -le 1 ]]; then    #none or 1 at-sign found

            #Check if there are more than 2 consecutive colons (e.g., :::, ::::, :::::, etc...)
            moreThan_twoConsecutiveColons_areFound=` echo "${ipv6Addr}" | grep -oE "${PATTERN_TRIPLECOLONS_PLUS}" | awk '{ print $0, length}'`
            #For IPv6 address to valid, no more than 2 consecutive colons are allowed
            if [[ -z ${moreThan_twoConsecutiveColons_areFound} ]]; then  #2 consecutive colons found and NO MORE
                echo "${TRUE}"
            else    #more than 2 consecutive colons found
                echo "${FALSE}"
            fi
        else    #more than 1 add-sign found
            echo "${FALSE}"
        fi
    else
        echo "${FALSE}"
    fi
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

wifi_netplan_print_summary_static_ipv46_input__func()
{
    #Get length of all inputs
    if [[ ${ipv4_address} == "${INPUT_BACK}" ]] || [[ ${ipv4_address} == "${INPUT_SKIP}" ]]; then
        ipv4_address=${EMPTYSTRING}
    fi
    if [[ ${ipv4_netmask} == ${INPUT_BACK} ]] || [[ ${ipv4_addipv4_netmaskress} == ${INPUT_SKIP} ]]; then
        ipv4_netmask=${EMPTYSTRING}
    fi
    if [[ ${ipv4_gateway} == ${INPUT_BACK} ]] || [[ ${ipv4_gateway} == ${INPUT_SKIP} ]]; then
        ipv4_gateway=${EMPTYSTRING}
    fi
    if [[ ${ipv6_address} == ${INPUT_BACK} ]] || [[ ${ipv6_address} == ${INPUT_SKIP} ]]; then
        ipv6_address=${EMPTYSTRING}
    fi
    if [[ ${ipv6_netmask} == ${INPUT_BACK} ]] || [[ ${ipv6_addipv6_netmaskress} == ${INPUT_SKIP} ]]; then
        ipv6_netmask=${EMPTYSTRING}
    fi
    if [[ ${ipv6_gateway} == ${INPUT_BACK} ]] || [[ ${ipv6_gateway} == ${INPUT_SKIP} ]]; then
        ipv6_gateway=${EMPTYSTRING}
    fi


    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_WIFI_YOUR_IPV4_INPUT}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_ADDRESS}${ipv4_address}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_NETMASK}${ipv4_netmask}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV4_GATEWAY}${ipv4_gateway}" "${PREPEND_EMPTYLINES_0}"

    debugPrint__func "${PRINTF_SUMMARY}" "${PRINTF_WIFI_YOUR_IPV6_INPUT}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_ADDRESS}${ipv6_address}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_NETMASK}${ipv6_netmask}" "${PREPEND_EMPTYLINES_0}"
    debugPrint__func "${EIGHT_SPACES}" "${PRINTF_IPV6_GATEWAY}${ipv6_gateway}" "${PREPEND_EMPTYLINES_0}"
}

wifi_netplan_static_ipv46_question__func()
{
    #Print question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ACCEPT_AND_CONTINUE}" "${PREPEND_EMPTYLINES_1}"

    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,4,6,a] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            #Print question + answer
            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ACCEPT_AND_CONTINUE} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

            break
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done    
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


#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

wifi_init_variables__sub()
{
    if [[ ${nonInterActive_isSetTo} == ${EMPTYSTRING} ]]; then  #no value has been set yet
        nonInterActive_isSetTo=${FALSE} #set to FALSE
    fi

    allowedToChange_netplan=${TRUE}
    dhcp_isSelected=${TRUE}
    exitCode=0
    ipv4_address=${EMPTYSTRING}
    ipv4_netmask=${EMPTYSTRING}
    ipv4_gateway=${EMPTYSTRING}
    ipv4_address_isValid=${FALSE}
    ipv4_netmask_isValid=${FALSE}
    ipv4_gateway_isValid=${FALSE}

    ipv6_address=${EMPTYSTRING}
    ipv6_netmask=${EMPTYSTRING}
    ipv6_gateway=${EMPTYSTRING}
    ipv6_address_isValid=${FALSE}
    ipv6_netmask_isValid=${FALSE}
    ipv6_gateway_isValid=${FALSE}

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

wifi_netplan_del_add_apply__sub()
{
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

        if [[ ${dhcp_isSelected} == ${TRUE} ]]; then
            wifi_netplan_add_dhcp_entries__func
        else
            wifi_netplan_static_ipv46_input__func
        fi
    fi

    # wifi_netplan_apply__func
}


#---MAIN SUBROUTINE
main__sub()
{
    if [[ ${loadHeader_isNeeded} == ${TRUE} ]] || [[ ${loadHeader_isNeeded} == ${EMPTYSTRING} ]]; then
        load_header__sub
    fi

    load_environmental_variables__sub

    wifi_init_variables__sub

    wifi_get_wifi_pattern__func

    wifi_wlan_select__func

    wifi_define_dynamic_variables__sub

    wifi_toggle_intf__func ${STATUS_UP}

wifi_netplan_static_ipv46_input__func
exit
    wifi_netplan_del_add_apply__sub
}


#---EXECUTE
main__sub