#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
bt_req_setTo=${1}      #optional (on/off)



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=1

if [[ ${argsTotal} == ${ARGSTOTAL_MAX} ]]; then
    interactive_isEnabled=${FALSE}
else
    interactive_isEnabled=${TRUE}
fi

#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---TRAP ON EXIT
trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=1

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

#---CONSTANTS
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

#---COMMAND RELATED CONSTANTS
HCICONFIG_CMD="hciconfig"
HCITOOL_CMD="hcitool"
RFCOMM_CMD="rfcomm"
REBOOTNOW_CMD="reboot now"
SYSTEMCTL_CMD="systemctl"

BT_TTYSX_LINE="\/dev\/ttyS4"
BT_BAUDRATE=3000000
BT_SLEEPTIME=200000

IS_ENABLED="is-enabled"
IS_ACTIVE="is-active"
STATUS="status"

ALL="all"
RELEASE="release"

ENABLE="enable"
DISABLE="disable"

START="start"
STOP="stop"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

#---READ INPUT CONSTANTS
INPUT_ABORT="a"
INPUT_NO="n"
INPUT_YES="y"

#---STATUS/BOOLEANS
ENABLED="enabled"
ACTIVE="active"

TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

ON="on"
OFF="off"

OK="OK"
MISSING="MISSING"

#---PATTERN CONSTANTS
PATTERN_COULD_NOT_BE_FOUND="could not be found"
PATTERN_BLUEZ="bluez"
PATTERN_RFCOMM="rfcomm"



#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle BT-module On/Off."

PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"



#---PRINTF PHASES
PRINTF_CONFIRM="CONFIRM:"
PRINTF_COMPLETED="COMPLETED:"
PRINTF_EXITING="EXITING:"
PRINTF_INFO="INFO:"
PRINTF_MANDATORY="${FG_PURPLERED}MANDATORY${NOCOLOR}${FG_ORANGE}:${NOCOLOR}"
PRINTF_PRECHECK="PRE-CHECK:"
PRINTF_QUESTION="QUESTION:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"

#---PRINTF ERROR MESSAGES
ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE="A ${FG_LIGHTGREY}REBOOT${NOCOLOR} MAY SOLVE THIS ISSUE"
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

ERRMSG_NO_BT_INTERFACE_FOUND="BT *INTERFACE* ${FG_LIGHTRED}NOT${NOCOLOR} FOUND"
ERRMSG_ONE_OR_MORE_SERVICES_ARE_MISSING="ONE OR MORE *SERVICES* ARE ${FG_LIGHTRED}MISSING${NOCOLOR}"
ERRMSG_IS_BT_INSTALLED_PROPERLY="IS BT *INSTALLED* PROPERLY?"

#---PRINTF MESSAGES
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_RFCOMM_BLUEZ_SERVICES="MODULE, SOFTWARE, AND SERVICES AVAILABILITY"

