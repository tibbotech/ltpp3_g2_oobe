#!/bin/bash
#---TRAP ON EXIT
trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT

trap CTRL_C_func INT



#---INPUT ARGS
#In order to NON-INTERACTIVELY configure the WLAN,...
#...please provide values for all the input args (as shown below)
wlanSelectIntf=${1} #optional

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
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
QUOTE_CHAR="\""
ENTER_CHAR=$'\x0a'

ZERO=0
ONE=1

EXITCODE_99=99

INPUT_ALL="a"
INPUT_BACK="b"
INPUT_IPV4="4"
INPUT_IPV6="6"
INPUT_NO="n"
INPUT_REDO="r"
INPUT_REFRESH="r"
INPUT_SKIP="s"
INPUT_YES="y"

DAEMON_TIMEOUT=1
DAEMON_RETRY=10
IWCONFIG_TIMEOUT=1
IWCONFIG_RETRY=30
SLEEP_TIMEOUT=1

PREPEND_EMPTYLINES_1=1

IEEE_80211="IEEE 802.11"
IWCONFIG="iwconfig"
SCAN_SSID_IS_1="scan_ssid=1"
WPA_SUPPLICANT="wpa_supplicant"

TRUE=1
FALSE=0

PASS=1
RETRY=0
DONOT_RETRY=1

ACTIVE="active"
INACTIVE="inactive"
STATUS_UP="UP"
STATUS_DOWN="DOWN"

PATTERN_ACCESS_POINT_NOT_ASSOCIATED="Access Point: Not-Associated"
PATTERN_ESSID="ESSID"
PATTERN_EXECSTART="ExecStart="
PATTERN_GREP="grep"
PATTERN_SSID="ssid"
PATTERN_USAGE="usage"

PASSWD_MIN_LENGTH=8

INSERT_AFTER_LINE_1=1

NUMOF_ROWS_0=0
NUMOF_ROWS_1=1
NUMOF_ROWS_2=2
NUMOF_ROWS_3=3
NUMOF_ROWS_4=4
NUMOF_ROWS_5=5
NUMOF_ROWS_6=6
NUMOF_ROWS_7=7

ERRMSG_COULD_NOT_ESTABLISH_CONNECTION_TO_SSID="COULD NOT ESTABLISH CONNECTION TO SSID ${FG_LIGHTGREY}${mySsid}${NOCOLOR}"
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERROMSG_FAILED_TO_RETRIEVE_SSIDS="${FG_LIGHTRED}FAILED${NOCOLOR} TO RETRIEVE SSIDS"
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
ERRMSG_PASSWORDS_DO_NOT_MATCH="PASSWORDS DO *NOT* MATCH"
ERRMSG_PASSWORD_MUST_BE_8_63_CHARACTERS="PASSWORD MUST BE 8..63 CHARACTERS"
ERRMSG_WIFI_INTERFACE_FOUND_BUT_NOT_UP="WIFI INTERFACE FOUND BUT NOT ${FG_LIGHTGREY}UP${NOCOLOR}"

PRINTF_INFO="INFO:"
PRINTF_IWCONFIG="${IWCONFIG}:"
PRINTF_QUESTION="QUESTION:"
PRINTF_RESTARTING="RESTARTING:"
PRINTF_STOPPING="STOPPING:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_TERMINATING="TERMINATING:"
PRINTF_WAITING_FOR="WAITING FOR:"
PRINTF_WARNING="WARNING:"
PRINTF_WRITING="WRITING:"

