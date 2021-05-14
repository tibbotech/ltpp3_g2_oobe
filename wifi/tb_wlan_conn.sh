#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
ssid_input=${1}                 #optional
ssidPwd_input=${2}              #optional
ssid_isHidden=${3}              #optional
ipv4_addrNetmask_input=${4}     #optional
ipv4_gateway_input=${5}         #optional
ipv4_dns_input=${6}             #optional
ipv6_addrNetmask_input=${7}     #optional
ipv6_gateway_input=${8}         #optional
ipv6_dns_input=${9}             #optional



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${ssid_input}

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=9

if [[ ${argsTotal} == ${ARGSTOTAL_MAX} ]]; then
    interactive_isEnabled=${FALSE}
else
    interactive_isEnabled=${TRUE}
fi

#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.3.12-0.0.1"



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



#---CONSTANTS
TITLE="TIBBO"

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

FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

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

PASSWD_MIN_LENGTH=8

#---READ INPUT CONSTANTS
ZERO=0
ONE=1

PASS="PASS"
DONOT_RETRY_AND_CONTINUE="DONOT_RETRY_AND_CONTINUE"
RETRY="RETRY"
QUIT="QUIT"

INPUT_BACK="b"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_NO="n"
INPUT_QUIT="q"
INPUT_REDO="r"
INPUT_REFRESH="r"
INPUT_SKIP="s"
INPUT_YES="y"

#---RETRY CONSTANTS
DAEMON_RETRY=10
IWCONFIG_RETRY=30

#---TIMEOUT CONSTANTS
DAEMON_TIMEOUT=1
IW_TIMEOUT=1
SLEEP_TIMEOUT=1

#---LINE CONSTANTS
INSERT_AFTER_LINE_1=1

NUMOF_ROWS_0=0
NUMOF_ROWS_1=1
NUMOF_ROWS_2=2
NUMOF_ROWS_3=3
NUMOF_ROWS_4=4
NUMOF_ROWS_5=5
NUMOF_ROWS_6=6
NUMOF_ROWS_7=7

EMPTYLINES_1=1

#---STATUS/BOOLEANS
ENABLED="enabled"
DISABLED="disabled"
ACTIVE="active"
INACTIVE="inactive"

TOGGLE_UP="up"
TOGGLE_DOWN="down"
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
PRINTF_USAGE_DESCRIPTION="Utility to setup WiFi-interface and establish connection."



#---PRINTF PHASES
PRINTF_INFO="INFO:"
PRINTF_IW="${IW_CMD}:"
PRINTF_QUESTION="QUESTION:"
PRINTF_RESTARTING="RESTARTING:"
PRINTF_STOPPING="STOPPING:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_TERMINATING="TERMINATING:"
PRINTF_WAITING_FOR="WAITING FOR:"
PRINTF_WARNING="${FG_PURPLERED}WARNING${NOCOLOR}:"
PRINTF_WRITING="WRITING:"

#---PRINTF ERROR MESSAGES
ERRMSG_COULD_NOT_ESTABLISH_CONNECTION_TO_SSID="COULD NOT ESTABLISH CONNECTION TO SSID ${FG_LIGHTGREY}${ssid_input}${NOCOLOR}"
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_FAILED_TO_RETRIEVE_SSIDS="${FG_LIGHTRED}FAILED${NOCOLOR} TO RETRIEVE SSIDS"
ERRMSG_FAILED_TO_TERMINATE_WPA_SUPPLICANT_DAEMON="${FG_LIGHTRED}FAILED${NOCOLOR} TO TERMINATE WPA SUPPLICANT DAEMON"
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
ERRMSG_PASSWORDS_DO_NOT_MATCH="PASSWORDS DO *NOT* MATCH"
ERRMSG_PASSWORD_MUST_BE_8_63_CHARACTERS="PASSWORD MUST BE 8..63 CHARACTERS"
ERRMSG_PLEASE_CHECK_SSID_AND_PASSWORD="PLEASE CHECK *SSID* AND *PASSWORD*"
ERRMSG_WIFI_INTERFACE_FOUND_BUT_NOT_UP="WIFI INTERFACE FOUND BUT NOT ${FG_LIGHTGREY}UP${NOCOLOR}"

#---PRINTF MESSAGES
PRINTF_ABOUT_TO_EXIT_WIFI_CONFIGURATION="ABOUT TO EXIT WiFi CONFIGURATION..."
PRINTF_ATTEMPTING_TO_RETRIEVE_SSIDS="ATTEMPTING TO RETRIEVE SSIDs"
PRINTF_CHECKING_SSID_CONNECTION_STATUS="CHECKING SSID CONNECTION STATUS..."
PRINTF_DAEMON_RELOAD="SYSTEMCTL DAEMON-RELOAD"
PRINTF_ESTABLISHED_CONNECTION_TO_SSID="${FG_GREEN}SUCCESSFULLY${NOCOLOR} ESTABLISHED CONNECTION TO SSID ${FG_LIGHTGREY}${ssid_input}${NOCOLOR}"
PRINTF_FILE_NOT_FOUND="FILE NOT FOUND:"
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."
PRINTF_PLEASE_EXECUTE_THE_FOLLOWING_COMMAND="PLEASE EXECUTE THE FOLLOWING COMMAND: ${FG_LIGHTGREY}${thisScript_fpath}${NOCOLOR}"
PRINTF_TERMINATION_OF_APPLICATION="TERMINATION OF APPLICATION"
PRINTF_TO_RUN_THE_WIFI_CONFIGURATION_AT_ANOTHER_TIME="TO RUN THE WiFi CONFIGURATION AT ANOTHER TIME..."

PRINTF_WPA_SUPPLICANT_DAEMON="WPA SUPPLICANT DAEMON"
PRINTF_WPA_SUPPLICANT_SERVICE_ENABLED="WPA SUPPLICANT DAEMON: ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_AND_NETPLAN_DAEMONS="WPA SUPPLICANT & NETPLAN DAEMONS (INCL. SSID CONNECTION)"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE="WPA SUPPLICANT DAEMON: ${FG_GREEN}ACTIVE${NOCOLOR}...OK"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE="WPA SUPPLICANT DAEMON: ${FG_LIGHTRED}IN-ACTIVE${NOCOLOR}...OK"
PRINTF_WPA_SUPPLICANT_SERVICE="WPA SUPPLICANT SERVICE"
PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_LIGHTRED}IN-ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_NOT_PRESENT="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"
PRINTF_WPA_SUPPLICANT_SERVICE_ISALREADY_ENABLED="SERVICE IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"

