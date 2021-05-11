#!/bin/bash
#---INPUT ARGS
arg1=${1}



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${arg1}



#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---TRAP ON EXIT
trap 'errTrap__sub $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---INPUT-ARG CONSTANTS
ARGSTOTAL_MIN=1

#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
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



#---CONSTANTS (OTHER)
TITLE="TIBBO"

BCMDHD="bcmdhd"
IEEE_80211="IEEE 802.11"
IW="iw"
IWCONFIG="iwconfig"
WPA_SUPPLICANT="wpa_supplicant"

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
TWO_SPACES="  "
FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

EXITCODE_99=99

#---TIMEOUT AND RETRY CONSTANTS
SLEEP_TIMEOUT=2
DAEMON_TIMEOUT=1
DAEMON_RETRY=10

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

#---PATTERN CONSTANTS
PATTERN_GREP="grep"
PATTERN_INTERFACE="Interface"
PATTERN_SSID="ssid"

#---COMMAND RELATED CONSTANTS
HCITOOL_CMD="hcitool"
RFCOMM_CMD="rfcomm"
SYSTEMCTL_CMD="systemctl"

#---STATUS/BOOLEANS
ACTIVE="active"
INACTIVE="inactive"

ENABLED="enabled"

TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

INPUT_NO="n"
INPUT_YES="y"



#---PRINTF PHASES
PRINTF_COMPLETED="COMPLETED:"
PRINTF_CONFIRM="CONFIRM:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"
PRINTF_CONFIGURE="CONFIGURE:"
PRINTF_DELETING="${FG_LIGHTRED}DELETING:${NOCOLOR}:"
PRINTF_DISABLING="DISABLING:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_MANDATORY="${FG_PURPLERED}MANDATORY${NOCOLOR}${FG_ORANGE}:${NOCOLOR}"
PRINTF_QUESTION="QUESTION:"
PRINTF_READING="READING:"
PRINTF_START="START:"
PRINTF_STATUS="STATUS:"
PRINTF_STOPPING="STOPPING:"
PRINTF_TERMINATING="TERMINATING:"
PRINTF_TOGGLE="TOGGLE:"
PRINTF_UINSTALLING="UINSTALLING:"

#---PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
ERRMSG_FAILED_TO_TERMINATE_WPA_SUPPLICANT_DAEMON="${FG_LIGHTRED}FAILED${NOCOLOR} TO TERMINATE WPA SUPPLICANT DAEMON"
ERRMSG_NO_WIFI_INTERFACE_FOUND="NO WiFi INTERFACE FOUND"

ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---HELPER/USAGE PRINT CONSTANTS
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Uninstall WiFi-software"

#---PRINTF MESSAGES
PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."

PRINTF_NOTHING_TO_DELETE="NOTHING TO DELETE..."

PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"
PRINTF_WIFI_SOFTWARE="WiFi SOFTWARE"

PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_DOWN="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"
PRINTF_WIFI_MODULE_IS_ALREADY_UP="WiFi MODULE ${FG_LIGHTGREY}${BCMDHD}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"