PRINTF_ABOUT_TO_EXIT_WIFI_CONFIGURATION="ABOUT TO EXIT WiFi CONFIGURATION..."
PRINTF_ATTEMPTING_TO_RETRIEVE_SSIDS="ATTEMPTING TO RETRIEVE SSIDs"
PRINTF_TO_RUN_THE_WIFI_CONFIGURATION_AT_ANOTHER_TIME="TO RUN THE WiFi CONFIGURATION AT ANOTHER TIME..."
PRINTF_PLEASE_EXECUTE_THE_FOLLOWING_COMMAND="PLEASE EXECUTE THE FOLLOWING COMMAND: ${FG_LIGHTGREY}${thisScript_fpath}${NOCOLOR}"
PRINTF_CHECKING_SSID_CONNECTION_STATUS="CHECKING SSID CONNECTION STATUS..."
PRINTF_ESTABLISHED_CONNECTION_TO_SSID="${FG_GREEN}SUCCESSFULLY${NOCOLOR} ESTABLISHED CONNECTION TO SSID ${FG_LIGHTGREY}${mySsid}${NOCOLOR}"
PRINTF_FILE_NOT_FOUND="FILE NOT FOUND:"
PRINTF_DAEMON_RELOAD="SYSTEMCTL DAEMON-RELOAD"
PRINTF_TERMINATION_OF_APPLICATION="TERMINATION OF APPLICATION"
PRINTF_WPA_SUPPLICANT_DAEMON="WPA SUPPLICANT ${FG_LIGHTGREY}TEST${NOCOLOR} DAEMON"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}TEST${NOCOLOR} DAEMON: ${FG_GREEN}ACTIVE${NOCOLOR}...OK"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}TEST${NOCOLOR} DAEMON: ${FG_LIGHTRED}INACTIVE${NOCOLOR}...OK"
PRINTF_WPA_SUPPLICANT_SERVICE="WPA SUPPLICANT SERVICE"
PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_LIGHTRED}INACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_NOT_PRESENT="WPA SUPPLICANT ${FG_LIGHTGREY}SERVICE${NOCOLOR}: ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"

PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

QUESTION_ADD_AS_HIDDEN_SSID="ADD AS ${FG_LIGHTGREY}HIDDEN${NOCOLOR} SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o/${FG_YELLOW}r${NOCOLOR}edo)?"
QUESTION_SELECT_ANOTHER_SSID="SELECT ANOTHER SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"

READ_CONNECT_TO_ANOTHER_SSID="CONNECT TO A DIFFERENT SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
READ_CONNECT_TO_AN_SSID="CONNECT TO AN SSID (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"


#---VARIABLES
wifi_define_dynamic_variables__sub()
{
    # errmsg_occured_in_file_wlan_netplanconf="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_netplanconf_filename}${NOCOLOR}"
    errmsg_occured_in_file_wlan_intf_updown="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_intf_updown_filename}${NOCOLOR}"

    #This is the Daemon using the configuration as specified in file /etc/wpa_supplicant.conf
    # pattern_ps_axf_wpa_supplicant_11="${WPA_SUPPLICANT} -B -c ${wpaSupplicant_fpath} -i${wlanSelectIntf}"
    # pattern_ps_axf_wpa_supplicant_12="${WPA_SUPPLICANT} -B -c ${wpaSupplicant_fpath} -i ${wlanSelectIntf}"
    
    # #This is the Daemon using the configuration as specified in file run/netplan/wpa-wlan0.conf (protected)
    # #This file is only created when a WiFi interfaces (including wpa ssid & password) is configured in /etc/netplan/*.yaml
    # pattern_ps_axf_wpa_supplicant_21="${WPA_SUPPLICANT} -c ${run_netplan_dir}/wpa-${wlanSelectIntf}.conf -i${wlanSelectIntf}"
    # pattern_ps_axf_wpa_supplicant_22="${WPA_SUPPLICANT} -c ${run_netplan_dir}/wpa-${wlanSelectIntf}.conf -i ${wlanSelectIntf}"

    printf_file_not_found_wpa_supplicant="${PRINTF_FILE_NOT_FOUND} ${FG_LIGHTGREY}${wpaSupplicant_fpath}${NOCOLOR}"
    printf_inserted_execStartPost_cmdline_into_wpa_supplicant_service="INSERTED EXECSTARTPOST CMDLINE INTO ${FG_LIGHTGREY}WPA_SUPPLICANT SERVICE${NOCOLOR}"
    printf_ssid_and_password_to="SSID & PASSWORD TO ${FG_LIGHTGREY}${wpaSupplicant_fpath}${NOCOLOR}"
}



