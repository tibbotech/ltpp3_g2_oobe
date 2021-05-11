#!/bin/bash
#---INPUT ARGS


#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${1}

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"


#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---TRAP ON EXIT
trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1

#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_BLUETOOTHCTL_DARKBLUE=$'\e[30;38;5;27m'
FG_DARKBLUE=$'\e[30;38;5;33m'
FG_SOFTDARKBLUE=$'\e[30;38;5;38m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_GREEN=$'\e[30;38;5;76m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
FG_LIGHTPINK=$'\e[30;38;5;224m'
TIBBO_FG_WHITE=$'\e[30;38;5;15m'

TIBBO_BG_ORANGE=$'\e[30;48;5;209m'

#---CONSTANTS (OTHER)
TITLE="TIBBO"

EMPTYSTRING=""

ASTERISK_CHAR="*"
BACKSLASH_CHAR="\\"
CARROT_CHAR="^"
COMMA_CHAR=","
COLON_CHAR=":"
DASH_CHAR="-"
DOLLAR_CHAR="$"
DOT_CHAR=$'\.'
ENTER_CHAR=$'\x0a'
QUESTION_CHAR="?"
QUOTE_CHAR=$'\"'
SLASH_CHAR="/"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"
TAB_CHAR=$'\t'

ONE_SPACE=" "
TWO_SPACES="${ONE_SPACE}${ONE_SPACE}"
FOUR_SPACES="${TWO_SPACES}${TWO_SPACES}"
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
HCITOOL_CMD="hcitool"
HCICONFIG_CMD="hciconfig"
RFCOMM_CMD="rfcomm"
RFCOMM_CHANNEL_1="1"
SYSTEMCTL_CMD="systemctl"

BT_TTYSX_LINE="\/dev\/ttyS4"
BT_BAUDRATE=3000000
BT_SLEEPTIME=200000

MODPROBE_BLUETOOTH="bluetooth"
MODPROBE_HCI_UART="hci_uart"
MODPROBE_RFCOMM="rfcomm"
MODPROBE_BNEP="bnep"
MODPROBE_HIDP="hidp"

ENABLE="enable"
DISABLE="disable"

START="start"
STOP="stop"

IS_ENABLED="is-enabled"
IS_ACTIVE="is-active"
STATUS="status"

ALL="all"
RELEASE="release"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

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

#---RETRY CONSTANTS
DAEMON_RETRY=20

#---TIMEOUT CONSTANTS
DAEMON_SLEEPTIME=3    #second

#---READ INPUT CONSTANTS
INPUT_ABORT="a"

#---STATUS/BOOLEANS
ENABLED="enabled"
ACTIVE="active"

TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

ON="on"
OFF="off"

INPUT_NO="n"
INPUT_YES="y"

CHECK_OK="OK"
CHECK_DISABLED="DISABLED"
CHECK_ENABLED="ENABLED"
CHECK_FAILED="FAILED"
CHECK_NOTAVAILABLE="N/A"
CHECK_PRESENT="PRESENT"
CHECK_RUNNING="RUNNING"
CHECK_STOPPED="STOPPED"

#---PATTERN CONSTANTS
PATTERN_BLUEZ="bluez"
PATTERN_COULD_NOT_BE_FOUND="could not be found"
PATTERN_TYPE_PRIMARY="Type: Primary"


#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_NO_INPUT_ARGS_REQUIRED="NO INPUT ARGS REQUIRED."

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Uninstall Bluetooth."



#---PRINTF PHASES
PRINTF_CONFIRM="CONFIRM:"
PRINTF_COMPLETED="COMPLETED:"
PRINTF_DELETING="${FG_LIGHTRED}DELETING:${NOCOLOR}:"
PRINTF_EXITING="EXITING:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_PRECHECK="PRE-CHECK:"
PRINTF_QUESTION="QUESTION:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_UINSTALLING="UNINSTALLING:"
PRINTF_MANDATORY="${FG_PURPLERED}MANDATORY${NOCOLOR}${FG_ORANGE}:${NOCOLOR}"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

ERRMSG_ONE_OR_MORE_SERVICES_ARE_MISSING="ONE OR MORE SERVICES ARE MISSING..."
ERRMSG_IS_BT_INSTALLED_PROPERLY="IS BT INSTALLED PROPERLY?"

#---PRINTF MESSAGES
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

PRINTF_BLUEZ="BLUEZ"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_DISABLED="BT-FIRMWARE SERVICE IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STOPPED="BT-FIRMWARE SERVICE IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_STOPPED="BLUETOOTH SERVICE IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_DISABLED="BLUETOOTH SERVICE IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_RFCOMM_BINDINGS_RELEASED="RFCOMM-BINDINGS ${FG_LIGHTGREY}RELEASED${NOCOLOR}"
PRINTF_RFCOMM_SERVICE_ISALREADY_STOPPED="RFCOMM-SERVICE IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_RFCOMM_SERVICE_ISALREADY_DISABLED="RFCOMM-SERVICE IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_STOPPING_BLUETOOTH_SERVICE="---:STOPPING BLUETOOTH SERVICE"
PRINTF_DISABLING_BLUETOOTH_SERVICE="---:DISABLING BLUETOOTH SERVICE"
PRINTF_STOPPING_BT_FIRMWARE_SERVICE="---:STOPPING BT-FIRMWARE SERVICE"
PRINTF_DISABLING_BT_FIRMWARE_SERVICE="---:DISABLING BT-FIRMWARE SERVICE"
PRINTF_STOPPING_RFCOMM_SERVICE="---:STOPPING RFCOMM-SERVICE"
PRINTF_DISABLING_RFCOMM_SERVICE="---:DISABLING RFCOMM-SERVICE"
PRINTF_REMOVING_FILES="---:REMOVING FILES"
PRINTF_DISABLING_BLUETOOTH_MODULES="---:DISABLING BT-MODULES"

PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"

PRINTF_NO_ACTION_REQUIRED="NO ACTION REQUIRED..."

PRINTF_A_REBOOT_IS_REQUIRED_TO_COMPLETE_THE_PROCESS="A ${FG_YELLOW}REBOOT${NOCOLOR} IS REQUIRED TO COMPLETE THE PROCESS..."

#---QUESTION MESSAGES
QUESTION_DISABLE_BT="${FG_LIGHTRED}DISABLE${NOCOLOR} BT (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_ENABLE_BT="${FG_GREEN}ENABLE${NOCOLOR} BT (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_REBOOT_NOW="REBOOT NOW (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_ARE_YOU_VERY_SURE="ARE YOU VERY SURE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_unknown_option="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

    printf_tb_bt_firmware_service_not_present="SERVICE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}' ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"
    printf_bluetooth_service_not_present="SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"
    printf_removing_bt_modules_from_config_file="---:REMOVING BT-MODULES FROM '${FG_LIGHTGREY}${modules_conf_fpath}${NOCOLOR}'"
    printf_rfcomm_onBoot_bind_service_not_present="SERVICE '${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_filename}${NOCOLOR}' ${FG_LIGHTRED}NOT${NOCOLOR} PRESENT"
}



#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    bluetooth_service_filename="bluetooth.service"

    usr_bin_dir=/usr/bin

    etc_modules_load_d_dir=/etc/modules-load.d
    modules_conf_filename="modules.conf"
    modules_conf_fpath=${etc_modules_load_d_dir}/${modules_conf_filename}

    usr_local_bin_dir=/usr/local/bin  #script location
    tb_bt_firmware_filename="tb_bt_firmware.sh"
    tb_bt_firmware_fpath=${usr_local_bin_dir}/${tb_bt_firmware_filename}
    rfcomm_onBoot_bind_filename="rfcomm_onBoot_bind.sh"
    rfcomm_onBoot_bind_fpath=${usr_local_bin_dir}/${rfcomm_onBoot_bind_filename}

    etc_systemd_system_dir=/etc/systemd/system #service location
    tb_bt_firmware_service_filename="tb_bt_firmware.service"
    tb_bt_firmware_service_fpath=${etc_systemd_system_dir}/${tb_bt_firmware_service_filename}   
    rfcomm_onBoot_bind_service_filename="rfcomm_onBoot_bind.service"
    rfcomm_onBoot_bind_service_fpath=${etc_systemd_system_dir}/${rfcomm_onBoot_bind_service_filename}   

    etc_systemd_system_multi_user_target_wants_dir=/etc/systemd/system/multi-user.target.wants #service-symlink location
    tb_bt_firmware_service_symlink_filename="tb_bt_firmware.service"
    tb_bt_firmware_service_symlink_fpath=${etc_systemd_system_multi_user_target_wants_dir}/${tb_bt_firmware_service_symlink_filename} 
    rfcomm_onBoot_bind_service_symlink_filename="rfcomm_onBoot_bind.service"
    rfcomm_onBoot_bind_service_symlink_fpath=${etc_systemd_system_multi_user_target_wants_dir}/${rfcomm_onBoot_bind_service_symlink_filename}
}



