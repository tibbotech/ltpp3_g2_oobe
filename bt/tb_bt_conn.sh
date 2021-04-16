#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
macAddr_chosen=${1}      #optional
pinCode_chosen=${2}      #optional



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${1}

#---Set boolean to FALSE if NON-INTERACTIVE MODE
TRUE="true"
FALSE="false"

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=2

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

BT_TTYSX_LINE="\/dev\/ttyS4"
BT_BAUDRATE=9600
BLUETOOTHCTL_SCAN_TIMEOUT=10

MAC_ADDRESS_INPUT="MAC-ADDRESS INPUT"
PIN_CODE_INPUT="PIN-CODE INPUT"

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
SEMICOLON_CHAR=";"
SLASH_CHAR="/"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"
TAB_CHAR=$'\t'

ONE_SPACE=" "
TWO_SPACES="${ONE_SPACE}${ONE_SPACE}"
FOUR_SPACES="${TWO_SPACES}${TWO_SPACES}"
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

EXITCODE_99=99

INPUT_BACK="b"
INPUT_NO="n"
INPUT_YES="y"
INPUT_REFRESH="r"

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
BLUETOOTHCTL_CMD="bluetoothctl"
HCITOOL_CMD="hcitool"
PGREP_CMD="pgrep"
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

YES="yes"
NO="no"



#---PATTERN CONSTANTS
PATTERN_BRCM_PATCHRAM_PLUS="brcm_patchram_plus"
PATTERN_GREP="grep"
PATTERN_DONE_SETTING_LINE_DISCIPLINE="Done setting line discpline"
PATTERN_BLUEZ="bluez"

PATTERN_NAME="Name"
PATTERN_PAIRED="Paired"



#---CASE-SELECT CONSTANTS
HCITOOL_HANLDER_CASE_CHOOSE_MACADDR="CHOOSE MAC-ADDRESS"
HCITOOL_HANLDER_CASE_PINCODE_INPUT="PIN-CODE INPUT"
HCITOOL_HANLDER_CASE_EXIT="EXIT"



#---PRINTF WIDTHS
PRINTF_DEVNAME_WIDTH="%-25s"
PRINTF_MACADDR_WIDTH="%-20s"
PRINTF_PAIRED_WIDTH="%-6s"
PRINTF_BOUND_WIDTH="%-6s"
PRINTF_RFCOMM_WIDTH="%-8s"

#---PRINTF HEADERS
PRINTF_HEADER_DEVNAME="NAME"
PRINTF_HEADER_MACADDR="MAC"
PRINTF_HEADER_PAIRED="PAIR"
PRINTF_HEADER_BIND="BIND"
PRINTF_HEADER_RFCOMM="RFCOMM"

#---PRINTF PHASES
PRINTF_COMPLETED="COMPLETED:"
PRINTF_COMPONENTS="COMPONENTS:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_ENTERING="ENTERING:"
PRINTF_EXITING="EXITING:"
PRINTF_FOUND="FOUND:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WARNING="WARNING:"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."

ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_OCCURRED_IN_FILE="OCCURRED IN FILE:"
ERRMSG_UNKNOWN_FORMAT="(${FG_LIGHTRED}Unknown format${NOCOLOR})"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"

#---PRINTF MESSAGES
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

PRINTF_BLUETOOTHCTL="${FG_BLUETOOTHCTL_DARKBLUE}${BLUETOOTHCTL_CMD}${NOCOLOR}"
PRINTF_BLUEZ="BLUEZ"
PRINTF_BLUEZ_BLUETOOTHCTL="BLUETOOTHCTL"
PRINTF_BLUEZ_HCICONFIG="HCICONFIG"
PRINTF_BLUEZ_HCITOOL="HCITOOL"
PRINTF_BLUEZ_RFCOMM="RFCOMM"
PRINTF_BT_BINDING_STATUS="BT-BINDING STATUS"
PRINTF_NO_PAIRED_DEVICES_FOUND="=:${FG_LIGHTRED}NO PAIRED DEVICES FOUND${NOCOLOR}:="
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Bind MAC-address to rfcomm."

PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES="SCANNING FOR *AVAILABLE* BT-DEVICES"

PRINTF_EXITING_NOW="EXITING NOW..."

