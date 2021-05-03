#!/bin/bash
#---INPUT ARGS
arg1=${1}



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${arg1}



#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---TRAP ON EXIT
trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---INPUT-ARG CONSTANTS
ARGSTOTAL_MIN=1

#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_SOFTLIGHTBLUE=$'\e[30;38;5;80m'
FG_GREEN=$'\e[30;38;5;76m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'

TIBBO_FG_WHITE=$'\e[30;38;5;15m'
TIBBO_BG_ORANGE=$'\e[30;48;5;209m'

#---CONSTANTS (OTHER)
TITLE="TIBBO"

EMPTYSTRING=""

QUESTION_CHAR="?"

FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
THIRTYTWO_SPACES=${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}

#---EXIT CODES
EXITCODE_99=99

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

LINENUM_1=1

#---COMMAND RELATED CONSTANTS
IW_CMD="iw"
SED_CMD="sed"

#---READ INPUT CONSTANTS
INPUT_NO="n"
INPUT_YES="y"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

#---PATTERN CONSTANTS
PATTERN_BCMDHD="bcmdhd"
PATTERN_IW="iw"



#---HELPER/USAGE PRINTF CONSTANTS
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="WiFi Main-menu."



#---PRINTF PHASES
PRINTF_CONFIRM="CONFIRM:"
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_SUGGESTION="SUGGESTION:"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"



#---VARIABLES



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    etc_dir=/etc
    wpaSupplicant_filename="wpa_supplicant.conf"
    wpaSupplicant_fpath="${etc_dir}/${wpaSupplicant_filename}"

    yaml_fpath="${etc_dir}/netplan/*.yaml"    #use the default full-path

    wlan_conn_filename="tb_wlan_conn.sh"
    wlan_conn_fpath=${current_dir}/${wlan_conn_filename}

    wlan_conn_info_filename="tb_wlan_conn_info.sh"
    wlan_conn_info_fpath=${current_dir}/${wlan_conn_info_filename}

    wlan_inst_filename="tb_wlan_inst.sh"
    wlan_inst_fpath=${current_dir}/${wlan_inst_filename}

    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

    wlan_netplanconf_filename="tb_wlan_netplan_conf.sh"
    wlan_netplanconf_fpath=${current_dir}/${wlan_netplanconf_filename}

    wlan_ubinst_filename="tb_wlan_uninst.sh"
    wlan_uninst_fpath=${current_dir}/${wlan_ubinst_filename}

    var_backups_dir=/var/backups
    tb_wlan_mainmenu_reboot_isRequired_tmp_filename="tb_wlan_mainmenu_reboot_isRequired.tmp"
    tb_wlan_mainmenu_reboot_isRequired_tmp_fpath=${var_backups_dir}/${tb_wlan_mainmenu_reboot_isRequired_tmp_filename}

    tb_wlan_mainmenu_system_uptime_tmp_filename="tb_wlan_mainmenu_system_uptime.tmp"
    tb_wlan_mainmenu_system_uptime_tmp_fpath=${var_backups_dir}/${tb_wlan_mainmenu_system_uptime_tmp_filename}
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

function checkIf_fileExists__func() {
    #Input args
    local file_toBeChecked=${1}

    #Define local variables
    local errmsg_file_not_found="FILE ${FG_LIGHTRED}NOT${NOCOLOR} FOUND '${FG_LIGHTGREY}${file_toBeChecked}${NOCOLOR}'"

    #Check if file exist
    if [[ ! -f ${wlan_inst_fpath} ]]; then #file not found
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_file_not_found}" "${TRUE}"
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
            printf '%s%b\n' ${EMPTYSTRING}
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
        printf '%s%b\n' ${EMPTYSTRING}
    fi

    printf '%s%b\n' "***${FG_LIGHTRED}ERROR${NOCOLOR}(${errCode}): ${errMsg}"
    if [[ ${show_exitingNow} == ${TRUE} ]]; then
        printf '%s%b\n' "${FG_ORANGE}EXITING:${NOCOLOR} ${thisScript_filename}"
        printf '%s%b\n' ${EMPTYSTRING}
        
        exit ${EXITCODE_99}
    fi
}
function errTrap__func()
{
    if [[ ${trapDebugPrint_isEnabled} == ${TRUE} ]]; then
        #Input args
        #The input args are retrieved from the trap which is set with the command (see top of script)
        #   trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
        bash_lineNum=${1}
        bash_command=${2}

        #PRINT
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: START"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "BASH COMMAND: ${FG_LIGHTGREY}${bash_command}${NOCOLOR}"
        printf '%s%b\n' "LINE-NUMBER: ${FG_LIGHTGREY}${bash_lineNum}${NOCOLOR}"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: END"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' ${EMPTYSTRING}
    fi
}

