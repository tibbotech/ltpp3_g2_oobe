#!/bin/bash
#---INPUT ARGS
arg1=${1}



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#



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
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_GREEN=$'\e[30;38;5;76m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
FG_BLUETOOTHCTL_DARKBLUE=$'\e[30;38;5;27m'

TIBBO_FG_WHITE=$'\e[30;38;5;15m'
TIBBO_BG_ORANGE=$'\e[30;48;5;209m'




#---CONSTANTS
TITLE="TIBBO"

BT_TTYSX_LINE="\/dev\/ttyS4"
BT_BAUDRATE=3000000
BT_SLEEPTIME=200000

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

INPUT_ABORT="a"

#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=1

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
HCITOOL_CMD="hcitool"
HCICONFIG_CMD="hciconfig"
RFCOMM_CMD="rfcomm"
RFCOMM_CHANNEL_1="1"
SYSTEMCTL_CMD="systemctl"

ENABLE="enable"
DISABLE="disable"

START="start"
STOP="stop"

IS_ENABLED="is-enabled"
IS_ACTIVE="is-active"
STATUS="status"

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

#---TIMEOUT CONSTANTS
DAEMON_SLEEPTIME=3    #second
DAEMON_RETRY=20

#---STATUS/BOOLEANS
ENABLED="enabled"
DISABLED="disabled"
ACTIVE="active"
INACTIVE="inactive"

TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

CHECK_OK="OK"
CHECK_DISABLED="DISABLED"
CHECK_ENABLED="ENABLED"
CHECK_FAILED="FAILED"
CHECK_PRESENT="PRESENT"
CHECK_NOTAVAILABLE="N/A"
CHECK_RUNNING="RUNNING"
CHECK_STOPPED="STOPPED"

#---PATTERN CONSTANTS
MODPROBE_BLUETOOTH="bluetooth"
MODPROBE_HCI_UART="hci_uart"
MODPROBE_RFCOMM="rfcomm"
MODPROBE_BNEP="bnep"
MODPROBE_HIDP="hidp"

PATTERN_BLUEZ="bluez"

PATTERN_BRCM_PATCHRAM_PLUS="brcm_patchram_plus"
PATTERN_COULD_NOT_BE_FOUND="could not be found"
PATTERN_GREP="grep"
PATTERN_DONE_SETTING_LINE_DISCIPLINE="Done setting line discpline"
PATTERN_TYPE_PRIMARY="Type: Primary"



#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Install Bluetooth."



#---PRINTF PHASES
PRINTF_COMPLETED="COMPLETED:"
PRINTF_COMPONENTS="COMPONENTS:"
PRINTF_FOUND="FOUND:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_WRITING="WRITING:"

#---ERROR MESSAGE CONSTANTS
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_NO_BT_INTERFACE_FOUND="NO BT-INTERFACE FOUND"
ERRMSG_INSTALLATION_NOT_COMPLETED_SUCCESSFULLY="INSTALLATION ${FG_LIGHTRED}NOT${NOCOLOR} COMPLETED SUCCESSFULLY..."
ERRMSG_REMOVING_BT_FIRMWARE_SERVICE_PLEASE_WAIT="${FG_LIGHTGREY}REMOVING${NOCOLOR} BT-FIRMWARE SERVICE, PLEASE WAIT..."
ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL="PLEASE *REBOOT* AND TRY TO *REINSTALL*"

ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---PRINTF MESSAGES
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

PRINTF_ENABLING_BLUETOOTH_MODULES="---:ENABLING BT-MODULES"
PRINTF_BT_CREATING_SCRIPT="CREATING SCRIPT:"
PRINTF_BT_CREATING_SERVICE="CREATING SERVICE:"
PRINTF_BLUEZ="BLUEZ"
PRINTF_BLUEZ_BLUETOOTHCTL="BLUETOOTHCTL"
PRINTF_BLUEZ_HCICONFIG="HCICONFIG"
PRINTF_BLUEZ_HCITOOL="HCITOOL"
PRINTF_BLUEZ_RFCOMM="RFCOMM"
PRINTF_BT_SUCCESSFULLY_KILLED_PID="${FG_GREEN}SUCCESSFULLY${NOCOLOR} KILLED:"
PRINTF_DAEMON_RELOADED="DAEMON RELOADED..."
PRINTF_LOADING_BT_FIRMWARE_SERVICE="---:LOADING BT-FIRMWARE SERVICE"
PRINTF_RETRIEVING_BT_INTERFACE="---:RETRIEVING BT-INTERFACE"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_unable_to_load_bt_firmware="UNABLE TO LOAD BT-FIRMWARE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}'"

    printf_bt_firmware_service_is_already_started="BT-FIRMWARE SERVICE IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
    printf_bt_firmware_service_started_successfully="BT-FIRMWARE SERVICE STARTED ${FG_GREEN}SUCCESSFULLY${NOCOLOR}"
    printf_bt_firmware_service_enabled="BT-FIRMWARE SERVICE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}' ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bt_firmware_service_is_already_enabled="BT-FIRMWARE SERVICE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}' IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bluetooth_service_enabled="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bluetooth_service_is_already_enabled="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bluetooth_service_started="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' ${FG_GREEN}STARTED${NOCOLOR}"
    printf_bluetooth_service_is_already_started="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
    printf_writing_bt_modules_to_config_file="---:WRITING BT-MODULES TO '${FG_LIGHTGREY}${modules_conf_fpath}${NOCOLOR}'"
    printf_creating_tb_bt_firmware_script="---:CREATING SCRIPT '${FG_LIGHTGREY}${tb_bt_firmware_filename}${NOCOLOR}'"
    printf_creating_tb_bt_firmware_service="---:CREATING SERVICE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}'"
    printf_creating_rfcomm_onBoot_bind_script="---:CREATING SCRIPT '${FG_LIGHTGREY}${rfcomm_onBoot_bind_filename}${NOCOLOR}'"
    printf_creating_rfcomm_onBoot_bind_service="---:CREATING SERVICE '${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_filename}${NOCOLOR}'"
}