#---PRINTF QUESTIONS
QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE="${FG_DARKBLUE}PIN-CODE IS AN ${FG_LIGHTBLUE}EMPTYSTRING${NOCOLOR}, ${FG_DARKBLUE}CONTINUE ANYWAYS (y/n)? ${NOCOLOR}"



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

    tb_bt_sndpair_filename="tb_bt_sndpair.sh"
    tb_bt_sndpair_fpath=${thisScript_current_dir}/${tb_bt_sndpair_filename}

    dev_dir=/dev

    tmp_dir=/tmp
    hcitool_scan_tmp_filename="hcitool_scan.tmp"
    hcitool_scan_tmp_fpath=${tmp_dir}/${hcitool_scan_tmp_filename}

    bluetoothctl_info_tmp_filename="bluetootctl_info.tmp"
    bluetoothctl_info_tmp_fpath=${tmp_dir}/${bluetoothctl_info_tmp_filename}

    bluetoothctl_bind_stat_tmp_filename="bluetoothctl_bind_stat.tmp"
    bluetoothctl_bind_stat_tmp_fpath=${tmp_dir}/${bluetoothctl_bind_stat_tmp_filename}

    var_backups_dir=/var/backups
    bluetoothctl_bind_stat_bck_filename="bluetoothctl_bind_stat.bck"
    bluetoothctl_bind_stat_bck_fpath=${var_backups_dir}/${bluetoothctl_bind_stat_bck_filename}
}



#---FUNCTIONS
press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=10

	#Initialize variables
	local keyPressed=""
	local tCounter=0
    local delta_tCounter=0

    #Define printf constants
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
    stdOutput=`echo "${inputVar}" | grep -E "${regEx}" 2>&1`

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

    if [[ -z ${topic} ]]; then
        printf '%s%b\n' "${msg}"
    else
        printf '%s%b\n' "${FG_ORANGE}${topic}${NOCOLOR} ${msg}"
    fi
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
    echo -e "\r"
    echo -e "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}

    hcitool_handler_caseSelect=${EMPTYSTRING}
    hcitool_macAddrList_string=${EMPTYSTRING}
    hcitool_scanList_string=${EMPTYSTRING}
    hcitool_scanList_array=()
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

               exit 0
            else
                input_args_print_unknown_option__sub
            fi
            ;;

        --version | -v)
            input_args_print_version__sub

            exit 0
            ;;
        
        *)
            if [[ ${argsTotal} -eq 0 ]]; then   #no input arg provided
                input_args_print_usage__sub
            elif [[ ${argsTotal} -eq 1 ]]; then #1 input arg provided
                input_args_print_unknown_option__sub
            elif [[ ${argsTotal} -gt ${ARGSTOTAL_MIN} ]]; then  #at more than 1 input arg provided
                if [[ ${argsTotal} -eq ${ARGSTOTAL_MAX} ]]; then    #not all input args provided
                    if [[ -z ${arg1} ]]; then   #MAC-address is an EMPTY STRING
                        input_args_print_arg1_cannot_be_emptyString__sub
                    fi
                elif [[ ${argsTotal} -ne ${ARGSTOTAL_MAX} ]]; then    #not all input args provided
                    input_args_print_unmatched__sub
                fi
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}Target Device BT ${FG_LIGHTPINK}MAC${NOCOLOR}-address (e.g. aa:bb:cc:dd:ee:ff)."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}Target Device BT ${FG_LIGHTPINK}PIN${NOCOLOR}-code (e.g. 1234)."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFLIGHTRED}\"${NOCOLOR} each argument."
        "${FOUR_SPACES}- PIN-code input can be an ${FG_SOFLIGHTRED}\"${NOCOLOR}empty string${FG_SOFLIGHTRED}\"${NOCOLOR}."
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

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${EMPTYLINES_1}"
}

software_inst__sub()
{
    #Define local variable
    local bluez_isInstalled=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    local prepend_emptylines=EMPTYLINES_1   #this variable is used just in case there are more software to be installed
    
    #Check if 'bluez' is already installed
    #If FALSE, then install 'bluez'
    if [[ ${bluez_isInstalled} == ${FALSE} ]]; then
        debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_BLUEZ}" "${prepend_emptylines}"
        debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_BLUETOOTHCTL}${NOCOLOR}" "${EMPTYLINES_0}"
        debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_HCICONFIG}${NOCOLOR}" "${EMPTYLINES_0}"
        debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_HCITOOL}${NOCOLOR}" "${EMPTYLINES_0}"
        debugPrint__func "${PRINTF_COMPONENTS}" "${TWO_SPACES}${FG_LIGHTGREY}${PRINTF_BLUEZ_RFCOMM}${NOCOLOR}" "${EMPTYLINES_0}"
        DEBIAN_FRONTEND=noninteractive apt-get -y install bluez

        prepend_emptylines=EMPTYLINES_0 #set variable
    fi
}