function CTRL_C_func() {
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_CTRL_C_WAS_PRESSED}" "${TRUE}"
}



#---SUBROUTINES
update_system_uptime__sub() {
    #Get new uptime
    system_uptime_new=`uptime -s`

    if [[ ! -f ${tb_wlan_mainmenu_system_uptime_tmp_fpath} ]]; then #file does NOT exist
        #set flag to FALSE
        system_uptime_isSame=${FALSE}
    else
        if [[ ! -s ${tb_wlan_mainmenu_system_uptime_tmp_fpath} ]]; then #file does NOT contain any data
            #set flag to FALSE
            system_uptime_isSame=${FALSE}
        else    #file contains data
            #Get uptime from file
            system_uptime_old=`${SED_CMD} -n ${LINENUM_1}p ${tb_wlan_mainmenu_system_uptime_tmp_fpath}`

            #Compare 'old' with 'new' uptime
            if [[ ${system_uptime_old} != ${system_uptime_new} ]]; then #system was rebooted
                system_uptime_isSame=${FALSE}
            else    #system was NOT rebooted
                system_uptime_isSame=${TRUE}
            fi
        fi
    fi

    #write 'new' uptime to file
    echo "${system_uptime_new}" > ${tb_wlan_mainmenu_system_uptime_tmp_fpath} 
}

determine_reboot_isRequired_flag__func() {
    if [[ ! -f ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath} ]]; then #file does NOT exist
        #set flag to FALSE
        reboot_isRequired=${FALSE}

        #write to file
        echo "${reboot_isRequired}" > ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath}
    else
        if [[ ! -s ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath} ]]; then #file does NOT contain any data
            #set flag to FALSE
            reboot_isRequired=${FALSE}

            #write to file
            echo "${reboot_isRequired}" > ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath} 
        else    #file contains data
            #Check if system uptime is the same (which means there was NO REBOOT)
            if [[ ${system_uptime_isSame} == ${TRUE} ]]; then #system was NOT rebooted
                #Get flag from file
                reboot_isRequired=`${SED_CMD} -n ${LINENUM_1}p ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath}`
            else    #system was rebooted
                #set flag to FALSE
                reboot_isRequired=${FALSE}

                #write to file
                echo "${reboot_isRequired}" > ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath}                
            fi
        fi
    fi
}

load_tibbo_banner__sub() {
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

checkIfisRoot__sub()
{
    #Define Local variables
    local currUser=`whoami`
    local ROOTUSER="root"
    local ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}SUDO${NOCOLOR} OR ${FG_LIGHTGREY}ROOT${NOCOLOR}"

    #Check if user is 'root'
    if [[ ${currUser} != ${ROOTUSER} ]]; then   #not root
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_USER_IS_NOT_ROOT}" "${TRUE}"    
    fi
}

init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    isInitStartup=${TRUE}   #this variable will be changed to 'FALSE' in subroutine 'wifi_mainmenu__sub'
    # myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
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
            if [[ ${argsTotal} -eq 1 ]]; then
                input_args_print_unknown_option__sub

                exit 0
            elif [[ ${argsTotal} -gt ${ARGSTOTAL_MIN} ]]; then
                input_args_print_no_input_args_required__sub

                exit 0
            fi
            ;;
    esac
}

input_args_print_info__sub()
{
    debugPrint__func "${PRINTF_DESCRIPTION}" "${PRINTF_USAGE_DESCRIPTION}" "${EMPTYLINES_1}"

    local usageMsg=(
        "Usage: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR}"
        ${EMPTYSTRING}
        "${FOUR_SPACES}No input arguments required."
    )

    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
}

input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${EMPTYLINES_1}"
}

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