PRINTF_WPA_SUPPLICANT_SERVICE="WPA SUPPLICANT SERVICE"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE="WPA SUPPLICANT DAEMON: ${FG_GREEN}ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE="WPA SUPPLICANT DAEMON: ${FG_LIGHTRED}IN-ACTIVE${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_AND_NETPLAN_DAEMONS="WPA SUPPLICANT & NETPLAN DAEMONS (INCL. SSID CONNECTION)"
PRINTF_WPA_SUPPLICANT_SERVICE_DISABLED="WPA SUPPLICANT SERVICE: ${FG_LIGHTRED}DISABLED${NOCOLOR}"
PRINTF_WPA_SUPPLICANT_SERVICE_ISALREADY_DISABLED="WPA SUPPLICANT SERVICE IS ALREADY ${FG_LIGHTRED}DISABLED${NOCOLOR}"

PRINTF_A_REBOOT_IS_REQUIRED_TO_COMPLETE_THE_PROCESS="A ${FG_YELLOW}REBOOT${NOCOLOR} IS REQUIRED TO COMPLETE THE PROCESS..."

#---PRINTF QUESTIONS
QUESTION_REBOOT_NOW="REBOOT NOW (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
QUESTION_ARE_YOU_VERY_SURE="ARE YOU VERY SURE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"



#---VARIABLES
dynamic_variables_definition__sub()
{
    pattern_four_spaces_wlan="^${ONE_SPACE}{4}${pattern_wlan}"
    pattern_four_spaces_anyString="^${ONE_SPACE}{4}[a-z]"

    printf_yaml_deleting_wifi_entries="---:DELETING WiFi ENTRIES IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"

    printf_file_not_found_wpa_supplicant="${PRINTF_FILE_NOT_FOUND} ${FG_LIGHTGREY}${wpaSupplicant_fpath}${NOCOLOR}"
    printf_wifi_entries_found="WiFi ENTRIES FOUND IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}" 
    printf_wifi_entries_not_found="WiFi ENTRIES *NOT* FOUND IN: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}" 
    printf_yaml_file_not_found="FILE NOT FOUND: ${FG_LIGHTGREY}${yaml_fpath}${NOCOLOR}"
}



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    etc_dir=/etc
    wpaSupplicant_filename="wpa_supplicant.conf"
    wpaSupplicant_fpath="${etc_dir}/${wpaSupplicant_filename}"

    yaml_fpath="${etc_dir}/netplan/*.yaml"    #use the default full-path
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
    pattern_wlan=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}

    wlanSelectIntf=${EMPTYSTRING}
    wpa_supplicant_daemon_isRunning=${FALSE}

    netplan_toBeDeleted_targetLineNum=0
    netplan_toBeDeleted_numOfLines=0
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

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${EMPTYLINES_1}"
    
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
}