#---PATHS
load_environmental_variables__sub()
{
    current_dir=`dirname "$0"`
    # run_netplan_dir=/run/netplan
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    lib_systemd_system_dir=/lib/systemd/system
    usr_bin_dir=/usr/bin

    systemctl_filename="systemctl"
    systemctl_fpath=${usr_bin_dir}/${systemctl_filename}
    
    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

    wlan_netplanconf_filename="tb_wlan_netplanconf.sh"
    wlan_netplanconf_fpath=${current_dir}/${wlan_netplanconf_filename}

    wpa_supplicant_service_filename="wpa_supplicant.service"
    wpa_supplicant_service_fpath=${lib_systemd_system_dir}/${wpa_supplicant_service_filename}


    wpaSupplicant_fpath="/etc/wpa_supplicant.conf"
}



#---FUNCTIONS
press_any_key__localfunc() {
	#Define constants
	local ANYKEY_TIMEOUT=10

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
    printf '%s%b\n' "${FG_ORANGE}${topic}${NOCOLOR} ${msg}"
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
        errExit_kill_wpa_supplicant_daemon__func
        
        printf '%s%b\n' "${FG_ORANGE}EXITING:${NOCOLOR} ${thisScript_filename}"
        printf '%s%b\n' ""
        
        exit ${EXITCODE_99}
    fi
}
errExit_kill_wpa_supplicant_daemon__func()
{
    #Check if 'wpa_supplicant test daemon' is running
    local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wpaSupplicant_fpath}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
    if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
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

