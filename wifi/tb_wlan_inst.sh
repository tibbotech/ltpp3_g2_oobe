#!/bin/bash
#---INPUT ARGS
arg1=${1}



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${arg1}



#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="1.0.0"




#---TRAP ON EXIT
trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
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
FG_SOFTLIGHTBLUE=$'\e[30;38;5;80m'
FG_GREEN=$'\e[30;38;5;76m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
FG_LIGHTPINK=$'\e[30;38;5;224m'
TIBBO_FG_WHITE=$'\e[30;38;5;15m'

TIBBO_BG_ORANGE=$'\e[30;48;5;209m'



#---CONSTANTS
TITLE="TIBBO"

BCMDHD="bcmdhd"
IEEE_80211="IEEE 802.11"
IW="iw"
IWCONFIG="iwconfig"

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

TRUE="true"
FALSE="false"

EXITCODE_99=99
SLEEP_TIMEOUT=2

ARGSTOTAL_MIN=1
ARGSTOTAL_MAX=4

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

STATUS_UP="UP"
STATUS_DOWN="DOWN"
TOGGLE_UP="up"
TOGGLE_DOWN="down"

# PATTERN_WLAN="wlan"
PATTERN_INTERFACE="Interface"
PATTERN_SSID="ssid"

ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="UNKNOWN OPTION: '${arg1}'"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"
# ERRMSG_UNABLE_TO_LOAD_WIFI_MODULE_BCMDHD="Unable to LOAD WiFi MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"

PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

PRINTF_CONFIGURE="CONFIGURE:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_TOGGLE="TOGGLE:"

PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle WiFi-module & install WiFi-software"

PRINTF_CURRENT_CONFIG_SSID="CURRENTLY CONFIGURED SSID:"
PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_UPDATES="UPDATES"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"
PRINTF_WIFI_SOFTWARE="WiFi SOFTWARE"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
PRINTF_WIFI_INTERFACE="WiFi INTERFACE"



#---VARIABLES



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)
}



#---FUNCTIONS
press_any_key__localfunc() {
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

		echo -e "\rPress (a)bort or any key to continue... (${delta_tCounter}) \c"
		read -N 1 -t 1 -s -r keyPressed

		if [[ ! -z "${keyPressed}" ]]; then
			if [[ "${keyPressed}" == "a" ]] || [[ "${keyPressed}" == "A" ]]; then
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

debugPrint__func()
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

errExit__func() 
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
errTrap__sub()
{
    if [[ ${trapDebugPrint_isEnabled} == ${TRUE} ]]; then
        #Input args
        #The input args are retrieved from the trap which is set with the command (see top of script)
        #   trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
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

updates_upgrades_inst_list__func()
{
    apt-get -y update
    # apt-get -y upgrade
}

software_inst_list__func()
{
    apt-get -y install wi
    apt-get -y install wireless-tools
    apt-get -y install wpasupplicant
}

toggle_module__func()
{
    #Input args
    local mod_isEnabled=${1}

    #Local variables
    local errMsg=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local wlanList_string=${EMPTYSTRING}

    #Check if 'wlanSelectIntf' is present
    bcmdhd_isPresent=`lsmod | grep ${BCMDHD}`

    #Toggle WiFi Module (enable/disable)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${bcmdhd_isPresent} ]]; then   #contains data (thus WLAN interface is already enabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_UP}" "${PREPEND_EMPTYLINES_1}"

            return
        fi

        modprobe ${BCMDHD}
    else
        if $[[ -z ${wlanList_string} ]]; then   #contains NO data (thus WLAN interface is already disabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_DOWN}" "${PREPEND_EMPTYLINES_1}"

            return
        fi

        modprobe -r ${BCMDHD}
    fi
    exitCode=$? #get exit-code
    if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
        errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD}" "${TRUE}"
    fi

    #Print result (exit-code=0)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then  #module was set to be enabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD}" "${PREPEND_EMPTYLINES_1}"
    else    #module was set to be disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD}" "${PREPEND_EMPTYLINES_1}"
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
    pattern_wlan=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    wlanSelectIntf=${EMPTYSTRING}
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
    debugPrint__func "${PRINTF_DESCRIPTION}" "${PRINTF_USAGE_DESCRIPTION}" "${PREPEND_EMPTYLINES_1}"

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
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${PREPEND_EMPTYLINES_1}"
}


update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES}" "${PREPEND_EMPTYLINES_1}"
    updates_upgrades_inst_list__func
}

inst_software__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_WIFI_SOFTWARE}" "${PREPEND_EMPTYLINES_1}"
    software_inst_list__func
}


enable_module__sub()
{
    toggle_module__func "${TRUE}"
}


#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    init_variables__sub

    input_args_case_select__sub

    update_and_upgrade__sub

    inst_software__sub

    enable_module__sub
}


#---EXECUTE
main__sub
