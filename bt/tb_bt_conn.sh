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
SEMICOLON_CHAR=";"
SLASH_CHAR="/"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"
TAB_CHAR=$'\t'

ONE_SPACE=" "
TWO_SPACES="${ONE_SPACE}${ONE_SPACE}"
FOUR_SPACES="${TWO_SPACES}${TWO_SPACES}"
EIGHT_SPACES="${FOUR_SPACES}${FOUR_SPACES}"

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
BLUETOOTHCTL_CMD="bluetoothctl"
HCICONFIG_CMD="hciconfig"
HCITOOL_CMD="hcitool"
PGREP_CMD="pgrep"
RFCOMM_CMD="rfcomm"
RFCOMM_CHANNEL_1="1"
SYSTEMCTL_CMD="systemctl"

BT_TTYSX_LINE="\/dev\/ttyS4"
BT_BAUDRATE=9600
BLUETOOTHCTL_SCAN_TIMEOUT=10

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

#---RETRY CONSTANTS
RETRY_MAX=10

#---TIMEOUT CONSTANTS
SLEEP_TIMEOUT=1

#---READ INPUT CONSTANTS
INPUT_BACK="b"
INPUT_NO="n"
INPUT_YES="y"
INPUT_QUIT="q"
INPUT_REFRESH="r"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

ENABLED="enabled"
ACTIVE="active"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

ON="on"
OFF="off"

YES="yes"
NO="no"

PRECHECK_OK="OK"
PRECHECK_PRESENT="PRESENT"
PRECHECK_MISSING="MISSING"
PRECHECK_ENABLED="ENABLED"
PRECHECK_FAILEDTOENABLE="FAILED TO ENABLE"
PRECHECK_RUNNING="RUNNING"
PRECHECK_UNABLETOSTART="UNABLE TO START"

#---PATTERN CONSTANTS
MODPROBE_BLUETOOTH="bluetooth"
MODPROBE_HCI_UART="hci_uart"
MODPROBE_RFCOMM="rfcomm"
MODPROBE_BNEP="bnep"
MODPROBE_HIDP="hidp"

PATTERN_BRCM_PATCHRAM_PLUS="brcm_patchram_plus"
PATTERN_GREP="grep"
PATTERN_DONE_SETTING_LINE_DISCIPLINE="Done setting line discpline"
PATTERN_BLUEZ="bluez"

PATTERN_BLUETOOTH="bluetooth"
PATTERN_HCI_UART="hci_uart"
PATTERN_RFCOMM="rfcomm"
PATTERN_BNEP="bnep"
PATTERN_HIDP="hidp"

#---CASE-SELECT CONSTANTS
HCITOOL_HANDLER_CASE_CHOOSE_MACADDR="CHOOSE MAC-ADDRESS"
HCITOOL_HANDLER_CASE_PINCODE_INPUT="PIN-CODE INPUT"
HCITOOL_HANDLER_CASE_EXIT="EXIT"



#---PRINTF WIDTHS
PRINTF_DEVNAME_WIDTH="%-25s"
PRINTF_MACADDR_WIDTH="%-20s"

#---PRINTF HEADERS
PRINTF_HEADER_DEVNAME="NAME"
PRINTF_HEADER_MACADDR="MAC"



#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_ARG1_CANNOT_BE_EMPTYSTRING="INPUT '${FG_YELLOW}ARG1${NOCOLOR}' CAN NOT BE AN *EMPTY STRING*"
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_OCCURRED_IN_FILE="OCCURRED IN FILE:"
ERRMSG_NOT_LISTED="(${FG_LIGHTRED}Not listed${NOCOLOR})"
ERRMSG_UNKNOWN_FORMAT="(${FG_LIGHTRED}Unknown format${NOCOLOR})"
ERRMSG_UNMATCHED_INPUT_ARGS="UNMATCHED INPUT ARGS (${FG_YELLOW}${argsTotal}${NOCOLOR} out-of ${FG_YELLOW}${ARGSTOTAL_MAX}${NOCOLOR})"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_FOR_HELP_PLEASE_RUN="FOR HELP, PLEASE RUN COMMAND '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Pair & Bind bluetooth-device(s) to rfcomm."