get_and_show_bt_bind_status__sub()
{
    #Define local variables
    local devName=${EMPTYSTRING}
    local isPaired=${NO}
    local isBound=${NO}
    local rfcommDevNum=${EMPTYSTRING}

    local macAddrList_string=${EMPTYSTRING}
    local macAddrList_array=()
    local macAddrList_arrayItem=${EMPTYSTRING}

    local printf_isPaired_color=${NOCOLOR}
    local printf_isBound_color=${NOCOLOR}

    #Define printf template
    printf_header_template="${PRINTF_DEVNAME_WIDTH}${PRINTF_MACADDR_WIDTH}${PRINTF_PAIRED_WIDTH}${PRINTF_BOUND_WIDTH}${PRINTF_RFCOMM_WIDTH}"

    #Show Bluetooth Conenction Status
    debugPrint__func "${PRINTF_INFO}" "${PRINTF_BT_BINDING_STATUS}" "${EMPTYLINES_1}"

    #Print Header
    printf "\n${printf_header_template}\n" "${FOUR_SPACES}${PRINTF_HEADER_DEVNAME}" "${PRINTF_HEADER_MACADDR}" "${PRINTF_HEADER_PAIRED}" "${PRINTF_HEADER_BIND}" "${PRINTF_HEADER_RFCOMM}"


    #Remove file (if present)
    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then
        rm ${bluetoothctl_bind_stat_tmp_fpath}
    fi

    #Get Paired MAC-addresses
    macAddrList_string=`${BLUETOOTHCTL_CMD} paired-devices | awk '{print $2}'`

    if [[ -z ${macAddrList_string} ]]; then
        printf "\n%b\n" "${EIGHT_SPACES}${EIGHT_SPACES}${PRINTF_NO_PAIRED_DEVICES_FOUND}"

        return  #exit function
    fi


    #Convert string to array
    eval "macAddrList_array=(${macAddrList_string})"   

    #1. Cycle through all paired MAC-addresses
    #2. Get the device-name, pair-status, and bind-status
    for macAddrList_arrayItem in "${macAddrList_array[@]}"
    do
        #Get 'bluetoothctl info' for a specified 'macAddrList_arrayItem'
        bluetootctl_get_info_for_specified_macAddr__func "${macAddrList_arrayItem}"

        #Retrieve information
        devName=`bluetootctl_retrieve_info_for_specified_pattern__func "${PATTERN_NAME}"`
        isPaired=`bluetootctl_retrieve_info_for_specified_pattern__func "${PATTERN_PAIRED}"`
        rfcommDevNum=`rfcomm_retrieve_info__func "${macAddrList_arrayItem}"`
        if [[ ${rfcommDevNum} != ${DASH_CHAR} ]]; then
            isBound=${YES}
        else
            isBound=${NO}
        fi

        #Write to File
        echo "${devName} ${macAddrList_arrayItem} ${isPaired} ${isBound} ${rfcommDevNum}" >> ${bluetoothctl_bind_stat_tmp_fpath}

        #Select the color for values 'isPaired' and 'isBound' (GREEN or RED)
        printf_isPaired_color=`bluetootctl_select_color__func "${isPaired}"`
        printf_isBound_color=`bluetootctl_select_color__func "${isBound}"`
        #Compose the 'printf template'
        printf_body_template="${FG_LIGHTGREY}${PRINTF_DEVNAME_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_MACADDR_WIDTH}${NOCOLOR}${printf_isPaired_color}${PRINTF_PAIRED_WIDTH}${NOCOLOR}${printf_isBound_color}${PRINTF_BOUND_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_RFCOMM_WIDTH}${NOCOLOR}"
        #Print
        printf "${printf_body_template}\n" "${FOUR_SPACES}${devName}" "${macAddrList_arrayItem}" "${isPaired}" "${isBound}" "${rfcommDevNum}"
    done
}
function bluetootctl_select_color__func()
{
    #Input args
    local inputValue=${1}

    #Define local variables
    local outputValue=${EMPTYSTRING}

    #Depending on the value (whether 'yes' or 'no'), add color
    if [[ ${inputValue} == ${YES} ]]; then
        outputValue=${FG_LIGHTGREEN}
    else    #inputValue == NO
        outputValue=${FG_SOFLIGHTRED}
    fi

    #Output
    echo ${outputValue}
}
function bluetootctl_get_info_for_specified_macAddr__func()
{
    #Input args
    local macAddr_input=${1}

    #Remove file (if present)
    if [[ -f ${bluetoothctl_info_tmp_fpath} ]]; then
        rm ${bluetoothctl_info_tmp_fpath}
    fi

    #Get and write information to file
    ${BLUETOOTHCTL_CMD} info ${macAddr_input} > ${bluetoothctl_info_tmp_fpath}
}
function bluetootctl_retrieve_info_for_specified_pattern__func()
{
    #Input args
    local pattern_input=${1}

    #Get Info for the specified input args
    #   grep -w "${pattern_input}": get the EXACT MATCH for specified 'pattern_input'
    #   cut -d":" -f2: get substring on right-side of colon ':'
    #   awk '$1=$1': remove leading and trailing spaces
    #   sed "s/ /_/g": replace SPACE with UNDERSCORE
    local info_output=`cat ${bluetoothctl_info_tmp_fpath} | grep -w "${pattern_input}" | cut -d":" -f2 | awk '$1=$1' | sed "s/ /_/g"`

    #Output
    echo ${info_output}
}
function rfcomm_retrieve_info__func()
{
    #Input args
    local macAddr_input=${1}

    #Get rfcomm-dev-number
    local rfcommDevNum=`${RFCOMM_CMD} | grep "${macAddr_input}" | cut -d":" -f1`

    #Combine with '/dev'
    #Initial value
    #   REMARK: in the case that 'macAddr_input' is NOT bound to an refcomm-dev-number
    local info_output=${DASH_CHAR}  #initial value
    if [[ ! -z ${rfcommDevNum} ]]; then
        info_output=${dev_dir}/${rfcommDevNum}
    fi

    #Output
    echo ${info_output}
}