#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    usr_bin_dir=/usr/bin
    brcm_patchram_plus_filename=${PATTERN_BRCM_PATCHRAM_PLUS}
    brcm_patchram_plus_fpath=${usr_bin_dir}/${brcm_patchram_plus_filename}

    etc_firmware_dir=/etc/firmware
    hcd_filename="BCM4345C5_003.006.006.0058.0135.hcd"
    hcd_fpath=${etc_firmware_dir}/${hcd_filename}

    bluetooth_service_filename="bluetooth.service"

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

input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION}" "${FALSE}"
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
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
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

    #Define local constants
    local PRINTF_STATUS_MOD="STATUS(MOD):"

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
    debugPrint__func "${PRINTF_STATUS_MOD}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function software_preCheck_isInstalled__func() 
{
    #Define local constants
    local PRINTF_STATUS_SOF="STATUS(SOF):"

    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}
    
    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${TRUE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_GREEN}${CHECK_OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE
    fi
    debugPrint__func "${PRINTF_STATUS_SOF}" "${printf_toBeShown}" "${EMPTYLINES_0}"
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
    debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"


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
        printf_toBeShown="${FG_LIGHTGREY}${EIGHT_DOTS}${NOCOLOR}${statusVal}"  
        debugPrint__func "${PRINTF_STATUS_SRV}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi
}
function checkIf_service_isPresent__func() {
    #Input args
    local service_input=${1}

    #Check if service is enabled
    local stdOutput1=`${SYSTEMCTL_CMD} ${STATUS} ${service_input} 2>&1 | grep "${PATTERN_COULD_NOT_BE_FOUND}"`
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
    local PRINTF_STATUS_PER="STATUS(PER):"
    local BT_INTERFACE="BT-interface"

    #Define local variables
    local btIntf=${EMPTYSTRING}
    local printf_toBeShown=${EMPTYSTRING}
    local software_isPresent=${FALSE}

    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${FALSE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        check_missing_isFound=${TRUE}   #set boolean to TRUE       

        return
    fi

    #In case 'bluez' is installed (thus 'hciconfig' is also installed)
    #Get the PRIMARY BT-interface
    btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_TYPE_PRIMARY}" | awk '{print $1}' | cut -d":" -f1 | xargs`
    if [[ -z ${btList_string} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_LIGHTRED}${CHECK_NOTAVAILABLE}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"

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
    debugPrint__func "${PRINTF_STATUS_PER}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}

update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES_UPGRADES}" "${EMPTYLINES_1}"
    
    DEBIAN_FRONTEND=noninteractive apt-get -y update   #install updates (non-interactive)

    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade   #install upgrades (non-interactive)
}

software_inst__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_BLUEZ}" "${EMPTYLINES_1}"
    debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_BLUETOOTHCTL}${NOCOLOR}" "${EMPTYLINES_0}"
    debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_HCICONFIG}${NOCOLOR}" "${EMPTYLINES_0}"
    debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_HCITOOL}${NOCOLOR}" "${EMPTYLINES_0}"
    
    DEBIAN_FRONTEND=noninteractive apt-get -y install bluez
}

bt_module_handler__sub()
{
    #Enable BT-Module
    debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_BLUETOOTH_MODULES}" "${EMPTYLINES_1}"
        
        bt_module_toggle_onOff__func "${MODPROBE_BLUETOOTH}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_HCI_UART}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_RFCOMM}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_BNEP}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_HIDP}" "${TRUE}"

    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_BLUETOOTH_MODULES}" "${EMPTYLINES_0}"

    #Add BT-Modules to Config file 'modules.conf'
    debugPrint__func "${PRINTF_START}" "${printf_writing_bt_modules_to_config_file}" "${EMPTYLINES_1}"

        bt_module_add_to_configFile__func "${MODPROBE_BLUETOOTH}" "${TRUE}"
        bt_module_add_to_configFile__func "${MODPROBE_HCI_UART}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_RFCOMM}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_BNEP}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_HIDP}" "${FALSE}"
    
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_writing_bt_modules_to_config_file}" "${EMPTYLINES_0}"
}
bt_module_toggle_onOff__func()
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
    printf_mod_is_already_up="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
    printf_mod_is_already_down="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"

    errmsg_failed_to_load_mod="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    printf_failed_to_unload_mod="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

    printf_successfully_loaded_mod="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    printf_successfully_unloaded_mod="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

    #Check if BT-modules is present
    mod_isPresent=`lsmod | grep ${mod_name}`

    #Toggle BT Module (enable/disable)
    if [[ ${toggleMod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${mod_isPresent} ]]; then   #contains data
            debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_up}" "${EMPTYLINES_0}"

            return
        fi

        modprobe ${mod_name}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_failed_to_load_mod}" "${TRUE}"
        else
            debugPrint__func "${PRINTF_STATUS}" "${printf_successfully_loaded_mod}" "${EMPTYLINES_0}"
        fi
    else
        if [[ -z ${mod_isPresent} ]]; then   #contains NO data
            debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_down}" "${EMPTYLINES_0}"

            return
        fi

        modprobe -r ${mod_name}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${FALSE}" "${EXITCODE_99}" "${printf_failed_to_unload_mod}" "${TRUE}"
        else
            debugPrint__func "${PRINTF_STATUS}" "${printf_successfully_unloaded_mod}" "${EMPTYLINES_0}"
        fi
    fi
}
bt_module_add_to_configFile__func()
{
    #Input args
    local mod_name=${1}
    local leading_emptyLine_isAdded=${2}

    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Write to file
    stdOutput=`cat ${modules_conf_fpath} | grep ${mod_name}`
    if [[ -z ${stdOutput} ]]; then
        if [[ ${leading_emptyLine_isAdded} == ${TRUE} ]]; then
            printf '%b%s\n' "" >> ${modules_conf_fpath}
        fi

        debugPrint__func "${PRINTF_WRITING}" "${mod_name}" "${EMPTYLINES_0}"

        printf '%b%s\n' "${mod_name}" >> ${modules_conf_fpath}
    else
        printf_mod_is_already_added="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_GREEN}ADDED${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_added}" "${EMPTYLINES_0}"
    fi
}