wifi_mainmenu__sub() {
    #Define local constants
    local MEMUHEADER_WIFI_MAINMENU="WIFI MAIN-MENU"
    local MENUMSG_INSTALL="Install"
    local MENUMSG_SSID_PLUS_NETPLAN_CONFIG="SSID + Netplan config"
    local MENUMSG_NETPLAN_CONFIG="Netplan config"
    local MENUMSG_INTERFACE_ONOFF="Interface on/off"
    local MENUMSG_INTERFACE_INFO="Interface Info"
    local MENUMSG_UNINSTALL="Uninstall"
    local MENUMSG_REBOOT="Reboot"
    local MENUMSG_Q_QUIT="Quit (Ctrl+C)"

    local MENUMSG_REQUIRED=${EMPTYSTRING}
    local MENUMSG_WIFI_STATE="${EMPTYSTRING}"

    local REGEX_INST="1,q"
    local REGEX_SSID_NETPLAN_CONF="2,q"
    local REGEX_NETPLAN_CONF="3,q"
    local REGEX_ALL_EXCL_INST="2-4,i,u,r,q"
    # local REGEX_UINST_REBOOT="u,r,q"
    local REGEX_REBOOT="r,q"

    local netplan_isConfigured=${FALSE}
    local wifi_isInstalled=${FALSE}
    local wifi_state=${STATUS_DOWN}
    local wlan_isPresent=${FALSE}
    local wlan_isUp=${FALSE}
    local ssid_isConfigured=${FALSE}


    #Define local variables
    local myChoice=${EMPTYSTRING}
    local regEx=${EMPTYSTRING}

    #Start loop
    while true
    do
        #Show Tibbo Banner
        if [[ ${isInitStartup} == ${FALSE} ]]; then
            load_tibbo_banner__sub
        else
            isInitStartup=${FALSE}  #change flag to FALSE
        fi

        #Choose the most suitable 'regEx' based on:
        #1. WiFi-software installation and module status
        #2. WiFi-interface presence
        #3. SSID-configuration status
        #4. Netplan-configuration status
        wifi_isInstalled=`wifi_validate_mod_and_software__func`
        if [[ ${wifi_isInstalled} == ${FALSE} ]]; then
            #Remark: 'reboot_isRequired' is set to {TRUE|FALSE} in subroutine 'wifi_mainmenu_uninstall__sub'
            if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                regEx=${REGEX_REBOOT}
            else
                regEx=${REGEX_INST}
            fi
        else    #wifi_isInstalled = TRUE
            #Check if WiFi is PRESENT
            wlan_isPresent=`wifi_checkIf_intf_isPresent__func`
            if [[ ${wlan_isPresent} == ${FALSE} ]]; then
                #Remark: 'reboot_isRequired' is set to TRUE in function 'wifi_checkIf_intf_isPresent__func'
                regEx=${REGEX_REBOOT}
            else    #wlan_isPresent = TRUE
                #Get Wifi-Interface
                wifi_retrieve_intfName__func

                #Get WiFi-status (UP or DOWN)
                wifi_state=`wifi_get_state__func`

                #Check if /etc/wpa_supplicant.conf contains a SSID-configuration
                ssid_isConfigured=`ssid_checkIf_isConfigured__func`
                if [[ ${ssid_isConfigured} == ${FALSE} ]]; then
                    #Remark: 'reboot_isRequired' maybe have been set by a previous action
                    if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                        regEx=${REGEX_REBOOT}
                    else
                        regEx=${REGEX_SSID_NETPLAN_CONF}
                    fi
                else    #ssid_isConfigured = TRUE
                    netplan_isConfigured=`netplan_checkIf_isConfigured__func`
                    if [[ ${netplan_isConfigured} == ${FALSE} ]]; then 
                        #Remark: 'reboot_isRequired' maybe have been set by a previous action
                        if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                            regEx=${REGEX_REBOOT}
                        else
                            regEx=${REGEX_NETPLAN_CONF}
                        fi
                    else    #netplan_isConfigured = TRUE
                        #Remark: 'reboot_isRequired' maybe have been set by a previous action
                        if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                            regEx=${REGEX_REBOOT}
                        else
                            regEx=${REGEX_ALL_EXCL_INST}
                        fi
                    fi
                fi
            fi
        fi

        #!!!BACKUP!!! Write 'reboot_isRequired' to file 'tb_wlan_mainmenu_reboot_isRequired_tmp_fpath'
        #REMARK: cannot write this in function 'wifi_checkIf_intf_isPresent__func', because...
        #........this function outputs a value
        echo "${reboot_isRequired}" > ${tb_wlan_mainmenu_reboot_isRequired_tmp_fpath}
    

        #Show menu items based on the chosen 'regEx'
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FG_LIGHTBLUE}${MEMUHEADER_WIFI_MAINMENU}${NOCOLOR}${THIRTYTWO_SPACES}v21.03.17-0.0.1"
        printf "%s\n" "----------------------------------------------------------------------"
        if [[ ${regEx} == ${REGEX_INST} ]]; then  #WiFi software not installed
            printf "%s\n" "${FOUR_SPACES}1 ${FG_LIGHTGREY}${MENUMSG_INSTALL}${NOCOLOR}"
        else    #WiFi software has been installed
            if [[ ${regEx} == ${REGEX_SSID_NETPLAN_CONF} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                printf "%s\n" "${FOUR_SPACES}2 ${FG_LIGHTGREY}${MENUMSG_SSID_PLUS_NETPLAN_CONFIG}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_NETPLAN_CONF} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                printf "%s\n" "${FOUR_SPACES}3 ${FG_LIGHTGREY}${MENUMSG_NETPLAN_CONFIG}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Change the contents of 'MENUMSG_INTERFACE_ONOFF' based on 'wifi_state'
                if [[ ${wifi_state} == ${STATUS_DOWN} ]]; then
                    MENUMSG_WIFI_STATE="${FG_SOFTLIGHTRED}${STATUS_DOWN}${NOCOLOR}"
                else
                    MENUMSG_WIFI_STATE="${FG_LIGHTGREEN}${STATUS_UP}${NOCOLOR}"
                fi
                printf "%s\n" "${FOUR_SPACES}4 ${FG_LIGHTGREY}${MENUMSG_INTERFACE_ONOFF}${NOCOLOR} (${MENUMSG_WIFI_STATE})"
                printf "%s\n" "----------------------------------------------------------------------"
                printf "%s\n" "${FOUR_SPACES}i ${FG_LIGHTGREY}${MENUMSG_INTERFACE_INFO}${NOCOLOR}"
            fi
            # if [[ ${regEx} == ${REGEX_UINST_REBOOT} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
            if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Only print horizontal line if 'regEx = REGEX_ALL_EXCL_INST'
                if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                    printf "%s\n" "----------------------------------------------------------------------"
                fi
                printf "%s\n" "${FOUR_SPACES}u ${FG_LIGHTGREY}${MENUMSG_UNINSTALL}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_REBOOT} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Only show 'required' if 'regEx = REGEX_REBOOT'
                if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                    MENUMSG_REQUIRED=" (${FG_SOFTLIGHTRED}required${NOCOLOR})"
                fi

                printf "%s\n" "${FOUR_SPACES}r ${FG_LIGHTGREY}${MENUMSG_REBOOT}${NOCOLOR}${MENUMSG_REQUIRED}"
            fi
        fi
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FOUR_SPACES}q ${FG_LIGHTGREY}${MENUMSG_Q_QUIT}${NOCOLOR}"
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" ${EMPTYSTRING}

        #Make a choice
        while true
        do
            #Select an option
            read -N 1 -e -p "Please choose an option: " myChoice
            printf "%s\n" ${EMPTYSTRING}

            #Only continue if a valid option is selected
            if [[ ! -z ${myChoice} ]]; then
                if [[ ${myChoice} =~ [${regEx}] ]]; then
                    break
                else
                    tput cuu1	#move UP with 1 line
                    tput cuu1	#move UP with 1 line
                    tput el		#clear until the END of line
                fi
            else
                tput cuu1	#move UP with 1 line
                tput el		#clear until the END of line
            fi
        done
            
        #Goto the selected option
        case ${myChoice} in
            1)
                wifi_mainmenu_install__sub
                ;;

            2)
                wifi_mainmenu_ssid_netplan_config__sub
                ;;

            3)
                wifi_mainmenu_netplan_config__sub
                ;;

            4)
                wifi_mainmenu_interface_onoff__sub
                ;;

            i)
                wifi_mainmenu_connect_info__sub
                ;;

            u)
                wifi_mainmenu_uninstall__sub
                ;;

            r)
                wifi_mainmenu_reboot__sub
                ;;

            q)
                exit
                ;;
        esac
    done
}
function wifi_validate_mod_and_software__func() {
    #Check if wifi-module 'bmcdhd' is installed
    if [[ `mod_checkIf_isPresent` == ${TRUE} ]]; then    #module is present
        if [[ `software_checkIf_isInstalled__func "${PATTERN_IW}"` == ${TRUE} ]]; then  #wifi software is installed
            echo "${TRUE}"
        else    #wifi software is NOT installed
            echo "${FALSE}"
        fi
    else    #module is not present
        echo "${FALSE}"
    fi

}
function mod_checkIf_isPresent() {
    #Check if 'bcmdhd' is present
    stdOutput=`lsmod | grep ${PATTERN_BCMDHD} 2>&1`
    if [[ ! -z ${stdOutput} ]]; then   #contains data
        echo "${TRUE}"
    else
        echo "${FALSE}"
    fi
}
function software_checkIf_isInstalled__func()
{
    #Input args
    local software_input=${1}

    #Define local variables
    local stdOutput=`apt-mark showinstall | grep ${software_input} 2>&1`

    #If 'stdOutput' is an EMPTY STRING, then software is NOT installed yet
    if [[ -z ${stdOutput} ]]; then #contains NO data
        echo ${FALSE}
    else
        echo ${TRUE}
    fi
}