hcitool_handler__sub()
{
    #Initial values
    hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_CHOOSE_MACADDR}

    while true
    do
        case ${hcitool_handler_caseSelect} in
            ${HCITOOL_HANLDER_CASE_CHOOSE_MACADDR})
                hcitool_choose_macAddr__func
                ;;

            ${HCITOOL_HANLDER_CASE_PINCODE_INPUT})
                hcitool_pincode_input__func
                ;;
            
            ${HCITOOL_HANLDER_CASE_EXIT})
                break
                ;;
        esac        
    done
}

function hcitool_choose_macAddr__func()
{
    #Define local variables
    local macAddr_chosen_raw=${EMPTYSTRING}
    local macAddr_isPresent=${FALSE}
    local macAddr_isValid=${FALSE}
    local debugMsg=${EMPTYSTRING}

    #Check if INTERACTIVE MODE is ENABLED
    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is enabled
        hcitool_get_and_show_scanList__func
    fi

    #Select a Device to bind to
    while true
    do
        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED            
            #Show read-input
            read -p "${FG_LIGHTBLUE}${MAC_ADDRESS_INPUT}${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): " macAddr_chosen_raw #provide your input
        else    #interactive-mode is DISABLED
            #Update variable
            #REMARK: input arg 'macAddr_chosen' is RAW-DATA and must be CLEANED and VALIDATED
            macAddr_chosen_raw=${macAddr_chosen}
        fi

        if [[ ! -z ${macAddr_chosen_raw} ]]; then   #input was NOT an empty string
            if [[ ${macAddr_chosen_raw} == ${INPUT_REFRESH} ]]; then
                hcitool_get_and_show_scanList__func
            else
                #Cleanup MAC-address
                #REMARK: this means removing all UNWANTED chars
                macAddr_chosen=`macAddr_cleanup__func "${macAddr_chosen_raw}"`

                #Validate MAC-address
                macAddr_isValid=`macAddr_isValid__func "${macAddr_chosen}"`
                if [[ ${macAddr_isValid} == ${FALSE} ]]; then
                    #Check if INTERACTIVE MODE is ENABLED
                    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                        tput cuu1
                        tput el

                        printf_macAddr_unknown_format="${FG_LIGHTBLUE}${MAC_ADDRESS_INPUT}${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): ${macAddr_chosen_raw} ${ERRMSG_UNKNOWN_FORMAT}"
                        debugPrint__func "${EMPTYSTRING}" "${printf_macAddr_unknown_format}" "${EMPTYLINES_0}"
                    else    #interactive-mode is DISABLED
                        errMsg_invalid_macAddr="INVALID ${MAC_ADDRESS_INPUT} '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}'"
                        errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_invalid_macAddr}" "${TRUE}"
                    fi
                else
                    #Check if INTERACTIVE MODE is ENABLED
                    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                        macAddr_isPresent=`hcitool_checkIf_macAddr_isPresent__func "${macAddr_chosen}"`
                        if [[ ${macAddr_isPresent} == ${TRUE} ]]; then  #MAC-address was found
                            tput cuu1
                            tput el

                            printf '%b%s\n' "${FG_LIGHTBLUE}${MAC_ADDRESS_INPUT}${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): ${macAddr_chosen}"
                        else    #MAC-address was NOT found
                            errMsg_invalid_macAddr="INVALID ${MAC_ADDRESS_INPUT} '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}'"
                            debugPrint__func "${PRINTF_WARNING}" "${errMsg_invalid_macAddr}" "${EMPTYLINES_1}"

                            press_any_key__func

                            clear_lines__func "${NUMOF_ROWS_5}"
                        fi
                    fi

                    hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_PINCODE_INPUT}    #goto next-case

                    break
                fi
            fi
        else    #input was an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_1}"
        fi
    done
}
function hcitool_get_and_show_scanList__func()
{
    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES}" "${EMPTYLINES_1}"
    
    #Get Available BT-devices
    hcitool_get_scanList__func

    #Show Available BT-devices
    hcitool_show_scanList__func

    #Print empty line
    printf '%b%s\n' ""
}