#---FUNCTIONS
function clear_lines__func() 
{
    #Input args
    local maxOf_rows=${1}

    #Clear line(s)
    if [[ ${maxOf_rows} -eq ${NUMOF_ROWS_0} ]]; then  #clear current line
        tput el1
    else    #clear specified number of line(s)
        tput el1

        for ((r=0; r<${maxOf_rows}; r++))
        do  
            tput cuu1
            tput el
        done
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
    local lowerString=`echo "${orgString}" | sed "s/./\L&/g"`

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

function noActionRequired_exit__func()
{
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_NO_ACTION_REQUIRED}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"

    append_emptyLines__func "${EMPTYLINES_1}"

    exit 0 
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



#---SUBROUTINES
load_tibbo_banner__sub() {
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
    bt_curr_setTo=${OFF}
    currService_setTo=${FALSE}
    trapDebugPrint_isEnabled=${FALSE}

    check_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToDisable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_failedToStop_isFound=${FALSE}
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
        ""
        "${FOUR_SPACES}No input arguments required."
    )

    printf "%s\n" ""
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}
input_args_print_usage__sub()
{
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_INTERACTIVE_MODE_IS_ENABLED}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_FOR_HELP_PLEASE_RUN}" "${EMPTYLINES_0}"
}
input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unknown_option}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}
input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${EMPTYLINES_1}"

    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
}
input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_INPUT_ARGS_REQUIRED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