#---PRINTF PHASES
PRINTF_COMPLETED="COMPLETED:"
PRINTF_COMPONENTS="COMPONENTS:"
PRINTF_ENTERING="ENTERING:"
PRINTF_EXITING="EXITING:"
PRINTF_FOUND="FOUND:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_WARNING="${FG_PURPLERED}WARNING${NOCOLOR}:"

#---PRINTF ERROR MESSAGES
ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE="A ${FG_LIGHTGREY}REBOOT${NOCOLOR} MAY SOLVE THIS ISSUE"
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---PRINTF MESSAGES
PRINTF_INTERACTIVE_MODE_IS_ENABLED="INTERACTIVE-MODE IS ${FG_GREEN}ENABLED${NOCOLOR}"

PRINTF_BLUETOOTHCTL="${FG_BLUETOOTHCTL_DARKBLUE}${BLUETOOTHCTL_CMD}${NOCOLOR} (non-interactive mode)"
PRINTF_BLUEZ="BLUEZ"
PRINTF_BLUEZ_BLUETOOTHCTL="BLUETOOTHCTL"
PRINTF_BLUEZ_HCICONFIG="HCICONFIG"
PRINTF_BLUEZ_HCITOOL="HCITOOL"
PRINTF_BLUEZ_RFCOMM="RFCOMM"
PRINTF_BT_INTERFACE_DOWN_DETECTED="BT *INTERFACE* ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR} DETECTED"
PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES="SCANNING FOR *AVAILABLE* BT-DEVICES"
PRINTF_CHECKING_BT_INTERFACE_STATE="---:CHECKING BT *INTERFACE* STATE"
PRINTF_RESTARTING_BLUETOOTH_SERVICE="---:RESTARTING '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}'"


PRINTF_EXITING_NOW="EXITING NOW..."

#---QUESTION MESSAGES
QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE="PIN-CODE IS AN ${FG_LIGHTBLUE}EMPTYSTRING${NOCOLOR}, CONTINUE ANYWAYS (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
dynamic_variables_definition__sub()
{
    errmsg_unknown_option="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"
    errmsg_occurred_in_file_tb_bt_conn_info="OCCURRED IN FILE: ${FG_LIGHTGREY}${tb_bt_conn_info_filename}${NOCOLOR}"
    errMsg_please_reboot_and_run_script="PLEASE ${FG_LIGHTGREY}REBOOT${NOCOLOR} AND RUN SCRIPT '${FG_LIGHTGREY}${tb_bt_inst_filename}${NOCOLOR}'"
}



#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    tb_bt_inst_filename="tb_bt_inst.sh"

    # tb_bt_updown_filename="tb_bt_updown.sh"
    # tb_bt_updown_fpath=${current_dir}/${tb_bt_updown_filename}

    tb_bt_conn_info_filename="tb_bt_conn_info.sh"
    tb_bt_conn_info_fpath=${thisScript_current_dir}/${tb_bt_conn_info_filename}

    tb_bt_sndpair_filename="tb_bt_sndpair.sh"
    tb_bt_sndpair_fpath=${thisScript_current_dir}/${tb_bt_sndpair_filename}

    tb_bt_firmware_service_filename="tb_bt_firmware.service"
    bluetooth_service_filename="bluetooth.service"
    rfcomm_onBoot_bind_service_filename="rfcomm_onBoot_bind.service"

    dev_dir=/dev
    usr_bin_dir=/usr/bin

    tmp_dir=/tmp
    hcitool_scan_tmp_filename="hcitool_scan.tmp"
    hcitool_scan_tmp_fpath=${tmp_dir}/${hcitool_scan_tmp_filename}

    bluetoothctl_bind_stat_tmp_filename="bluetoothctl_bind_stat.tmp"
    bluetoothctl_bind_stat_tmp_fpath=${tmp_dir}/${bluetoothctl_bind_stat_tmp_filename}

    tb_bt_conn_info_intf_names_tmp_filename="tb_bt_conn_info_intf_names.tmp"
    tb_bt_conn_info_intf_names_tmp_fpath=${tmp_dir}/${tb_bt_conn_info_intf_names_tmp_filename}
}