wifi_wlan_check_intf_availability__func()
{
    #Check WLAN interface
    local stdOutput=$(ip link show | grep "${pattern_wlan}")
    if [[ -z ${stdOutput} ]]; then  #contains data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTERFACE_FOUND}" "${TRUE}"
    else    #contains NO data
        local wlan_isUp=$(echo "${wlan_isPresent}" | grep "${STATUS_UP}")
        if [[ -z ${wlan_isUp} ]]; then  #No WLAN interfaces UP
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_WIFI_INTERFACE_FOUND_BUT_NOT_UP}" "${TRUE}"
        fi
    fi
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
    wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1 2>&1`

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


wifi_get_current_config_ssid_name__func()
{
    #Define local variables
    local debugMsg=${EMPTYSTRING}
    local readInputMsg=${EMPTYSTRING}
    local wpa_supplicant_ssid=${EMPTYSTRING}

    #Check if '/etc/wpa_supplicant.conf' exists
    if [[ -f ${wpaSupplicant_fpath} ]]; then
        wpa_supplicant_ssid=`cat ${wpaSupplicant_fpath} | grep -w ${PATTERN_SSID} | grep -v ${PATTERN_USAGE} |cut -d"${QUOTE_CHAR}" -f2 2>&1`
        
        debugMsg="CURRENT SSID: ${FG_YELLOW}${wpa_supplicant_ssid}${NOCOLOR}"    #MUST BE PUT HERE
        debugPrint__func "${PRINTF_INFO}" "${debugMsg}" "${PREPEND_EMPTYLINES_1}"

        readInputMsg=${READ_CONNECT_TO_ANOTHER_SSID}
    else
        readInputMsg=${READ_CONNECT_TO_AN_SSID}
    fi

    #Show 'read-input message'
    debugPrint__func "${PRINTF_QUESTION}" "${readInputMsg}" "${PREPEND_EMPTYLINES_1}"

    #Ask if user wants to connec to a WiFi AccessPoint
    while true
    do
        read -N1 -r -s -p "" myChoice

        if [[ ${myChoice} =~ [y,n] ]]; then
            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

            debugPrint__func "${PRINTF_QUESTION}" "${readInputMsg} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

            break
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

wifi_wpa_supplicant_get_service_status__func()
{   
    #PLEASE NOTE that the wpa_supplicant 'service' is NOT dependent on the wpa_supplicant 'daemon'

    #Check if wpa_supplicant service is present
    #REMARK: use '2>&1 > /dev/null' to capture stdErr only
    local stdError=`systemctl status ${WPA_SUPPLICANT} 2>&1 > /dev/null`

    if [[ ! -z ${stdError} ]]; then #an error has occurred
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_NOT_PRESENT}" "${PREPEND_EMPTYLINES_1}"
    else    #no errors found
        #Check if wpa_supplicant service is 'active' or 'inactive'
        local wpa_service_status=`systemctl is-active "${WPA_SUPPLICANT}" 2>&1`

        if [[ ${wpa_service_status} == ${INACTIVE} ]]; then    #is Inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_INACTIVE}" "${PREPEND_EMPTYLINES_1}"
        else    #is Active
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_ACTIVE}" "${PREPEND_EMPTYLINES_1}"
        fi
    fi
}

# wifi_wpa_supplicant_service_insert_execStartPost__func()
# {
#     #Compose command line
#     execStartPost_cmdline="ExecStartPost=${systemctl_fpath} stop ${WPA_SUPPLICANT}.service"

#     #Print
#     debugPrint__func "${PRINTF_STATUS}" "${printf_inserted_execStartPost_cmdline_into_wpa_supplicant_service}" "${PREPEND_EMPTYLINES_1}"
#     #Insert command line
#     sed -i "/^${PATTERN_EXECSTART}.*/a ${execStartPost_cmdline}" ${wpa_supplicant_service_fpath}

#     #Print
#     debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAEMON_RELOAD}" "${PREPEND_EMPTYLINES_0}"
#     #Reload Daemon
#     systemctl daemon-reload
# }

wifi_wpa_supplicant_get_daemon_status__func()
{
    #PLEASE NOTE that the wpa_supplicant 'daemon' is NOT dependent on the wpa_supplicant 'service'

    #Check if 'wpa_supplicant.conf' is present
    if [[ ! -f ${wpaSupplicant_fpath} ]]; then  #file is NOT found
        wpa_supplicant_daemon_isRunning=${FALSE}

        debugPrint__func "${PRINTF_STATUS}" "${printf_file_not_found_wpa_supplicant}" "${PREPEND_EMPTYLINES_0}"
    else    #file is found
        #Check if wpa_supplicant test daemon is running
        #REMARK:
        #TWO daemons could be running:
        #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wifi_wpa_supplicant_start_daemon__func')
        #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
        #GET PID of TEST DAEMON
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wpaSupplicant_fpath}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            wpa_supplicant_daemon_isRunning=${TRUE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE}" "${PREPEND_EMPTYLINES_0}"
        else    #daemon is NOT running
            wpa_supplicant_daemon_isRunning=${FALSE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE}" "${PREPEND_EMPTYLINES_0}"
        fi
    fi
}

wifi_wpa_supplicant_kill_daemon__func()
{   
    #Define local variables
    local ps_pidList_string=${EMPTYSTRING}
    local ps_pidList_array=()
    local ps_pidList_item=${EMPTYSTRING}
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if wpa_supplicant daemon is already INACTIVE
    #If TRUE, then exit function immediately
    if [[ ${wpa_supplicant_daemon_isRunning} == ${FALSE} ]]; then
        return
    fi 
    
    #If that's the case, kill that daemon
    debugPrint__func "${PRINTF_TERMINATING}" "${PRINTF_WPA_SUPPLICANT_DAEMON}" "${PREPEND_EMPTYLINES_0}"

    #GET PID of TEST DAEMON
    #REMARK:
    #TWO daemons could be running:
    #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wifi_wpa_supplicant_start_daemon__func')
    #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
    #GET PID of TEST DAEMON
    local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wpaSupplicant_fpath}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`

    #Convert string to array
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL DAEMON
    for ps_pidList_item in "${ps_pidList_array[@]}"; do 
        printf '%b\n' "${EIGHT_SPACES}${FG_LIGHTRED}Killed${NOCOLOR} PID: ${ps_pidList_item}"

        kill -9 ${ps_pidList_item}
    done

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"


    #CHECK IF DAEMON HAS BEEN KILLED AND EXIT
    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wpaSupplicant_fpath}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
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
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

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