wlan_intf_selection__sub()
{
    #Define local variables
    local seqNum=0
    local arrNum=0
    local wlanList_string=${EMPTYSTRING}
    local wlanList_array=()
    local wlanList_arrayLen=0
    local wlanItem=${EMPTYSTRING}

    #Get ALL available WLAN interface
    # wlanList_string=`ip link show | grep ${pattern_wlan} | cut -d" " -f2 | cut -d":" -f1 2>&1` (OLD CODE)
    wlanList_string=`{ ${IW} dev | grep "${PATTERN_INTERFACE}" | cut -d" " -f2 | xargs -n 1 | sort -u | xargs; } 2> /dev/null`

    #Check if 'wlanList_string' contains any data
    if [[ -z $wlanList_string ]]; then  #contains NO data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_WIFI_INTERFACE_FOUND}" "${TRUE}"       
    fi


    #Convert string to array
    eval "wlanList_array=(${wlanList_string})"   

    #Get Array Length
    wlanList_arrayLen=${#wlanList_array[*]}

    #Select WLAN interface
    if [[ ${wlanList_arrayLen} -eq 1 ]]; then
         wlanSelectIntf=${wlanList_array[0]}
    else
        #Show available WLAN interface
        printf '%s%b\n' ""
        printf '%s%b\n' "${FG_ORANGE}AVAILABLE WiFi INTEFACES:${NOCOLOR}"
        for wlanItem in "${wlanList_array[@]}"; do
            seqNum=$((seqNum+1))    #increment sequence number

            printf '%b\n' "${EIGHT_SPACES}${seqNum}. ${wlanItem}"   #print
        done

        #Print empty line
        printf '%s%b\n' ""
        
         #Save cursor position
        tput sc

        #Choose WLAN interface
        while true
        do
            read -N1 -p "${FG_LIGHTBLUE}Your choice${NOCOLOR}: " myChoice

            if [[ ${myChoice} =~ [1-9,0] ]]; then
                if [[ ${myChoice} -ne ${ZERO} ]] && [[ ${myChoice} -le ${seqNum} ]]; then
                    arrNum=$((myChoice-1))   #get array-number based on the selected sequence-number

                    wlanSelectIntf=${wlanList_array[arrNum]}  #get array-item

                    printf '%s%b\n' ""  #print an empty line

                    break
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            else
                if [[ ${myChoice} == ${ENTER_CHAR} ]]; then
                    clear_lines__func ${NUMOF_ROWS_1}
                else
                    clear_lines__func ${NUMOF_ROWS_0}

                    tput rc #restore cursor position
                fi
            fi
        done
    fi
}
get_wifi_pattern__sub()
{
    #Get 'pattern_wlan'
    pattern_wlan=`echo ${wlanSelectIntf} | sed -e "s/[0-9]*$//"`
}

netplan_del_wlan_entries_handler__sub()
{
    #Define local variables
    local doNot_read_yaml=${FALSE}
    local stdOutput=${EMPTYSTRING}

    #Initialization
    netplan_toBeDeleted_targetLineNum=0   #reset parameter
    netplan_toBeDeleted_numOfLines=0    #reset parameter

    #Check if file '*.yaml' is present
    if [[ ! -f ${yaml_fpath} ]]; then
        debugPrint__func "${PRINTF_INFO}" "${printf_yaml_file_not_found}" "${EMPTYLINES_1}" #print
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NOTHING_TO_DELETE}" "${EMPTYLINES_0}" #print

        return  #exit function
    fi

    #Check if 'line' contains the string 'wlanSelectIntf' (e.g. wlan0)
    stdOutput=`cat ${yaml_fpath} | grep "${wlanSelectIntf}" 2>&1`
    if [[ -z ${stdOutput} ]]; then  #contains NO data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_not_found}" "${EMPTYLINES_1}" #print
        debugPrint__func "${PRINTF_INFO}" "${PRINTF_NOTHING_TO_DELETE}" "${EMPTYLINES_0}" #print

        netplan_toBeDeleted_targetLineNum=0   #reset parameter
        netplan_toBeDeleted_numOfLines=0    #reset parameter

        #Set boolean to TRUE
        #REMARK: this means SKIP READING of file '*.yaml'
        doNot_read_yaml=${TRUE}
    else    #contains data
        debugPrint__func "${PRINTF_INFO}" "${printf_wifi_entries_found}" "${EMPTYLINES_1}" #print
    fi

    #REMARK: if TRUE, then skip
    if [[ ${doNot_read_yaml} == ${FALSE} ]]; then
        netplan_retrieve_toBeDeleted_lines__func

        netplan_del_wlan_entries__func
    fi

    #Check if there are any lines to be deleted.
    #If NONE, then exit function.
    if [[ ${netplan_toBeDeleted_numOfLines} -eq 0 ]]; then
        return
    fi
}
netplan_retrieve_toBeDeleted_lines__func()
{
    #Define local variables
    local line=${EMPTYSTRING}
    local lineNum=1
    local stdOutput=${EMPTYSTRING}

    #Initialize variables
    netplan_toBeDeleted_targetLineNum=0
    netplan_toBeDeleted_numOfLines=0

    #Read each line of '*.yaml'
    #IMPORTANT ADDITION:
    #With the addition of '|| [ -n "$line" ]', the lines which does NOT END...
    #...with a 'new line (\n)' will also be read
    IFS=""  #use this command to KEEP LEADING SPACES (IMPORTANT)
    while read -r line || [ -n "$line" ]
    do
        # Check if 'line' contains the string 'wifis'
        # stdOutput=`echo ${line} | grep "${PATTERN_WIFIS}"`
        # if [[ ! -z ${stdOutput} ]]; then  #'wifis' string is found
        #     debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print
        # fi

        #Check if 'line' contains the string 'wlawlanSelectIntfnx' (e.g. wlan0)
        stdOutput=`echo ${line} | grep "${wlanSelectIntf}" 2>&1`
        if [[ ! -z ${stdOutput} ]]; then  #'wlanx' is found (with x=0,1,2,...)
            debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print

            netplan_toBeDeleted_targetLineNum=${lineNum}    #update value (which will be used later on to delete these entries)

            netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))    #increment parameter
        else
            #This condition ONLY APPLIES once a match for 'wlanSelectIntf' is found.
            #In other words: 'netplan_toBeDeleted_targetLineNum > 0'
            #Keep on READING the lines TILL 
            #1. 'any string with exactly 4 leading spaces' is found.
            #Why exactly 4 leading spaces?
            #Because according to 'netplan' notation convention, all interface names starts with 4 leading spaces
            #For example:
            #<2 SPACES>  ethernets:
            #<4 SPACES>    eth0:
            #<2 SPACES>  wifis:
            #<4 SPACES>    wlan0:
            #2. end of file (in this case no match was found for a string with 4 leading spaces)
            if [[ ${netplan_toBeDeleted_targetLineNum} -gt 0 ]]; then
                #Check if 'line' contains 'pattern_four_spaces_anyString'
                stdOutput=`echo ${line} | egrep "${pattern_four_spaces_anyString}"`
                if [[ -z ${stdOutput} ]]; then #match NOT found
                    debugPrint__func "${PRINTF_READING}" "${line}" "${EMPTYLINES_0}" #print

                    netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))    #increment parameter
                else    #match is found
                    break
                fi
            fi
        fi

        #Increment line-number
        lineNum=$((lineNum+1))
    done < "${yaml_fpath}"
}
netplan_del_wlan_entries__func()
{
    #Define local variables
    local lineDeleted_count=0
    local lineDeleted=${EMPTYSTRING}
    local numOf_wlanIntf=0

    #Check the number of lines to be deleted
    if [[ ${netplan_toBeDeleted_numOfLines} -eq 0 ]]; then    #no lines to be deleted
        return
    else    #there are lines to be deleted
        #Check the number of configured wlan-interfaces in '*.yaml'
        numOf_wlanIntf=`cat ${yaml_fpath} | egrep "${pattern_four_spaces_wlan}" | wc -l`

        if [[ ${numOf_wlanIntf} -eq 1 ]]; then  #only 1 interface configured
            #In this case DECREMENT 'netplan_toBeDeleted_targetLineNum' by 1:
            #This means move-up 1 line-number, because entry 'wifis' also HAS TO BE REMOVED
            netplan_toBeDeleted_targetLineNum=$((netplan_toBeDeleted_targetLineNum-1))

            #INCREMENT 'netplan_toBeDeleted_numOfLines' by 1:
            #This is because of the additional deletion of entry 'wifis'.
            netplan_toBeDeleted_numOfLines=$((netplan_toBeDeleted_numOfLines+1))
        fi
    fi

    #Check if file '*.yaml' is present
    #If FALSE, then exit function
    if [[ ! -f ${yaml_fpath} ]]; then
        return  #exit function
    fi

    #Print
    debugPrint__func "${PRINTF_START}" "${printf_yaml_deleting_wifi_entries}" "${EMPTYLINES_1}"

    #Read each line of '*.yaml'
    while true
    do
        #Delete current line-number 'netplan_toBeDeleted_targetLineNum'
        #REMARK:
        #   After the deletion of a line, all the contents BELOW this line will be...
        #   ... shifted up one line.
        #   Because of this 'shift-up' the variable 'netplan_toBeDeleted_targetLineNum' can be used again, again, and again...
        lineDeleted=`sed "${netplan_toBeDeleted_targetLineNum}q;d" ${yaml_fpath}`   #GET line specified by line number 'netplan_toBeDeleted_targetLineNum'
        
        debugPrint__func "${PRINTF_DELETING}" "${lineDeleted}" "${EMPTYLINES_0}" #print

        sed -i "${netplan_toBeDeleted_targetLineNum}d" ${yaml_fpath}   #DELETE line specified by line number 'netplan_toBeDeleted_targetLineNum'

        lineDeleted_count=$((lineDeleted_count+1))    #increment parameter    

        #Check if all lines belonging to wlan0 have been deleted
        #If TRUE, then exit function
        if [[ ${lineDeleted_count} -eq ${netplan_toBeDeleted_numOfLines} ]]; then
            break  #exit function
        fi
    done < "${yaml_fpath}"

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_yaml_deleting_wifi_entries}" "${EMPTYLINES_0}"
}