#---FUNCTIONS
function press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=5

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
    preCheck_numOf_failed=0
    trapDebugPrint_isEnabled=${FALSE}

    #Variable which will be used in script 'tb_bt_conn_info_fpath'
    #Initially set to an EMPTYSTIRNG
    imported_btState=${EMPTYSTRING}

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
        "${FOUR_SPACES}- Do NOT forget to ${FG_SOFTLIGHTRED}\"${NOCOLOR}double quotes${FG_SOFTLIGHTRED}\"${NOCOLOR} each argument."
        "${FOUR_SPACES}- PIN-code input can be an ${FG_SOFTLIGHTRED}\"${NOCOLOR}empty string${FG_SOFTLIGHTRED}\"${NOCOLOR}."
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

preCheck_handler__sub()
{
    #Define local constants
    local ERRMSG_ONE_OR_MORE_OBJECTS_WERE_MISSING="ONE OR MORE OBJECTS WERE ${FG_LIGHTRED}${PRECHECK_MISSING}${NOCOLOR}..."
    local ERRMSG_IS_BT_INSTALLED_PROPERLY="IS BT *INSTALLED* PROPERLY?"
    local PRINTF_PRECHECK="PRE-CHECK:"
    local PRINTF_MODULE_SOFTWARE_SERVICES_AVAILABILITY="MODULE, SOFTWARE, AND SERVICES AVAILABILITY"

    #Reset variable
    preCheck_numOf_failed=0

    #Print
    debugPrint__func "${PRINTF_PRECHECK}" "${PRINTF_MODULE_SOFTWARE_SERVICES_AVAILABILITY}" "${EMPTYLINES_1}"

    #Pre-check
    mods_preCheck_arePresent__func
    software_preCheck_isInstalled__func
    services_preCheck__func
    intf_preCheck_isPresent__func

    #Check if there any 'failed' was found
    if [[ ${preCheck_numOf_failed} -ne 0 ]]; then
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_ONE_OR_MORE_OBJECTS_WERE_MISSING}" "${FALSE}"
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_IS_BT_INSTALLED_PROPERLY}" "${TRUE}"        
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
        printf_toBeShown="${FG_LIGHTGREY}${mod_name}${NOCOLOR}: ${FG_GREEN}${PRECHECK_OK}${NOCOLOR}"
    else    #contains NO data
        printf_toBeShown="${FG_LIGHTGREY}${mod_name}${NOCOLOR}: ${FG_LIGHTRED}${PRECHECK_MISSING}${NOCOLOR}"

        preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
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
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_GREEN}${PRECHECK_OK}${NOCOLOR}" 
    else
        printf_toBeShown="${FG_LIGHTGREY}${PATTERN_BLUEZ}${NOCOLOR}: ${FG_LIGHTRED}${PRECHECK_MISSING}${NOCOLOR}"

        preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
    fi
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
}
function services_preCheck__func()
{
    services_preCheck_and_takeAction__func "${tb_bt_firmware_service_filename}"
    services_preCheck_and_takeAction__func "${bluetooth_service_filename}"
    services_preCheck_and_takeAction__func "${rfcomm_onBoot_bind_service_filename}"
}
function services_preCheck_and_takeAction__func()
{
    #Input args
    local service_input=${1}  

    #Define local constants
    local FOUR_DOTS="...."
    local EIGHT_DOTS=${FOUR_DOTS}${FOUR_DOTS}
    local TWELVE_DOTS=${FOUR_DOTS}${EIGHT_DOTS}


    #Check if the services are present
    #REMARK: if a service is present then it means that...
    #........its corresponding variable would CONTAIN DATA.
    local printf_toBeShown=${EMPTYSTRING}
    local service_isPresent=${FALSE}
    local service_isEnabled=${FALSE}
    local service_doublecheck_isEnabled=${FALSE}
    local service_isActive=${FALSE}
    local service_doublecheck_isActive=${FALSE}

    #Print
    printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}:"
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

    #systemctl status <service>
    #All services should be always present after the Bluetooth Installation
    service_isPresent=`checkIf_service_isPresent__func "${service_input}"`
    if [[ ${service_isPresent} == ${TRUE} ]]; then
        statusVal=${FG_GREEN}${PRECHECK_PRESENT}${NOCOLOR}
        printf_toBeShown="${FG_LIGHTGREY}${FOUR_DOTS}${NOCOLOR}${statusVal}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    else    #service is NOT started
        preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
        
        clear_lines__func "${NUMOF_ROWS_1}"

        statusVal=${FG_LIGHTRED}${PRECHECK_MISSING}${NOCOLOR}
        printf_toBeShown="${FG_LIGHTGREY}${service_input}${NOCOLOR}: ${FG_LIGHTRED}${PRECHECK_MISSING}${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        return  #exit function
    fi


    #systemctl is-enabled <service>
    service_isEnabled=`checkIf_service_isEnabled__func "${service_input}"`  #check if 'is-enabled'
    if [[ ${service_isEnabled} == ${TRUE} ]]; then
        statusVal=${FG_GREEN}${PRECHECK_ENABLED}${NOCOLOR}
    else
        #TRY to ENABLE service
        ${SYSTEMCTL_CMD} ${ENABLE} ${service_input}

        service_doublecheck_isEnabled=`checkIf_service_isEnabled__func "${service_input}"`  #double-check if 'is-enabled'
        if [[ ${service_doublecheck_isEnabled} == ${TRUE} ]]; then  #service could be enabled
            statusVal=${FG_GREEN}${PRECHECK_ENABLED}${NOCOLOR}  
        else    #service could NOT be enabled
            statusVal=${FG_LIGHTRED}${PRECHECK_DISABLED}${NOCOLOR}

            preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
        fi
    fi
    printf_toBeShown="${FG_LIGHTGREY}${EIGHT_DOTS}${NOCOLOR}${statusVal}"
    debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"


    #systemctl is-active <service>
    #If service=rfcomm_onBoot_bind.service, do NOT check if service is-active
    if [[ ${service_input} != ${rfcomm_onBoot_bind_service_filename} ]]; then
        service_isActive=`checkIf_service_isActive__func "${service_input}"`  #check if 'is-active'
        if [[ ${service_isActive} == ${TRUE} ]]; then   #service is started
            statusVal=${FG_GREEN}${PRECHECK_RUNNING}${NOCOLOR}      
        else    #service is NOT started
            #TRY to START service
            ${SYSTEMCTL_CMD} ${START} ${service_input}  

            service_doublecheck_isActive=`checkIf_service_isActive__func "${service_input}"`  #double-check if 'is-active'
            if [[ ${service_doublecheck_isActive} == ${TRUE} ]]; then   #service could be started
                statusVal=${FG_GREEN}${PRECHECK_RUNNING}${NOCOLOR}
            else    #service could NOT be started
                preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed

                statusVal=${FG_LIGHTRED}${PRECHECK_STOPPED}${NOCOLOR}
            fi
        fi

        printf_toBeShown="${FG_LIGHTGREY}${TWELVE_DOTS}${NOCOLOR}${statusVal}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi
}
function checkIf_service_isPresent__func() {
    #Input args
    local service_input=${1}

    #Define local constants
    local PATTERN_COULD_NOT_BE_FOUND="could not be found"

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
    local printf_toBeShown=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}

    #Check if 'hciconfig' is installed
    stdOutput=`ls -l ${usr_bin_dir} | grep "${HCICONFIG_CMD}"`
    if [[ -z ${stdOutput} ]]; then  #contains NO data (which means that bluez is NOT installed)
        printf_toBeShown="${FG_LIGHTGREY}${HCICONFIG_CMD}${NOCOLOR}: ${FG_LIGHTRED}MISSING${NOCOLOR}${FG_LIGHTGREY}...DEPENDS ON${NOCOLOR} ${FG_BLUETOOTHCTL_DARKBLUE}'BLUEZ'${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"

        preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
    else
        #Get for available BT-interfaces
        stdOutput=`${HCICONFIG_CMD}`  
        if [[ ! -z ${stdOutput} ]]; then   #contains data (at least one interface is present)
            printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_GREEN}${PRECHECK_OK}${NOCOLOR}"
        else    #contains no data (no interface present)
            printf_toBeShown="${FG_LIGHTGREY}${BT_INTERFACE}${NOCOLOR}: ${FG_LIGHTRED}MISSING${NOCOLOR}"

            preCheck_numOf_failed=$((preCheck_numOf_failed+1))  #accumulate the number of failed
        fi

        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_toBeShown}" "${EMPTYLINES_0}"
    fi
}