#---QUESTION MESSAGES
QUESTION_ADD_AS_HIDDEN_SSID="ADD AS ${FG_PURPLERED}HIDDEN${NOCOLOR} SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}r${NOCOLOR}edo/${FG_YELLOW}q${NOCOLOR}uit)?"
QUESTION_SELECT_ANOTHER_SSID="SELECT ANOTHER SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}q${NOCOLOR}uit)?"

#---READ INPUT MESSAGES
READ_CONNECT_TO_ANOTHER_SSID="CONNECT TO A DIFFERENT SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}q${NOCOLOR}uit)?"
READ_CONNECT_TO_AN_SSID="CONNECT TO AN SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}q${NOCOLOR}uit)?"



#---VARIABLES
dynamic_variables_definition__sub()
{
    # errmsg_occurred_in_file_wlan_netplanconf="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_netplanconf_filename}${NOCOLOR}"
    errmsg_occurred_in_file_wlan_intf_updown="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_intf_updown_filename}${NOCOLOR}"

    #This is the Daemon using the configuration as specified in file /etc/wpa_supplicant.conf
    # pattern_ps_axf_wpa_supplicant_11="${WPA_SUPPLICANT} -B -c ${wpaSupplicant_conf_fpath} -i${wlanSelectIntf}"
    # pattern_ps_axf_wpa_supplicant_12="${WPA_SUPPLICANT} -B -c ${wpaSupplicant_conf_fpath} -i ${wlanSelectIntf}"
    
    # #This is the Daemon using the configuration as specified in file run/netplan/wpa-wlan0.conf (protected)
    # #This file is only created when a WiFi interfaces (including wpa ssid & password) is configured in /etc/netplan/*.yaml
    # pattern_ps_axf_wpa_supplicant_21="${WPA_SUPPLICANT} -c ${run_netplan_dir}/wpa-${wlanSelectIntf}.conf -i${wlanSelectIntf}"
    # pattern_ps_axf_wpa_supplicant_22="${WPA_SUPPLICANT} -c ${run_netplan_dir}/wpa-${wlanSelectIntf}.conf -i ${wlanSelectIntf}"

    printf_file_not_found_wpa_supplicant="${PRINTF_FILE_NOT_FOUND} ${FG_LIGHTGREY}${wpaSupplicant_conf_fpath}${NOCOLOR}"
    printf_ssid_and_password_to_wpaSupplicant_conf="SSID & PASSWORD TO ${FG_LIGHTGREY}${wpaSupplicant_conf_fpath}${NOCOLOR}"
}



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    lib_systemd_system_dir=/lib/systemd/system
    tmp_dir=/tmp
    usr_bin_dir=/usr/bin

    systemctl_filename="systemctl"
    systemctl_fpath=${usr_bin_dir}/${systemctl_filename}

    wlan_conn_info_filename="tb_wlan_conn_info.sh"
    wlan_conn_info_fpath=${current_dir}/${wlan_conn_info_filename}    

    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

    wlan_netplanconf_filename="tb_wlan_netplan_conf.sh"
    wlan_netplanconf_fpath=${current_dir}/${wlan_netplanconf_filename}

    wpa_supplicant_service_filename="wpa_supplicant.service"
    wpa_supplicant_service_fpath=${lib_systemd_system_dir}/${wpa_supplicant_service_filename}

    etc_dir=/etc
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

    tb_wlan_conn_iwlistScan_raw_tmp_filename="tb_wlan_conn_iwlistScan_raw.tmp"
    tb_wlan_conn_iwlistScan_raw_tmp_fpath=${tmp_dir}/${tb_wlan_conn_iwlistScan_raw_tmp_filename}
    tb_wlan_conn_iwlistScan_ssid_quality_tmp_filename="tb_wlan_conn_iwlistScan_ssid_quality.tmp"
    tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath=${tmp_dir}/${tb_wlan_conn_iwlistScan_ssid_quality_tmp_filename}
    tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_filename="tb_wlan_conn_iwlistScan_ssid_quality_sorted.tmp"
    tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_fpath=${tmp_dir}/${tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_filename}
    tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_filename="tb_wlan_conn_iwlistScan_ssid_quality_final.tmp"
    tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath=${tmp_dir}/${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_filename}
}



#---FUNCTIONS
function press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=5

	#Initialize variables
	local keyPressed=""
	local tCounter=0
    local delta_tCounter=0

	#Show Press Any Key message with count-down
	while [[ ${tCounter} -le ${ANYKEY_TIMEOUT} ]];
	do
		delta_tCounter=$(( ${ANYKEY_TIMEOUT} - ${tCounter} ))

		echo -e "\rPress (a)bort or any key to continue... (${delta_tCounter}) \c"
		read -N 1 -t 1 -s -r keyPressed

		if [[ ! -z "${keyPressed}" ]]; then
			if [[ "${keyPressed}" == "a" ]] || [[ "${keyPressed}" == "A" ]]; then
				exit
			else
				break
			fi
		fi
		
		tCounter=$((tCounter+1))
	done

	echo -e "\r"
}

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

function convertTo_lowercase__func()
{
    #Input args
    local orgString=${1}

    #Define local variables
    local lowerString=`echo ${orgString} | tr "[:upper:]" "[:lower:]"`

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
    printf '%s%b\n' "${FG_ORANGE}${topic}${NOCOLOR} ${msg}"
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
        if [[ ${user_isRoot} == ${TRUE} ]]; then
            errExit_kill_wpa_supplicant_daemon__func
        fi

        printf '%s%b\n' "${FG_ORANGE}EXITING:${NOCOLOR} ${thisScript_filename}"
        printf '%s%b\n' ""
        
        exit ${EXITCODE_99}
    fi
}
function errExit_kill_wpa_supplicant_daemon__func()
{
    #Check if 'wpa_supplicant test daemon' is running
    local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
    if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
        wpa_supplicant_kill_daemon__func
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

wlan_intf_selection__sub()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    # if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
    #     return
    # fi

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
        errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_occurred_in_file_wlan_intf_updown}" "${TRUE}"
    fi
}


