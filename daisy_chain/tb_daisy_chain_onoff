#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
daisyChainMode_req_setTo=${1}      #optional (on/off)



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
FG_YELLOW=$'\e[1;33m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_GREEN=$'\e[30;38;5;76m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
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

EXITCODE_99=99

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
SYSTEMCTL_CMD="systemctl"


#---STATUS/BOOLEANS
ENABLE="enable"
DISABLE="disable"

START="start"
STOP="stop"

IS_ACTIVE="is-active"

ON="on"
OFF="off"

ONE="1"
ZERO="0"

ACTIVE="active"

ENABLED="enabled"
DISABLED="disabled"

INPUT_NO="n"
INPUT_YES="y"



#---PATTERN CONSTANTS



#---ERROR MESSAGE CONSTANTS
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."

ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="UNKNOWN OPTION"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"

#---HELPER/USAGE PRINT CONSTANTS
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Turn Daisy-Chain Mode On/Off."

PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

#---PRINT CONSTANTS
PRINTF_COMPLETED="COMPLETED:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_EXITING="EXITING:"
PRINTF_INFO="INFO:"
PRINTF_QUESTION="QUESTION:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WRITING="WRITING:"

PRINTF_DAEMON_RELOADED="DAEMON RELOADED..."
PRINTF_DAISY_CHAIN_ISALREADY_ON="DAISY-CHAIN IS *ALREADY* ${FG_GREEN}ON${NOCOLOR}"
PRINTF_DAISY_CHAIN_ISALREADY_OFF="DAISY-CHAIN IS *ALREADY* ${FG_LIGHTRED}OFF${NOCOLOR}"
PRINTF_DAISY_CHAIN_ISCURRENTLY_ON="DAISY-CHAIN IS CURRENTLY ${FG_GREEN}ON${NOCOLOR}"
PRINTF_DAISY_CHAIN_ISCURRENTLY_OFF="DAISY-CHAIN IS CURRENTLY ${FG_LIGHTRED}OFF${NOCOLOR}"
PRINTF_TOGGLING_DAISY_CHAIN_ONOFF="SETTING DAISY-CHAIN MODE"

PRINTF_NO_ACTION_REQUIRED="NO ACTION REQUIRED..."
PRINTF_SERVICE_IS_RUNNING="DAISY-CHAIN *SERVICE* IS ${FG_GREEN}RUNNING${NOCOLOR}"


#---PRINTF QUESTIONS
QUESTION_DISABLE_DAISY_CHAIN="SET DAISY-CHAIN MODE TO ${FG_LIGHTRED}OFF${NOCOLOR} (y/n)"
QUESTION_ENABLE_DAISY_CHAIN="SET DAISY-CHAIN MODE TO ${FG_GREEN}ON${NOCOLOR} (y/n)"



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

    daisychain_state_service="daisychain_state.service"
}



#---FUNCTIONS
function press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=10
    local PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE="Press (a)bort or any key to continue..."

	#Initialize variables
	local keyPressed=""
	local tCounter=0
    local delta_tCounter=0


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
        printf '%s%b\n' "${FG_ORANGE}${PRINTF_EXITING}${NOCOLOR} ${thisScript_filename}"
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
    daisyChainMode_curr_setTo=${OFF}
    currService_setTo=${FALSE}
    trapDebugPrint_isEnabled=${FALSE}
}

input_args_hander__sub()
{
    #Convert 'daisyChainMode_req_setTo' to lowercase
    daisyChainMode_req_setTo=`convertTo_lowercase__func "${daisyChainMode_req_setTo}"`

    #Update 'arg1'
    arg1=${daisyChainMode_req_setTo}
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

daisy_chain_handler__sub()
{
    daisy_chain_toggle_onoff__function
}
function daisy_chain_toggle_onoff__function()
{
    #Define local variables
    local question_toBeShown=${EMPTYSTRING}

    #Check if service 'enable-eth1-before-login.service' is running
    local daisychain_state_setTo=`${SYSTEMCTL_CMD} ${IS_ACTIVE} ${daisychain_state_service}`

    #Check whether service 'is-active'
    if [[ ${daisychain_state_setTo} == ${ACTIVE} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAISY_CHAIN_ISCURRENTLY_ON}" "${EMPTYLINES_0}"
        question_toBeShown=${QUESTION_DISABLE_DAISY_CHAIN}  #set variable

        daisyChainMode_curr_setTo=${ON}   #current Daisy-Chain mode

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            daisyChainMode_req_setTo=${OFF}    #new Daisy-Chain mode
        fi
    else
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAISY_CHAIN_ISCURRENTLY_OFF}" "${EMPTYLINES_0}"
        question_toBeShown=${QUESTION_ENABLE_DAISY_CHAIN}

        daisyChainMode_curr_setTo=${OFF}   #current Daisy-Chain mode

        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled 
            daisyChainMode_req_setTo=${ON}    #new Daisy-Chain mode
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
    if [[ ${myChoice} == ${INPUT_YES} ]]; then
        daisy_chain_service_handler__func
    else
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NO_ACTION_REQUIRED}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"
    fi

    append_emptyLines__func "${EMPTYLINES_1}"
}
function daisy_chain_service_handler__func()
{
    #Define local variables
    local printf_toBeShown=${EMPTYSTRING}

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_TOGGLING_DAISY_CHAIN_ONOFF}" "${EMPTYLINES_1}"


    #Start/Stop Service (if not done yet)
    if [[ ${daisyChainMode_req_setTo} != ${daisyChainMode_curr_setTo} ]]; then  #there is a difference in the values
        append_emptyLines__func "${EMPTYLINES_1}"

        if [[ ${daisyChainMode_req_setTo} == ${OFF} ]]; then
            ${SYSTEMCTL_CMD} ${STOP} ${daisychain_state_service}
            ${SYSTEMCTL_CMD} ${DISABLE} ${daisychain_state_service}
        else    #daisyChainMode_req_setTo = ON
            ${SYSTEMCTL_CMD} ${ENABLE} ${daisychain_state_service}
            ${SYSTEMCTL_CMD} ${START} ${daisychain_state_service}
        fi

        #Reload Daemon
        bt_daemon_reload__func
    else    #there is NO difference in the values
        if [[ ${daisyChainMode_curr_setTo} == ${OFF} ]]; then
            #Unconditionally DISABLE service to DISABLE eth1
            ${SYSTEMCTL_CMD} ${DISABLE} ${daisychain_state_service}

            printf_toBeShown=${PRINTF_DAISY_CHAIN_ISALREADY_OFF}
        else    #daisyChainMode_req_setTo = ON
            #Unconditionally ENABLE service to ENABLE eth1
            ${SYSTEMCTL_CMD} ${ENABLE} ${daisychain_state_service}

            printf_toBeShown=${PRINTF_DAISY_CHAIN_ISALREADY_ON}
        fi
    
        debugPrint__func "${PRINTF_INFO}" "${printf_toBeShown}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_EXITING}" "${thisScript_filename}" "${EMPTYLINES_0}"
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_TOGGLING_DAISY_CHAIN_ONOFF}" "${EMPTYLINES_1}"
}
function bt_daemon_reload__func()
{    
    ${SYSTEMCTL_CMD} daemon-reload

    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAEMON_RELOADED}" "${PREPEND_EMPTYLINES_1}"
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

    daisy_chain_handler__sub
}



#---EXECUTE
main__sub