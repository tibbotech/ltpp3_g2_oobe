#!/bin/bash
#---TRAP ON EXIT
trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT

trap CTRL_C_func INT



#---INPUT ARGS



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

BCMDHD="bcmdhd"
IEEE_80211="IEEE 802.11"
IW="iw"
IWCONFIG="iwconfig"

EMPTYSTRING=""
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
QUOTE_CHAR="\""
ENTER_CHAR=$'\x0a'

TRUE=1
FALSE=0

EXITCODE_99=99
SLEEP_TIMEOUT=2

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

STATUS_UP="UP"
STATUS_DOWN="DOWN"
TOGGLE_UP="up"
TOGGLE_DOWN="down"

# PATTERN_WLAN="wlan"
PATTERN_INTERFACE="Interface"
PATTERN_SSID="ssid"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
# ERRMSG_UNABLE_TO_LOAD_WIFI_MODULE_BCMDHD="Unable to LOAD WiFi MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"

PRINTF_CONFIGURE="CONFIGURE:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_TOGGLE="TOGGLE:"

PRINTF_CURRENT_CONFIG_SSID="CURRENTLY CONFIGURED SSID:"
PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"
PRINTF_WIFI_SOFTWARE="WiFi SOFTWARE"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
PRINTF_WIFI_INTERFACE="WiFi INTERFACE"



#---VARIABLES
wifi_define_dynamic_variables__sub()
{
    errMsg_occured_in_file="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_config_filename}${NOCOLOR}"

    printf_successfully_set_wlan_to_down="${FG_GREEN}SUCCESSFULLY${NOCOLOR} SET ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} TO ${FG_LIGHTGREY}${STATUS_DOWN}${NOCOLOR}"
    printf_successfully_set_wlan_to_up="${FG_GREEN}SUCCESSFULLY${NOCOLOR} SET ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} TO ${FG_LIGHTGREY}${STATUS_UP}${NOCOLOR}"
}



#---PATHS
load_environmental_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    # tb_wlan_stateconf_filename="tb_wlan_stateconf.sh"
    # wlan_config_filename="tb_wlan_config.sh"
    # wlan_netplanconf_filename="tb_wlan_netplanconf.sh"
    
    # tb_wlan_stateconf_fpath=${current_dir}/${tb_wlan_stateconf_filename}
    # wlan_config_fpath=${current_dir}/${wlan_config_filename}
    # wlan_netplanconf_fpath=${current_dir}/${wlan_netplanconf_filename}
    # wpaSupplicant_fpath="/etc/wpa_supplicant.conf"
    # yaml_fpath="/etc/netplan/*.yaml"    #use the default full-path
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
				exit 0
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

wifi_updates_upgrades_inst_list__func()
{
    apt-get -y update
    apt-get -y upgrade
}

wifi_software_inst_list__func()
{
    apt-get -y install wi
    apt-get -y install wireless-tools
    apt-get -y install wpasupplicant
}

wifi_toggle_module__func()
{
    #Input args
    local mod_isEnabled=${1}

    #Local variables
    local errMsg=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}

    #Check if 'wlanSelectIntf' is present
    local stdOutput=$(ip link show | grep "${pattern_wlan}")

    #Toggle WiFi Module (enable/disable)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${stdOutput} ]]; then   #contains data (thus WLAN interface is already enabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_UP}" "${PREPEND_EMPTYLINES_1}"

            return
        fi

        modprobe ${BCMDHD}
    else
        if $[[ -z ${stdOutput} ]]; then   #contains NO data (thus WLAN interface is already disabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_DOWN}" "${PREPEND_EMPTYLINES_1}"

            return
        fi

        modprobe -r ${BCMDHD}
    fi
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD}" "${TRUE}"
    fi

    #Print result (exit-code=0)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then  #module was set to be enabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD}" "${PREPEND_EMPTYLINES_1}"
    else    #module was set to be disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD}" "${PREPEND_EMPTYLINES_1}"
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
    #   grep "${PATTERN_INTERFACE}": find a match for 'Interface
    #   awk '{print $1}': get the first column
    #   sed 's/[0-9]*//g': exclude all numeric values from string
    #   xargs -n 1: convert string to array
    #   sort -u: get unique values
    #   xargs: convert back to string
    # pattern_wlan_string=`{ ${IW} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | sed 's/[0-9]*//g' | xargs -n 1 | sort -u | xargs; } 2> /dev/null`
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

    #Get ALL available wlan interface
    wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1 2>&1`

    #Check if 'wlanList_string' contains any data
    #If no data, then exit...
    if [[ -z $wlanList_string ]]; then  
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTERFACE_FOUND}" "${TRUE}"       
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

# wifi_toggle_intf__func()
# {
#     #Run script 'tb_wlan_stateconf.sh'
#     ${tb_wlan_stateconf_fpath} "${wlanSelectIntf}" "${yaml_fpath}" "${STATUS_UP}"
# }


#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

wifi_init_variables__sub()
{
    exitCode=0
    myChoice=${EMPTYSTRING}
    pattern_wlan=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlanSelectIntf=${EMPTYSTRING}
}

wifi_update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES_UPGRADES}" "${PREPEND_EMPTYLINES_1}"
    wifi_updates_upgrades_inst_list__func
}

wifi_inst_software__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_WIFI_SOFTWARE}" "${PREPEND_EMPTYLINES_1}"
    wifi_software_inst_list__func
}

wifi_enable_module__sub()
{
    wifi_toggle_module__func "${TRUE}"
}

wifi_select_wlan_intf__sub()
{
    wifi_wlan_select__func "${wlanSelectIntf}"
}

# wifi_connect_to_ssid__sub()
# {
#     #Define Local variables
#     ${wlan_config_fpath} "${wlanSelectIntf}" "${FALSE}" "${pattern_wlan}"
#     exitCode=$? #get exit-code

#     if [[ ${exitCode} -ne 0 ]]; then
#         errExit__func "${FALSE}" "${EXITCODE_99}" "${errMsg_occured_in_file}" "${TRUE}"
#     fi  
# }


#---MAIN SUBROUTINE
main__sub()
{
    load_header__sub

    load_environmental_variables__sub

    wifi_init_variables__sub

    wifi_update_and_upgrade__sub

    wifi_inst_software__sub

    wifi_get_wifi_pattern__func

    wifi_enable_module__sub

    # wifi_select_wlan_intf__sub

    # wifi_define_dynamic_variables__sub
    
    # wifi_connect_to_ssid__sub

}


#---EXECUTE
main__sub