wpa_supplicant_get_daemon_status__func()
{
    #PLEASE NOTE that the wpa_supplicant 'daemon' is NOT dependent on the wpa_supplicant 'service'

    #Check if 'wpa_supplicant.conf' is present
    if [[ ! -f ${wpaSupplicant_fpath} ]]; then  #file is NOT found
        wpa_supplicant_daemon_isRunning=${FALSE}

        debugPrint__func "${PRINTF_STATUS}" "${printf_file_not_found_wpa_supplicant}" "${EMPTYLINES_1}"
    else    #file is found
        #Check if wpa_supplicant test daemon is running
        #REMARK:
        #TWO daemons could be running:
        #1. TEST DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
        #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
        #GET PID of TEST DAEMON
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            wpa_supplicant_daemon_isRunning=${TRUE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_ACTIVE}" "${EMPTYLINES_1}"
        else    #daemon is NOT running
            wpa_supplicant_daemon_isRunning=${FALSE}

            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_DAEMON_IS_INACTIVE}" "${EMPTYLINES_1}"
        fi
    fi
}
wpa_supplicant_kill_daemon__func()
{   
    #Define local variables
    local prepend_emptylines=${EMPTYLINES_0}
    local ps_pidList_string=${EMPTYSTRING}
    local ps_pidList_array=()
    local ps_pidList_item=${EMPTYSTRING}
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*10=10) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if wpa_supplicant daemon is already IN-ACTIVE
    #If TRUE, then exit function immediately
    if [[ ${wpa_supplicant_daemon_isRunning} == ${FALSE} ]]; then
        return
    fi 
    
    debugPrint__func "${PRINTF_TERMINATING}" "${PRINTF_WPA_SUPPLICANT_AND_NETPLAN_DAEMONS}" "${EMPTYLINES_0}"

    #GET PID of TEST DAEMON
    #REMARK:
    #TWO daemons could be running:
    #1. WPA_SUPPLICANT DAEMON: /sbin/wpa_supplicant -B -c /etc/wpa_supplicant.conf -iwlan0 (executed in function: 'wpa_supplicant_start_daemon__func')
    #2. NETPLAN DAEMON: /sbin/wpa_supplicant -c /run/netplan/wpa-wlan0.conf -iwlan0 (implicitely started after executing 'netplan apply')
    #GET THEIR PIDs
    local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`

    #Convert string to array
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL DAEMON
    for ps_pidList_item in "${ps_pidList_array[@]}"; do 
        printf '%b\n' "${EIGHT_SPACES}${FG_LIGHTRED}Killed${NOCOLOR} PID: ${ps_pidList_item}"

        kill -9 ${ps_pidList_item}
    done

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"


    #CHECK IF DAEMON HAS BEEN KILLED AND EXIT
    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        local ps_pidList_string=`ps axf | grep -E "${WPA_SUPPLICANT}.*${wlanSelectIntf}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ -z ${ps_pidList_string} ]]; then  #deamons are NOT running
            wpa_supplicant_daemon_isRunning=${FALSE}

            break
        else    #deamons are NOT running
            wpa_supplicant_daemon_isRunning=${TRUE}
        fi

        sleep ${DAEMON_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        #Print
        clear_lines__func ${NUMOF_ROWS_1}
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 10 times
            break
        fi
    done

    #HANDLE RESULT
    if [[ ${wpa_supplicant_daemon_isRunning} == ${TRUE} ]]; then    #daemon is still running (not good)
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_TERMINATE_WPA_SUPPLICANT_DAEMON}" "${TRUE}"
    fi
}