bt_firmware_handler__sub()
{
    #Create BT Load-Unload Firmware script
    bt_firmware_create_script__func

    #Create Bluetooth Firmware Service 'bt_fw_loadUnload.service'
    bt_firmware_create_service_and_symlink__func

    #Reload Daemon (IMPORTANT)
    bt_daemon_reload__func

    #Wait for 5 seconds for the Daemon to Complete Reloading
    sleep ${DAEMON_SLEEPTIME}

    #Load BT-firmware
    bt_firmware_load__func
}
function bt_firmware_create_script__func()
{
    #-------------------------------------------------------------------------------------
    #This script will be used by service '/etc/systemd/system/tb_bt_firmware.service'
    #-------------------------------------------------------------------------------------

    #Defile local variables
    local sed_to_be_updated_value="to_be_updated_value"

    local sed_version_matchPattern="version"
    local sed_version_newPattern="${scriptVersion}"
    local sed_fw_matchPattern="FIRMWARE_FILENAME"
    local sed_fw_newPattern="${hcd_filename}"
    local sed_sleeptime_matchPattern="FIRMWARE_SLEEPTIME"
    local sed_sleeptime_newPattern="${BT_SLEEPTIME}"
    local sed_ttysxLine_matchPattern="FIRMWARE_TTYSX_LINE"
    local sed_ttysxLine_newPattern="${BT_TTYSX_LINE}"

    local sed_baudrate_matchPattern="BT_BAUDRATE"
    local sed_baudrate_newPattern="${BT_BAUDRATE}"
    local sed_enable_matchPattern="ENABLE"
    local sed_enable_newPattern="${ENABLE}"
    local sed_disable_matchPattern="DISABLE"
    local sed_disable_newPattern="${DISABLE}"
    local sed_true_matchPattern="TRUE"
    local sed_true_newPattern="${TRUE}"
    local sed_false_matchPattern="FALSE"
    local sed_false_newPattern="${FALSE}"
    local sed_bluetooth_matchPattern="MOD_BLUETOOTH"
    local sed_bluetooth_newPattern="${MODPROBE_BLUETOOTH}"
    local sed_hci_uart_matchPattern="MOD_HCI_UART"
    local sed_hci_uart_newPattern="${MODPROBE_HCI_UART}"
    local sed_rfcomm_matchPattern="MOD_RFCOMM"
    local sed_rfcomm_newPattern="${MODPROBE_RFCOMM}"
    local sed_bnep_matchPattern="MOD_BNEP"
    local sed_bnep_newPattern="${MODPROBE_BNEP}"
    local sed_hidp_matchPattern="MOD_HIDP"
    local sed_hidp_newPattern="${MODPROBE_HIDP}"



    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_tb_bt_firmware_script}" "${EMPTYLINES_1}"

    #Delete file (if present)
    if [[ -f ${tb_bt_firmware_fpath} ]]; then
        rm ${tb_bt_firmware_fpath}
    fi

    #Write the following contents to file 'tb_bt_firmware.service'
cat > ${tb_bt_firmware_fpath} << "EOL"
#!/bin/bash
#---version:to_be_updated_value
#---Input args
ACTION=${1}



#---COLORS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'



#---BOOLEAN CONSTANTS
ENABLE="to_be_updated_value"
DISABLE="to_be_updated_value"

TRUE="to_be_updated_value"
FALSE="to_be_updated_value"

MOD_BLUETOOTH="to_be_updated_value"
MOD_HCI_UART="to_be_updated_value"
MOD_RFCOMM="to_be_updated_value"
MOD_BNEP="to_be_updated_value"
MOD_HIDP="to_be_updated_value"

#---PATTERN CONSTANTS
PATTERN_GREP="grep"

#---Command Constants
BT_BAUDRATE=to_be_updated_value
BRCM_PATCHRAM_PLUS_FILENAME="brcm_patchram_plus"
BRCM_PATHRAM_PLUS_FPATH=/usr/bin/${BRCM_PATCHRAM_PLUS_FILENAME}
FIRMWARE_FILENAME="to_be_updated_value"
FIRMWARE_FPATH=/etc/firmware/${FIRMWARE_FILENAME}
FIRMWARE_SLEEPTIME=to_be_updated_value
FIRMWARE_TTYSX_LINE=to_be_updated_value

#---TIMEOUT CONSTANTS
RETRY_MAX=3
SLEEP_TIMEOUT=1
TIMEOUT_MAX=30

#---VARIABLES
btDevice_isFound=""

#---FUNCTIONS
usage_sub() 
{
    printf '%b\n' "Usage: $0 {enable|disable}"
	
    exit 1
}

module_check_and_load__func()
{
    #Input args
    local mod_name=${1}

    #Define local variables
    local mod_isPresent=${EMPTYSTRING}


    #Check if BT-modules is present
    mod_isPresent=`lsmod | grep ${mod_name}`
    if [[ ! -z ${mod_isPresent} ]]; then   #contains data (means that specified module is already enabled)
        return
    else    #contains NO data (means that specified module is NOT enabled  yet)
        modprobe ${mod_name}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            printf '%b\n' ":--*${FG_LIGHTRED}ERROR${NOCOLOR}: FAILED TO ENABLE MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}'"
            printf '%b\n' ":--*${FG_LIGHTRED}ERROR${NOCOLOR}: EXITING NOW..."

            exit ${exitCode}
        else
            printf '%b\n' ":-->${FG_ORANGE}STATUS${NOCOLOR}: *SUCCESSFULLY* ENABLED MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}'"
        fi
    fi
}

firmware_load__func()
{
    #Run command
    sudo sh -c "${BRCM_PATHRAM_PLUS_FPATH}  --enable_hci \
                                    --no2bytes \
                                        --tosleep ${FIRMWARE_SLEEPTIME} \
                                            --baudrate ${BT_BAUDRATE} \
                                                --patchram ${FIRMWARE_FPATH} \
                                                    ${FIRMWARE_TTYSX_LINE} &"
                    }