function get_current_config_ssid_name__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[  ${interactive_isEnabled} == ${FALSE} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        ssid_isAllowed_toBe_Configured=${TRUE}  #MANDATORY

        return
    fi

    #Define local variables
    local debugMsg=${EMPTYSTRING}
    local readInputMsg=${EMPTYSTRING}
    local wpa_supplicant_ssid=${EMPTYSTRING}

    #Check if '/etc/wpa_supplicant.conf' exists
    if [[ -f ${wpaSupplicant_conf_fpath} ]]; then
        wpa_supplicant_ssid=`cat ${wpaSupplicant_conf_fpath} | grep -w ${PATTERN_SSID} | grep -v ${PATTERN_USAGE} |cut -d"${QUOTE_CHAR}" -f2 2>&1`
        
        debugMsg="CURRENT SSID: ${FG_YELLOW}${wpa_supplicant_ssid}${NOCOLOR}"    #MUST BE PUT HERE
        debugPrint__func "${PRINTF_INFO}" "${debugMsg}" "${EMPTYLINES_1}"

        readInputMsg=${READ_CONNECT_TO_ANOTHER_SSID}
    else
        readInputMsg=${READ_CONNECT_TO_AN_SSID}
    fi

    #Show 'read-input message'
    debugPrint__func "${PRINTF_QUESTION}" "${readInputMsg}" "${EMPTYLINES_1}"

    #Ask if user wants to connec to a WiFi AccessPoint
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n,q] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${readInputMsg} ${myChoice}" "${EMPTYLINES_0}"

            if [[ ${myChoice} == ${INPUT_QUIT} ]]; then   #answer was Abort
                exit 0
            else
                break
            fi
        else
            clear_lines__func ${NUMOF_ROWS_0}
        fi
    done

    if [[ ${myChoice} == ${INPUT_YES} ]]; then
        ssid_isAllowed_toBe_Configured=${TRUE}
    else
        ssid_isAllowed_toBe_Configured=${FALSE}
    fi
}

function wpa_supplicant_get_service_status__func()
{   
    #Define local variable
    local EMPTYLINES=${EMPTYLINES_0}

    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[  ${interactive_isEnabled} == ${FALSE} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        EMPTYLINES=${EMPTYLINES_1}
    fi

    #PLEASE NOTE that the wpa_supplicant 'service' is NOT dependent on the wpa_supplicant 'daemon'

    #Check if wpa_supplicant service is present
    #REMARK: use '2>&1 > /dev/null' to capture stdErr only
    local stdError=`systemctl status ${WPA_SUPPLICANT} 2>&1 > /dev/null`

    if [[ ! -z ${stdError} ]]; then #an error has occurred
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_NOT_PRESENT}" "${EMPTYLINES}"
    else    #no errors found
        #Check if wpa_supplicant service is 'active' or 'inactive'
        local wpa_service_status=`systemctl is-active "${WPA_SUPPLICANT}" 2>&1`

        if [[ ${wpa_service_status} == ${INACTIVE} ]]; then    #is Inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE}" "${EMPTYLINES}"
        else    #is Active
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE}" "${EMPTYLINES}"
        fi
    fi
}

function wpa_supplicant_get_daemon_status__func()
{
    #PLEASE NOTE that the wpa_supplicant 'daemon' is NOT dependent on the wpa_supplicant 'service'

    #Check if 'wpa_supplicant.conf' is present
    if [[ ! -f ${wpaSupplicant_conf_fpath} ]]; then  #file is NOT found
        wpa_supplicant_daemon_isRunning=${FALSE}

        debugPrint__func "${PRINTF_STATUS}" "${printf_file_not_found_wpa_supplicant}" "${EMPTYLINES_1}"
    else    #file is found
        #Check if wpa_supplicant test daemon is running
        #REMARK:
        #TWO daemons could be running:
        #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
        #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
        #GET PID of TEST DAEMON
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            wpa_supplicant_daemon_isRunning=${TRUE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE}" "${EMPTYLINES_1}"
        else    #daemon is NOT running
            wpa_supplicant_daemon_isRunning=${FALSE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE}" "${EMPTYLINES_1}"
        fi
    fi
}