function wifi_retrieve_intfName__func() {
    wlanSelectIntf=`${IW_CMD} dev | grep Interface | cut -d" " -f2`
}
function wifi_checkIf_intf_isPresent__func() {
    local isPresent=${FALSE}

    local stdOutput=`${IW_CMD} dev | grep ${wlanSelectIntf} 2>&1`
    if [[ -z ${stdOutput} ]]; then #no data found
        reboot_isRequired=${TRUE}    #IMPORTANT: set flag to TRUE

        isPresent=${FALSE}
    else    #data was found
        reboot_isRequired=${FALSE}    #IMPORTANT: set flag to TRUE

        isPresent=${TRUE}
    fi

    #Output
    echo ${isPresent}
}
function wifi_get_state__func() {
    local stdOutput=`ip link show ${wlanSelectIntf} | grep ${STATUS_UP} 2>&1`
    if [[ -z ${stdOutput} ]]; then #no data found
        echo ${STATUS_DOWN}
    else    #data was found
        echo ${STATUS_UP}
    fi
}

function ssid_checkIf_isConfigured__func() {
    #Define local constants
    local PATTERN_NETWORK="network"
    local PATTERN_SSID="ssid"

    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Check if file is found
    if [[ ! -f ${wpaSupplicant_fpath} ]]; then  #file is NOT found
        echo ${FALSE}
    else    #file is found
        stdOutput=`cat ${wpaSupplicant_fpath} | grep "${PATTERN_NETWORK}"`
        if [[ -z ${stdOutput} ]]; then  #no data found
            echo ${FALSE}
        else     #data was found
            stdOutput=`cat ${wpaSupplicant_fpath} | grep "${PATTERN_SSID}"`
            if [[ -z ${stdOutput} ]]; then  #no data found
                echo ${FALSE}
            else     #data was found
                echo ${TRUE}
            fi
        fi
    fi
}