firmware_checkIf_isRunning__func()
{
    #Input args
    local isPrecheck=${1}

    if [[ ${isPrecheck} == ${TRUE} ]]; then
        #Check if Firmware is already loaded
        pid_isLoaded=`pgrep -f ${BRCM_PATCHRAM_PLUS_FILENAME}` 
        if [[ ! -z ${pid_isLoaded} ]]; then   #pid was found
            printf '%b\n' ":-->${FG_ORANGE}SERVICE-CHECK${NOCOLOR}: BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}' IS RUNNING ALREADY"

            exit 0
        else
            return
        fi    
    fi

    #Define local variables
    pid_isLoaded=""
    local retry_param=0

    #Start check
    while true
    do
        #Maximum retry has been reached
        if [[ ${retry_param} == ${TIMEOUT_MAX} ]]; then
            printf '%b\n' ":--*${FG_LIGHTRED}ERROR${NOCOLOR}: *UNABLE* TO LOAD BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}'"

            exit 99
        fi

        #Check if Firmware is already loaded
        pid_isLoaded=`pgrep -f ${BRCM_PATCHRAM_PLUS_FILENAME}` 
        if [[ ! -z ${pid_isLoaded} ]]; then   #pid was found
            printf '%b\n' ":-->${FG_ORANGE}SERVICE-CHECK${NOCOLOR}: BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}' IS RUNNING"

            break
        fi

        #wait for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment parameter by 1
        retry_param=$((retry_param+1))
    done
}
pid_kill_and_check__func()
{
    #Input args
    local pid_input=${1}
    local proc_input=${2}

    #Define local variables
    local retry_param=0
    local pid_isKilled=$EMPTYSTRING}

    #Kill specified PID and check if it really has been killed
    while true
    do
        #Check if the number of retries have exceeded the allowed maximum
        if [[ ${retry_param} -gt ${TIMEOUT_MAX} ]]; then  #maximum exceeded
            printf '%b\n' ":--*${FG_LIGHTRED}ERROR${NOCOLOR}: *UNABLE* TO KILL PID '${FG_LIGHTRED}${pid_input}${NOCOLOR}'"

            return
        fi

        #Kill PID
        kill -9 ${pid_input}

        #Check if PID has been killed
        #REMARK: if TRUE, then 'pid_isKilled' is an EMPTY STRING
        pid_isKilled=`pgrep -f ${proc_input} | grep ${pid_input}` 
        if [[ -z ${pid_isKilled} ]]; then   #pid was not found
            printf '%b\n' ":-->${FG_ORANGE}SERVICE-STOP${NOCOLOR}: KILLED PID '${FG_LIGHTRED}${pid_input}${NOCOLOR}'"

            break   #exit loop
        fi

        #Process could not be killed...yet
        #wait for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Incrememty retry-parameter
        retry_param=$((retry_param+1))
    done  
}

bt_intf_checkIf_isPresent__func()
{
    #Define local variables
    bt_Intf_isPresent=""
    local retry_param=0

    #Start check
    while true
    do
        #Maximum retry has been reached
        if [[ ${retry_param} -gt ${TIMEOUT_MAX} ]]; then
            printf '%b\n' ":--*${FG_LIGHTRED}ERROR${NOCOLOR}: *NO* BT-INTERFACE FOUND!"
            printf '%b\n' ":--*${FG_LIGHTRED}REASON${NOCOLOR}: *UNABLE* TO LOAD BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}'"

            do_disable_sub  #unload firmware

            exit 99
        fi

        #Check if any BT-interface is present
        bt_Intf_isPresent=`hciconfig` 
        if [[ ! -z ${bt_Intf_isPresent} ]]; then   #interface is present
            printf '%b\n' ":-->${FG_ORANGE}STATUS${NOCOLOR}: BT-INTERFACE FOUND...RDY"

            break  #exit sub
        fi

        #wait for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment parameter by 1
        retry_param=$((retry_param+1))
    done
}

do_enable_sub() {
    #Print an empty line
    printf '%b\n' ""
    
    #Check if BT-modules are Enabled
    module_check_and_load__func "${MOD_BLUETOOTH}"
    module_check_and_load__func "${MOD_HCI_UART}"
    module_check_and_load__func "${MOD_RFCOMM}"
    module_check_and_load__func "${MOD_BNEP}"
    module_check_and_load__func "${MOD_HIDP}"

    #Check if BT-firmware is ALREADY loaded
    firmware_checkIf_isRunning__func "${TRUE}"

    #Load Bluetooth Firmware
    printf '%b\n' ":-->${FG_ORANGE}SERVICE-START${NOCOLOR}: LOADING BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}'"
    printf '%b\n' ":-->${FG_ORANGE}SERVICE-START${NOCOLOR}: PLEASE WAIT..."
    firmware_load__func

    #Check if BT-firmware is loaded
    #   This check will take no longer than 10 seconds.
    #   Should there be NO BT-interface available after 10 seconds, then...
    #   ...it would mean that the Firmware was not loaded correctly.
    firmware_checkIf_isRunning__func "${FALSE}"

    #Check if any BT-interface is present
    #REMARK: 
    #   This check will take no longer than 10 seconds.
    #   Should there be NO BT-interface available after 10 seconds, then...
    #   ...it would mean that the Firmware was not loaded correctly.
    #   In this case, the Firmware will be unloaded.
    #   Reloading the Firmware afterwards would NOT help due to...
    #   ...some hardware resetting issue.
    bt_intf_checkIf_isPresent__func

    #Print an empty line
    printf '%b\n' ""
}

do_disable_sub() {
    printf '%b\n' ""
    printf '%b\n' ":-->${FG_ORANGE}SERVICE-STOP${NOCOLOR}: UNLOADING BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}'"

    #Get PID List
    local ps_pidList_string=`pgrep -f "${BRCM_PATCHRAM_PLUS_FILENAME}" 2>&1`

    #Convert string to array
    local ps_pidList_array=()
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL FIRMWARE
    for ps_pidList_item in "${ps_pidList_array[@]}"; do
        pid_kill_and_check__func "${ps_pidList_item}" "${BRCM_PATCHRAM_PLUS_FILENAME}"
    done

    printf '%b\n' ":-->${FG_ORANGE}SERVICE-STOP${NOCOLOR}: *COMPLETED* UNLOADING BT-FIRMWARE '${FG_LIGHTGREY}${BRCM_PATCHRAM_PLUS_FILENAME}${NOCOLOR}'"
    printf '%b\n' ""
}