function hcitool_get_scanList__func()
{
    #Define local variables
    local devName=${EMPTYSTRING}
    local macAddr=${EMPTYSTRING}

    #Check if directory '/tmp' exist.
    #If FALSE, then create directory
    if [[ ! -d ${tmp_dir} ]]; then
        mkdir ${tmp_dir}
    fi

    #Remove file (if present)
    if [[ -f ${hcitool_scan_tmp_fpath} ]]; then
        rm ${hcitool_scan_tmp_fpath}
    fi

    #Get scan result and write to file
    ${HCITOOL_CMD} scan | tail -n+2 > ${hcitool_scan_tmp_fpath}
}
function hcitool_show_scanList__func()
{
    #Define local variables
    local line=${EMPTYSTRING}
    local devName=${EMPTYSTRING}
    local macAddr=${EMPTYSTRING}

    #Define printf template
    printf_header_template="${PRINTF_DEVNAME_WIDTH}${PRINTF_MACADDR_WIDTH}"
    printf_body_template="${FG_LIGHTGREY}${PRINTF_DEVNAME_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_MACADDR_WIDTH}"

    #Print Header
    printf "\n${printf_header_template}\n" "${FOUR_SPACES}${PRINTF_HEADER_DEVNAME}" "${PRINTF_HEADER_MACADDR}"

    #Read file contents
    while read -r line
    do
        #Get device-name
        devName=`echo ${line} | awk '{print $2}'`

        #Get MAC-address
        macAddr=`echo ${line} | awk '{print $1}'`

        #Print
        printf "${printf_body_template}\n" "${FOUR_SPACES}${devName}" "${macAddr}"
    done <  ${hcitool_scan_tmp_fpath}
}
function hcitool_checkIf_macAddr_isPresent__func()
{
    #Input args
    local macAddr_input=${1}

    #Define local variables
    local stdOutput1=${EMPTYSTRING}
    local stdOutput2=${EMPTYSTRING}
    local macAddr_isPresent=${FALSE}

    #Check if file 'hcitool_scan.tmp' exist
    if [[ -f ${hcitool_scan_tmp_fpath} ]]; then #file exists
        stdOutput1=`cat ${hcitool_scan_tmp_fpath} | awk '{print $1}' | grep -w "${macAddr_input}"`
    fi

    #Check if MAC-address is present in the file 'hcitool_scan.tmp'
    if [[ ! -z ${stdOutput1} ]]; then    #MAC-address is present in the file 'hcitool_scan.tmp'
        macAddr_isPresent=${TRUE}
    else   #MAC-address is NOT present in the file 'hcitool_scan.tmp'
        #Check if file 'bluetoothctl_bind_stat.tmp' exist
        if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then #file exists
            stdOutput2=`cat ${bluetoothctl_bind_stat_tmp_fpath} | awk '{print $2}' | grep -w "${macAddr_input}"`
        fi

        #Check if MAC-address is present in the file 'bluetoothctl_bind_stat.tmp'
        if [[ ! -z ${stdOutput2} ]]; then    #MAC-address is present in the file 'bluetoothctl_bind_stat.tmp'
            macAddr_isPresent=${TRUE}
        fi
    fi

    #Output
    echo ${macAddr_isPresent}
}
function macAddr_cleanup__func()
{
    #Input args
    local macAddr_input=${1}

    #Define local variables
    local macAddr_clean=${EMPTYSTRING}
    local macAddr_output=${EMPTYSTRING}
    local numOf_dots=0
    local numOf_colons=0
    local regEx=${EMPTYSTRING}
    local regEx_blank=${EMPTYSTRING}
    local regex_leadingComma=${EMPTYSTRING}
    local regex_trailingComma=${EMPTYSTRING}

    #Define 'regEx' for 'sed'
    regEx="[^0-9a-zA-Z:]"            #keep numbers, colon, comma
    regEx_Leading="^[^0-9a-zA-Z]"     #Begin from the START (^), but KEEP numbers and colon (^0-9a-f)
    regEx_Trailing="[^0-9a-zA-Z]$"     #Begin from the END ($), but KEEP numbers and colon (^0-9a-f)

    while true
    do
        #Remove ALL SPACES
        macAddr_clean=`echo ${macAddr_input} | tr -d ' '`

        #Subsitute SINGLE SEMI-COLON with COLON
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${SEMICOLON_CHAR}/${COLON_CHAR}/g"`

        #Subsitute SINGLE DOT with COLON
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${DOT_CHAR}/${COLON_CHAR}/g"`

        #Subsitute SINGLE DASH with COLON
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${DASH_CHAR}/${COLON_CHAR}/g"`

        #Subsitute MULTIPLE COLONS with ONE COLON
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${COLON_CHAR}${COLON_CHAR}*/${COLON_CHAR}/g"`

        #Remove all UNWANTED chars but keep chars SPECIFIED by 'regEx'
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${regEx}/${EMPTYSTRING}/g"`

        #Remove any LEADING UNWANTED chars
        macAddr_clean=`echo ${macAddr_clean} | sed "s/${regEx_Leading}/${EMPTYSTRING}/g"`

        #Remove any TRAILING UNWANTED chars
        macAddr_output=`echo ${macAddr_clean} | sed "s/${regEx_Trailing}/${EMPTYSTRING}/g"`

        #Check if 'macAddr_input' is EQUAL to 'macAddr_output'
        #If TRUE, then exit while-loop
        #If FALSE, then update 'macAddr_input', and go back to the beginning of the loop
        #REMARK: the main idea is to keep on cleaning AND updating 'macAddr_input' until...
        #...'macAddr_input = macAddr_output'
        if [[ ${macAddr_output} != ${macAddr_input} ]]; then    #strings are different
            macAddr_input=${macAddr_output}
        else    #strings are the same
            break
        fi
    done

    #Output
    echo ${macAddr_output}
}
function macAddr_isValid__func()
{
    #Input args
    local macAddr_input=${1}

    #Define local variables
    local regEx=${EMPTYSTRING}
    local isValid=${FALSE}

    #Regular expression
    regEx="^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$"

    #Validate MAC-address
    if [[ "${macAddr_input}" =~ ${regEx} ]]; then  #MAC-address is Valid
        isValid=${TRUE}
    else    #MAC-address is NOT valid
        isValid=${FALSE}
    fi

    #Output
    echo ${isValid}
}