function wpa_supplicant_kill_daemon__func()
{   
    #Define local variables
    local EMPTYLINES=${EMPTYLINES_0}
    local ps_pidList_string=${EMPTYSTRING}
    local ps_pidList_array=()
    local ps_pidList_item=${EMPTYSTRING}
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if wpa_supplicant daemon is already IN-ACTIVE
    #If TRUE, then exit function immediately
    if [[ ${wpa_supplicant_daemon_isRunning} == ${FALSE} ]]; then
        return
    fi 
    
    #If that's the case, kill that daemon
    if [[ ${errExit_isEnabled} == ${TRUE} ]]; then
        EMPTYLINES=${EMPTYLINES_1}
    fi
    debugPrint__func "${PRINTF_TERMINATING}" "${PRINTF_WPA_SUPPLICANT_AND_NETPLAN_DAEMONS}" "${EMPTYLINES}"

    #GET PID of TEST DAEMON
    #REMARK:
    #TWO daemons could be running:
    #1. WPA_SUPPLICANT DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
    #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
    #GET THEIR PIDs
    local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`

    #Convert string to array
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL DAEMON
    for ps_pidList_item in "${ps_pidList_array[@]}"; do 
        printf '%b\n' "${EIGHT_SPACES}${FG_LIGHTRED}Killed${NOCOLOR} PID: ${ps_pidList_item}"

        kill -9 ${ps_pidList_item}
    done

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"


    #CHECK IF DAEMON HAS BEEN KILLED AND EXIT
    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ -z ${ps_pidList_string} ]]; then  #deamons are NOT running
            wpa_supplicant_daemon_isRunning=${FALSE}

            break
        else    #deamons are NOT running
            wpa_supplicant_daemon_isRunning=${TRUE}
        fi

        sleep ${DAEMON_TIMEOUT}  #wait

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

    #HANDLE RESULT
    if [[ ${wpa_supplicant_daemon_isRunning} == ${TRUE} ]]; then    #daemon is still running (not good)
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_TERMINATE_WPA_SUPPLICANT_DAEMON}" "${TRUE}"
    fi
}

function get_available_ssid__func()
{

    #Define local constants
    local PATTERN_NULL="\x00"
    local PATTERN_ESSID="ESSID"
    local PATTERN_QUALITY="Quality"
    local RETRY_PARAM_MAX=3

    local PRINTF_HEADER_SSID="SSID"
    local PRINTF_HEADER_SIGNAL="SIGNAL(%)"

    #REMARK: regading the signal-quality when using the commands 'iwlist' and 'iw'
    #1. MIN SIGNAL-LEVEL: -110 dBm -> MIN SIGNAL-QUALITY=0
    #2. MAX SIGNAL-LEVEL: -40 dBm -> MAX SIGNAL-QUALITY=70
    #FORMULA: LEVEL = QUALITY + 110

    local QUALITY_MIN=0
    local QUALITY_MAX=70

    #Define local variable
    local printf_width=0
    local print_width_tmp=0
    local header_ssid_len=0
    local ssid_org_len=0

    local retry_param=0

    local ssidList_string=${EMPTYSTRING}
    local ssidList_array=()
    local ssidList_arrayItem=${EMPTYSTRING}
    local qualityRawList_string=${EMPTYSTRING}
    local qualityRawList_array=()
    local qualityRawList_arrayItem=${EMPTYSTRING}
    local qualityPercList_array=()
    local qualityPercList_arrayItem=${EMPTYSTRING}

    local ssid_org=${EMPTYSTRING}
    local ssid_adj=${EMPTYSTRING}
    local ssid_colored=${EMPTYSTRING}
    local qualityPerc_org=${EMPTYSTRING}
    local qualityPerc_colored=${EMPTYSTRING}
    local qualityPerc_chosenColor=${NOCOLOR}

    local qualityValue=0
    local maxQualityValue=0
    local qualityPerc=0

    local stdError=${EMPTYSTRING}

    #Delete files
    if [[ -f ${tb_wlan_conn_iwlistScan_raw_tmp_fpath} ]]; then
        rm ${tb_wlan_conn_iwlistScan_raw_tmp_fpath}
    fi

    if [[ -f ${tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath} ]]; then
        rm ${tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath}
    fi

    if [[ -f ${tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_fpath} ]]; then
        rm ${tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_fpath}
    fi
    
    if [[ -f ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath} ]]; then
        rm ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}
    fi

    #Print empty line
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ATTEMPTING_TO_RETRIEVE_SSIDS}" "${EMPTYLINES_1}"

    #Check if the 'iwlist' command can be run without an error
    stdError=`${IWLIST_CMD} ${wlanSelectIntf} scan 2>&1 > /dev/null`
    exitCode=$?

    if [[ ! -z ${stdError} ]]; then    #string contains data
        errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_RETRIEVE_SSIDS}" "${TRUE}"
    fi


#---RAW
    #Get Available SSID list
    while true
    do
        #Get all SSID (including all data) and write to a temporary file
        ${IWLIST_CMD} ${wlanSelectIntf} scan > ${tb_wlan_conn_iwlistScan_raw_tmp_fpath} 2>&1

        #Check if file 'tb_wlan_conn_iwlistScan.tmp' contains any data
        #if TRUE, then exit loop
        if [[ -f ${tb_wlan_conn_iwlistScan_raw_tmp_fpath} ]]; then
            break
        fi

        retry_param=$((retry_param+1))  #increment counter

        #Only allowed to retry 3 times
        #Whether the 'ssidList_string' contains data or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then
            break
        fi
    done


#---SSID:only
    #Get SSID and store in SSIDList_string
    ssidList_string=`cat ${tb_wlan_conn_iwlistScan_raw_tmp_fpath} | grep "${PATTERN_ESSID}" | cut -d":" -f2`
    #Convert string to array
    eval "ssidList_array=(${ssidList_string})"   
    # get length of an array
    ssidList_arrayLen=${#ssidList_array[@]}

#---QUALITY: current-value/max-value (e.g. 30/70)
    #Get Quality and store in qualityRawList_string
    qualityRawList_string=`cat ${tb_wlan_conn_iwlistScan_raw_tmp_fpath} | grep "${PATTERN_QUALITY}" | cut -d"=" -f2 | cut -d" " -f1`
    #Convert string to array
    eval "qualityRawList_array=(${qualityRawList_string})"   

#---QUALITY in Percentage (current-value*100/max-value)
    #Cycle through Arrays and Combine Arrays into One Array
    for qualityRawList_arrayItem in "${qualityRawList_array[@]}"
    do
        #Get the REAL signal-quality
        qualityValue=`echo ${qualityRawList_arrayItem} | cut -d"\${SLASH_CHAR}" -f1`
        #Calculate the percentage (=REAL*100/MAX)
        qualityPerc=$(( ((qualityValue-QUALITY_MIN)*100)/(QUALITY_MAX-QUALITY_MIN) ))

        #Add to 'qualityPerc' to array 'qualityPercList_array'
        qualityPercList_array+=(${qualityPerc})    
    done


#---PRINTF-WIDTH: get length of longest string
    for ssidList_arrayItem in ${ssidList_array[@]}
    do
        print_width_tmp=${#ssidList_arrayItem}

        #Check if 'print_width_tmp' is LARGER THAN 'printf_width'
        #If TRUE, then update 'printf_width'
        if [[ ${print_width_tmp} -gt ${printf_width} ]]; then
            printf_width=${print_width_tmp}  #update variable
        fi
    done

    #Increase 'printf_width' by '4'
    #REMARK: in case there are irregularities in the string-value
    printf_width=$((printf_width+1))
    

#---SIGNAL-HEADER LENGTH: get length of the header 'PRINTF_HEADER_SSID'
    header_ssid_len=${#PRINTF_HEADER_SSID}
    
    #Re-adjust 'printf_width' (if needed)
    #Re-define header_ssid (if applicable2)
    if [[ ${header_ssid_len} -gt ${printf_width} ]]; then
        printf_width=${header_ssid_len}

        #Update variable
        header_ssid=${PRINTF_HEADER_SSID}
    else
        #Redefine variable by appending trailing spaces
        header_ssid=`printf "%-${printf_width}s" "${PRINTF_HEADER_SSID}"`
    fi


#---COMBINE: SSID+QUALITY (For SORTING)
    #Cycle through Arrays and Combine Arrays into One Array
    for (( j=1; j<${ssidList_arrayLen}+1; j++ ))
    do
        #Get SSID
        ssidList_arrayItem=${ssidList_array[$j-1]}

        if [[ ${ssidList_arrayItem} != *"${PATTERN_NULL}"* ]] && [[ ${ssidList_arrayItem} != ${EMPTYSTRING} ]]; then #only show NON-EMPTYSTRING
            #Get Quality of that SSID
            qualityPercList_arrayItem=${qualityPercList_array[$j-1]}

            echo -e "${ssidList_arrayItem}${COMMA_CHAR}${qualityPercList_arrayItem}" >> ${tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath}
        fi
    done

    #1. Sort column#2 of file 'tb_wlan_conn_iwlistScan_ssid_quality.tmp'
    #2. Write to file 'tb_wlan_conn_iwlistScan_ssid_quality_sorted.tmp'
    #REMARK:
    #   -t<new separator>: define 'column-separator'
    #   -k<column-number>: define column-number to be sorted
    #   -rn: reverse numeric sort
    sort -t${COMMA_CHAR} -k2 -rn ${tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath} > ${tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_fpath}


#---FINALIZATION: SSID + SIGNAL-QUALITY
    #HEADER:
    #Write to file
    echo -e "---------------------------------------------------------------------" > ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}
    echo -e "${FOUR_SPACES}${NOCOLOR}${header_ssid}${EIGHT_SPACES}${PRINTF_HEADER_SIGNAL}${NOCOLOR}" >> ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}
    echo -e "---------------------------------------------------------------------" >> ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}

    #BODY:
    #1. Read each line of file 'tb_wlan_conn_iwlistScan_ssid_quality_sorted.tmp'
    #2. Extract SSID and Signal-Quality
    #3. Append Empty Spaces to SSID (if needed)
    #4. Add 'color' to SSID and Signal-Quality
    while read line
    do
        #Get SSID
        ssid_org=`echo ${line} | cut -d"," -f1`
        #Determine SSID-length
        ssid_org_len=${#ssid_org}

        #Add Empty Spaces (if needed)
        if [[ ${ssid_org_len} -lt ${printf_width} ]]; then
              #Add Empty Spaces if needed
            ssid_adj=`printf "%-${printf_width}s" "${ssid_org}"`
        else
            ssid_adj=${ssid_org}
        fi        

        #Get Signal-Quality
        qualityPerc_org=`echo ${line} | cut -d"," -f2`

        #Color 'qualityPerc' and add '%'
        #Choose color
        qualityPerc_chosenColor=`get_available_ssid_chooseColor__func "${qualityPerc_org}"`
        #Add color to 'qualityPerc_org'
        qualityPerc_colored="${qualityPerc_chosenColor}${qualityPerc_org}${NOCOLOR}"

        # #Add 'FG_LIGHTGREY' to 'ssidList_arrayItem'
        # ssid_colored=${FG_LIGHTGREY}${ssid_adj}${NOCOLOR}

        #Combine 'ssidList_arrayItem'+'qualityPerc_org'
        #Write to file
        echo -e "${FOUR_SPACES}${ssid_adj}${EIGHT_SPACES}${qualityPerc_colored}" >> ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}
    done < ${tb_wlan_conn_iwlistScan_ssid_quality_sorted_tmp_fpath}
}
function get_available_ssid_chooseColor__func()
{
    #Input args
    local perc_input=${1}

    #Define local colors
    local FG_GREEN_46=$'\e[30;38;5;46m'
    local FG_GREEN_82=$'\e[30;38;5;82m'
    local FG_GREEN_118=$'\e[30;38;5;118m'
    local FG_GREENYELLOW_154=$'\e[30;38;5;155m'
    local FG_GREENYELLOW_148=$'\e[30;38;5;148m'
    local FG_YELLOW_226=$'\e[30;38;5;226m'
    local FG_YELLOWORANGE_215=$'\e[30;38;5;215m'
    local FG_ORANGE_208=$'\e[30;38;5;208m'
    local FG_DARKERORANGE_202=$'\e[30;38;5;202m'
    local FG_RED_196=$'\e[30;38;5;196m'

    #Define local constants
    local PERC_10=10
    local PERC_20=20
    local PERC_30=30
    local PERC_40=40
    local PERC_50=50
    local PERC_60=60
    local PERC_70=70
    local PERC_80=80
    local PERC_90=90

    #Choose color based on input parameter
    if [[ ${perc_input} -lt ${PERC_10} ]]; then
        chosenColor=${FG_RED_196}
    elif [[ ${perc_input} -ge ${PERC_10} ]] && [[ ${perc_input} -lt ${PERC_20} ]]; then
        chosenColor=${FG_DARKERORANGE_202}
    elif [[ ${perc_input} -ge ${PERC_20} ]] && [[ ${perc_input} -lt ${PERC_30} ]]; then
        chosenColor=${FG_ORANGE_208}
    elif [[ ${perc_input} -ge ${PERC_30} ]] && [[ ${perc_input} -lt ${PERC_40} ]]; then
        chosenColor=${FG_YELLOWORANGE_215}
    elif [[ ${perc_input} -ge ${PERC_40} ]] && [[ ${perc_input} -lt ${PERC_50} ]]; then
        chosenColor=${FG_YELLOW_226}
    elif [[ ${perc_input} -ge ${PERC_50} ]] && [[ ${perc_input} -lt ${PERC_60} ]]; then
        chosenColor=${FG_GREENYELLOW_148}
    elif [[ ${perc_input} -ge ${PERC_60} ]] && [[ ${perc_input} -lt ${PERC_70} ]]; then
        chosenColor=${FG_GREENYELLOW_154}
    elif [[ ${perc_input} -ge ${PERC_70} ]] && [[ ${perc_input} -lt ${PERC_80} ]]; then
        chosenColor=${FG_GREEN_118}
    elif [[ ${perc_input} -ge ${PERC_80} ]] && [[ ${perc_input} -lt ${PERC_90} ]]; then
        chosenColor=${FG_GREEN_82}
    else    #perc_input > 90%
        chosenColor=${FG_GREEN_46}
    fi

    #Output
    echo ${chosenColor}
}

function show_available_ssid__func() {
    #Define local variable
    local line=${EMPTYSTRING}

    #Show content of file
    #REMARK:
    #   'IFS' is important to be included here, because...
    #   ...without 'IFS', the regEx'es (incl. spaces),...
    #   ...will not be processed. Instead,...
    #   ...those regEx'es will be printed as characters.
    IFS=''
    while read -r line
    do
        echo "${line}"
    done < ${tb_wlan_conn_iwlistScan_ssid_quality_final_tmp_fpath}
}

function choose_ssid__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        return
    fi

    #Define local variables
    local mySsid_isValid=${EMPTYSTRING}
    local debugMsg=${EMPTYSTRING}

    #Get Available SSIDs
    get_available_ssid__func

    #Show Available SSIDs
    show_available_ssid__func

    #Print empty line
    printf '%b%s\n' ""

    #Select SSID
    while true
    do
        read -p "${FG_LIGHTBLUE}SSID${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh, ${FG_YELLOW}q${NOCOLOR}uit): " ssid_input #provide your input
      
        if [[ ! -z ${ssid_input} ]]; then   #input was NOT an empty string
            if [[ ${ssid_input} == ${INPUT_QUIT} ]]; then  #answer was Abort
                exit 0
            elif [[ ${ssid_input} == ${INPUT_REFRESH} ]]; then
                #Get Available SSIDs
                get_available_ssid__func

                #Show Available SSIDs
                show_available_ssid__func

                #Print empty line
                printf '%b%s\n' ""
            else
                mySsid_isValid=`cat ${tb_wlan_conn_iwlistScan_ssid_quality_tmp_fpath} | awk '{print $1}' | egrep "${ssid_input}" 2>&1`
                if [[ ! -z ${mySsid_isValid} ]]; then #SSID was found in the 'ssidList_string'
                    break
                else    #SSID was NOT found in the 'ssidList_string'
                    debugPrint__func "${PRINTF_WAITING_FOR}" "${PRINTF_TERMINATION_OF_APPLICATION}" "${EMPTYLINES_1}"

                    debugMsg="SSID ${FG_LIGHTGREY}${ssid_input}${NOCOLOR} ${FG_LIGHTRED}NOT${NOCOLOR} FOUND"
                    debugPrint__func "${PRINTF_WARNING}" "${debugMsg}" "${EMPTYLINES_0}"

                    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_AS_HIDDEN_SSID}" "${EMPTYLINES_0}"
                  
                    while true
                    do
                        read -N1 -r -s -p "" myChoice

                        if [[ ${myChoice} =~ [y,n,r,q] ]]; then
                            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

                            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_AS_HIDDEN_SSID} ${myChoice}" "${EMPTYLINES_0}"

                            break
                        fi
                    done

                    if [[ ${myChoice} != ${INPUT_REDO} ]]; then   #answer was NOT redo
                        if [[ ${myChoice} == ${INPUT_QUIT} ]]; then   #answer was Abort
                            exit 0
                        elif [[ ${myChoice} == ${INPUT_YES} ]]; then
                            ssid_isHidden=${TRUE}   #flag SSID as HIDDEN
                        fi

                        printf '%s%b\n' ""

                        break
                    else    #myChoice == 'r'
                        clear_lines__func ${NUMOF_ROWS_5}
                    fi
                fi
            fi
        else    #input was an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi
    done
}

function ssidPassword_input__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    # if [[ ! -z ${ssidPwd_input} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
    #     interactive_isEnabled=${FALSE}

    #     return
    # fi
    
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        return
    fi

    #Define local variables
    local mySsidPwd_len=0
    local mySsidPwd_confirm=${EMPTYSTRING}
    local errMsg=${EMPTYSTRING}

    #Provide phrase (password)
    while true
    do
        tput sc #backup cursor position

        read -s -p "${FG_LIGHTBLUE}PASSWORD${NOCOLOR} (${FG_YELLOW}q${NOCOLOR}uit): " ssidPwd_input #provide your input
        if [[ ! -z ${ssidPwd_input} ]]; then   #input was NOT an empty string
            if [[ ${ssidPwd_input} == ${INPUT_QUIT} ]]; then   #answer was Abort
                exit 0
            fi

            mySsidPwd_len=${#ssidPwd_input}  #Get the length of input 'ssidPwd_input'
            if [[ ${mySsidPwd_len} -ge ${PASSWD_MIN_LENGTH} ]]; then #string length is at least 8 characters
                printf '%s%b\n' ""
                
                tput sc #backup cursor position

                while true
                do
                    read -s -p "${FG_SOFTLIGHTBLUE}PASSWORD (Confirm)${NOCOLOR} (${FG_YELLOW}q${NOCOLOR}uit): " mySsidPwd_confirm #provide your input
                    if [[ ! -z ${mySsidPwd_confirm} ]]; then   #input was NOT an empty string
                        if [[ ${mySsidPwd_confirm} == ${INPUT_QUIT} ]]; then   #answer was Abort
                            exit 0
                        fi

                        #Compare 'ssidPwd_input' with 'mySsidPwd_confirm' (both HAS TO BE THE SAME)
                        if [[ "${ssidPwd_input}" == "${mySsidPwd_confirm}" ]]; then 
                            return
                        else
                            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_PASSWORDS_DO_NOT_MATCH}" "${FALSE}"

                            press_any_key__func

                            clear_lines__func ${NUMOF_ROWS_4}

                            break
                        fi
                    else
                        tput rc #restore cursor position
                    fi
                done
            else    #string length is NOT at least 8 characters
                errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_PASSWORD_MUST_BE_8_63_CHARACTERS}" "${FALSE}"

                press_any_key__func

                clear_lines__func "${NUMOF_ROWS_3}"
            fi
        else
            tput rc #restore cursor position
        fi
    done
}

function ssid_ssidPasswd_writeToFile__func()
{
    #Define local variables
    local EMPTYLINES=${EMPTYLINES_1}    #by default set to '1'

    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode
        EMPTYLINES=${EMPTYLINES_0}  #set to '0'
    fi

    #Write Selected SSID and Password to Config File
    printf '%s%b\n' ""

    debugPrint__func "${PRINTF_WRITING}" "${printf_ssid_and_password_to_wpaSupplicant_conf}" "${EMPTYLINES}"
                            
    #Write to file '/etc/wpa_supplicant.conf'
    wpa_passphrase ${ssid_input} ${ssidPwd_input}  | tee ${wpaSupplicant_conf_fpath} >> /dev/null    

    #Wait for 1 seconds
    sleep ${SLEEP_TIMEOUT}

    #(If Applicable) Insert 'scan_ssid=1' at line-number=2
    #REMARK: 'scan_ssid=1' is REQUIRED when adding HIDDEN SSID
    #REMARK: \t=TAB, however to properly write a TAB to a file,...
    #........ESCAPE CHAR '\' has to be prepended resulting in '\\t'
    if [[ ${ssid_isHidden} == ${TRUE} ]]; then
        sed -i "/${PATTERN_SSID}/a ${SCAN_SSID_IS_1}" ${wpaSupplicant_conf_fpath}
    fi
}

function wpa_supplicant_start_daemon__func()
{
    #Define local variables
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if wpa_supplicant daemon is already IN-ACTIVE
    #If TRUE, then exit function immediately
    if [[ ${wpa_supplicant_daemon_isRunning} == ${TRUE} ]]; then
        return
    fi

    #If FALSE, then start wpa_supplicant daemon
    debugPrint__func "${PRINTF_STARTING}" "${PRINTF_WPA_SUPPLICANT_DAEMON}" "${EMPTYLINES_0}"

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"

    #run wpa_supplicant daemon command
    ${WPA_SUPPLICANT} -B -c ${wpaSupplicant_conf_fpath} -i${wlanSelectIntf}

    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        stdOutput=`ps axf | egrep "${pattern_ps_axf_wpa_supplicant_11}|${pattern_ps_axf_wpa_supplicant_12}|${pattern_ps_axf_wpa_supplicant_21}|${pattern_ps_axf_wpa_supplicant_22}" | grep -v "${PATTERN_GREP}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then  #contains data
            wpa_supplicant_daemon_isRunning=${TRUE}

            break
        else
            wpa_supplicant_daemon_isRunning=${FALSE}
        fi

        sleep ${DAEMON_TIMEOUT}  #wait

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

    #HANDLE RESULT
    if [[ ${wpa_supplicant_daemon_isRunning} == ${FALSE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_WPA_SUPPLICANT_DAEMON}" "${TRUE}"
    fi
}

function wpa_supplicant_service_start_and_enable__func()
{   
    #REMARK: wpa_supplicant service is associated with the command:
    #           /sbin/wpa_supplicant -u -s -O /run/wpa_supplicant
    #Define local variables
    local wpa_supplicant_service_isActive=${EMPTYSTRING}

    #Stop wpa_supplicant service (if running)
    wpa_supplicant_service_isActive=`systemctl is-active "${WPA_SUPPLICANT}" 2>&1`
    if [[ ${wpa_supplicant_service_isActive} == ${INACTIVE} ]]; then    #is Inactive
        debugPrint__func "${PRINTF_STARTING}" "${PRINTF_WPA_SUPPLICANT_SERVICE}" "${EMPTYLINES_1}"

        systemctl start "${WPA_SUPPLICANT}" #start service
    else    #is Active
        debugPrint__func "${PRINTF_RESTARTING}" "${PRINTF_WPA_SUPPLICANT_SERVICE}" "${EMPTYLINES_1}"

        systemctl restart "${WPA_SUPPLICANT}" #restart service
    fi

     #Enable wpa_supplicant service (if Disabled)
    local wpa_supplicant_service_isEnabled=`systemctl is-enabled "${WPA_SUPPLICANT}" 2>&1`

    if [[ ${wpa_supplicant_service_isEnabled} != ${ENABLED} ]]; then    #service is ENABLED
        systemctl enable "${WPA_SUPPLICANT}" #disable service

        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_ENABLED}" "${EMPTYLINES_0}"
    else
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_ISALREADY_ENABLED}" "${EMPTYLINES_0}"
    fi   
}