PRINTF_BT_IS_CURRENTLY_ENABLED="BT IS CURRENTLY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BT_IS_CURRENTLY_DISABLED="BT IS CURRENTLY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_ISALREADY_ENABLED="BT IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BT_ISALREADY_DISABLED="BT IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_ISALREADY_LOADED="BT *FIRMWARE* IS ALREADY ${FG_GREEN}LOADED${NOCOLOR}"
PRINTF_BT_FIRMWARE_ISALREADY_UNLOADED="BT *FIRMWARE* IS ALREADY ${FG_LIGHTRED}UNLOADED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_STARTED="BLUETOOTH *SERVICE* IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_STOPPED="BLUETOOTH *SERVICE* IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_ENABLED="BLUETOOTH *SERVICE* IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BLUETOOTH_SERVICE_ISALREADY_DISABLED="BLUETOOTH *SERVICE* IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STARTED="BT FIRMWARE *SERVICE* IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STOPPED="BT FIRMWARE *SERVICE* IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_ENABLED="BT FIRMWARE *SERVICE* IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_DISABLED="BT FIRMWARE *SERVICE* IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_RETRIEVING_BT_INTERFACE="---:RETRIEVING BT *INTERFACE*"
PRINTF_RFCOMM_BINDS_RELEASED_ALL="RFCOMM *BIND*: RELEASED ALL"
PRINTF_RFCOMM_SERVICE_ISALREADY_STARTED="RFCOMM *SERVICE* IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
PRINTF_RFCOMM_SERVICE_ISALREADY_STOPPED="RFCOMM *SERVICE* IS ALREADY ${FG_LIGHTRED}STOPPED${NOCOLOR}"
PRINTF_RFCOMM_SERVICE_ISALREADY_ENABLED="RFCOMM *SERVICE* IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_RFCOMM_SERVICE_ISALREADY_DISABLED="RFCOMM *SERVICE* IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_STARTING_BLUETOOTH_SERVICE="---:STARTING BLUETOOTH *SERVICE*"
PRINTF_STOPPING_BLUETOOTH_SERVICE="---:STOPPING BLUETOOTH *SERVICE*"
PRINTF_ENABLING_BLUETOOTH_SERVICE="---:ENABLING BLUETOOTH *SERVICE*"
PRINTF_DISABLING_BLUETOOTH_SERVICE="---:DISABLING BLUETOOTH *SERVICE*"
PRINTF_STARTING_BT_FIRMWARE_SERVICE="---:STARTING BT FIRMWARE *SERVICE*"
PRINTF_STOPPING_BT_FIRMWARE_SERVICE="---:STOPPING BT FIRMWARE *SERVICE*"
PRINTF_ENABLING_BT_FIRMWARE_SERVICE="---:ENABLING BT FIRMWARE *SERVICE*"
PRINTF_DISABLING_BT_FIRMWARE_SERVICE="---:DISABLING BT FIRMWARE *SERVICE*"
PRINTF_STARTING_RFCOMM_SERVICE="---:STARTING RFCOMM *SERVICE*"
PRINTF_STOPPING_RFCOMM_SERVICE="---:STOPPING RFCOMM *SERVICE*"
PRINTF_ENABLING_RFCOMM_SERVICE="---:ENABLING RFCOMM *SERVICE*"
PRINTF_DISABLING_RFCOMM_SERVICE="---:DISABLING RFCOMM *SERVICE*"
PRINTF_NO_ACTION_REQUIRED="NO ACTION REQUIRED..."

PRINTF_A_REBOOT_IS_REQUIRED_TO_COMPLETE_THE_PROCESS="A ${FG_YELLOW}REBOOT${NOCOLOR} IS REQUIRED TO COMPLETE THE PROCESS..."

#---QUESTION MESSGAES
QUESTION_DISABLE_BT="${FG_LIGHTRED}DISABLE${NOCOLOR} BT (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_ENABLE_BT="${FG_GREEN}ENABLE${NOCOLOR} BT (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_REBOOT_NOW="REBOOT NOW (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_ARE_YOU_VERY_SURE="ARE YOU VERY SURE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_unknown_option="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"
}



#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    bluetooth_service_filename="bluetooth.service"
    rfcomm_onBoot_bind_service_filename="rfcomm_onBoot_bind.service"
    tb_bt_firmware_service_filename="tb_bt_firmware.service"
}



#---FUNCTIONS
function press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=10

	#Initialize variables
	local keyPressed=""
	local tCounter=0
    local delta_tCounter=0

    #PRINTF Constants
    local PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE="Press (a)bort or any key to continue..."

	#Show Press Any Key message with count-down
	while [[ ${tCounter} -le ${ANYKEY_TIMEOUT} ]];
	do
		delta_tCounter=$(( ${ANYKEY_TIMEOUT} - ${tCounter} ))

		echo -e "\r${PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE} (${delta_tCounter}) \c"
		read -N 1 -t 1 -s -r keyPressed

		if [[ ! -z "${keyPressed}" ]]; then
			if [[ "${keyPressed}" == "${INPUT_ABORT}" ]]; then
				exit 0
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
    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NO_ACTION_REQUIRED}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"

        append_emptyLines__func "${EMPTYLINES_1}"
    fi

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
load_header__sub() {
    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
        echo -e "\r"
        echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
    fi
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
}

input_args_handler__sub()
{
    #Convert 'bt_req_setTo' to lowercase
    bt_req_setTo=`convertTo_lowercase__func "${bt_req_setTo}"`

    #Update 'arg1'
    arg1=${bt_req_setTo}
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
                if [[ -z ${arg1} ]]; then   #MAC-address is an EMPTY STRING
                    input_args_print_arg1_cannot_be_emptyString__sub
                else
                    if [[ ${arg1} != ${ON} ]] && [[ ${arg1} != ${OFF} ]]; then
                        input_args_print_unknown_option__sub
                    fi
                fi
            else   #not all input args provided
                input_args_print_unmatched__sub
            fi
            ;;
    esac
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}toggle {on|off}."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFTLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFTLIGHTRED}\"${NOCOLOR} each argument."
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
}
input_args_print_arg1_cannot_be_emptyString__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"  
}
input_args_print_unmatched__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNMATCHED_INPUT_ARGS}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}