wifi_get_available_ssid__func()
{
    #Define local variable
    local RETRY_PARAM_MAX=3
    local retry_param=0
    local stdError=${EMPTYSTRING}

    #Print empty line
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ATTEMPTING_TO_RETRIEVE_SSIDS}" "${PREPEND_EMPTYLINES_1}"

    #Check if the 'iwlist' command can be run without an error
    stdError=`iwlist ${wlanSelectIntf} scan 2>&1 > /dev/null`
    exitCode=$?

    if [[ ! -z ${stdError} ]]; then    #string contains data
        errExit__func "${TRUE}" "${exitCode}" "${stdError}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERROMSG_FAILED_TO_RETRIEVE_SSIDS}" "${TRUE}"
    fi

    #Get Available SSID list
    while true
    do
        #Get available SSIDs
        ssidList_string=`iwlist ${wlanSelectIntf} scan | grep ${PATTERN_ESSID} | cut -d"${QUOTE_CHAR}" -f2 2>&1`

        #Check if 'ssidList_string' contains data
        if [[ ! -z ${ssidList_string} ]]; then
            break
        fi

        retry_param=$((retry_param+1))  #increment counter

        #Only allowed to retry 3 times
        #Whether the 'ssidList_string' contains data or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then
            break
        fi
    done

    #Convert string to array
    eval "ssidList_array=(${ssidList_string})"
}

wifi_show_available_ssid__func()
{
    #Define local variables
    local arrayItem=${EMPTYSTRING}

    #Show available SSID
    printf '%s%b\n' ""
    printf '%s%b\n' "${FG_ORANGE}AVAILABLE SSID:${NOCOLOR}"
    for arrayItem in "${ssidList_array[@]}"; do 
        printf '%b\n' "${EIGHT_SPACES}${arrayItem}"
    done
}

wifi_choose_ssid__func()
{
    #Define local variables
    local mySsid_isValid=${EMPTYSTRING}
    local myChoice=${EMPTYSTRING}
    local debugMsg=${EMPTYSTRING}

    #Get Available SSIDs
    wifi_get_available_ssid__func

    #Show Available SSIDs
    wifi_show_available_ssid__func

    #Print empty line
    printf '%b%s\n' ""

    #Select SSID
    while true
    do
        read -p "${FG_LIGHTBLUE}SSID${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): " mySsid #provide your input
      
        if [[ ! -z ${mySsid} ]]; then   #input was NOT an empty string
            if [[ ${mySsid} == ${INPUT_REFRESH} ]]; then
                #Get Available SSIDs
                wifi_get_available_ssid__func

                #Show Available SSIDs
                wifi_show_available_ssid__func
            else
                mySsid_isValid=`echo ${ssidList_string} | egrep "${mySsid}" 2>&1`
                if [[ ! -z ${mySsid_isValid} ]]; then #SSID was found in the 'ssidList_string'
                    break
                else    #SSID was NOT found in the 'ssidList_string'
                    debugPrint__func "${PRINTF_WAITING_FOR}" "${PRINTF_TERMINATION_OF_APPLICATION}" "${PREPEND_EMPTYLINES_1}"

                    debugMsg="SSID ${FG_LIGHTGREY}${mySsid}${NOCOLOR} ${FG_LIGHTRED}NOT${NOCOLOR} FOUND"
                    debugPrint__func "${PRINTF_WARNING}" "${debugMsg}" "${PREPEND_EMPTYLINES_0}"

                    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_AS_HIDDEN_SSID}" "${PREPEND_EMPTYLINES_0}"
                  
                    while true
                    do
                        read -N1 -r -s -p "" myChoice

                        if [[ ${myChoice} =~ [y,n,r] ]]; then
                            clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

                            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ADD_AS_HIDDEN_SSID} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

                            break
                        fi
                    done

                    if [[ ${myChoice} != ${INPUT_REDO} ]]; then   #answer was NOT redo
                        if [[ ${myChoice} == ${INPUT_YES} ]]; then   #answer was yes
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


