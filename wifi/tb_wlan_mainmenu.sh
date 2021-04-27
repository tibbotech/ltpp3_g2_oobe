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

PATTERN_BCMDHD="bcmdhd"
PATTERN_IW="iw"

EMPTYSTRING=""

QUESTION_CHAR="?"

FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
THIRTYTWO_SPACES=${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}


EXITCODE_99=99

#---LINE CONSTANTS
EMPTYLINES_0=0
EMPTYLINES_1=1

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

INPUT_NO="n"
INPUT_YES="y"



#---HELPER/USAGE PRINT CONSTANTS
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_STATUS="STATUS:"
PRINTF_SUGGESTION="SUGGESTION:"
PRINTF_VERSION="VERSION:"


#---ERROR MESSAGE CONSTANTS
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---PRINT MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="WiFi Main-menu."



#---VARIABLES



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

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
}



#---FUNCTIONS
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
    myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlan_isUp=${FALSE}
    ssid_isPresent=${FALSE}
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
    local MENUMSG_CONNECT_TO_WIFI="Connect to WiFi"
    local MENUMSG_NETPLAN_CONFIG="Netplan config"
    local MENUMSG_INTERFACE_ONOFF="Interface on/off"
    local MENUMSG_INTERFACE_INFO="Interface Info"
    local MENUMSG_UNINSTALL="Uninstall"
    local MENUMSG_Q_QUIT="Quit (Ctrl+C)"

    local REGEX_INST="1,q"
    local REGEX_UNINST="2-4,i,u,q"

    #Define local variables
    local regEx=${EMPTYSTRING}

    #Show menu
    while true
    do
        #Show Tibbo Banner
        load_tibbo_banner__sub

        #Check if user is 'sudo' or 'root'
        checkIfisRoot__sub

        #Check if WiFi Module is Present and Software is Installed
        wifi_isInstalled=`validate_wifi_install__func`
        if [[ ${wifi_isInstalled} == ${FALSE} ]]; then
            regEx=${REGEX_INST}
        else
            regEx=${REGEX_UNINST}
        fi


        #Show menu items
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FG_LIGHTBLUE}${MEMUHEADER_WIFI_MAINMENU}${NOCOLOR}${THIRTYTWO_SPACES}v21.03.17-0.0.1"
        printf "%s\n" "----------------------------------------------------------------------"
        if [[ ${wifi_isInstalled} == ${FALSE} ]]; then
            printf "%s\n" "${FOUR_SPACES}1. ${MENUMSG_INSTALL}"
        fi
        if [[ ${wifi_isInstalled} == ${TRUE} ]]; then
            printf "%s\n" "${FOUR_SPACES}2. ${MENUMSG_CONNECT_TO_WIFI}"
        fi
        if [[ ${wifi_isInstalled} == ${TRUE} ]]; then
            printf "%s\n" "${FOUR_SPACES}3. ${MENUMSG_NETPLAN_CONFIG}"
        fi
        if [[ ${wifi_isInstalled} == ${TRUE} ]]; then
            printf "%s\n" "${FOUR_SPACES}4. ${MENUMSG_INTERFACE_ONOFF}"
        fi
        if [[ ${wifi_isInstalled} == ${TRUE} ]]; then
            printf "%s\n" "----------------------------------------------------------------------"
            printf "%s\n" "${FOUR_SPACES}i. ${MENUMSG_INTERFACE_INFO}"
            printf "%s\n" "${FOUR_SPACES}u. ${MENUMSG_UNINSTALL}"
        fi
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FOUR_SPACES}q. ${MENUMSG_Q_QUIT}"
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" ${EMPTYSTRING}

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
                wifi_mainmenu_connection__sub
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

            q)
                exit
                ;;
        esac
    done
}
function validate_wifi_install__func() {
    #Check if wifi-module 'bmcdhd' is installed
    if [[ `checkIf_wifiModule_isPresent` == ${TRUE} ]]; then    #module is present
        if [[ `checkIf_software_isInstalled__func "${PATTERN_IW}"` == ${TRUE} ]]; then  #wifi software is installed
            echo "${TRUE}"
        else    #wifi software is NOT installed
            echo "${FALSE}"
        fi
    else    #module is not present
        echo "${FALSE}"
    fi

}
function checkIf_wifiModule_isPresent() {
    #Check if 'bcmdhd' is present
    stdOutput=`lsmod | grep ${PATTERN_BCMDHD} 2>&1`
    if [[ ! -z ${stdOutput} ]]; then   #contains data
        echo "${TRUE}"
    else
        echo "${FALSE}"
    fi
}
function checkIf_software_isInstalled__func()
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