#---CHECK INPUT ARGS
if [[ $# -ne 1 ]]; then	#input args is not equal to 2 
    usage_sub
else
	if [[ ${1} != ${ENABLE} ]] && [[ ${1} != ${DISABLE} ]]; then
		usage_sub
	fi
fi

#---SELECT CASE
case "${ACTION}" in
    ${ENABLE})
        do_enable_sub
        ;;
    ${DISABLE})
        do_disable_sub
        ;;
    *)
        usage_sub
        ;;
esac
EOL

    #There are 3 steps:
    #1. Update the values within file 'tb_bt_firmware_template.sh' which are marked with 'to_be_updated_value'
    #   
    #2. Save file as '/usr/local/bin/${tb_bt_firmware_fpath}'
    sed -i "/${sed_version_matchPattern}/s/${sed_to_be_updated_value}/${sed_version_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_fw_matchPattern}/s/${sed_to_be_updated_value}/${sed_fw_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_sleeptime_matchPattern}/s/${sed_to_be_updated_value}/${sed_sleeptime_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_ttysxLine_matchPattern}/s/${sed_to_be_updated_value}/${sed_ttysxLine_newPattern}/g" ${tb_bt_firmware_fpath}

    sed -i "/${sed_baudrate_matchPattern}/s/${sed_to_be_updated_value}/${sed_baudrate_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_enable_matchPattern}/s/${sed_to_be_updated_value}/${sed_enable_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_disable_matchPattern}/s/${sed_to_be_updated_value}/${sed_disable_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_true_matchPattern}/s/${sed_to_be_updated_value}/${sed_true_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_false_matchPattern}/s/${sed_to_be_updated_value}/${sed_false_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_bluetooth_matchPattern}/s/${sed_to_be_updated_value}/${sed_bluetooth_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_hci_uart_matchPattern}/s/${sed_to_be_updated_value}/${sed_hci_uart_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_rfcomm_matchPattern}/s/${sed_to_be_updated_value}/${sed_rfcomm_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_bnep_matchPattern}/s/${sed_to_be_updated_value}/${sed_bnep_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_hidp_matchPattern}/s/${sed_to_be_updated_value}/${sed_hidp_newPattern}/g" ${tb_bt_firmware_fpath}



    #3. Change file permission to '755'
    chmod 755 ${tb_bt_firmware_fpath}

    
    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_creating_tb_bt_firmware_script}" "${EMPTYLINES_0}"
}
function bt_firmware_create_service_and_symlink__func()
{
    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_tb_bt_firmware_service}" "${EMPTYLINES_1}"

    #Delete file (if present)
    if [[ -f ${tb_bt_firmware_service_fpath} ]]; then
        rm ${tb_bt_firmware_service_fpath}
    fi

    #There are 2 steps:
    #1.1 Write the following contents to file 'tb_bt_firmware.service'
cat > ${tb_bt_firmware_service_fpath} << EOL
#--------------------------------------------------------------------
#---version:${scriptVersion}
#--------------------------------------------------------------------
# Remarks:
# 1. In oder for the service to run after a reboot
#		make sure to create a 'symlink'
#		ln -s /etc/systemd/system/<myservice.service> /etc/systemd/system/multi-user.target.wants/<myservice.service>
# 2. Reload daemon: systemctl daemon-reload
# 3. Start Service: systemctl start <myservice.service>
# 4. Check status: systemctl status <myservice.service>
#--------------------------------------------------------------------
[Unit]
Description=Loads/Unloads the Bluetooth Firmware.
After=networkd-dispatcher.service



[Service]
Type=oneshot
#User MUST BE SET TO 'root'
User=root
RemainAfterExit=true
ExecStart=${tb_bt_firmware_fpath} enable
ExecStop=${tb_bt_firmware_fpath} disable
StandardInput=journal+console
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOL

    #1.2. Change file permission to '644'
    chmod 644 ${tb_bt_firmware_service_fpath}

    #2.1 Delete file (if present)
    if [[ -f ${tb_bt_firmware_service_symlink_fpath} ]]; then
        rm ${tb_bt_firmware_service_symlink_fpath}
    fi

    #2.2 Create a Symlink of 'tb_bt_firmware.service'
    ln -s ${tb_bt_firmware_service_fpath} ${tb_bt_firmware_service_symlink_fpath}

    #2.3 Change file permission to '777'
    chmod 777 ${tb_bt_firmware_service_symlink_fpath}

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_creating_tb_bt_firmware_service}" "${EMPTYLINES_0}"
}
function bt_daemon_reload__func()
{    
    ${SYSTEMCTL_CMD} daemon-reload

    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAEMON_RELOADED}" "${EMPTYLINES_1}"
}
function bt_firmware_load__func()
{
    #Define local constants
    local RETRY_MAX=10

    #Define local variables
    local pid_isLoaded=${EMPTYSTRING}
    local retry_param=0
    local service_isActive_val=${INACTIVE}
    local service_isEnabled_val=${DISABLED}

    #Check if BT-firmware is already loaded
    service_isActive_val=`${SYSTEMCTL_CMD} is-active ${tb_bt_firmware_service_filename}`

    if [[ ${service_isActive_val} == ${ACTIVE} ]]; then    #service is already active
        debugPrint__func "${PRINTF_STATUS}" "${printf_bt_firmware_service_is_already_started}" "${EMPTYLINES_0}"
    else    #service is NOT active
         #Print
        debugPrint__func "${PRINTF_START}" "${PRINTF_LOADING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
        
        #Start BT-firmware service
        ${SYSTEMCTL_CMD} ${START} ${tb_bt_firmware_service_filename}

        #Check if 'Firmware is loaded and running'
        while true
        do
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then
                    errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_load_bt_firmware}" "${FALSE}"
                    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_INSTALLATION_NOT_COMPLETED_SUCCESSFULLY}" "${FALSE}"

                    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_REMOVING_BT_FIRMWARE_SERVICE_PLEASE_WAIT}" "${FALSE}"
                    #Clean-up 'tb_bt_firmware.service'
                    bt_Firmware_service_cleanUp__sub

                    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_PLEASE_REBOOT_AND_TRY_TO_REINSTALL}" "${TRUE}"

                    return  #exit loop
            fi

            #REMARK: if TRUE, then 'pid_isKilled' is an EMPTY STRING
            pid_isLoaded=`pgrep -f ${PATTERN_BRCM_PATCHRAM_PLUS}` 
            if [[ ! -z ${pid_isLoaded} ]]; then   #pid was found
                debugPrint__func "${PRINTF_STATUS}" "${printf_bt_firmware_service_started_successfully}" "${EMPTYLINES_0}"

                break   #exit loop
            fi

            #Wait for 1 second
            sleep 1

            #Increment retry-parameter'
            retry_param=$((retry_param+1))

            # #Restart
            # ${SYSTEMCTL_CMD} restart ${tb_bt_firmware_service_filename}
        done


        #Check if Service is Enabled
        service_isEnabled_val=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${tb_bt_firmware_service_filename}`
        if [[ ${service_isEnabled_val} == ${DISABLED} ]]; then   #is disabled
            #Enable bluetooth.service
            ${SYSTEMCTL_CMD} ${ENABLE} ${tb_bt_firmware_service_filename}
        
            #Wait for 1 second
            sleep 1
            
            #Print
            debugPrint__func "${PRINTF_STATUS}" "${printf_bt_firmware_service_enabled}" "${EMPTYLINES_1}"
        else    #is enabled
            #Print
            debugPrint__func "${PRINTF_STATUS}" "${printf_bt_firmware_service_is_already_enabled}" "${EMPTYLINES_1}"
        fi


        #Print
        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_LOADING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
    fi
}

bt_Firmware_service_cleanUp__sub()
{
    #Check if service 'tb_bt_firmware.service'
    local stdErr=`${SYSTEMCTL_CMD} ${STATUS} ${tb_bt_firmware_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr} == ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
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
    local service_isEnabled_val=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${tb_bt_firmware_service_filename}`
    if [[ ${service_isEnabled_val} == ${ENABLED} ]]; then #service is-disabled
        ${SYSTEMCTL_CMD} ${DISABLE} ${tb_bt_firmware_service_filename}
    fi
}
function bt_firmware_service_stop__func()
{
    #Check whether service is-active
    local service_isActive_val=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${tb_bt_firmware_service_filename}`
    if [[ ${service_isActive_val} == ${ACTIVE} ]]; then #service is-active
        ${SYSTEMCTL_CMD} ${STOP} ${tb_bt_firmware_service_filename} 
    fi
}
function bt_firmware_remove_all_files__func()
{
    #Remove script
    if [[ -f ${tb_bt_firmware_fpath} ]]; then
        rm ${tb_bt_firmware_fpath}
    fi
    if [[ -f ${tb_bt_firmware_service_fpath} ]]; then
        rm ${tb_bt_firmware_service_fpath}
    fi
    if [[ -f ${tb_bt_firmware_service_symlink_fpath} ]]; then
        rm ${tb_bt_firmware_service_symlink_fpath}
    fi
}

