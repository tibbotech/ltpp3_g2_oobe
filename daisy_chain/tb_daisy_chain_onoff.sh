#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
mode_chosen=${1}      #optional (on/off)



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${1}



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

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=1

EXITCODE_99=99

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

#---COMMAND RELATED CONSTANTS



#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

ON="on"
OFF="off"

ONE="1"
ZERO="0"



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
PRINTF_USAGE_DESCRIPTION="Utility to Turn Daisy-Chain Mode On/Off"

PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"


#---PRINT CONSTANTS
PRINTF_COMPLETED="COMPLETED:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_INFO="INFO:"
PRINTF_QUESTION="QUESTION:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WRITING="WRITING:"

PRINTF_DAISY_CHAIN_IS_ENABLED="DAISY CHAIN IS ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_DAISY_CHAIN_IS_DISABLED="DAISY CHAIN IS ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_TOGGLING_DAISY_CHAIN="TOGGLING DAISY CHAIN"

QUESTION_DISABLE_DAISY_CHAIN="DISABLE DAISY CHAIN (y/n)"
QUESTION_ENABLE_DAISY_CHAIN="DIABLE DAISY CHAIN (y/n)"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_daisy_chain_service_is_not_running="SERVICE '${FG_LIGHTGREY}${enable_eth1_before_login_service}${NOCOLOR}' IS ${FG_LIGHTRED}NOT${NOCOLOR} RUNNING"
    errmsg_unknown_option="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

    printf_service_is_running="SERVICE '${FG_LIGHTGREY}${enable_eth1_before_login_service}${NOCOLOR}' IS ${FG_GREEN}RUNNING${NOCOLOR}"
}





#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    enable_eth1_before_login_service="enable-eth1-before-login.service"

    mode_fpath=/sys/devices/platform/soc@B/9c108000.l2sw/mode
}



#---FUNCTIONS
function press_any_key__func() {
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
    trapDebugPrint_isEnabled=${FALSE}
}

input_args_hander__sub()
{
    #Convert 'toggle_value' to lowercase
    toggle_value=`convertTo_lowercase__func "${toggle_value}"`

    #Update 'arg1'
    arg1=${toggle_value}
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
    debugPrint__func "${PRINTF_DESCRIPTION}" "${PRINTF_USAGE_DESCRIPTION}" "${PREPEND_EMPTYLINES_1}"

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
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}{on|off}."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}${FOUR_SPACES}- Do NOT forget to surround each argument with ${FG_SOFLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFLIGHTRED}\"${NOCOLOR}."
    )

    printf "%s\n" ""
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ""
    printf "%s\n" ""
}
input_args_print_usage__sub()
{
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_INTERACTIVE_MODE_IS_ENABLED}" "${PREPEND_EMPTYLINES_1}"
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_FOR_HELP_PLEASE_RUN}" "${PREPEND_EMPTYLINES_0}"
}
input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unknown_option}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}
input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${PREPEND_EMPTYLINES_1}"
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
    daisy_chain_check_service__function

    daisy_chain_toggle_onoff__function
}
function daisy_chain_check_service__function()
{
    #Check if service 'enable-eth1-before-login.service' is running
    local daisy_chain_service_isRunning=""=`systemctl is-active ${enable_eth1_before_login_service}`

    #If service is NOT running, then exit with error
    if [[ -z ${daisy_chain_service_isRunning} ]]; then  #contains NO data (service is NOT running)
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_daisy_chain_service_is_not_running}" "${TRUE}"
    else
        debugPrint__func "${PRINTF_STATUS}" "${printf_service_is_running}" "${PREPEND_EMPTYLINES_1}"
    fi
}
function daisy_chain_toggle_onoff__function()
{
    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_TOGGLING_DAISY_CHAIN}" "${PREPEND_EMPTYLINES_1}"

    #Define local variables
    local mode_currVal=`cat ${mode_fpath}`
    
    if [[ ${mode_currVal} == ${ONE} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAISY_CHAIN_IS_ENABLED}" "${PREPEND_EMPTYLINES_0}"
        debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_DISABLE_DAISY_CHAIN}" "${PREPEND_EMPTYLINES_0}"
#>>>Define QUESTION_DISABLE_DAISY_CHAIN?
#IF ANSWER IS YES, then
#>>>Set value mode_newVal=${OFF}
    else
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAISY_CHAIN_IS_DISABLED}" "${PREPEND_EMPTYLINES_0}"
        debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_ENABLE_DAISY_CHAIN}" "${PREPEND_EMPTYLINES_0}"

#>>>Define QUESTION_ENABLE_DAISY_CHAIN?
#IF ANSWER IS YES, then
#>>>Set value mode_newVal=${ON}
    fi

#>>>EXECUTE BASED ON 'mode_newVal'
#>>>Simply echo "${mode_newVal}" > ${mode_fpath}

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_TOGGLING_DAISY_CHAIN}" "${PREPEND_EMPTYLINES_0}"
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    init_variables__sub

    dynamic_variables_definition__sub

    input_args_hander__sub

    input_args_case_select__sub

    daisy_chain_handler__sub
}



#---EXECUTE
main__sub