validate_handler__sub()
{
    #Print
    debugPrint__func "${PRINTF_PRECHECK}" "${PRINTF_RFCOMM_BLUEZ_SERVICES}" "${EMPTYLINES_1}"

    checkIf_rfcomm_isLoaded__sub

    checkIf_software_isInstalled__sub

    checkIf_services_arePresent__sub
}

checkIf_rfcomm_isLoaded__sub()
{
    #Define local variables
    local stdOutput=${EMPTYSTRING}
    
    #Check if software is installed
    stdOutput=`lsmod | grep ${PATTERN_RFCOMM}`
    if [[ ! -z ${stdOutput} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_RFCOMM}${NOCOLOR}: ${FG_GREEN}${OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_RFCOMM}${NOCOLOR}: ${FG_LIGHTRED}${MISSING}${NOCOLOR}"
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}

checkIf_software_isInstalled__sub() 
{
    #Define local variables
    local software_isPresent=${FALSE}
    
    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${TRUE} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_GREEN}${OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_LIGHTRED}${MISSING}${NOCOLOR}"
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}

checkIf_services_arePresent__sub()
{
    #Check if the services are present
    #REMARK: if a service is present then it means that...
    #........its corresponding variable would CONTAIN DATA.
    local stdErr1=${EMPTYSTRING}
    local stdErr2=${EMPTYSTRING}
    local stdErr3=${EMPTYSTRING}
    local printf_toBeShown=${EMPTYSTRING}
    local errmsg_toBeShown=${EMPTYSTRING}

    #tb_bt_firmware.service
    stdErr1=`${SYSTEMCTL_CMD} ${STATUS} ${tb_bt_firmware_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr1} != ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}: ${FG_GREEN}${OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}: ${FG_LIGHTRED}${MISSING}${NOCOLOR}"
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #bluetooth.service
    stdErr2=`${SYSTEMCTL_CMD} ${STATUS} ${bluetooth_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr2} != ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}: ${FG_GREEN}${OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}: ${FG_LIGHTRED}${MISSING}${NOCOLOR}"
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #rfcomm_onBoot_bind.service
    stdErr3=`${SYSTEMCTL_CMD} ${STATUS} ${rfcomm_onBoot_bind_service_filename} 2>&1 ? /dev/null`
    if [[ ${stdErr3} != ${PATTERN_COULD_NOT_BE_FOUND} ]]; then
        printf_toBeShown="${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_filename}${NOCOLOR}: ${FG_GREEN}${OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${rfcomm_onBoot_bind_service_filename}${NOCOLOR}: ${FG_LIGHTRED}${MISSING}${NOCOLOR}"
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #Show Error Message (if applicable)
    if [[ -z ${stdErr1} ]] || \
         [[ -z ${stdErr2} ]] || \
            [[ -z ${stdErr3} ]]; then

        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_SERVICES_ARE_MISSING}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IS_BT_INSTALLED_PROPERLY}" "${TRUE}"        
    fi
}

setToVal_handler__sub()
{
    #INTERACTIVE MODE
    setToVal_func__func
}
function setToVal_func__func()
{
    #Define local variables
    local question_toBeShown=${EMPTYSTRING}

    #Check if any BT-interface is present
    bt_Intf_isPresent=`hciconfig` 
    if [[ ! -z ${bt_Intf_isPresent} ]]; then  #contains data
        #Current BT-setting
        bt_curr_setTo=${ON}

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            bt_req_setTo=${OFF}    #new BT-setting
        fi
        
        if [[ ${bt_req_setTo} != ${bt_curr_setTo} ]]; then
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_IS_CURRENTLY_ENABLED}" "${EMPTYLINES_1}"
            question_toBeShown=${QUESTION_DISABLE_BT}  #set variable
        else
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_ISALREADY_ENABLED}" "${EMPTYLINES_1}"

            noActionRequired_exit__func
        fi
    else    #contains NO data
        #Current BT-setting
        bt_curr_setTo=${OFF}

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            bt_req_setTo=${ON}    #new BT-setting
        fi

        if [[ ${bt_req_setTo} != ${bt_curr_setTo} ]]; then
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_IS_CURRENTLY_DISABLED}" "${EMPTYLINES_1}"
            question_toBeShown=${QUESTION_ENABLE_BT}
        else
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_ISALREADY_DISABLED}" "${EMPTYLINES_1}"

            noActionRequired_exit__func
        fi
    fi

    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled    
        #Print Question
        debugPrint__func "${PRINTF_QUESTION}" "${question_toBeShown}" "${EMPTYLINES_0}"

        #Loo
        while true
        do
            read -N1 -e -p "${EMPTYSTRING}" myChoice
            if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                clear_lines__func "${NUMOF_ROWS_2}"

                debugPrint__func "${PRINTF_QUESTION}" "${question_toBeShown} ${myChoice}" "${EMPTYLINES_0}"

                break
            else    #all other cases (e.g. ENTER or any-other-key was pressed)
                clear_lines__func "${NUMOF_ROWS_1}"
            fi
        done
    else    #interactive-mode is DISABLED
        myChoice=${INPUT_YES}   #set variable to 'YES'
    fi

    #Enable/Disable Service
    if [[ ${myChoice} == ${INPUT_NO} ]]; then
        noActionRequired_exit__func
    fi
}