bluetooth_service_handler__sub() 
{
    #Define local variables
    local isEnabled=${FALSE}
    local isActive=${FALSE}

    #Check if Service is Enabled
    isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${bluetooth_service_filename}`
    if [[ ${isEnabled} != ${ENABLED} ]]; then   #is NOT enabled yet
        #Enable bluetooth.service
        ${SYSTEMCTL_CMD} ${ENABLE} ${bluetooth_service_filename}
    
        #Wait for 1 second
        sleep 1
        
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_enabled}" "${EMPTYLINES_1}"
    else    #is already enabled
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_is_already_enabled}" "${EMPTYLINES_1}"
    fi

    #Check if Service is Enabled
    isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${bluetooth_service_filename}`
    if [[ ${isActive} != ${ACTIVE} ]]; then   #is NOT active yet
        #Start bluetooth.service
        #REMARK: 
        #   By STARTing the 'bluetooth.service',...
        #...the BT-interface (e.g. hci0) will be brought UP automatically.
        ${SYSTEMCTL_CMD} ${START} ${bluetooth_service_filename}
    
        #Wait for 1 second
        sleep 1
        
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_started}" "${EMPTYLINES_0}"
    else    #is already active
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_is_already_started}" "${EMPTYLINES_0}"
    fi
}

bt_intf_handler__sub()
{
    #Check if Bluetooth interface is present
    bt_intf_explorer__func
}
function bt_intf_explorer__func()
{
    #Define local variables
    local btList_string=${EMPTYSTRING}
    local btList_array=()
    local btList_arrayLen=0
    local btList_arrayItem=${EMPTYSTRING}

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${EMPTYLINES_1}"

    #Get the PRIMARY BT-interface
    btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_TYPE_PRIMARY}" | awk '{print $1}' | cut -d":" -f1 | xargs`
    if [[ ! -z ${btList_string} ]]; then    #contains data
        #Convert string to array
        eval "btList_array=(${btList_string})"

        #Show available BT-interface(s)
        for btList_arrayItem in "${btList_array[@]}"; do
            debugPrint__func "${PRINTF_FOUND}" "${btList_arrayItem}" "${EMPTYLINES_0}"
        done   
    else    #contains NO data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_BT_INTERFACE_FOUND}" "${TRUE}"
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${EMPTYLINES_0}"
}

rfcomm_onBoot_service_handler__sub()
{
    #Create script
    rfcomm_onBoot_create_script__func

    #Create Service and Symlink
    rfcomm_onBoot_create_service_and_symlink__func
}
function rfcomm_onBoot_create_script__func()
{
    #-------------------------------------------------------------------------------------
    #This script will be used by service '/etc/systemd/system/tb_bt_firmware.service'
    #-------------------------------------------------------------------------------------

    #Defile local variables
    local sed_to_be_updated_value="to_be_updated_value"
    local sed_version_matchPattern="version"
    local sed_version_newPattern="${scriptVersion}"



    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_rfcomm_onBoot_bind_script}" "${EMPTYLINES_1}"

    #Delete file (if present)
    if [[ -f ${rfcomm_onBoot_bind_fpath} ]]; then
        rm ${rfcomm_onBoot_bind_fpath}
    fi

    #Write the following contents to file 'tb_bt_firmware.service'
cat > ${rfcomm_onBoot_bind_fpath} << "EOL"
#!/bin/bash
#---version:to_be_updated_value



#---COLORS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'

#---CONSTANTS
EMPTYSTRING=""

DASH_CHAR="-"

