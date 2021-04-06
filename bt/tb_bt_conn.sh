#!/bin/bash
#---INPUT ARGS
#To run this script in interactive-mode, do not provide any input arguments
macAddr_input=${1}      #optional
pinCode_input=${2}      #optional



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
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFLIGHTRED=$'\e[30;38;5;131m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
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

MAC_ADDRESS="MAC-ADDRESS"
PIN_CODE="PIN-CODE"

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

ONE_SPACE=" "
TWO_SPACES="${ONE_SPACE}${ONE_SPACE}"
FOUR_SPACES="${TWO_SPACES}${TWO_SPACES}"
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=2

EXITCODE_98=98  #pin-code error
EXITCODE_99=99

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

PREPEND_EMPTYLINES_0=0
PREPEND_EMPTYLINES_1=1



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



#---PATTERN CONSTANTS
PATTERN_BRCM_PATCHRAM_PLUS="brcm_patchram_plus"
PATTERN_GREP="grep"
PATTERN_DONE_SETTING_LINE_DISCIPLINE="Done setting line discpline"
SCREEN_PATTERN="screen"



#---HEADER PRINT CONSTANTS
PRINTF_COMPLETED="COMPLETED:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_FOUND="FOUND:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WARNING="WARNING:"

#---ERROR MESSAGE CONSTANTS
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."

ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_NOT_ENOUGH_INPUT_ARGS="NOT ENOUGH INPUT ARGS (${argsTotal} out-of ${ARGSTOTAL_MAX})"
ERRMSG_OCCURRED_IN_FILE="OCCURRED IN FILE:"

#---PRINT CONSTANTS
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"
PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE="Press (a)bort or any key to continue..."
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to setup WiFi-interface and establish connection."

PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES="SCANNING FOR *AVAILABLE* BT-DEVICES"

#---QUESTION PRINT CONSTANTS
QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE="${FG_DARKBLUE}PIN-CODE IS AN ${FG_LIGHTBLUE}EMPTYSTRING${NOCOLOR}, ${FG_DARKBLUE}CONTINUE ANYWAYS (y/n)? ${NOCOLOR}"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_unknown_option="UNKNOWN OPTION: '${arg1}'"
}



#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    tb_bt_sndpair_filename="tb_bt_sndpair.sh"
    tb_bt_sndpair_fpath=${thisScript_current_dir}/${tb_bt_sndpair_filename}

    tmp_dir=/tmp
    hcitool_scan_tmp_filename="hcitool_scan.tmp"
    hcitool_scan_tmp_fpath=${tmp_dir}/${hcitool_scan_tmp_filename}
}



#---FUNCTIONS
press_any_key__func() {
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
    printf '%s%b\n' "${FG_ORANGE}${topic}${NOCOLOR} ${msg}"
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
    local stdOutput=`apt-mark showinstall | grep ${software_input}`

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
                input_args_print_unknown_option__sub

                exit 0
            elif [[ ${argsTotal} -gt ${ARGSTOTAL_MIN} ]]; then  #at more than 1 input arg provided
                if [[ ${argsTotal} -ne ${ARGSTOTAL_MAX} ]]; then    #not all input args provided
                    input_args_print_incomplete_args__sub

                    exit 0
                fi
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
        "Usage #3: ${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} \"${FG_LIGHTGREY}arg1${NOCOLOR}\" \"${FG_LIGHTGREY}arg2${NOCOLOR}\""
        ""
        "${FOUR_SPACES}arg1${TAB_CHAR}${TAB_CHAR}Target Device BT-${FG_LIGHTPINK}MAC${NOCOLOR}-address."
        "${FOUR_SPACES}arg2${TAB_CHAR}${TAB_CHAR}Target Device BT-${FG_LIGHTPINK}PIN${NOCOLOR}-code."
        ""
        "${FOUR_SPACES}REMARKS:"
        "${FOUR_SPACES}${FOUR_SPACES}- Make sure to surround each argument with ${FG_SOFLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFLIGHTRED}\"${NOCOLOR}."
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

input_args_print_incomplete_args__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NOT_ENOUGH_INPUT_ARGS}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${PREPEND_EMPTYLINES_1}"
}

software_inst__sub()
{
    #Define local variable
    local screen_isInstalled=`checkIf_software_isInstalled__func "${SCREEN_PATTERN}"`
    
    #Check if 'screen' is already installed
    #If FALSE, then install 'screen'
    #REMARK:
    #   'screen' will be used to connect the LTPP3-G2 to another BT-device
    if [[ ${screen_isInstalled} == ${FALSE} ]]; then #contains NO data
        debugPrint__func "${PRINTF_INSTALLING}" "${SCREEN_PATTERN}" "${PREPEND_EMPTYLINES_1}"

        DEBIAN_FRONTEND=noninteractive apt-get -y install screen    #will be needed to enable rfcomm
    fi
}