function hcitool_pincode_input__func()
{
    #Define local variables
    local pinCode_isValid=${FALSE}

    #Pin-code input
    while true
    do
        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED            
            #Show read-input
            read -p "${FG_LIGHTBLUE}${PIN_CODE_INPUT}${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): " pinCode_chosen #provide your input
        fi

        if [[ ${pinCode_chosen} == ${INPUT_BACK} ]]; then
            hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_CHOOSE_MACADDR}    #goto next-case

            break
        elif [[ ${pinCode_chosen} == ${EMPTYSTRING} ]]; then   #input was an EMPTY STRING
            #Check if INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED              
                while true
                do
                    read -N1 -e -p "${QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE}" myChoice
                    if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                        if [[ ${myChoice} == ${INPUT_YES} ]]; then
                            hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_EXIT}    #goto next-case

                            break
                        else
                            if [[ ${myChoice} == ${INPUT_NO} ]]; then
                                hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_PINCODE_INPUT}    #goto next-case

                                break
                            fi
                        fi
                    else    #interactive-mode is DISABLED
                        clear_lines__func "${NUMOF_ROWS_1}"
                    fi
                done
            else
                hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_EXIT}    #goto next-case

                break
            fi
        else
            #Check if Pin-code
            pinCode_isValid=`pinCode_isNumeric__func "${pinCode_chosen}"`
            if [[ ${pinCode_isValid} == ${FALSE} ]]; then
                #Check if INTERACTIVE MODE is ENABLED
                if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                    tput cuu1
                    tput el

                    printf_pinCode_unknown_format="${FG_LIGHTBLUE}${PIN_CODE_INPUT}${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack): ${pinCode_chosen} ${ERRMSG_UNKNOWN_FORMAT}"
                    debugPrint__func "${EMPTYSTRING}" "${printf_pinCode_unknown_format}" "${EMPTYLINES_0}"
                else    #interactive-mode is DISABLED
                    errMsg_invalid_pinCode="INVALID ${PIN_CODE_INPUT} '${FG_LIGHTGREY}${pinCode_chosen}${NOCOLOR}'"
                    errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_invalid_pinCode}" "${TRUE}"
                fi
            else
                hcitool_handler_caseSelect=${HCITOOL_HANLDER_CASE_EXIT}    #goto next-case

                break
            fi
        fi
    done
}
function pinCode_isNumeric__func()
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