#---COMMAND RELATED CONSTANTS
RFCOMM_CHANNEL_1="1"
RFCOMM_CMD="rfcomm"



#---VARIABLES
exitCode=0



#---ENVIRONMENT VARIABLES
dev_dir=/dev
var_backups_dir=/var/backups
bluetoothctl_bind_stat_bck_filename="bluetoothctl_bind_stat.bck"
bluetoothctl_bind_stat_bck_fpath=${var_backups_dir}/${bluetoothctl_bind_stat_bck_filename}




#---FUNCTIONS
function rfcomm_get_uniq_rfcommDevNum__func()
{
    #Define local variables
    local rfcommNum=1
    local rfcommDevNum="${EMPTYSTRING}"
    local stdOutput=${EMPTYSTRING}

    #Find an available rfcomm-dev-number
    while true
    do
        #Update 'rfcommDevNum'
        rfcommDevNum="${RFCOMM_CMD}${rfcommNum}"

        #Check if 'rfcommDevNum' is IN-USE
        stdOutput=`${RFCOMM_CMD} | grep -w "${rfcommDevNum}" 2>&1`
        if [[ -z ${stdOutput} ]]; then
            break
        fi

        #Increment 'rfcommNum'
        rfcommNum=$((rfcommNum+1))
    done

    #Output
    echo ${rfcommDevNum}
}

function rfcomm_bind_uniq_rfcommDevNum_to_chosen_macAddr__func()
{
    #Input args
    local macAddr_input=${1}
    local dev_refcommDevNum_input=${2}   

    #Define local variables
    local mac_isFound=${EMPTYSTRING}
    local retry_param=0
    local RETRY_MAX=10
    local rfcommDevNum=${EMPTYSTRING}

    #Define printf messages
    errmsg_unable_to_bind_macAddr_to_rfcommDevNum=":--*${FG_LIGHTRED}ERROR${NOCOLOR}: *UNABLE* TO BIND '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${dev_refcommDevNum_input}${NOCOLOR}'"
    errmsg_reason_device_might_not_be_online=":--*${FG_LIGHTRED}REASON${NOCOLOR}: '${macAddr_input}' MIGHT *NOT* BE ONLINE"
    printf_bound_macAddr_to_rfcommDevNum_successfully=":-->${FG_ORANGE}STATUS${NOCOLOR}: *SUCCESSFULLY* BOUND '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${dev_refcommDevNum_input}${NOCOLOR}'"

    #Bind MAC-address to an rfcomm-dev-number
    ${RFCOMM_CMD} bind ${dev_refcommDevNum_input} ${macAddr_input} 2>&1 > /dev/null &
    
    #Get exit-code
    exitCode=$?
    if [[ ${exitCode} -eq 0 ]]; then    #command was executed successfully
        #This while-loop acts as a waiting time allowing the command to finish its execution process
        while [[ -z ${mac_isFound} ]]
        do
            mac_isFound=`${RFCOMM_CMD} | grep -w ${macAddr_input}`  #binding is found when running 'rfcomm' command

            sleep 1 #if no PID found yet, sleep for 1 second

            retry_param=$((retry_param+1))  #increment retry paramter

            #a Maxiumum of 10 retries is allowed
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum retries has been exceeded
                break
            fi
        done

        if [[ ! -z ${mac_isFound} ]]; then    #contains data
            #Print
            printf '%b\n' "${printf_bound_macAddr_to_rfcommDevNum_successfully}"
        else    #contains NO data
            printf '%b\n' "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}"
            printf '%b\n' "${errmsg_reason_device_might_not_be_online}"
        fi
    else    #exit-code!=0
        printf '%b\n' "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}"
        printf '%b\n' "${errmsg_reason_device_might_not_be_online}"
    fi
}



#---SUBROUTINES
rebind_to_btDevices__sub()
{
    #Define local variables
    local macAddr=${EMPTYSTRING}
    local macAddr_isPaired=${EMPTYSTRING}
    local macAddr_isAlreadyBound=${EMPTYSTRING}
    local rfcommDevNum=${EMPTYSTRING}
    local rfcommDevNum_isPresent=${EMPTYSTRING}
    local dev_refcommDevNum=${EMPTYSTRING}
    local dev_refcommDevNum_isPresent=${EMPTYSTRING}


    #Check if file 'bluetoothctl_bind_stat.tmp' exist
    #If FALSE, then exit script
    if [[ ! -f ${bluetoothctl_bind_stat_bck_fpath} ]]; then #file exists
        exit 0
    fi

    #In case file 'bluetoothctl_bind_stat.tmp' exist, then...
    #...read line by line
    while read -r line
    do
        #Get 'rfcomm-dev-number' from 'line' (if any)
        dev_refcommDevNum=`echo ${line} | awk '{print $5}'`

        #Check if 'dev_refcommDevNum' contains 'rfcomm'
        dev_refcommDevNum_isPresent=`echo ${dev_refcommDevNum} | grep "${RFCOMM_CMD}"`

        if [[ ! -z ${dev_refcommDevNum_isPresent} ]]; then    #contains data
            #Get MAC-address
            macAddr=`echo ${line} | awk '{print $2}'`

            #Check if MAC-address is still paired with the LTPP3-G2
            macAddr_isPaired=`bluetoothctl paired-devices | grep ${macAddr}`

            if [[ ! -z ${macAddr_isPaired} ]]; then #contains data
                macAddr_isAlreadyBound=`${RFCOMM_CMD} | grep "${macAddr}"`

                if [[ ! -z ${macAddr_isAlreadyBound} ]]; then   #contains data
                    printf_macAddr_is_already_bound_to_dev_refcommDevNum=":-->${FG_ORANGE}STATUS${NOCOLOR}: '${macAddr}' IS ALREADY BOUND TO '${dev_refcommDevNum}'"
                    printf '%b\n' "${printf_macAddr_is_already_bound_to_dev_refcommDevNum}"
                else    #contains NO data
                    #Get rfcomm-dev-number (without '/dev')
                    rfcommDevNum=`basename ${dev_refcommDevNum}`
                    
                    #Check if 'rfcommDevNum' is already in-use
                    rfcommDevNum_isPresent=`${RFCOMM_CMD} | grep "${rfcommDevNum}"`

                    #If TRUE, then get generate a Unique rfcomm-dev-number
                    if [[ ! -z ${rfcommDevNum_isPresent} ]]; then   #contains data
                        #Get a unique rfcomm-dev-number
                        rfcommDevNum=`rfcomm_get_uniq_rfcommDevNum__func`

                        #Combine prepend '/dev'
                        dev_refcommDevNum=${dev_dir}/${rfcommDevNum}
                    fi

                    #Bind MAC-address to rfcomm-dev-number
                    rfcomm_bind_uniq_rfcommDevNum_to_chosen_macAddr__func "${macAddr}" "${dev_refcommDevNum}"
                fi
            else    #contains NO data
                errmsg_unable_to_bind_rfcommDevNum_to_macAddr=":--*${FG_LIGHTRED}ERROR${NOCOLOR}: *UNABLE* TO BIND '${dev_refcommDevNum}' TO '${macAddr}'"
                errmsg_reason_no_pairing_with_device=":--*${FG_LIGHTRED}REASON${NOCOLOR}: NO PAIRING WITH DEVICE '${macAddr}'"

                printf '%b\n' "${errmsg_unable_to_bind_rfcommDevNum_to_macAddr}"
                printf '%b\n' "${errmsg_reason_no_pairing_with_device}"
            fi
        fi
    done < ${bluetoothctl_bind_stat_bck_fpath}
}