wifi_ssid_ssidPasswd_writeToFile__func()
{
    #Write to file '/etc/wpa_supplicant.conf'
    wpa_passphrase ${mySsid} ${mySsidPwd}  | tee ${wpaSupplicant_fpath} >> /dev/null    

    #Wait for 1 seconds
    sleep ${SLEEP_TIMEOUT}

    #(If Applicable) Insert 'scan_ssid=1' at line-number=2
    #REMARK: 'scan_ssid=1' is REQUIRED when adding HIDDEN SSID
    #REMARK: \t=TAB, however to properly write a TAB to a file,...
    #........ESCAPE CHAR '\' has to be prepended resulting in '\\t'
    if [[ ${ssid_isHidden} == ${TRUE} ]]; then
        sed -i "/${PATTERN_SSID}/a ${SCAN_SSID_IS_1}" ${wpaSupplicant_fpath}
    fi
}

wifi_ssid_ssidPasswd_input_and_writeToFile__func()
{
    #Define local variables
    local mySsidPwd_len=0
    local mySsidPwd_confirm=${EMPTYSTRING}
    local errMsg=${EMPTYSTRING}

    #Provide phrase (password)
    while true
    do
        tput sc #backup cursor position

        read -s -p "${FG_LIGHTBLUE}PASSWORD${NOCOLOR}: " mySsidPwd #provide your input
        if [[ ! -z ${mySsidPwd} ]]; then   #input was NOT an empty string
            mySsidPwd_len=${#mySsidPwd}  #Get the length of input 'mySsidPwd'
            if [[ ${mySsidPwd_len} -ge ${PASSWD_MIN_LENGTH} ]]; then #string length is at least 8 characters
                printf '%s%b\n' ""
                
                tput sc #backup cursor position

                while true
                do
                    read -s -p "${FG_SOFTLIGHTBLUE}PASSWORD (Confirm)${NOCOLOR}: " mySsidPwd_confirm #provide your input
                    if [[ ! -z ${mySsidPwd_confirm} ]]; then   #input was NOT an empty string
                        #Compare 'mySsidPwd' with 'mySsidPwd_confirm' (both HAS TO BE THE SAME)
                        if [[ "${mySsidPwd}" == "${mySsidPwd_confirm}" ]]; then 
                            #Write Selected SSID and Password to Config File
                            printf '%s%b\n' ""

                            debugPrint__func "${PRINTF_WRITING}" "${printf_ssid_and_password_to}" "${PREPEND_EMPTYLINES_1}"

                            wifi_ssid_ssidPasswd_writeToFile__func

                            return
                        else
                            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_PASSWORDS_DO_NOT_MATCH}" "${FALSE}"

                            press_any_key__localfunc

                            clear_lines__func ${NUMOF_ROWS_4}

                            break
                        fi
                    else
                        tput rc #restore cursor position
                    fi
                done
            else    #string length is NOT at least 8 characters
                errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_PASSWORD_MUST_BE_8_63_CHARACTERS}" "${FALSE}"

                press_any_key__localfunc

                clear_lines__func "${NUMOF_ROWS_3}"
            fi
        else
            tput rc #restore cursor position
        fi
    done
}