hcitool_handler__sub()
{
    debugPrint__func "${PRINTF_START}" "${PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES}" "${PREPEND_EMPTYLINES_1}"

    hcitool_choose_device__func

    hcitool_pincode_input__func


    ${tb_bt_sndpair_fpath} "${macAddr_input}" "${pinCode_input}" "${BLUETOOTHCTL_SCAN_TIMEOUT}"
    exitCode=$? #get exit-code to check if the above command was executed successfully
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_OCCURRED_IN_FILE} ${FG_LIGHTGREY}${tb_bt_sndpair_fpath}${NOCOLOR}" "${TRUE}"
    fi  




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

    #Get scan result and write to file
    hcitool scan | tail -n+2 > ${hcitool_scan_tmp_fpath}
}

function hcitool_show_scanList__func()
{
    #Define local variables
    local devName=${EMPTYSTRING}
    local macAddr=${EMPTYSTRING}

    #Print empty line
    printf '%b%s\n' ""
    
    #Get Device-Name (2nd column of file)
    cat ${hcitool_scan_tmp_fpath} | awk -v VAR1="${EIGHT_SPACES}" '{ printf "%s %-20s %-20s\n", VAR1, $2, $1 }'
}

function hcitool_choose_device__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${macAddr_input} != ${EMPTYSTRING} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        return
    fi

    #Define local variables
    local macAddr_matched=${EMPTYSTRING}
    local debugMsg=${EMPTYSTRING}

    #Get Available SSIDs
    hcitool_get_scanList__func

    #Show Available SSIDs
    hcitool_show_scanList__func

    #Select a Device to connect to
    while true
    do
        #Print empty line
        printf '%b%s\n' ""
        
        read -p "${FG_LIGHTBLUE}${MAC_ADDRESS}${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): " macAddr_input #provide your input
        if [[ ! -z ${macAddr_input} ]]; then   #input was NOT an empty string
            if [[ ${macAddr_input} == ${INPUT_REFRESH} ]]; then
                #Get Available BT-devices
                hcitool_get_scanList__func

                #Show Available BT-devices
                hcitool_show_scanList__func
            else
                macAddr_matched=`cat ${hcitool_scan_tmp_fpath} | awk '{print $1}' | grep -w "${macAddr_input}"`
                if [[ ! -z ${macAddr_matched} ]]; then #SSID was found in the 'ssidList_string'
                    tput cuu1
                    tput el

                    printf '%b%s\n' "${FG_LIGHTBLUE}${MAC_ADDRESS}${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh): ${macAddr_matched}"

                    break
                else    #SSID was NOT found in the 'ssidList_string'
                    printf_invalid_device_name="INVALID ${MAC_ADDRESS} '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}'"
                    debugPrint__func "${PRINTF_WARNING}" "${printf_invalid_device_name}" "${PREPEND_EMPTYLINES_1}"

                    press_any_key__func

                    clear_lines__func "${NUMOF_ROWS_5}"
                fi
            fi
        else    #input was an EMPTY STRING
            clear_lines__func "${NUMOF_ROWS_2}"
        fi
    done
}

function hcitool_pincode_input__func()
{
    #Check if NON-INTERACTIVE MODE is ENABLED
    if [[ ${pinCode_input} != ${EMPTYSTRING} ]]; then   #variable is already set as input arg (NOT an EMPTY STRING)
        return
    fi

    #Pin-code input
    while true
    do
        read -p "${FG_LIGHTBLUE}${PIN_CODE}${NOCOLOR}: " pinCode_input #provide your input
        if [[ ! -z ${pinCode_input} ]]; then   #input was NOT an empty string
            break
        else    #input was an EMPTY STRING
            while true
            do
                read -N1 -e -p "${QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE}" myChoice
                if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                    if [[ ${myChoice} == ${INPUT_YES} ]]; then
                        return
                    else
                        if [[ ${myChoice} == ${INPUT_NO} ]]; then
                            break
                        fi
                    fi
                else
                    clear_lines__func "${NUMOF_ROWS_1}"
                fi
            done
        fi
    done
}

connect_to_bt_device_handler__sub() {
    echo -e "still need to code this part"
    echo -e "funct 'tb_bt_sndpair_fpath' should return an exitcode when it fails so that this part will NOT be excuted"
}


#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub

    init_variables__sub

    input_args_case_select__sub

    dynamic_variables_definition__sub

    software_inst__sub

    hcitool_handler__sub

    connect_to_bt_device_handler__sub   #Still need to code this!!!
}




#---EXECUTE
main__sub