main__sub()
{
    rebind_to_btDevices__sub

    printf '%b\n' ""
}



#---EXECUTE
main__sub

EOL



    #There are 3 steps:
    #1. Update the values within file 'tb_bt_firmware_template.sh' which are marked with 'to_be_updated_value'  
    #2. Save file as '/usr/local/bin/${tb_bt_firmware_fpath}'
    sed -i "/${sed_version_matchPattern}/s/${sed_to_be_updated_value}/${sed_version_newPattern}/g" ${rfcomm_onBoot_bind_fpath}
  
    #3. Change file permission to '755'
    chmod 755 ${rfcomm_onBoot_bind_fpath}

    
    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_creating_rfcomm_onBoot_bind_script}" "${EMPTYLINES_0}"
}
function rfcomm_onBoot_create_service_and_symlink__func()
{
    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_rfcomm_onBoot_bind_service}" "${EMPTYLINES_1}"

    #Delete file (if present)
    if [[ -f ${rfcomm_onBoot_bind_service_fpath} ]]; then
        rm ${rfcomm_onBoot_bind_service_fpath}
    fi

    #There are 2 steps:
    #1.1 Write the following contents to file 'rfcomm_onBoot_bind.service'
cat > ${rfcomm_onBoot_bind_service_fpath} << EOL
#--------------------------------------------------------------------
#---version:${scriptVersion}
#--------------------------------------------------------------------
# Remarks:
# 1. In oder for the service to run after a reboot
#		make sure to create a 'symlink'
#		ln -s /etc/systemd/system/<myservice.service> /etc/systemd/system/multi-user.target.wants/<myservice.service>
# 2. Reload daemon: systemctl daemon-reload
# 3. Start Service: systemctl start <myservice.service>
# 4. Check status: systemctl status <myservice.service>
#--------------------------------------------------------------------
[Unit]
Description=Binds BT-devices to rfcomm.
After=tb_bt_firmware.service



[Service]
Type=oneshot
#User MUST BE SET TO 'root'
User=root
ExecStart=${rfcomm_onBoot_bind_fpath}
StandardInput=journal+console
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOL

    #1.2. Change file permission to '644'
    chmod 644 ${rfcomm_onBoot_bind_service_fpath}

    #2.1 Delete file (if present)
    if [[ -f ${rfcomm_onBoot_bind_service_symlink_fpath} ]]; then
        rm ${rfcomm_onBoot_bind_service_symlink_fpath}
    fi

    #2.2 Create a Symlink of 'tb_bt_firmware.service'
    ln -s ${rfcomm_onBoot_bind_service_fpath} ${rfcomm_onBoot_bind_service_symlink_fpath}

    #2.3 Change file permission to '777'
    chmod 777 ${rfcomm_onBoot_bind_service_symlink_fpath}

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_creating_rfcomm_onBoot_bind_service}" "${EMPTYLINES_0}"
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
    local ERRMSG_A_REBOOT_MAY_RESOLVE_THIS_ISSUE="A ${FG_LIGHTGREY}REBOOT${NOCOLOR} MAY RESOLVE THIS ISSUE"
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
    services_preCheck__func "${TRUE}"   #after an installation 'bt_isUP should be TRUE'
    intf_preCheck_isPresent__func

    #Print 'failed' message(s) depending on the detected failure(s)
    if [[ ${check_missing_isFound} == ${TRUE} ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_ITEMS_WERE_NA}" "${FALSE}"      
    
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IS_BT_INSTALLED_PROPERLY}" "${TRUE}"  
    else
        if [[ ${check_failedToEnable_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_ENABLE_SERVICES}" "${FALSE}"      
            
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_RESOLVE_THIS_ISSUE}" "${TRUE}"  
        fi

        if [[ ${check_failedToDisable_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_DISABLE_SERVICES}" "${FALSE}"      
            
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_RESOLVE_THIS_ISSUE}" "${TRUE}"  
        fi

        if [[ ${check_failedToStart_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_SERVICES}" "${FALSE}"      
            
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_RESOLVE_THIS_ISSUE}" "${TRUE}"  
        fi

        if [[ ${check_failedToStop_isFound} == ${TRUE} ]]; then
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_STOP_SERVICES}" "${FALSE}"      
            
            errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_RESOLVE_THIS_ISSUE}" "${TRUE}"  
        fi
    fi
}

#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_tibbo_banner__sub
    
    checkIfisRoot__sub
    
    init_variables__sub

    input_args_case_select__sub

    preCheck_handler__sub

    dynamic_variables_definition__sub

    update_and_upgrade__sub

    software_inst__sub

    bt_module_handler__sub

    bt_firmware_handler__sub

    bluetooth_service_handler__sub

    bt_intf_handler__sub

    rfcomm_onBoot_service_handler__sub

    postCheck_handler__sub
}


#---EXECUTE
main__sub