function netplan_checkIf_isConfigured__func() {
    #Define local constants
    local PATTERN_WIFIS="wifis:"

    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Check if pattern 'wifis' is found
    if [[ ! -f ${yaml_fpath} ]]; then  #file is NOT found
        echo ${FALSE}
    else    #file is found
        stdOutput=`cat ${yaml_fpath} | grep "${PATTERN_WIFIS}"`
        if [[ -z ${stdOutput} ]]; then  #no data found
            echo ${FALSE}
        else     #data was found
            stdOutput=`cat ${yaml_fpath} | grep "${wlanSelectIntf}"`
            if [[ -z ${stdOutput} ]]; then  #no data found
                echo ${FALSE}
            else     #data was found
                echo ${TRUE}
            fi
        fi
    fi
}

wifi_mainmenu_install__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_inst_fpath}"

    #Execute file
    ${wlan_inst_fpath}
}

wifi_mainmenu_ssid_netplan_config__sub() {
    #Get 'old' state-values
    local ssid_isConfigured_old=`ssid_checkIf_isConfigured__func`
    local netplan_isConfigured_old=`netplan_checkIf_isConfigured__func` 

    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_conn_fpath}"

    #Execute file
    ${wlan_conn_fpath}

    #Get 'new' state-values
    local ssid_isConfigured_new=`ssid_checkIf_isConfigured__func`
    local netplan_isConfigured_new=`netplan_checkIf_isConfigured__func`

    #FIRST: Compare (SSID) 'old' and 'new' values
    #REMARK: if both values are the same, then RECOMMEND a REBOOT
    if [[ ${ssid_isConfigured_old} == ${ssid_isConfigured_new} ]]; then
        reboot_isRequired=${TRUE}    #IMPORTANT: set flag to TRUE
    else    #'old' and 'new' values are DIFFERENT
        #NEXT: Compare (NETPLAN) 'old' and 'new' values
        #REMARK: if both values are the same, then RECOMMEND a REBOOT
        if [[ ${netplan_isConfigured_old} == ${netplan_isConfigured_new} ]]; then
            reboot_isRequired=${TRUE}    #IMPORTANT: set flag to TRUE
        else
            reboot_isRequired=${FALSE}   #IMPORTANT: set flag to FALSE
        fi
    fi
}