wpa_supplicant_stop_and_disable_service__func()
{   
    #REMARK: wpa_supplicant service is associated with the command:
    #           /sbin/wpa_supplicant -u -s -O /run/wpa_supplicant

    #Stop wpa_supplicant service (if running)
    local wpa_supplicant_service_isActive=`systemctl is-active "${WPA_SUPPLICANT}" 2>&1`
    if [[ ${wpa_supplicant_service_isActive} == ${ACTIVE} ]]; then    #is ACTIVE
        debugPrint__func "${PRINTF_STOPPING}" "${PRINTF_WPA_SUPPLICANT_SERVICE}" "${EMPTYLINES_1}"

        systemctl stop "${WPA_SUPPLICANT}" #stop service
    fi

    #Disable wpa_supplicant service (if Enabled)
    local wpa_supplicant_service_isEnabled=`systemctl is-enabled "${WPA_SUPPLICANT}" 2>&1`

    if [[ ${wpa_supplicant_service_isEnabled} == ${ENABLED} ]]; then    #service is ENABLED
        systemctl disable "${WPA_SUPPLICANT}" #disable service

        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_DISABLED}" "${EMPTYLINES_0}"
    else
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WPA_SUPPLICANT_SERVICE_ISALREADY_DISABLED}" "${EMPTYLINES_0}"
    fi
}