function ssid_connection_status__func()
{
    #Define local variable
    local sleep_timeout_max=$((IW_TIMEOUT*IWCONFIG_RETRY))    #(1*30=30) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local isNotConnected=${PATTERN_NOT_CONNECTED}
    local errMsg=${EMPTYSTRING}
    local successMsg=${EMPTYSTRING}

    #Initial setting
    ssidConnection_status=${FALSE}

    #PRINT
    debugPrint__func "${PRINTF_IW}" "${PRINTF_CHECKING_SSID_CONNECTION_STATUS}" "${EMPTYLINES_1}"

    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"

#---Check the status of SSID Connection
    #REMARK: please note that it may take time (up to 30 seconds) for the SSID Connection Status to change.
    while true
    do
        #Check Status of SSID Connection
        isNotConnected=`${IW_CMD} ${wlanSelectIntf} link | egrep "${PATTERN_NOT_CONNECTED}" 2>&1`

        #REMARK: this means that the SSID Connection is SUCCESSFUL
        if [[ -z ${isNotConnected} ]]; then  #contains NO data
            break
        fi

        sleep ${IW_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        clear_lines__func ${NUMOF_ROWS_1}

        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 30 times
            break
        fi
    done

#---CONNECTED or NOT-CONNECTED to SSID
    if [[ ! -z ${isNotConnected} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_COULD_NOT_ESTABLISH_CONNECTION_TO_SSID}" "${FALSE}"

        if [[ ${interactive_isEnabled} == ${FALSE} ]]; then
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_CHECK_SSID_AND_PASSWORD}" "${TRUE}"
        fi

        debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_SELECT_ANOTHER_SSID}" "${EMPTYLINES_1}"
        while true
        do
            read -N1 -r -s -p "" myChoice

            if [[ ${myChoice} =~ [y,n,q] ]]; then
                clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

                debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_SELECT_ANOTHER_SSID} ${myChoice}" "${EMPTYLINES_0}"

                break
            else
                clear_lines__func ${NUMOF_ROWS_0}
            fi
        done

        #'yes' was pressed
        if [[ ${myChoice} == ${INPUT_NO} ]]; then
            # debugPrint__func "${PRINTF_INFO}" "${PRINTF_ABOUT_TO_EXIT_WIFI_CONFIGURATION}" "${EMPTYLINES_1}"
            # debugPrint__func "${PRINTF_INFO}" "${PRINTF_TO_RUN_THE_WIFI_CONFIGURATION_AT_ANOTHER_TIME}" "${EMPTYLINES_0}"
            # debugPrint__func "${PRINTF_INFO}" "${PRINTF_PLEASE_EXECUTE_THE_FOLLOWING_COMMAND}" "${EMPTYLINES_0}"

            ssidConnection_status=${DONOT_RETRY_AND_CONTINUE}    #Output
        elif [[ ${myChoice} == ${INPUT_QUIT} ]]; then
            ssidConnection_status=${QUIT}    #Output
        else
            ssidConnection_status=${RETRY}  #Output
        fi
    else        
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ESTABLISHED_CONNECTION_TO_SSID}" "${EMPTYLINES_0}"
        
        ssidConnection_status=${PASS}   #Output
    fi
}