get_intf_state_and_show_conn_info__func()
{
    #Define local variables
    local line=${EMPTYSTRING}
    local errmsg_unable_to_bring_up_bt_interface=${EMPTYSTRING}
    local printf_interface_is_up=${EMPTYSTRING}
    local retry_param=1

    #Execute script to get Bluetooth-connection Information
    #Bluetooth information is written to 2 files:
    #1. /tmp/bluetootctl_info.tmp (not used in this script)
    #2. /tmp/bluetoothctl_bind_stat.tmp, which is used by the functions:
	#       - hcitool_checkIf_macAddr_isPresent__func
	#       - checkIf_macAddr_isAlready_paired__func
	#       - checkIf_macAddr_isAlreadyBound__func
    ${tb_bt_conn_info_fpath}

    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then
        errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_occurred_in_file_tb_bt_conn_info}" "${TRUE}"
    fi

    #Check if file exist
    #REMARK: if TRUE, then it means that at least one BT-interface is DOWN
    if [[ -f ${tb_bt_conn_info_intf_names_tmp_fpath} ]]; then
        #Restart 'bluetoot.service' 
        #REMARK: by restarting this service, the BT-interface(s) which were down will would be brought UP
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_INTERFACE_DOWN_DETECTED}" "${EMPTYLINES_1}"
        debugPrint__func "${PRINTF_START}" "${PRINTF_RESTARTING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"
        
        ${SYSTEMCTL_CMD} restart ${bluetooth_service_filename}
        
        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_RESTARTING_BLUETOOTH_SERVICE}" "${EMPTYLINES_0}"

        #START: Checking BT-interface's state
        debugPrint__func "${PRINTF_START}" "${PRINTF_CHECKING_BT_INTERFACE_STATE}" "${EMPTYLINES_0}"

        #Read each line of file
        while read line
        do
            #Wait for a no longer than a specified maximum number of seconds
            while true
            do
                #Check BT-interface's state
                stdOutput=`${HCICONFIG_CMD} ${line} | grep "${STATUS_UP}"`
                if [[ ! -z ${stdOutput} ]]; then    #contains data
                    printf_interface_is_up="BT *INTERFACE* '$FG_LIGHTGREY${line}${NOCOLOR}' IS ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
                    debugPrint__func "${PRINTF_STATUS}" "${printf_interface_is_up}" "${EMPTYLINES_0}"

                    break   #exit this loop
                else    #contains NO data
                    if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum retry has been reached
                        errmsg_unable_to_bring_up_bt_interface="UNABLE TO BRING UP BT *INTERFACE* '$FG_LIGHTGREY${line}${NOCOLOR}'"
                        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_bring_up_bt_interface}" "${FALSE}"
                        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_A_REBOOT_MAY_SOLVE_THIS_ISSUE}" "${TRUE}"

                        break   #exit this loop
                    fi
                fi

                sleep ${SLEEP_TIMEOUT}  #wait for a specified number of second(s)

                retry_param=$((retry_param+1))  #increment parameter
            done
        done < ${tb_bt_conn_info_intf_names_tmp_fpath}

        debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_CHECKING_BT_INTERFACE_STATE}" "${EMPTYLINES_0}"
    fi
}