bluetoothctl_trust_and_pair__sub()
{
    #Define local variables
    local isPaired=${NO}
    local printf_isAlready_paired=${EMPTYSTRING}

    #Define printf message
    errmsg_unable_to_pair_with="${FG_LIGHTRED}UNABLE${NOCOLOR} TO PAIR WITH '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}'"
    printf_pairing_with_macAddr="---:PAIRING WITH '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}'"

    #Check for any currently PAIRED BT-devices
    isPaired=`checkIf_macAddr_isAlready_paired__func "${macAddr_chosen}"`

    if [[ ${isPaired} == ${YES} ]]; then    #already Paired
        printf_isAlready_paired="DEVICE '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}' IS ALREADY ${FG_GREEN}PAIRED${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_isAlready_paired}" "${EMPTYLINES_1}"

        return  #exit function
    else
        debugPrint__func "${PRINTF_START}" "${printf_pairing_with_macAddr}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_ENTERING}" "${PRINTF_BLUETOOTHCTL}" "${EMPTYLINES_0}"

        #Add an Empty Line
        printf '%b\n' ""
    fi

    #Trust and Pair LTPP3-G2 with the selected MAC-address
    ${tb_bt_sndpair_fpath} "${macAddr_chosen}" "${pinCode_chosen}" "${BLUETOOTHCTL_SCAN_TIMEOUT}" "${FALSE}"

    #Get the exit-code
    #REMARK: 
    #   script 'tb_bt_sndpair.sh' will output the following 2 exit-codes:
    #   0: successful
    #   99: error
    exitCode=$?
    if [[ ${exitCode} -eq 0 ]]; then
        debugPrint__func "${PRINTF_EXITING}" "${PRINTF_BLUETOOTHCTL}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_COMPLETED}" "${printf_pairing_with_macAddr}" "${EMPTYLINES_0}"       
    else    #exit-code=99
        #Add an Empty Line
        printf '%b\n' ""

        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_pair_with}" "${TRUE}"
    fi  
}
function checkIf_macAddr_isAlready_paired__func()
{
    #Input args
    local macAddr_input=${1}   

    #Define local variables
    local isPaired=${NO}

    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then #file exists
        #Check if chosen BT-device is already PAIRED (just use ' /tmp/bluetoothctl_bind_stat.tmp' )
        #   grep -w ${macAddr_input}: get result containing pattern 'macAddr_input'
        #   awk '{print $3}': get value of in 3rd column
        isPaired=`cat ${bluetoothctl_bind_stat_tmp_fpath} | grep -w ${macAddr_input} | awk '{print $3}'`
    fi

    #Output
    echo ${isPaired}
}