#---SUBROUTINES
load_tibbo_banner__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

checkIfisRoot__sub()
{
    #Define local constants
    local ROOTUSER="root"
    local ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}SUDO${NOCOLOR} OR ${FG_LIGHTGREY}ROOT${NOCOLOR}"

    #Define Local variables
    local currUser=`whoami`

    #Check if user is 'root'
    if [[ ${currUser} != ${ROOTUSER} ]]; then   #not root
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_USER_IS_NOT_ROOT}" "${TRUE}"  

        user_isRoot=${TRUE}
    fi
}


init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    myChoice=${EMPTYSTRING}    
    ssid_isAllowed_toBe_Configured=${FALSE}
    if [[ -z ${ssid_isHidden} ]]; then
        ssid_isHidden=${FALSE}
    fi
    trapDebugPrint_isEnabled=${FALSE}
    wlanSelectIntf=${EMPTYSTRING}
    wpa_supplicant_daemon_isRunning=${FALSE}
    user_isRoot=${FALSE}

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
    #Check if 'ssid_isHidden' is a boolean value
    input_args_checkIf_value_isBoolean__func
}

function input_args_checkIf_value_isBoolean__func()
{
    #Backup 'ssid_isHidden' value
    local ssid_isHidden_org=${ssid_isHidden}

    #Convert Lowercase
    ssid_isHidden=`convertTo_lowercase__func "${ssid_isHidden}"`

    #Check if 'ssid_isHidden' contains 'true'
    if [[ "${ssid_isHidden}" =~ .*"${TRUE}"* ]]; then   #does contain TRUE
        return
    else    #does NOT contain TRUE
        #Check if 'ssid_isHidden' contains 'false'
        if [[ "${ssid_isHidden}" == *"${FALSE}"* ]]; then   #does contain FALSE
            return
        else    #does not contain FALSE
            #Update message
            errmsg_arg3_is_not_a_boolean="'arg3' IS NOT A BOOLEAN: ${ssid_isHidden_org}"
            
            errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_arg3_is_not_a_boolean}" "${FALSE}"
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
        fi
    fi
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\" \"${FG_LIGHTGREY}arg3${NOCOLOR}\" \"${FG_LIGHTPINK}arg4${NOCOLOR}\" \"${FG_LIGHTGREY}arg5${NOCOLOR}\" \"${FG_LIGHTPINK}arg6${NOCOLOR}\" \"${FG_LIGHTPINK}arg7${NOCOLOR}\"  \"${FG_LIGHTGREY}arg8${NOCOLOR}\" \"${FG_LIGHTPINK}arg9${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}SSID to connect onto."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}SSID password."
        "${FOUR_SPACES}arg3${TAB_CHAR}${TAB_CHAR}SSID-is-Hidden {${FG_LIGHTGREEN}true${FG_LIGHTGREY}|${FG_SOFTLIGHTRED}false${NOCOLOR}}."
        "${FOUR_SPACES}arg4${TAB_CHAR}${TAB_CHAR}IPv4 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}192.168.1.10${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}24${NOCOLOR})."
        "${FOUR_SPACES}arg5${TAB_CHAR}${TAB_CHAR}IPv4 gateway (e.g. 192.168.1.254)."
        "${FOUR_SPACES}arg6${TAB_CHAR}${TAB_CHAR}IPv4 DNS (e.g., 8.8.8.8${FG_SOFTLIGHTRED},${NOCOLOR}8.8.4.4)."
        "${FOUR_SPACES}arg7${TAB_CHAR}${TAB_CHAR}IPv6 ${FG_SOFTDARKBLUE}address${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}netmask${NOCOLOR} (e.g. ${FG_SOFTDARKBLUE}2001:beef::15:5${FG_LIGHTGREY}/${FG_SOFTLIGHTBLUE}64${NOCOLOR})."
        "${FOUR_SPACES}arg8${TAB_CHAR}${TAB_CHAR}IPv6 gateway (e.g. 2001:beef::15:900d)."
        "${FOUR_SPACES}arg9${TAB_CHAR}${TAB_CHAR}IPv6 DNS (e.g., 2001:4860:4860::8888${FG_SOFTLIGHTRED},${NOCOLOR}2001:4860:4860::8844)."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFTLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFTLIGHTRED}\"${NOCOLOR} each argument."
        "${FOUR_SPACES}- Some arguments (${FG_LIGHTPINK}arg4${NOCOLOR},${FG_LIGHTPINK}arg6${NOCOLOR},${FG_LIGHTPINK}arg7${NOCOLOR},${FG_LIGHTPINK}arg9${NOCOLOR}) allow multiple input values separated by a comma-separator (${FG_SOFTLIGHTRED},${NOCOLOR})."
        "${FOUR_SPACES}- If DHCP is used, please set argruments arg4, arg5, arg6, arg7, arg8, and arg9 to ${FG_SOFTLIGHTRED}dhcp${NOCOLOR}"
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