hcitool_handler__sub()
{
    #Initial values
    hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_CHOOSE_MACADDR}

    while true
    do
        case ${hcitool_handler_caseSelect} in
            ${HCITOOL_HANDLER_CASE_CHOOSE_MACADDR})
                hcitool_choose_macAddr__func
                ;;

            ${HCITOOL_HANDLER_CASE_PINCODE_INPUT})
                hcitool_pincode_input__func
                ;;
            
            ${HCITOOL_HANDLER_CASE_EXIT})
                break
                ;;
        esac        
    done
}

function hcitool_choose_macAddr__func()
{
    #Define local constants
    local READMSG_MACADDRESS_INPUT="${FG_LIGHTBLUE}MAC-ADDRESS INPUT${NOCOLOR} (${FG_YELLOW}r${NOCOLOR}efresh, ${FG_YELLOW}q${NOCOLOR}uit):"

    #Define local variables
    local macAddr_chosen_raw=${EMPTYSTRING}
    local macAddr_isPresent=${FALSE}
    local macAddr_isValid=${FALSE}
    local debugMsg=${EMPTYSTRING}
    local readMsg=(${FG_YELLOW}r${NOCOLOR}efresh, ${FG_YELLOW}q${NOCOLOR}uit):""

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
            read -e -p "${READMSG_MACADDRESS_INPUT} " macAddr_chosen_raw #provide your input
        else    #interactive-mode is DISABLED
            #Update variable
            #REMARK: input arg 'macAddr_chosen' is RAW-DATA and must be CLEANED and VALIDATED
            macAddr_chosen_raw=${macAddr_chosen}
        fi

        if [[ ! -z ${macAddr_chosen_raw} ]]; then   #input was NOT an empty string
            if [[ ${macAddr_chosen_raw} == ${INPUT_QUIT} ]]; then
                exit 0
            elif [[ ${macAddr_chosen_raw} == ${INPUT_REFRESH} ]]; then
                hcitool_get_and_show_scanList__func
            else
                #Cleanup MAC-address
                #REMARK: this means removing all UNWANTED chars
                macAddr_chosen=`macAddr_cleanup__func "${macAddr_chosen_raw}"`

                #Validate MAC-address
                macAddr_isValid=`macAddr_format_isValid__func "${macAddr_chosen}"`
                if [[ ${macAddr_isValid} == ${FALSE} ]]; then   #unknown format
                    #Check if INTERACTIVE MODE is ENABLED
                    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                        clear_lines__func "${NUMOF_ROWS_1}"

                        printf_macAddr_unknown_format="${READMSG_MACADDRESS_INPUT} ${macAddr_chosen_raw} ${ERRMSG_UNKNOWN_FORMAT}"
                        debugPrint__func "${EMPTYSTRING}" "${printf_macAddr_unknown_format}" "${EMPTYLINES_0}"
                    else    #interactive-mode is DISABLED
                        errMsg_invalid_macAddr="INVALID MAC-ADDRESS INPUT '${FG_LIGHTGREY}${macAddr_chosen}${NOCOLOR}'"
                        errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_invalid_macAddr}" "${TRUE}"
                    fi
                else    #format is valid
                    #Check if INTERACTIVE MODE is ENABLED
                    if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                        macAddr_isPresent=`hcitool_checkIf_macAddr_isPresent__func "${macAddr_chosen}"`
                        if [[ ${macAddr_isPresent} == ${TRUE} ]]; then  #MAC-address was found
                            clear_lines__func "${NUMOF_ROWS_1}"

                            printf '%b%s\n' "${READMSG_MACADDRESS_INPUT} ${macAddr_chosen}"

                            hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_PINCODE_INPUT}    #goto next-case

                            break
                        else    #MAC-address was NOT found
                            clear_lines__func "${NUMOF_ROWS_1}"

                            printf_macAddr_unknown_format="${READMSG_MACADDRESS_INPUT} ${macAddr_chosen_raw} ${ERRMSG_NOT_LISTED}"
                            debugPrint__func "${EMPTYSTRING}" "${printf_macAddr_unknown_format}" "${EMPTYLINES_0}"
                        fi
                    else
                        hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_PINCODE_INPUT}    #goto next-case

                        break
                    fi
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
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SCANNING_FOR_AVAILABLE_BT_DEVICES}" "${EMPTYLINES_1}"
    
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
function macAddr_format_isValid__func()
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
    #Define local constants
    local READMSG_PINCODE_INPUT="${FG_LIGHTBLUE}PIN-CODE INPUT${NOCOLOR} (${FG_YELLOW}b${NOCOLOR}ack, ${FG_YELLOW}q${NOCOLOR}uit):"

    #Define local variables
    local pinCode_isValid=${FALSE}

    #Pin-code input
    while true
    do
        #Check if INTERACTIVE MODE is ENABLED
        if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED            
            #Show read-input
            read -e -p "${READMSG_PINCODE_INPUT} " pinCode_chosen #provide your input
        fi

        if [[ ${pinCode_chosen} == ${INPUT_QUIT} ]]; then
            exit 0
        elif [[ ${pinCode_chosen} == ${INPUT_BACK} ]]; then
            hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_CHOOSE_MACADDR}    #goto next-case

            break
        elif [[ ${pinCode_chosen} == ${EMPTYSTRING} ]]; then   #input was an EMPTY STRING
            #Check if INTERACTIVE MODE is ENABLED
            if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED              
                while true
                do
                    read -N1 -e -p "${QUESTION_PINCODE_IS_AN_EMPTYSTRING_CONTINUE}" myChoice
                    if [[ ${myChoice} =~ [${INPUT_YES},${INPUT_NO}] ]]; then
                        if [[ ${myChoice} == ${INPUT_YES} ]]; then
                            hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_EXIT}    #goto next-case

                            return
                        else
                            if [[ ${myChoice} == ${INPUT_NO} ]]; then
                                hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_PINCODE_INPUT}    #goto next-case

                                break
                            fi
                        fi
                    else    #interactive-mode is DISABLED
                        clear_lines__func "${NUMOF_ROWS_1}"
                    fi
                done
            else
                hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_EXIT}    #goto next-case

                break
            fi
        else
            #Check if Pin-code
            pinCode_isValid=`pinCode_isNumeric__func "${pinCode_chosen}"`
            if [[ ${pinCode_isValid} == ${FALSE} ]]; then
                #Check if INTERACTIVE MODE is ENABLED
                if [[ ${interactive_isEnabled} == ${TRUE} ]]; then #interactive-mode is ENABLED
                    clear_lines__func "${NUMOF_ROWS_1}"

                    printf_pinCode_unknown_format="${READMSG_PINCODE_INPUT} ${pinCode_chosen} ${ERRMSG_UNKNOWN_FORMAT}"
                    debugPrint__func "${EMPTYSTRING}" "${printf_pinCode_unknown_format}" "${EMPTYLINES_0}"
                else    #interactive-mode is DISABLED
                    errMsg_invalid_pinCode="INVALID PIN-CODE INPUT '${FG_LIGHTGREY}${pinCode_chosen}${NOCOLOR}'"
                    errExit__func "${TRUE}" "${EXITCODE_99}" "${errMsg_invalid_pinCode}" "${TRUE}"
                fi
            else
                hcitool_handler_caseSelect=${HCITOOL_HANDLER_CASE_EXIT}    #goto next-case

                return
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
        get_intf_state_and_show_conn_info__func
    fi
    
    # #Add an Empty Line
    # printf '%b\n' ""
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
    local retry_param=1

    #Define printf messages
    errmsg_unable_to_bind_macAddr_to_rfcommDevNum="${FG_LIGHTRED}UNABLE${NOCOLOR} TO BIND '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${rfcommDevNum_input}${NOCOLOR}'"
    printf_binding_macAddr_to_rfcommDevNum="---:BINDING '${FG_LIGHTGREY}${macAddr_input}${NOCOLOR}' TO '${FG_LIGHTGREY}${rfcommDevNum_input}${NOCOLOR}'"

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

            sleep ${SLEEP_TIMEOUT} #if no PID found yet, sleep for 1 second

            retry_param=$((retry_param+1))  #increment retry paramter

            #a Maxiumum of 10 retries is allowed
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum retries has been excaw
                break
            fi
        done

        if [[ ! -z ${mac_isFound} ]]; then    #contains data
            #Print
            debugPrint__func "${PRINTF_COMPLETED}" "${printf_binding_macAddr_to_rfcommDevNum}"
        else    #contains NO data
            errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}" "${TRUE}"
        fi
    else    #exit-code!=0
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_unable_to_bind_macAddr_to_rfcommDevNum}" "${TRUE}"
    fi
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub

    checkIfisRoot__sub
    
    init_variables__sub

    dynamic_variables_definition__sub

    input_args_case_select__sub
    
    preCheck_handler__sub

    get_intf_state_and_show_conn_info__func

    hcitool_handler__sub

    bluetoothctl_trust_and_pair__sub

    rfcomm_bind_handler__sub
}



#---EXECUTE
main__sub