disable_module__sub()
{
    toggle_module__func "${FALSE}"
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
    local bcmdhd_isPresent=`lsmod | grep ${BCMDHD}`

    #Toggle WiFi Module (enable/disable)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${bcmdhd_isPresent} ]]; then   #contains data (thus WLAN interface is already enabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_UP}" "${EMPTYLINES_1}"

            return
        fi

        modprobe ${BCMDHD}
        
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_LOAD_MODULE_BCMDHD}" "${TRUE}"
        fi
    else
        if [[ -z ${bcmdhd_isPresent} ]]; then   #contains NO data (thus WLAN interface is already disabled)
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_WIFI_MODULE_IS_ALREADY_DOWN}" "${EMPTYLINES_1}"

            return
        fi

        modprobe -r ${BCMDHD}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_UNLOAD_MODULE_BCMDHD}" "${TRUE}"
        fi
    fi

    #Print result (exit-code=0)
    if [[ ${mod_isEnabled} == ${TRUE} ]]; then  #module was set to be enabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_LOADED_WIFI_MODULE_BCMDHD}" "${EMPTYLINES_1}"
    else    #module was set to be disabled
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD}" "${EMPTYLINES_1}"
    fi
}

uninst_software__sub()
{
    debugPrint__func "${PRINTF_UINSTALLING}" "${PRINTF_WIFI_SOFTWARE}" "${EMPTYLINES_1}"
    software_uninst_list__func
}
software_uninst_list__func()
{
    #Uninstall software
    apt-get -y remove iw
    apt-get -y remove wireless-tools
    apt-get -y remove wpasupplicant

    #Remove /etc/wpa_supplicant.conf
    if [[ -f ${wpaSupplicant_fpath} ]]; then
        rm ${wpaSupplicant_fpath}
    fi
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

    load_header__sub
    
    checkIfisRoot__sub

    init_variables__sub

    input_args_case_select__sub

    wlan_intf_selection__sub

    get_wifi_pattern__sub

    dynamic_variables_definition__sub

    netplan_del_wlan_entries_handler__sub

    wpa_supplicant_get_daemon_status__func

    wpa_supplicant_kill_daemon__func

    wpa_supplicant_stop_and_disable_service__func

    #REMARK:
    #   Do NOT UNLOAD the modules, then...
    #   it is also not needed to REBOOT after an UNINSTALL
    # disable_module__sub

    uninst_software__sub

    update_and_upgrade__sub

    # bt_reqTo_reboot__sub
}


#---EXECUTE
main__sub