connect_to_ssid__sub()
{
    local ssidConnection_status=false

    #This function will output the flag 'ssid_isAllowed_toBe_Configured'
    get_current_config_ssid_name__func

    if [[ ${ssid_isAllowed_toBe_Configured} == ${FALSE} ]]; then
        return
    fi

    while true
    do
        #Show wpa_supplicant service status
        wpa_supplicant_get_service_status__func

        #Show wpa_supplicant daemon status
        wpa_supplicant_get_daemon_status__func

        #Kill currently running 'wpa_supplicant' daemon(s) (if any)
        #REMARK: the daemon will also DISABLE the WiFi Inteface (implicitely)
        wpa_supplicant_kill_daemon__func

        #Set interface to 'UP' state
        toggle_intf__func ${TOGGLE_UP}

        #Choose SSID
        choose_ssid__func

        #Provide SSID Password
        ssidPassword_input__func

        #Write SSID and Password to file
        ssid_ssidPasswd_writeToFile__func

        #Show wpa_supplicant daemon status
        wpa_supplicant_get_daemon_status__func

        #TEST if '/etc/wpa_supplicant.conf' works by starting the 'wpa_supplicant daemon'
        #REMARK: 
        #The WiFi Interface will be enabled automatically
        #If the SSID & PASSWORD are valid then the SSID connection will be established
        #PLEASE NOTE: this DAEMON MUST BE KILLED at 
        wpa_supplicant_start_daemon__func

        #Show wpa_supplicant daemon status
        wpa_supplicant_get_daemon_status__func

        #Start WPA supplicant SERVICE
        wpa_supplicant_service_start_and_enable__func

        #Show wpa_supplicant service status
        wpa_supplicant_get_service_status__func

        #Check SSID Connection
        #Output: ssidConnection_status
        ssid_connection_status__func
        if [[ ${ssidConnection_status} != ${RETRY} ]]; then
            #Kill currently running 'wpa_supplicant' daemon (if any)
            #REMARK: the daemon will also DISABLE the WiFi Inteface (implicitely
            wpa_supplicant_kill_daemon__func

            if [[ ${ssidConnection_status} == ${PASS} ]]; then
                break
            elif [[ ${ssidConnection_status} == ${DONOT_RETRY_AND_CONTINUE} ]]; then
                #Print message
                connect_to_ssid_show_current_ssid__func

                break
            else    #ssidConnection_status = QUIT
                exit 0
            fi
        fi
    done
}
function connect_to_ssid_show_current_ssid__func()
{
        #Get current configured SSID
        local wpa_supplicant_ssid=`cat ${wpaSupplicant_conf_fpath} | grep -w ${PATTERN_SSID} | grep -v ${PATTERN_USAGE} |cut -d"${QUOTE_CHAR}" -f2 2>&1`
        
        #Compose printf message
        local debugMsg="CONTINUE USING EXISTING SSID: ${FG_YELLOW}${wpa_supplicant_ssid}${NOCOLOR}"
        debugPrint__func "${PRINTF_INFO}" "${debugMsg}" "${EMPTYLINES_1}"
}

configure_netplan__sub()
{
    if [[ ${interactive_isEnabled} == ${FALSE} ]]; then #non-interactive mode is Enabled
        ${wlan_netplanconf_fpath} "${wlanSelectIntf}" \
                                    "${yaml_fpath}" \
                                        "${ipv4_addrNetmask_input}" "${ipv4_gateway_input}" "${ipv4_dns_input}"\
                                            "${ipv6_addrNetmask_input}" "${ipv6_gateway_input}" "${ipv6_dns_input}"
    else    #interactive mode is Enabled
        ${wlan_netplanconf_fpath} ${TRUE}
    fi

    #Get exit-code
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_occurred_in_file_wlan_netplanconf}" "${TRUE}"
    fi  
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

    load_tibbo_banner__sub

    init_variables__sub

    checkIfisRoot__sub

    input_args_case_select__sub

    preCheck_handler__sub

    dynamic_variables_definition__sub

    wlan_intf_selection__sub

    get_wifi_pattern__sub

    connect_to_ssid__sub

    configure_netplan__sub

    postCheck_handler__sub

    wlan_connect_info__sub
}



#---EXECUTE
main__sub