services_handler__sub()
{
    #tb_bt_firmware.service: set to Enable/Disable (do NOT Start/Stop yet!)
    #Remark: the reason why we don't 'Start' the service right away is because...
    #........IF the service was Stopped previously, and the LTPP3-G2 was NOT rebooted since,
    #........then due to a BUG the service will NOT be able to 'Start'.
    #To Resolve the above mentioned issue, the LTPP3-G2 has to be REBOOTed.
    firmware_service_enableSet__func

    #bluetooth.service: set to Enable/Disable, also Start/Stop
    bluetooth_service_enableSet__func
    bluetooth_service_activeSet__func

    #rfcomm_onBoot_bind.service: set to Enable/Disable, also Start/Stop
    rfcomm_service_enableSet__func
    rfcomm_service_activeSet__func
}
function firmware_service_enableSet__func()
{
    #Check whether service is-active
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${tb_bt_firmware_service_filename}`

    if [[ ${bt_req_setTo} == ${ON} ]]; then  #request to Disable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_ENABLED}" "${EMPTYLINES_1}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${ENABLE} ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #request to Enable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-disabled
            debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${DISABLE} ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
        fi
    fi
}
function bluetooth_service_enableSet__func()
{
    #Check whether service is-enabled
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${bluetooth_service_filename}`

    if [[ ${bt_req_setTo} == ${ON} ]]; then  #request to Disable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_ENABLED}" "${EMPTYLINES_1}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${ENABLE} ${bluetooth_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #request to Enable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
            debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${DISABLE} ${bluetooth_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-disabled
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
        fi
    fi
}
function bluetooth_service_activeSet__func()
{
    #Check whether service is-active
    local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${bluetooth_service_filename}`

    if [[ ${bt_req_setTo} == ${ON} ]]; then  #switch ON
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_STARTED}" "${EMPTYLINES_1}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_STARTING_BLUETOOTH_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${START} ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STARTING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #switch OFF
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_BLUETOOTH_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${STOP} ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BLUETOOTH_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_1}"
        fi
    fi
}
function rfcomm_service_enableSet__func()
{
    #Check whether service is-enabled
    local service_isEnabled=`${SYSTEMCTL_CMD} ${IS_ENABLED} ${rfcomm_onBoot_bind_service_filename}`

    if [[ ${bt_req_setTo} == ${ON} ]]; then  #request to Disable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_ENABLED}" "${EMPTYLINES_1}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_RFCOMM_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${ENABLE} ${rfcomm_onBoot_bind_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #request to Enable Service
        if [[ ${service_isEnabled} == ${ENABLED} ]]; then #service is-enabled
            debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_RFCOMM_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${DISABLE} ${rfcomm_onBoot_bind_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-disabled
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_1}"
        fi
    fi
}
function rfcomm_service_activeSet__func()
{
    #Check whether service is-active
    local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${rfcomm_onBoot_bind_service_filename}`

    if [[ ${bt_req_setTo} == ${ON} ]]; then  #switch ON
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_STARTED}" "${EMPTYLINES_1}" 
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_STARTING_RFCOMM_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${START} ${rfcomm_onBoot_bind_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STARTING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #switch OFF
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_RFCOMM_SERVICE}" "${EMPTYLINES_1}"
            
            ${SYSTEMCTL_CMD} ${STOP} ${rfcomm_onBoot_bind_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_RFCOMM_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_1}"
        fi
    fi
}

# function bt_firmware_service_activeSet__func()
# {
#     #Check whether service is-active
#     local service_isActive=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${tb_bt_firmware_service_filename}`