wifi_mainmenu_netplan_config__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_netplanconf_fpath}"

    #Execute file
    ${wlan_netplanconf_fpath}
}

wifi_mainmenu_interface_onoff__sub() {
    #Get 'old' state-value
    local wifi_state_old=`wifi_get_state__func`

    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_intf_updown_fpath}"

    #Execute file
    ${wlan_intf_updown_fpath}

    #Get 'new' state-value
    local wifi_state_new=`wifi_get_state__func`

    #Compare 'old' and 'new' values
    #REMARK: if both values are the same, then RECOMMEND a REBOOT
    if [[ ${wifi_state_old} == ${wifi_state_old} ]]; then
        reboot_isRequired=${TRUE}    #IMPORTANT: set flag to TRUE
    else
        reboot_isRequired=${FALSE}   #IMPORTANT: set flag to FALSE
    fi
}

wifi_mainmenu_connect_info__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_conn_info_fpath}"

    #Execute file
    ${wlan_conn_info_fpath}
}

wifi_mainmenu_uninstall__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_uninst_fpath}"

    #Execute file
    ${wlan_uninst_fpath}

    #IMPORTANT: set flag to TRUE
    reboot_isRequired=${TRUE}
}

wifi_mainmenu_reboot__sub() {
    #Define local constants
    local QUESTION_REBOOT_NOW="REBOOT NOW (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
    local QUESTION_ARE_YOU_VERY_SURE="ARE YOU VERY SURE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"

    #Define local variables
    local myChoice=${EMPTYSTRING}

    #Print Question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_REBOOT_NOW}" "${EMPTYLINES_0}"

    while true
    do
        read -N1 -r -s -e -p "${EMPTYSTRING}" myChoice
        if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
            clear_lines__func "${NUMOF_ROWS_2}"

            debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_REBOOT_NOW} ${myChoice}" "${EMPTYLINES_0}"

            if [[ ${myChoice} == ${INPUT_YES} ]]; then
                debugPrint__func "${PRINTF_CONFIRM}" "${QUESTION_ARE_YOU_VERY_SURE}" "${EMPTYLINES_0}"

                while true
                do
                    read -N1 -r -s -e -p "${EMPTYSTRING}" myChoice
                    if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                        clear_lines__func "${NUMOF_ROWS_2}"

                        debugPrint__func "${PRINTF_CONFIRM}" "${QUESTION_ARE_YOU_VERY_SURE} ${myChoice}" "${EMPTYLINES_0}"

                        if [[ ${myChoice} == ${INPUT_YES} ]]; then
                            reboot
                        fi

                        break
                    else    #all other cases (e.g. ENTER or any-other-key was pressed)
                        clear_lines__func "${NUMOF_ROWS_1}"
                    fi
                done
            fi

            break
        else    #all other cases (e.g. ENTER or any-other-key was pressed)
            clear_lines__func "${NUMOF_ROWS_1}"
        fi
    done
}


#---MAIN SUBROUTINE
main_sub() {
    load_env_variables__sub

    update_system_uptime__sub

    determine_reboot_isRequired_flag__func

    load_tibbo_banner__sub

    checkIfisRoot__sub

    init_variables__sub

    input_args_case_select__sub

    wifi_mainmenu__sub
}



#EXECUTE
main_sub
