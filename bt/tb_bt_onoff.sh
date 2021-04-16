#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
bt_toggleTo=${1}      #optional (on/off)



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



#---COLORS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFLIGHTRED=$'\e[30;38;5;131m'
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

MODPROBE_BLUETOOTH="bluetooth"
MODPROBE_HCI_UART="hci_uart"
MODPROBE_RFCOMM="rfcomm"
MODPROBE_BNEP="bnep"
MODPROBE_HIDP="hidp"

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

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=1

EXITCODE_99=99

DAEMON_SLEEPTIME=3    #second
DAEMON_RETRY=20

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
HCITOOL_CMD="hcitool"
RFCOMM_CMD="rfcomm"
RFCOMM_CHANNEL_1="1"

#---STATUS/BOOLEANS
ENABLE="enable"
DISABLE="disable"

TRUE="true"
FALSE="false"

ENABLED="enabled"
ACTIVE="active"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

ON="on"
OFF="off"

INPUT_NO="n"
INPUT_YES="y"



#---PATTERN CONSTANTS



#---PRINTF PHASES
PRINTF_COMPLETED="COMPLETED:"
PRINTF_COMPONENTS="COMPONENTS:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_FOUND="FOUND:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WRITING="WRITING:"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."

ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"

ERRMSG_FAILED_TO_START_BT_DAEMON="FAILED TO START BT *FIRMWARE*"
ERRMSG_FAILED_TO_TERMINATE_BLUETOOTH_FIRMWARE="${FG_LIGHTRED}FAILED${NOCOLOR} TO TERMINATE BT *FIRMWARE*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_NO_BT_INTERFACE_FOUND="NO BT *INTERFACE FOUND"
ERRMSG_UNABLE_TO_KILL_PID="UNABLE TO KILL PID"
ERRMSG_UNABLE_TO_LOAD_BT_FIRMWARE="UNABLE TO LOAD BT *FIRMWARE*"
ERRMSG_UNKNOWN_OPTION="UNKNOWN OPTION"

#---HELPER/USAGE PRINT CONSTANTS
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle BT-module On/Off."

PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

#---PRINTF MESSAGES
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

PRINTF_BT_IS_CURRENTLY_ENABLED="BT IS CURRENTLY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BT_IS_CURRENTLY_DISABLED="BT IS CURRENTLY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_ISALREADY_LOADED="BT *FIRMWARE* IS ALREADY ${FG_GREEN}LOADED${NOCOLOR}"
PRINTF_BT_FIRMWARE_ISALREADY_UNLOADED="BT *FIRMWARE* IS ALREADY ${FG_LIGHTRED}UNLOADED${NOCOLOR}"
PRINTF_BT_FIRMWARE_WAS_LOADED_SUCCESSFULLY="BT *FIRMWARE* WAS LOADED ${FG_GREEN}SUCCESSFULLY${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE="BT *FIRMWARE* SERVICE"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_ACTIVE=" BT FIRMWARE *SERVICE* IS ALREADY ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_ENABLED=" BT FIRMWARE *SERVICE* IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_INACTIVE=" BT FIRMWARE *SERVICE* IS ALREADY ${FG_LIGHTRED}IN-ACTIVE${NOCOLOR}"
PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_DISABLED=" BT FIRMWARE *SERVICE* IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_BT_SUCCESSFULLY_KILLED_PID="${FG_GREEN}SUCCESSFULLY${NOCOLOR} KILLED:"
PRINTF_DAEMON_RELOADED="DAEMON RELOADED..."
PRINTF_ENABLING_BT_FIRMWARE_SERVICE="---:ENABLING BT *FIRMWARE* SERVICE"
PRINTF_DISABLING_BT_FIRMWARE_SERVICE="---:ENABLING BT *FIRMWARE* SERVICE"
PRINTF_NO_ACTION_REQUIRED="NO ACTION REQUIRED..."

#---PRINTF QUESTIONS
QUESTION_DISABLE_BT="${FG_LIGHTRED}DISABLE${NOCOLOR} BT (y/n)"
QUESTION_ENABLE_BT="${FG_GREEN}ENABLE${NOCOLOR} BT (y/n)"



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



