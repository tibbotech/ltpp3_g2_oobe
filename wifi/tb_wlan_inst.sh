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

#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=4

#---CONSTANTS (OTHER)
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
IWCONFIG_CMD="iwconfig"
LSMOD_CMD="lsmod"

MODPROBE_BCMDHD="bcmdhd"

POWER="power"
TOGGLE_OFF="off"
TOGGLE_ON="on"

#---READ INPUT CONSTANTS
ZERO=0
ONE=1

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

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
CHECK_STOPPED="STOPPED"

#---TIMEOUT CONSTANTS
SLEEP_TIMEOUT=2

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

#---PATTERN CONSTANTS
PATTERN_INTERFACE="Interface"
PATTERN_IW="iw"
PATTERN_POWER_MANAGEMENT="Power Management"
PATTERN_SSID="ssid"
PATTERN_WIRELESS_TOOLS="wireless-tools"
PATTERN_WPASUPPLICANT="wpasupplicant"

#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle WiFi-module & install WiFi-software"



#---PRINTF PHASES
PRINTF_INSTALLING="INSTALLING:"
PRINTF_SETTING="SETTING:"
PRINTF_STATUS="STATUS:"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
ERRMSG_NO_INTF_FOUND="NO WiFi INTERFACE FOUND"
ERRMSG_PLEASE_REBOOT_AND_TRY_TO_INSTALL_AGAIN="PLEASE *REBOOT* AND TRY TO *INSTALL* AGAIN"

ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---PRINTF MESSAGES
PRINTF_POWERMANAGEMENT_OFF="POWER MANAGEMENT: OFF"
PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR}"
PRINTF_UPDATES="UPDATES"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"
PRINTF_WIFI_SOFTWARE="WiFi SOFTWARE"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${MODPROBE_BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_occurred_in_file_wlan_intf_updown="OCCURRED IN FILE: ${FG_LIGHTGREY}${wlan_intf_updown_filename}${NOCOLOR}"

    pwrmgmt_setting=${FALSE}
}



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    wlan_intf_updown_filename="tb_wlan_intf_updown.sh"
    wlan_intf_updown_fpath=${current_dir}/${wlan_intf_updown_filename}

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
function errTrap__func()
{
    if [[ ${trapDebugPrint_isEnabled} == ${TRUE} ]]; then
        #Input args
        #The input args are retrieved from the trap which is set with the command (see top of script)
        #   trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
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
    errExit_isEnabled=${TRUE}
    exitCode=0
    myChoice=${EMPTYSTRING}
    pattern_wlan=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlanSelectIntf=${EMPTYSTRING}

    check_missing_isFound=${FALSE}
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

input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_info__sub()
{
    debugPrint__func "${PRINTF_DESCRIPTION}" "${PRINTF_USAGE_DESCRIPTION}" "${EMPTYLINES_1}"

    local usageMsg=(
        "Usage: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR}"
        ""
        "${FOUR_SPACES}No input arguments required."
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

    #Reset variables
    check_missing_isFound=${FALSE}

    #Print
    debugPrint__func "${PRINTF_PRECHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Pre-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func "${PATTERN_IW}"
    software_preCheck_isInstalled__func "${PATTERN_WIRELESS_TOOLS}"
    software_preCheck_isInstalled__func "${PATTERN_WPASUPPLICANT}"
    intf_preCheck_isPresent__func
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
        check_missing_isFound=${TRUE}   #set boolean to TRUE   

        printf_toBeShown="${FG_LIGHTGREY}${INTF}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"    

        return
    fi

    #Get ALL available WLAN interface
    wlanList_string=`{ ${IW_CMD} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | xargs -n 1 | sort -u | xargs; } 2> /dev/null`
    if [[ -z ${wlanList_string} ]]; then
        check_missing_isFound=${TRUE}   #set boolean to TRUE   

        printf_toBeShown="${FG_LIGHTGREY}${INTF}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"    

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

wlan_intf_selection__sub()
{
    #Define local variables
    local seqNum=0
    local arrNum=0
    local wlanList_string=${EMPTYSTRING}
    local wlanList_array=()
    local wlanList_arrayLen=0
    local wlanItem=${EMPTYSTRING}

    #Get ALL available WLAN interface
    wlanList_string=`{ ${IW_CMD} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

    #Check if 'wlanList_string' contains any data
    if [[ -z $wlanList_string ]]; then  #contains NO data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_INTF_FOUND}" "${TRUE}"       
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

function intf_toggle__func()
{
    #Input arg
    local intfState_setTo=${1}

    #Run script 'tb_wlan_stateconf.sh'
    #IMPORTANT: set interface to 'UP'
    #REMARK: this is required for the 'iwlist' scan to get the SSID-list
    ${wlan_intf_updown_fpath} "${wlanSelectIntf}" "${intfState_setTo}" "${yaml_fpath}"
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_occurred_in_file_wlan_intf_updown}" "${TRUE}"
    fi  
}

update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES_UPGRADES}" "${EMPTYLINES_1}"
    updates_upgrades_inst_list__func
}
function updates_upgrades_inst_list__func()
{
    apt-get -y update

    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
}

software_install__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_WIFI_SOFTWARE}" "${EMPTYLINES_1}"
    software_inst_list__func
}
function software_inst_list__func()
{
    apt-get -y install iw
    apt-get -y install wireless-tools
    apt-get -y install wpasupplicant
}

mods_enable__sub()
{
    toggle_module__func "${TRUE}"
}
function toggle_module__func()
{
    #Input args
    local mod_isEnabled=${1}

    #Local variables
    local errMsg=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local wlanList_string=${EMPTYSTRING}

    #Check if 'bcmdhd' is present
    bcmdhd_isPresent=`${LSMOD_CMD} | grep ${MODPROBE_BCMDHD}`

    #Toggle WiFi Module (enable/disable)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${bcmdhd_isPresent} ]]; then   #contains data (thus WLAN interface is already enabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_UP}" "${EMPTYLINES_1}"

            return
        fi

        modprobe ${MODPROBE_BCMDHD}
        
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD}" "${TRUE}"
        fi
    else
        if $[[ -z ${wlanList_string} ]]; then   #contains NO data (thus WLAN interface is already disabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_DOWN}" "${EMPTYLINES_1}"

            return
        fi

        modprobe -r ${MODPROBE_BCMDHD}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD}" "${TRUE}"
        fi
    fi

    #Print result (exit-code=0)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then  #module was set to be enabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD}" "${EMPTYLINES_1}"
    else    #module was set to be disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD}" "${EMPTYLINES_1}"
    fi
}

postCheck_handler__sub()
{
    #Define local constants
    local PRINTF_POSTCHECK="${FG_PURPLERED}POST${NOCOLOR}${FG_ORANGE}-CHECK:${NOCOLOR}"
    local ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA="ONE OR MORE ITEMS WERE ${FG_LIGHTRED}N/A${NOCOLOR}..."
    local ERRMSG_IS_WIFI_INSTALLED_CORRECTLY="IS WiFi *INSTALLED* PROPERLY?"
    local PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES="STATUS OF MODULES/SOFTWARE/SERVICES"

    #Reset variables
    check_missing_isFound=${FALSE}

    #Print
    debugPrint__func "${PRINTF_POSTCHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Post-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func "${PATTERN_IW}"
    software_preCheck_isInstalled__func "${PATTERN_WIRELESS_TOOLS}"
    software_preCheck_isInstalled__func "${PATTERN_WPASUPPLICANT}"
    intf_preCheck_isPresent__func

    #Print 'failed' message(s) depending on the detected failure(s)
    if [[ ${check_missing_isFound} == ${TRUE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA}" "${FALSE}"      
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_REBOOT_AND_TRY_TO_INSTALL_AGAIN}" "${TRUE}"  
    fi
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    checkIfisRoot__sub

    init_variables__sub

    input_args_case_select__sub

    preCheck_handler__sub

    mods_enable__sub

    update_and_upgrade__sub

    software_install__sub
    
    wlan_intf_selection__sub

    intf_toggle__func ${TOGGLE_UP}

    postCheck_handler__sub
}


#---EXECUTE
main__sub