rfcomm_bind_handler__sub() {
    #Define local variables
    local isAlreadyBound=${EMPTYSTRING}
    local rfcommDevNum=${EMPTYSTRING}


    #FIRST: check if LTPP3-G2 is already BOUND to the selected MAC-address
    isAlreadyBound=`checkIf_macAddr_isAlreadyBound__func "${macAddr_chosen}"`
    if [[ ${isAlreadyBound} == ${YES} ]]; then    #already Bound
        local printf_isAlreadyBound="DEVICE '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}' IS ALREADY ${FG_GREEN}BOUND${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_isAlreadyBound}" "${EMPTYLINES_0}"

        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_EXITING_NOW}" "${EMPTYLINES_0}"
    else    #not bound
        #Get an available rfcomm-dev-number
        rfcommDevNum=`rfcomm_get_uniq_rfcommDevNum__func`

        #Bind to an available rfcomm-dev-number
        rfcomm_bind_uniq_rfcommDevNum_to_chosen_macAddr__func "${macAddr_chosen}" "${rfcommDevNum}"

        #Show BT-binding status (update)
        get_and_show_bt_bind_status__sub

        #Backup '/tmp/bluetoothctl_bind_stat.tmp' as '/var/backups/bluetoothctl_bind_stat.bck'
        backup_bluetoothctl_binding_status__func
    fi
    
    #Add an Empty Line
    printf '%b\n' ""
}
function checkIf_macAddr_isAlreadyBound__func()
{
    #Input args
    local macAddr_input=${1}   

    #Define local variables
    local isAlreadyBound=${NO}

    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then #file exists
        #Check if chosen BT-device is already PAIRED (just use ' /tmp/bluetoothctl_bind_stat.tmp' )
        #   grep -w ${macAddr_input}: get result containing pattern 'macAddr_input'
        #   awk '{print $4}': get value of in 4rd column
        isAlreadyBound=`cat ${bluetoothctl_bind_stat_tmp_fpath} | grep -w ${macAddr_input} | awk '{print $4}' 2>&1`
    fi

    #Output
    echo ${isAlreadyBound}
}
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
    local rfcommDevNum_input=${2}   

    #Define local variables
    local mac_isFound=${EMPTYSTRING}
    local retry_param=0
    local RETRY_MAX=10

    #Define printf messages
    errmsg_unable_to_bind_macAddr_to_rfcommDevNum="${FG_LIGHTRED}UNABLE${NOCOLOR} TO BIND '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${rfcommDevNum_input}${NOCOLOR}'"
    printf_binding_macAddr_to_rfcommDevNum="BINDING '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${rfcommDevNum_input}${NOCOLOR}'"

    #Print message
    debugPrint__func "${PRINTF_START}" "${printf_binding_macAddr_to_rfcommDevNum}" "${EMPTYLINES_1}"

    #Start Binding and Run in the BACKGROUND
    ${RFCOMM_CMD} bind ${dev_dir}/${rfcommDevNum_input} ${macAddr_input} 2>&1 > /dev/null &
    
    #Get exit-code
    exitCode=$?
    if [[ ${exitCode} -eq 0 ]]; then    #command was executed successfully
        #This while-loop acts as a waiting time allowing the command to finish its execution process
        while [[ -z ${mac_isFound} ]]
        do
            mac_isFound=`${RFCOMM_CMD} | grep -w ${macAddr_input}`  #get PID

            sleep 1 #if no PID found yet, sleep for 1 second

            retry_param=$((retry_param+1))  #increment retry paramter

            #a Maxiumum of 10 retries is allowed
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum retries has been exceeded
                break
            fi
        done

        if [[ ! -z ${mac_isFound} ]]; then    #contains data
            #Print
            debugPrint__func "${PRINTF_COMPLETED}" "${printf_binding_macAddr_to_rfcommDevNum}" "${EMPTYLINES_0}"
        else    #contains NO data
            errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}" "${TRUE}"
        fi
    else    #exit-code!=0
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}" "${TRUE}"
    fi
}

backup_bluetoothctl_binding_status__func()
{
    #Copy file from '/tmp' to '/var/backups'
    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then #file exists
        cp ${bluetoothctl_bind_stat_tmp_fpath} ${bluetoothctl_bind_stat_bck_fpath}
    fi
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub

    init_variables__sub

    dynamic_variables_definition__sub

    input_args_case_select__sub
    
    software_inst__sub

    get_and_show_bt_bind_status__sub

    hcitool_handler__sub

    bluetoothctl_trust_and_pair__sub

    rfcomm_bind_handler__sub
}



#---EXECUTE
main__sub