#---SUBROUTINES
load_header__sub() {
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    myChoice=${EMPTYSTRING}
    bt_currSetTo=${OFF}
    currService_setTo=${FALSE}
    trapDebugPrint_isEnabled=${FALSE}
}

input_args_hander__sub()
{
    #Convert 'bt_toggleTo' to lowercase
    bt_toggleTo=`convertTo_lowercase__func "${bt_toggleTo}"`

    #Update 'arg1'
    arg1=${bt_toggleTo}
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
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFLIGHTRED}\"${NOCOLOR} each argument."
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


bt_toggle_onoff_handler__sub()
{
    #INTERACTIVE MODE
    bt_toggle_onoff__func
}
function bt_toggle_onoff__func()
{
    #Define local variables
    local question_toBeShown=${EMPTYSTRING}

    #Check if any BT-interface is present
    bt_Intf_isPresent=`hciconfig` 
    if [[ ! -z ${bt_Intf_isPresent} ]]; then  #contains data
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_IS_CURRENTLY_ENABLED}" "${EMPTYLINES_1}"
        question_toBeShown=${QUESTION_DISABLE_BT}  #set variable

        bt_currSetTo=${ON}   #current BT-setting

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            bt_toggleTo=${OFF}    #new BT-setting
        fi
    else
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_IS_CURRENTLY_DISABLED}" "${EMPTYLINES_1}"
        question_toBeShown=${QUESTION_ENABLE_BT}

        bt_currSetTo=${OFF}   #current BT-setting

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            bt_toggleTo=${ON}    #new BT-setting
        fi
    fi

    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled    
        #Print Question
        debugPrint__func "${PRINTF_QUESTION}" "${question_toBeShown}" "${EMPTYLINES_1}"

        #Loo
        while true
        do
            read -N1 -e -p "${EMPTYSTRING}" myChoice
            if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                clear_lines__func "${NUMOF_ROWS_2}"

                debugPrint__func "${PRINTF_QUESTION}" "${question_toBeShown} ${myChoice}" "${EMPTYLINES_0}"

                break
            else    #interactive-mode is DISABLED
                clear_lines__func "${NUMOF_ROWS_1}"
            fi
        done
    else    #interactive-mode is DISABLED
        myChoice=${INPUT_YES}   #set variable to 'YES'
    fi

    #Enable/Disable Service
    if [[ ${myChoice} == ${INPUT_NO} ]]; then
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NO_ACTION_REQUIRED}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"

        exit 0
    fi

    append_emptyLines__func "${EMPTYLINES_1}"
}

bt_firmware_handler__sub()
{
    bt_firmware_service__func

}

function bt_firmware_service__func()
{
    #Check whether service is-active
    local service_isActive=`systemctl is-active ${tb_bt_firmware_service_filename}`

    if [[ ${bt_toggleTo} == ${ON} ]]; then  #switch ON
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_ACTIVE}" "${EMPTYLINES_1}"
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_ISALREADY_LOADED}" "${EMPTYLINES_0}" 
        else    #service is-inactive
            debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
            systemctl start ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
        fi
    else    #switch OFF
        if [[ ${service_isActive} == ${ACTIVE} ]]; then #service is-active
            debugPrint__func "${PRINTF_START}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_1}"
            
            systemctl stop ${tb_bt_firmware_service_filename}

            debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_DISABLING_BT_FIRMWARE_SERVICE}" "${EMPTYLINES_0}"
        else    #service is-inactive
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_SERVICE_ISALREADY_INACTIVE}" "${EMPTYLINES_1}"
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_ISALREADY_UNLOADED}" "${EMPTYLINES_0}" 
        fi
    fi

    # #Check whether service is-enabled
    # local service_isEnabled=`systemctl is-enabled ${tb_bt_firmware_service_filename}`
    # if [[ ${service_isEnabled} == ${ENABLED} ]]; then

    # else

    # fi
}


#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    init_variables__sub

    input_args_hander__sub

    dynamic_variables_definition__sub

    input_args_case_select__sub

    bt_toggle_onoff_handler__sub

    # bt_firmware_handler__sub
}



#---EXECUTE
main__sub