#     if [[ ${bt_req_setTo} == ${ON} ]]; then  #switch ON
#         if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
#             debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STARTED}" "${EMPTYLINES_1}"
#             debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_ISALREADY_LOADED}" "${EMPTYLINES_0}" 
#         else    #service is-inactive
#             debugPrint__func "${PRINTF_START}" "${PRINTF_STARTING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
#             ${SYSTEMCTL_CMD} ${START} ${tb_bt_firmware_service_filename}

#             debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STARTING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
#         fi
#     else    #switch OFF
#         if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
#             debugPrint__func "${PRINTF_START}" "${PRINTF_STOPPING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
#             ${SYSTEMCTL_CMD} ${STOP} ${tb_bt_firmware_service_filename}

#             debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_STOPPING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
#         else    #service is-inactive
#             debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_STOPPED}" "${EMPTYLINES_1}"
#             debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_ISALREADY_UNLOADED}" "${EMPTYLINES_0}" 
#         fi
#     fi
# }

bt_intf_find_and_bring_up__sub()
{
    #Only execute this subroutine if 'bt_req_setTo = on'
    if [[ ${bt_req_setTo} == ${OFF} ]]; then    #bt_req_setTo = off
        return  #exit subroutine
    fi

    #Define local variables
    local btList_string=${EMPTYSTRING}
    local btList_array=()
    local btList_arrayLen=0
    local btList_arrayItem=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}
    local printf_bt_intf_currently_down=${EMPTYSTRING}
    local printf_bringing_bt_intf_up=${EMPTYSTRING}
    local printf_bt_intf_isAlready_up=${EMPTYSTRING}

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${EMPTYLINES_1}"

    #Get available BT-interfaces
    #Explanation:
    #   hcitool dev:        get interface names
    #   tr -d '\r\n':       trim '\r' and '\n'
    #   cut -d":" -f2:      get substring right-side of ':'
    #   awk '{print $1}':   get results of column#: 1
    btList_string=`${HCITOOL_CMD} dev | tr -d '\r\n' | cut -d":" -f2 | awk '{print $1}'`
    if [[ ! -z ${btList_string} ]]; then    #contains data
        #Convert string to array
        eval "btList_array=(${btList_string})"

        #Show available BT-interface(s)
        for btList_arrayItem in "${btList_array[@]}"; do
            debugPrint__func "${PRINTF_FOUND}" "${btList_arrayItem}" "${EMPTYLINES_0}"

            #Check if BT-interface is UP?
            stdOutput=`${HCICONFIG_CMD} ${btList_arrayItem} | grep ${STATUS_UP}`        
            if [[ -z ${stdOutput} ]]; then   #interface is DOWN
                #update printf messages
                printf_bt_intf_currently_down="BT *INTERFACE* CURRENTLY ${FG_LIGHTRED}DOWN${NOCOLOR}"
                printf_bringing_bt_intf_up="BRINGING BT *INTERFACE* ${FG_GREEN}UP${NOCOLOR}"

                debugPrint__func "${PRINTF_STATUS}" "${printf_bt_intf_currently_down}" "${EMPTYLINES_0}"
                debugPrint__func "${PRINTF_STATUS}" "${printf_bringing_bt_intf_up}" "${EMPTYLINES_0}"
            
                ${HCICONFIG_CMD} ${btList_arrayItem} ${TOGGLE_UP}
            # else
            #     #update printf messages
            #     printf_bt_intf_isAlready_up="BT *INTERFACE* IS ALREADY ${FG_GREEN}UP${NOCOLOR}"

            #     debugPrint__func "${PRINTF_STATUS}" "${printf_bt_intf_isAlready_up}" "${EMPTYLINES_0}"
            fi    
        done   
    else    #contains NO data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_BT_INTERFACE_FOUND}" "${FALSE}"
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${FALSE}"
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${EMPTYLINES_0}"
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
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RFCOMM_BINDS_RELEASED_ALL}" "${EMPTYLINES_0}"
}

bt_reqTo_reboot__sub()
{
    #Print Important Message
    debugPrint__func "${PRINTF_MANDATORY}" "${PRINTF_A_REBOOT_IS_REQUIRED_TO_COMPLETE_THE_PROCESS}" "${EMPTYLINES_1}"

    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
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
                                ${REBOOTNOW_CMD}
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
    fi
}


#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    checkIfisRoot__sub
    
    init_variables__sub

    input_args_handler__sub

    dynamic_variables_definition__sub

    input_args_case_select__sub

    validate_handler__sub

    setToVal_handler__sub

    services_handler__sub

    bt_intf_find_and_bring_up__sub

    rfcomm_release_binds__sub

    bt_reqTo_reboot__sub
}



#---EXECUTE
main__sub