bt_firmware_service_handler__sub()
{
    #Check if service 'tb_bt_firmware.service'
    local stdErr=`${SYSTEMCTL_CMD} ${STATUS} ${tb_bt_firmware_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr} == ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${printf_tb_bt_firmware_service_not_present}" "${EMPTYLINES_1}"

        return  #exit function
    fi

    #In case service 'tb_bt_firmware.service' is present
    #Disable service
    bt_Firmware_service_disable__func

    #Stop service
    bt_firmware_service_stop__func

    #Remove file
    bt_firmware_remove_all_files__func
}
function bt_Firmware_service_disable__func()
{
    #Check whether service is-active
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${tb_bt_firmware_service_filename}`

    if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-disabled
        debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
        
        ${SYSTEMCTL_CMD} ${DISABLE} ${tb_bt_firmware_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-inactive
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
    fi
}
function bt_firmware_service_stop__func()
{
    #Check whether service is-active
    local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${tb_bt_firmware_service_filename}`
    if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
        debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
        
        ${SYSTEMCTL_CMD} ${STOP} ${tb_bt_firmware_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-inactive
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_0}"
    fi
}
function bt_firmware_remove_all_files__func()
{
    debugPrint__func "${PRINTF_START}" "${PRINTF_REMOVING_FILES}" "${EMPTYLINES_1}"

    #Remove script
    if [[ -f ${tb_bt_firmware_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${tb_bt_firmware_filename}${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${tb_bt_firmware_fpath}
    fi
    if [[ -f ${tb_bt_firmware_service_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${tb_bt_firmware_service_fpath}
    fi
    if [[ -f ${tb_bt_firmware_service_symlink_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${tb_bt_firmware_service_symlink_filename}(symlink)${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${tb_bt_firmware_service_symlink_fpath}
    fi

    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_REMOVING_FILES}" "${EMPTYLINES_0}"
}

preCheck_handler__sub()
{
    #Define local constants
    local PRINTF_PRECHECK="PRE-CHECK:"
    local PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES="STATUS OF MODULES/SOFTWARE/SERVICES"

    #Print
    debugPrint__func "${PRINTF_PRECHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Check if any BT-interface is present
    local bt_isUp=`intf_checkIf_isUp__func`

    #Pre-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func
    services_preCheck__func "${bt_isUp}"
    intf_preCheck_isPresent__func
}
function intf_checkIf_isUp__func() {
    #Define local variables
    local btList_string=${EMPTYSTRING}
    local printf_toBeShown=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}

    #Check if 'hciconfig' is installed
    stdOutput=`ls -l ${usr_bin_dir} | grep "${HCICONFIG_CMD}"`
    if [[ -z ${stdOutput} ]]; then  #contains NO data (which means that bluez is NOT installed)
        echo ${FALSE}
    else
        #Get the PRIMARY BT-interface
        btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_TYPE_PRIMARY}" | awk '{print $1}' | cut -d":" -f1 | xargs`
        if [[ ! -z ${btList_string} ]]; then    #contains data
            #Convert string to array
            eval "btList_array=(${btList_string})"

            #Cycle through array containing the BT_interface(s)
            #REMARK: should be only 1 interface
            for btList_arrayItem in "${btList_array[@]}"
            do
                #Check if BT-interface is UP?
                stdOutput=`${HCICONFIG_CMD} ${btList_arrayItem} | grep "${STATUS_UP}"`  
                if [[ ! -z ${stdOutput} ]]; then   #contains data (interface is UP)
                    echo ${TRUE}

                    #Do not exit function nor break loop
                    #Continue on and check other interfaces as well (if any)
                else    #contains no data (interface is DOWN)
                    echo ${FALSE}

                    return  #exit function right away
                fi    
            done   
        else    #contains NO data
            #REMARK:
            #   Could be 'FALSE', when executing 'hciconfig', and...
            #   ...no result is found when grepping for pattern 'PATTERN_TYPE_PRIMARY'
            echo ${FALSE}
        fi
    fi
}
function mods_preCheck_arePresent__func()
{
    #Check if all Mods are present
    mod_checkIf_isPresent__func "${MODPROBE_BLUETOOTH}"
    mod_checkIf_isPresent__func "${MODPROBE_HCI_UART}"
    mod_checkIf_isPresent__func "${MODPROBE_RFCOMM}"
    mod_checkIf_isPresent__func "${MODPROBE_BNEP}"
    mod_checkIf_isPresent__func "${MODPROBE_HIDP}"
}
function mod_checkIf_isPresent__func() 
{
    #Input args
    local mod_name=${1}

    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}

    #Check if BT-modules is present
    mod_isPresent=`lsmod | grep ${mod_name}`
    if [[ ! -z ${mod_isPresent} ]]; then   #contains data
        printf_toBeShown="${FG_LIGHTGREY}${mod_name}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}"
    else    #contains NO data
        printf_toBeShown="${FG_LIGHTGREY}${mod_name}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function software_preCheck_isInstalled__func() 
{
    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}
    
    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${TRUE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"

        check_missing_isFound=${TRUE}
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function services_preCheck__func()
{
    #Input args
    local bt_isUp=${1}

    services_preCheck_isPresent_isEnabled_isActive__func "${tb_bt_firmware_service_filename}" "${bt_isUp}"
    services_preCheck_isPresent_isEnabled_isActive__func "${bluetooth_service_filename}" "${bt_isUp}"
    services_preCheck_isPresent_isEnabled_isActive__func "${rfcomm_onBoot_bind_service_filename}" "${bt_isUp}"
}
function services_preCheck_isPresent_isEnabled_isActive__func()
{
    #Input args
    local service_input=${1}  
    local bt_isUp=${2}

    #Define local constants
    local FOUR_DOTS="...."
    local EIGHT_DOTS=${FOUR_DOTS}${FOUR_DOTS}
    local TWELVE_DOTS=${FOUR_DOTS}${EIGHT_DOTS}


    #Check if the services are present
    #REMARK: if a service is present then it means that...
    #........its corresponding variable would CONTAIN DATA.
    local printf_toBeShown=${EMPTYSTRING}
    local service_isPresent=${FALSE}
    local service_isEnabled_val=${FALSE}
    local service_doublecheck_isEnabled=${FALSE}
    local service_isActive_val=${FALSE}
    local service_doublecheck_isActive=${FALSE}
    local statusVal=${EMPTYSTRING}

    #Print
    printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}:"
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #systemctl status <service>
    #All services should be always present after the Bluetooth Installation
    service_isPresent=`checkIf_service_isPresent__func "${service_input}"`
    if [[ ${service_isPresent} == ${TRUE} ]]; then  #service is present
        printf_toBeShown="${FG_LIGHTGREY}${FOUR_DOTS}${NOCOLOR}${FG_GREEN}${CHECK_PRESENT}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    else    #service is NOT present
        check_missing_isFound=${TRUE}   #set boolean to TRUE
        
        clear_lines__func "${NUMOF_ROWS_1}"

        printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        return  #exit function
    fi
    

    #systemctl is-enabled <service>
    service_isEnabled_val=`checkIf_service_isEnabled__func "${service_input}"`  #check if 'is-enabled'
    if [[ ${service_isEnabled_val} == ${TRUE} ]]; then  #service is enabled
        if [[ ${bt_isUp} == ${TRUE} ]]; then
            check_failedToDisable_isFound=${FALSE}
        else
            check_failedToEnable_isFound=${TRUE}
        fi

            statusVal=${FG_GREEN}${CHECK_ENABLED}${NOCOLOR}
    else    #service is NOT enabled
        if [[ ${bt_isUp} == ${TRUE} ]]; then
            check_failedToDisable_isFound=${TRUE}
        else
            check_failedToDisable_isFound=${FALSE}
        fi

        statusVal=${FG_LIGHTRED}${CHECK_DISABLED}${NOCOLOR}
    fi
    printf_toBeShown="${FG_LIGHTGREY}${EIGHT_DOTS}${NOCOLOR}${statusVal}"
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"


    #systemctl is-active <service>
    #If service=rfcomm_onBoot_bind.service, do NOT check if service is-active
    if [[ ${service_input} != ${rfcomm_onBoot_bind_service_filename} ]]; then
        service_isActive_val=`checkIf_service_isActive__func "${service_input}"`  #check if 'is-active'
        if [[ ${service_isActive_val} == ${TRUE} ]]; then   #service is started
            if [[ ${bt_isUp} == ${TRUE} ]]; then
                check_failedToDisable_isFound=${FALSE}
            else
                check_failedToStart_isFound=${TRUE}  #set boolean to TRUE
            fi

            statusVal=${FG_GREEN}${CHECK_RUNNING}${NOCOLOR}
        else    #service is NOT started
            if [[ ${bt_isUp} == ${TRUE} ]]; then
                check_failedToStop_isFound=${TRUE}  #set boolean to TRUE
            else
                check_failedToDisable_isFound=${FALSE}
            fi

            statusVal=${FG_LIGHTRED}${CHECK_STOPPED}${NOCOLOR}
        fi
        printf_toBeShown="${FG_LIGHTGREY}${TWELVE_DOTS}${NOCOLOR}${statusVal}"  
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi
}
function checkIf_service_isPresent__func() {
    #Input args
    local service_input=${1}

    #Check if service is enabled
    local stdOutput1=`${SYSTEMCTL_CMD} ${STATUS} ${tb_bt_firmware_service_filename} 2>&1 | grep "${PATTERN_COULD_NOT_BE_FOUND}"`
    if [[ -z ${stdOutput1} ]]; then #contains NO data (service is present)
        echo ${TRUE}
    else    #service is NOT enabled
        echo ${FALSE}
    fi
}
function checkIf_service_isEnabled__func() {
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
function checkIf_service_isActive__func() {
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
function intf_preCheck_isPresent__func() {
    #Define local constants
    local BT_INTERFACE="BT-interface"

    #Define local variables
    local btIntf=${EMPTYSTRING}
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}

    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${FALSE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${HCICONFIG_CMD}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}${FG_LIGHTGREY}...DEPENDS ON${NOCOLOR} ${FG_BLUETOOTHCTL_DARKBLUE}'BLUEZ'${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE       

        return
    fi

    #In case 'bluez' is installed (thus 'hciconfig' is also installed)
    #Get the PRIMARY BT-interface
    btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_TYPE_PRIMARY}" | awk '{print $1}' | cut -d":" -f1 | xargs`
    if [[ -z ${btList_string} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}${FG_LIGHTGREY}...DEPENDS ON${NOCOLOR} ${FG_BLUETOOTHCTL_DARKBLUE}'BLUEZ'${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE       

        return
    fi

    #Convert string to array
    eval "btList_array=(${btList_string})"

    #Show available BT-interface(s)
    for btList_arrayItem in "${btList_array[@]}"
    do
        if [[ -z ${btIntf} ]]; then
            btIntf=${btList_arrayItem}
        else
            btIntf="${btIntf}, ${btList_arrayItem}"
        fi
    done   


    #Print
    printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_GREEN}${btIntf}${NOCOLOR}"
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}

bluetooth_service_handler__sub()
{
    #Check if service 'bluetooth.service'
    stdErr=`${SYSTEMCTL_CMD} ${STATUS} ${bluetooth_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr} == ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_not_present}" "${EMPTYLINES_1}"

        return  #exit function
    fi

    #In case service 'bluetooth.service' is present
    #Disable service
    bluetooth_service_disable__func

    #Stop service
    bluetooth_service_stop__func
}
function bluetooth_service_disable__func()
{
    #Check whether service is-enabled
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${bluetooth_service_filename}`
    if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
        debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_1}"
        
        ${SYSTEMCTL_CMD} ${DISABLE} ${bluetooth_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
    fi
}
function bluetooth_service_stop__func()
{
    #Check whether service is-active
    local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${bluetooth_service_filename}`
    if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
        debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        
        ${SYSTEMCTL_CMD} ${STOP} ${tb_bt_firmware_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-inactive
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_0}"
    fi
}

rfcomm_service_handler__sub()
{
    #Check if service 'bluetooth.service'
    stdErr=`${SYSTEMCTL_CMD} ${STATUS} ${rfcomm_onBoot_bind_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr} == ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${printf_rfcomm_onBoot_bind_service_not_present}" "${EMPTYLINES_1}"

        return  #exit function
    fi

    #In case service 'bluetooth.service' is present
    #Disable service
    rfcomm_service_disable__func

    #Stop service
    rfcomm_service_stop__func

    #Remove file
    rfcomm_remove_all_files__func
}
function rfcomm_service_disable__func()
{
    #Check whether service is-enabled
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${rfcomm_onBoot_bind_service_filename}`
    if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
        debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_RFCOMM_SERVICE}" "${EMPTYLINES_1}"
        
        ${SYSTEMCTL_CMD} ${DISABLE} ${rfcomm_onBoot_bind_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
    fi
}
function rfcomm_service_stop__func()
{
    #Check whether service is-active
    local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${rfcomm_onBoot_bind_service_filename}`
    if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
        debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
        
        ${SYSTEMCTL_CMD} ${STOP} ${rfcomm_onBoot_bind_service_filename}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
    else    #service is-inactive
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_0}"
    fi
}
function rfcomm_remove_all_files__func()
{
    debugPrint__func "${PRINTF_START}" "${PRINTF_REMOVING_FILES}" "${EMPTYLINES_1}"

    #Remove script
    if [[ -f ${rfcomm_onBoot_bind_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${rfcomm_onBoot_bind_filename}${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${rfcomm_onBoot_bind_fpath}
    fi
    if [[ -f ${rfcomm_onBoot_bind_service_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_filename}${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${rfcomm_onBoot_bind_service_fpath}
    fi
    if [[ -f ${rfcomm_onBoot_bind_service_symlink_fpath} ]]; then
        debugPrint__func "${PRINTF_DELETING}" "${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_symlink_filename} (symlink)${NOCOLOR}" "${EMPTYLINES_0}"
        rm ${rfcomm_onBoot_bind_service_symlink_fpath}
    fi

    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_REMOVING_FILES}" "${EMPTYLINES_0}"
}

rfcomm_release_binds__sub()
{
    #This subroutine only needs to be executed when switching 'Off' BT.
    if [[ ${bt_req_setTo} == ${ON} ]]; then  #switch ON
        return  #exit function
    fi

    #Release all bindings
    ${RFCOMM_CMD} ${RELEASE} ${ALL}

    #Print
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_BINDINGS_RELEASED}" "${EMPTYLINES_1}"
}

disable_module__sub()
{
    #Enable BT-Module
    debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BLUETOOTH_MODULES}" "${EMPTYLINES_1}"
        
        bt_module_toggle_off__func "${MODPROBE_BLUETOOTH}" "${FALSE}"
        bt_module_toggle_off__func "${MODPROBE_HCI_UART}" "${FALSE}"
        bt_module_toggle_off__func "${MODPROBE_RFCOMM}" "${FALSE}"
        bt_module_toggle_off__func "${MODPROBE_BNEP}" "${FALSE}"
        bt_module_toggle_off__func "${MODPROBE_HIDP}" "${FALSE}"

    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BLUETOOTH_MODULES}" "${EMPTYLINES_0}"

    #Add BT-Modules to config file 'modules.conf'
    debugPrint__func "${PRINTF_START}" "${printf_removing_bt_modules_from_config_file}" "${EMPTYLINES_1}"

        bt_module_remove_from_configFile__func "${MODPROBE_BLUETOOTH}" "${TRUE}"
        bt_module_remove_from_configFile__func "${MODPROBE_HCI_UART}" "${FALSE}"
        bt_module_remove_from_configFile__func "${MODPROBE_RFCOMM}" "${FALSE}"
        bt_module_remove_from_configFile__func "${MODPROBE_BNEP}" "${FALSE}"
        bt_module_remove_from_configFile__func "${MODPROBE_HIDP}" "${FALSE}"
    
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_removing_bt_modules_from_config_file}" "${EMPTYLINES_0}"
}
function bt_module_toggle_off__func()
{
    #Input args
    local mod_name=${1}
    local toggleMod_isEnabled=${2}

    #Define Local variables
    local errMsg=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local btList_string=${EMPTYSTRING}
    local mod_isPresent=${EMPTYSTRING}

    #Print messages
    errmsg_failed_to_unload_mod="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    printf_mod_not_found="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' ${FG_LIGHTRED}NOT${NOCOLOR} FOUND"
   
    #Check if BT-modules is present
    mod_isPresent=`lsmod | grep ${mod_name}`

    #DISABLE BT Module
    if [[ -z ${mod_isPresent} ]]; then   #contains NO data
        debugPrint__func "${PRINTF_STATUS}" "${printf_mod_not_found}" "${EMPTYLINES_0}"

        return
    fi

    #Unload module
    modprobe -r ${mod_name}
}
function bt_module_remove_from_configFile__func()
{
    #Input args
    local mod_name=${1}
    local leading_emptyLine_isAdded=${2}

    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Remove line containing 'mod_name'
    stdOutput=`cat ${modules_conf_fpath} | grep ${mod_name}`
    if [[ ! -z ${stdOutput} ]]; then    #contains data
        debugPrint__func "${PRINTF_DELETING}" "${mod_name}" "${EMPTYLINES_0}"

        sed -i "/${mod_name}/d" ${modules_conf_fpath}
    else    #contains NO data
        printf_mod_is_already_removed="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY REMOVED"
        debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_removed}" "${EMPTYLINES_0}"
    fi
}

uninst_software__sub()
{
    debugPrint__func "${PRINTF_UINSTALLING}" "${PRINTF_BLUEZ}" "${EMPTYLINES_1}"
    software_uninst_list__func
}
software_uninst_list__func()
{
    DEBIAN_FRONTEND=noninteractive apt-get -y remove bluez
}

update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES_UPGRADES}" "${EMPTYLINES_1}"
    updates_upgrades_inst_list__func
}
updates_upgrades_inst_list__func()
{
    DEBIAN_FRONTEND=noninteractive apt-get -y update

    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

    DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
}

postCheck_handler__sub()
{
    #Define local constants
    local PRINTF_POSTCHECK="POST-CHECK:"
    local ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA="ONE OR MORE ITEMS WERE ${FG_LIGHTRED}N/A${NOCOLOR}..."
    local ERRMSG_FAILED_TO_ENABLE_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *ENABLE* SERVICE(S)"
    local ERRMSG_FAILED_TO_DISABLE_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *DISABLE* SERVICE(S)"
    local ERRMSG_FAILED_TO_START_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *START* SERVICE(S)"
    local ERRMSG_FAILED_TO_STOP_SERVICES="${FG_LIGHTRED}${CHECK_FAILED}${NOCOLOR} TO *STOP* SERVICE(S)"
    local ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE="A ${FG_LIGHTGREY}REBOOT${NOCOLOR} MAY SOLVE THIS ISSUE"
    local ERRMSG_IS_BT_INSTALLED_PROPERLY="IS BT *INSTALLED* PROPERLY?"
    local PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES="STATUS OF MODULES/SOFTWARE/SERVICES"

    #Reset variable
    check_missing_isFound=${FALSE}
    check_failedToEnable_isFound=${FALSE}
    check_failedToDisable_isFound=${FALSE}
    check_failedToStart_isFound=${FALSE}
    check_failedToStop_isFound=${FALSE}

    #Print
    debugPrint__func "${PRINTF_POSTCHECK}" "${PRINTF_STATUS_OF_MODULES_SOFTWARE_SERVICES}" "${EMPTYLINES_1}"

    #Post-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func
    services_preCheck__func "${FALSE}"   #after an installation 'bt_isUP should be FALSE'
    intf_preCheck_isPresent__func

    # #Print 'failed' message(s) depending on the detected failure(s)
    # check_missing_isFound=false
    # if [[ ${check_missing_isFound} == ${TRUE} ]]; then
    #     errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA}" "${FALSE}"      
    
    #     errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IS_BT_INSTALLED_PROPERLY}" "${TRUE}"  
    # else
    #     if [[ ${check_failedToEnable_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_ENABLE_SERVICES}" "${FALSE}"      
            
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${TRUE}"  
    #     fi

    #     if [[ ${check_failedToDisable_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_DISABLE_SERVICES}" "${FALSE}"      
            
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${TRUE}"  
    #     fi

    #     if [[ ${check_failedToStart_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_SERVICES}" "${FALSE}"      
            
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${TRUE}"  
    #     fi

    #     if [[ ${check_failedToStop_isFound} == ${TRUE} ]]; then
    #         errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_STOP_SERVICES}" "${FALSE}"      
            
    #         errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${TRUE}"  
    #     fi
    # fi
}

bt_reqTo_reboot__sub()
{
    #Print Important Message
    debugPrint__func "${PRINTF_MANDATORY}" "${PRINTF_A_REBOOT_IS_REQUIRED_TO_COMPLETE_THE_PROCESS}" "${EMPTYLINES_1}"

    #Print Question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_REBOOT_NOW}" "${EMPTYLINES_0}"

    #Loo
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
main__sub()
{
    load_env_variables__sub

    load_tibbo_banner__sub
    
    checkIfisRoot__sub
    
    init_variables__sub

    dynamic_variables_definition__sub

    input_args_case_select__sub

    preCheck_handler__sub

    bt_firmware_service_handler__sub

    bluetooth_service_handler__sub

    rfcomm_service_handler__sub

    rfcomm_release_binds__sub

    #REMARK:
    #   Unlike the WLAN, NOT UNLOADING the Modules...
    #   ...does NOT mean that a reboot is not required.
    #   A reboot would still be required, due to the fact...
    #   ...that the INABILITY to LOAD the FIRMWARE (after an UNLOAD)...
    #   ...is NOT caused the UNLOAD of the modules, but...
    #   ...by UNLOADING the FIRMWARE itself
    #   Therefore running the subroutine 'bt_reqTo_reboot__sub'...
    #   ...is still REQUIRED.
    # disable_module__sub

    uninst_software__sub

    update_and_upgrade__sub

    postCheck_handler__sub

    bt_reqTo_reboot__sub
}



#---EXECUTE
main__sub