wifi_mainmenu_install__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_inst_fpath}"

    #Execute file
    ${wlan_inst_fpath}
}

wifi_mainmenu_connection__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_conn_fpath}"

    #Execute file
    ${wlan_conn_fpath}
}

wifi_mainmenu_netplan_config__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_netplanconf_fpath}"

    #Execute file
    ${wlan_netplanconf_fpath}
}

wifi_mainmenu_interface_onoff__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_intf_updown_fpath}"

    #Execute file
    ${wlan_intf_updown_fpath}
}

wifi_mainmenu_connect_info__sub() {
    #Get Wifi Interface
    retrieve_wifi_interface_name__func

    #Get Wifi Status
    checkIf_wlan_intf_status__func

    if [[ ${wlan_isUp} == ${TRUE} ]]; then  #interface is UP
        #Check if SSID is PRESENT
        checkIf_ssid_isPresent__func
        if [[ ${ssid_isPresent} == ${TRUE} ]]; then #SSID is present
            #Check if file exists
            #REMARK: if file does NOT exist, then exit
            checkIf_fileExists__func "${wlan_conn_info_fpath}"

            #Execute file
            ${wlan_conn_info_fpath}
        fi
    fi
}
function retrieve_wifi_interface_name__func() {
    wlanSelectIntf=`iw dev | grep Interface | cut -d" " -f2`
}
function check_wlan_intf_status__func() {
    #Define local CONSTANTS
    PRINTF_NO_WIFI_INTF_FOUND="NO WIFI INTERFACE FOUND"
    PRINTF_REBOOT_THEN_TRY_TO_CONNECT_TO_WIFI="REBOOT, THEN TRY TO CONNECT TO WIFI (OPTION 2)"
    PRINTF_WIFI_INTF_IS_DOWN="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} IS ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
    BRING_INTF_UP_THEN_TRY_AGAIN="BRING ${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} ${FG_GREEN}${STATUS_UP}${NOCOLOR} (OPTION 4), THEN TRY AGAIN..."

    #Get Wifi Interface Status
    local stdOutput=`iw dev | grep ${wlanSelectIntf} 2>&1`
    if [[ -z ${stdOutput} ]]; then #an error has occurred
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_NO_WIFI_INTF_FOUND}" "${EMPTYLINES_0}"
        debugPrint__func "${PRINTF_SUGGESTION}" "${PRINTF_REBOOT_THEN_TRY_TO_CONNECT_TO_WIFI}" "${EMPTYLINES_0}"

        wlan_isUp=${FALSE}
    else    #no errors found
        stdOutput=`ip link show ${wlanSelectIntf} | grep ${STATUS_UP} 2>&1`
        if [[ -z ${stdOutput} ]]; then    #wlan is 'DOWN'
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_INTF_IS_DOWN}" "${EMPTYLINES_0}"
            debugPrint__func "${PRINTF_SUGGESTION}" "${BRING_INTF_UP_THEN_TRY_AGAIN}" "${EMPTYLINES_0}"

            wlan_isUp=${FALSE}
        else
            wlan_isUp=${TRUE}
        fi
    fi
}
function checkIf_ssid_isPresent__func() {
    #Define local CONSTANTS
    local PATTERN_OFF_ANY="off/any"

    #Check if SSID is present
    local stdOutput=`iwconfig ${wlanSelectIntf} | grep ${PATTERN_OFF_ANY} | cut -d":" -f2 2>&1`
    if [[ ! -z ${stdOutput} ]]; then    #contains data (which means no SSID present)
        debugPrint__func "${PRINTF_STATUS}" "${ SOMETHING }" "${EMPTYLINES_0}"
        debugPrint__func "${PRINTF_SUGGESTION}" "${ SOMETHING }" "${EMPTYLINES_0}"

        ssid_isPresent=${FALSE}
    else    #contains no data (which means SSID is present)
        ssid_isPresent=${TRUE}
    fi
}

wifi_mainmenu_uninstall__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${wlan_uninst_fpath}"

    #Execute file
    ${wlan_uninst_fpath}
}



#---MAIN SUBROUTINE
main_sub() {
    load_env_variables__sub

    init_variables__sub

    input_args_case_select__sub

    wifi_mainmenu__sub
}



#EXECUTE
main_sub