wifi_wpa_supplicant_start_daemon__func()
{
    #Define local variables
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if wpa_supplicant daemon is already INACTIVE
    #If TRUE, then exit function immediately
    if [[ ${wpa_supplicant_daemon_isRunning} == ${TRUE} ]]; then
        return
    fi

    #If FALSE, then start wpa_supplicant daemon
    debugPrint__func "${PRINTF_STARTING}" "${PRINTF_WPA_SUPPLICANT_DAEMON}" "${PREPEND_EMPTYLINES_1}"

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

    #run wpa_supplicant daemon command
    ${WPA_SUPPLICANT} -B -c ${wpaSupplicant_fpath} -i${wlanSelectIntf}

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
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

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

wifi_wpa_supplicant_start_service__func()
{   
    #REMARK: wpa_supplicant service is associated with the command:
    #           /sbin/wpa_supplicant -u -s -O /run/wpa_supplicant
    #Define local variables
    local wpa_supplicant_service_isActive=${EMPTYSTRING}

    #Stop wpa_supplicant service (if running)
    wpa_supplicant_service_isActive=`systemctl is-active "${WPA_SUPPLICANT}" 2>&1`
    if [[ ${wpa_supplicant_service_isActive} == ${INACTIVE} ]]; then    #is Inactive
        debugPrint__func "${PRINTF_STARTING}" "${PRINTF_WPA_SUPPLICANT_SERVICE}" "${PREPEND_EMPTYLINES_1}"

        systemctl start "${WPA_SUPPLICANT}" #start service
    else    #is Active
        debugPrint__func "${PRINTF_RESTARTING}" "${PRINTF_WPA_SUPPLICANT_SERVICE}" "${PREPEND_EMPTYLINES_1}"

        systemctl restart "${WPA_SUPPLICANT}" #restart service
    fi
}

function wifi_ssid_connection_status__func()
{
    #Define local variable
    local sleep_timeout_max=$((IWCONFIG_TIMEOUT*IWCONFIG_RETRY))    #(1*30=30) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local notConnected_ToAccessPoint_isTrue=${PATTERN_ACCESS_POINT_NOT_ASSOCIATED}
    local errMsg=${EMPTYSTRING}
    local successMsg=${EMPTYSTRING}

    #Initial setting
    ssidConnection_status=${FALSE}

    #PRINT
    debugPrint__func "${PRINTF_IWCONFIG}" "${PRINTF_CHECKING_SSID_CONNECTION_STATUS}" "${PREPEND_EMPTYLINES_1}"

    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

#---Check the status of SSID Connection
    #REMARK: please note that it may take time (up to 30 seconds) for the SSID Connection Status to change.
    while true
    do
        #Check Status of SSID Connection
        notConnected_ToAccessPoint_isTrue=`${IWCONFIG} ${wlanSelectIntf} | egrep "${PATTERN_ACCESS_POINT_NOT_ASSOCIATED}" 2>&1`

        #REMARK: this means that the SSID Connection is SUCCESSFUL
        if [[ -z ${notConnected_ToAccessPoint_isTrue} ]]; then  #contains NO data
            break
        fi

        sleep ${IWCONFIG_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        clear_lines__func ${NUMOF_ROWS_1}

        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 30 times
            break
        fi
    done

#---CONNECTED or NOT-CONNECTED to SSID
    if [[ ! -z ${notConnected_ToAccessPoint_isTrue} ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_COULD_NOT_ESTABLISH_CONNECTION_TO_SSID}" "${FALSE}"

        debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_SELECT_ANOTHER_SSID}" "${PREPEND_EMPTYLINES_1}"
        while true
        do
            read -N1 -r -s -p "" myChoice

            if [[ ${myChoice} =~ [y,n] ]]; then
                clear_lines__func ${NUMOF_ROWS_1}   #go up one line and clear line content

                debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_SELECT_ANOTHER_SSID} ${myChoice}" "${PREPEND_EMPTYLINES_0}"

                break
            else
                clear_lines__func ${NUMOF_ROWS_0}
            fi
        done

        #'yes' was pressed
        if [[ ${myChoice} == ${INPUT_NO} ]]; then
            debugPrint__func "${PRINTF_INFO}" "${PRINTF_ABOUT_TO_EXIT_WIFI_CONFIGURATION}" "${PREPEND_EMPTYLINES_1}"
            debugPrint__func "${PRINTF_INFO}" "${PRINTF_TO_RUN_THE_WIFI_CONFIGURATION_AT_ANOTHER_TIME}" "${PREPEND_EMPTYLINES_0}"
            debugPrint__func "${PRINTF_INFO}" "${PRINTF_PLEASE_EXECUTE_THE_FOLLOWING_COMMAND}" "${PREPEND_EMPTYLINES_0}"

            ssidConnection_status=${DONOT_RETRY}    #Output
        else
            ssidConnection_status=${RETRY}  #Output
        fi
    else        
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ESTABLISHED_CONNECTION_TO_SSID}" "${PREPEND_EMPTYLINES_0}"
        
        ssidConnection_status=${PASS}   #Output
    fi
}



#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

wifi_init_variables__sub()
{
    exitCode=0
    myChoice=${EMPTYSTRING}    
    mySsid=${EMPTYSTRING}
    mySsidPwd=${EMPTYSTRING}
    ssid_isAllowed_toBe_Configured=${FALSE}
    ssid_isHidden=${FALSE}
    trapDebugPrint_isEnabled=${FALSE}
    wpa_supplicant_daemon_isRunning=${FALSE}
}

wifi_connect_to_ssid__sub()
{
    local ssidConnection_status=false

    #This function will output the flag 'ssid_isAllowed_toBe_Configured'
    wifi_get_current_config_ssid_name__func

    if [[ ${ssid_isAllowed_toBe_Configured} == ${FALSE} ]]; then
        return
    fi

    while true
    do
        #Show wpa_supplicant service status
        wifi_wpa_supplicant_get_service_status__func

        #Insert ExecStartPost Entry into /lib/systemd/system/wpa_supplicant.service
        # wifi_wpa_supplicant_service_insert_execStartPost__func

        #Show wpa_supplicant daemon status
        wifi_wpa_supplicant_get_daemon_status__func

        #Kill currently running 'wpa_supplicant' daemon (if any)
        #REMARK: the daemon will also DISABLE the WiFi Inteface (implicitely)
        wifi_wpa_supplicant_kill_daemon__func

        #Set interface to 'UP' state
        wifi_toggle_intf__func ${STATUS_UP}

        #Choose SSID
        wifi_choose_ssid__func

        #Provide SSID Password
        wifi_ssid_ssidPasswd_input_and_writeToFile__func

        #Show wpa_supplicant daemon status
        wifi_wpa_supplicant_get_daemon_status__func

        #TEST if '/etc/wpa_supplicant.conf' works by starting the 'wpa_supplicant daemon'
        #REMARK: 
        #The WiFi Interface will be enabled automatically
        #If the SSID & PASSWORD are valid then the SSID connection will be established
        #PLEASE NOTE: this DAEMON MUST BE KILLED at 
        wifi_wpa_supplicant_start_daemon__func

        #Show wpa_supplicant daemon status
        wifi_wpa_supplicant_get_daemon_status__func

        #Start WPA supplicant SERVICE
        wifi_wpa_supplicant_start_service__func

        #Show wpa_supplicant service status
        wifi_wpa_supplicant_get_service_status__func

        #Check SSID Connection
        #Output: ssidConnection_status
        wifi_ssid_connection_status__func
        if [[ ${ssidConnection_status} != ${RETRY} ]]; then
            printf '%s%b\n' ""
            #Kill currently running 'wpa_supplicant' daemon (if any)
            #REMARK: the daemon will also DISABLE the WiFi Inteface (implicitely
            wifi_wpa_supplicant_kill_daemon__func

            break
        fi
    done
}

wifi_configure_netplan__sub()
{
    ${wlan_netplanconf_fpath} "${wlanSelectIntf}" "${FALSE}" "${yaml_fpath}" "${pattern_wlan}" "${TRUE}"
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_occured_in_file_wlan_netplanconf}" "${TRUE}"
    fi  
}


#---MAIN SUBROUTINE
main__sub()
{
    load_header__sub

    load_environmental_variables__sub

    wifi_init_variables__sub

    wifi_get_wifi_pattern__func

    wifi_wlan_select__func

    wifi_define_dynamic_variables__sub
    
    wifi_connect_to_ssid__sub

    wifi_configure_netplan__sub
}



#---EXECUTE
main__sub
