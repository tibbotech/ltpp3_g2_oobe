#!/bin/bash
#---INPUT ARGS
banner_isDisabled=${1}



#---VARIABLES FOR 'input_args_case_select__sub'
argsTotal=$#
arg1=${banner_isDisabled}



#---SCRIPT-NAME
scriptName=$( basename "$0" )

#---CURRENT SCRIPT-VERSION
scriptVersion="21.03.23-0.0.1"



#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1

#---COLORS CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_DARKBLUE=$'\e[30;38;5;33m'
FG_SOFTDARKBLUE=$'\e[30;38;5;38m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'

TIBBO_FG_WHITE=$'\e[30;38;5;15m'
TIBBO_BG_ORANGE=$'\e[30;48;5;209m'



#---CONSTANTS (OTHER)
TITLE="TIBBO"

EMPTYSTRING=""

COLON_CHAR=":"
DASH_CHAR="-"
QUESTION_CHAR="?"

ONE_SPACE=" "
TWO_SPACES="${ONE_SPACE}${ONE_SPACE}"
FOUR_SPACES="${TWO_SPACES}${TWO_SPACES}"
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}

NO_ROUTE="no route"

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
BLUETOOTHCTL_CMD="bluetoothctl"
HCICONFIG_CMD="hciconfig"
HCITOOL_CMD="hcitool"
RFCOMM_CMD="rfcomm"
TIMEOUT_CMD="timeout"

#---LINE CONSTANTS
EMPTYLINES_0=0
EMPTYLINES_1=1
EMPTYLINES_3=3

LINENUM_2=2
LINENUM_3=3
LINENUM_4=4
LINENUM_5=5

#---TIMEOUT CONSTANTS
TIMEOUT_CMDVAL=10   #seconds

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

YES="yes"
NO="no"

#---PATTERN CONSTANTS
PATTERN_BD_ADDRESS="BD Address"
PATTERN_NAME="Name"
PATTERN_PAIRED="Paired"
PATTERN_TYPE_PRIMARY="Type: Primary"

PATTERN_BLUEZ="bluez"

#---PRINTF WIDTHS
PRINTF_DEVNAME_WIDTH="%-25s"
PRINTF_MACADDR_WIDTH="%-20s"
PRINTF_PAIRED_WIDTH="%-6s"
PRINTF_BOUND_WIDTH="%-6s"
PRINTF_RFCOMM_WIDTH="%-8s"

PRINTF_STATE_WIDTH="%-6s"

#---PRINTF HEADERS
PRINTF_HEADER_REMOTEDEVNAME="REMOTE DEVNAME"
PRINTF_HEADER_MACADDR="MAC"
PRINTF_HEADER_PAIRED="PAIR"
PRINTF_HEADER_BIND="BIND"
PRINTF_HEADER_RFCOMM="RFCOMM"

PRINTF_HEADER_LOCALDEVNAME="LOCAL DEVNAME"
PRINTF_HEADER_STATE="STATE"



#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to Show Bluetooth Information."



#---PRINTF PHASES
PRINTF_INFO="INFO:"
PRINTF_STATUS="STATUS:"

#---PRINT MESSAGES
PRINTF_BLUETOOTH_INTERFACE_STATUS="${FG_LIGHTBLUE}BLUETOOTH${NOCOLOR} ${FG_SOFTDARKBLUE}INTERFACE${NOCOLOR} ${FG_LIGHTBLUE}STATUS${NOCOLOR}"
PRINTF_BLUETOOTH_BIND_STATUS="${FG_LIGHTBLUE}BLUETOOTH${NOCOLOR} ${FG_SOFTDARKBLUE}BIND${NOCOLOR} ${FG_LIGHTBLUE}STATUS${NOCOLOR}"

PRINTF_NO_INTERFACES_FOUND="=:${FG_LIGHTRED}NO INTERFACES FOUND${NOCOLOR}:="
PRINTF_NO_PAIRED_DEVICES_FOUND="=:${FG_LIGHTRED}NO PAIRED DEVICES FOUND${NOCOLOR}:="

PRINTF_PLEASE_WAIT="PLEASE WAIT..."



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    dev_dir=/dev
    
    tmp_dir=/tmp
    bluetoothctl_info_tmp_filename="bluetootctl_info.tmp"
    bluetoothctl_info_tmp_fpath=${tmp_dir}/${bluetoothctl_info_tmp_filename}

    bluetoothctl_bind_stat_tmp_filename="bluetoothctl_bind_stat.tmp"
    bluetoothctl_bind_stat_tmp_fpath=${tmp_dir}/${bluetoothctl_bind_stat_tmp_filename}

    tb_bt_conn_info_intf_names_tmp_filename="tb_bt_conn_info_intf_names.tmp"
    tb_bt_conn_info_intf_names_tmp_fpath=${tmp_dir}/${tb_bt_conn_info_intf_names_tmp_filename}

    var_backups_dir=/var/backups
    bluetoothctl_bind_stat_bck_filename="bluetoothctl_bind_stat.bck"
    bluetoothctl_bind_stat_bck_fpath=${var_backups_dir}/${bluetoothctl_bind_stat_bck_filename}
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
            printf '%s%b\n' ${EMPTYSTRING}
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

function checkIf_software_isInstalled__func()
{
    #Input args
    local package_input=${1}

    #Define local constants
    local pattern_packageStatus_installed="ii"

    #Define local 
    local packageStatus=`dpkg -l | grep -w "${package_input}" | awk '{print $1}'`

    #If 'stdOutput' is an EMPTY STRING, then software is NOT installed yet
    if [[ ${packageStatus} == ${pattern_packageStatus_installed} ]]; then #contains NO data
        echo ${TRUE}
    else
        echo ${FALSE}
    fi
}



#---SUBROUTINE
init_variables__sub()
{
    #Corrective action if 'banner_isDisabled' is an EMPTY STRING
    if [[ -z ${banner_isDisabled} ]]; then
        banner_isDisabled=${FALSE}
    else
        if [[ ${banner_isDisabled} != ${TRUE} ]]; then
            banner_isDisabled=${FALSE}
        fi
    fi

    wlanSelectIntf=${EMPTYSTRING}
}

load_tibbo_banner__sub() {
    if [[ ${banner_isDisabled} == ${FALSE} ]]; then
        printf "%s\n" ${EMPTYSTRING}
        printf "%s\n" "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
    fi
}

checkIfisRoot__sub()
{
    #Define local constants
    local ROOTUSER="root"
    local ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}SUDO${NOCOLOR} OR ${FG_LIGHTGREY}ROOT${NOCOLOR}"

    #Define Local variables
    local currUser=`whoami`

    #Check if user is 'root'
    if [[ ${currUser} != ${ROOTUSER} ]]; then   #not root
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_USER_IS_NOT_ROOT}" "${TRUE}"  

        user_isRoot=${TRUE}
    fi
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
                if [[ ${arg1} != ${TRUE} ]] && [[ ${arg1} != ${FALSE} ]]; then
                    input_args_print_unknown_option__sub
                fi
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
        ${EMPTYSTRING}
        "${FOUR_SPACES}No input arguments required."
    )

    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" "${usageMsg[@]}"
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
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

bt_intf_status_handler__Sub()
{
    #Define local variables
    local macAddr=${EMPTYSTRING}
    local btState=${STATUS_DOWN}
    local stdOutput=${EMPTYSTRING}

    local btList_string=${EMPTYSTRING}
    local btList_array=()
    local btList_arrayLen=0
    local btList_arrayItem=${EMPTYSTRING}

    local software_isPresent=${FALSE}

    #Delete file (if present)
    if [[ -f ${tb_bt_conn_info_intf_names_tmp_fpath} ]]; then
        rm ${tb_bt_conn_info_intf_names_tmp_fpath}
    fi

    #Print title
    printf "%s\n" "----------------------------------------------------------------------"
    printf "%s\n" "${PRINTF_BLUETOOTH_INTERFACE_STATUS}"
    printf "%s\n" "----------------------------------------------------------------------"

    #Update printf template
    printf_header_template="${PRINTF_DEVNAME_WIDTH}${PRINTF_MACADDR_WIDTH}${PRINTF_STATE_WIDTH}"

    #Print Header
    printf "${printf_header_template}\n" "${FOUR_SPACES}${PRINTF_HEADER_LOCALDEVNAME}" "${PRINTF_HEADER_MACADDR}" "${PRINTF_HEADER_STATE}"


    #Check if software is installed
    software_isPresent=`checkIf_software_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isPresent} == ${FALSE} ]]; then
        #Print message
        printf "\n%b\n" "${EIGHT_SPACES}${EIGHT_SPACES}${PRINTF_NO_INTERFACES_FOUND}"

        #Append Empty Line
        printf '%s%b\n' "" 

        #Exit function
        exit 99
    fi

    #Get the PRIMARY BT-interface
    btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_TYPE_PRIMARY}" | awk '{print $1}' | cut -d":" -f1 | xargs`
    if [[ -z ${btList_string} ]]; then
        #Print message
        printf "\n%b\n" "${EIGHT_SPACES}${EIGHT_SPACES}${PRINTF_NO_INTERFACES_FOUND}"

        #Append Empty Line
        printf '%s%b\n' "" 

        #Exit function
        exit 99
    fi

    #Convert string to array
    eval "btList_array=(${btList_string})"

    #Initial value
    exported_btState=${STATUS_UP}

    #Show available BT-interface(s)
    for btList_arrayItem in "${btList_array[@]}"
    do
        #Get MAC-address
        macAddr=`${HCICONFIG_CMD} ${btList_arrayItem} | grep "${PATTERN_BD_ADDRESS}" | xargs | cut -d":" -f2- | xargs | cut -d" " -f1 | xargs`
        #Get State
        stdOutput=`${HCICONFIG_CMD} ${btList_arrayItem} | grep "${STATUS_UP}"`
        if [[ ! -z ${stdOutput} ]]; then    #contains data
            btState=${STATUS_UP}
        else    #contains no data
            btState=${STATUS_DOWN}

            echo "${btList_arrayItem}" >> ${tb_bt_conn_info_intf_names_tmp_fpath}
        fi

        #Select the color for values 'btState' (GREEN or RED)
        printf_btState_color=`bt_intf_state_select_color__func "${btState}"`
        #Compose the 'printf template'
        printf_body_template="${FG_LIGHTGREY}${PRINTF_DEVNAME_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_MACADDR_WIDTH}${NOCOLOR}${printf_btState_color}${PRINTF_STATE_WIDTH}${NOCOLOR}"
        #Print
        printf "${printf_body_template}\n" "${FOUR_SPACES}${btList_arrayItem}" "${macAddr}" "${btState}"
    done   

    #Append Empty Line
    printf '%s%b\n' ""
}
function bt_intf_state_select_color__func()
{
    #Input args
    local inputValue=${1}

    #Define local variables
    local outputValue=${EMPTYSTRING}

    #Depending on the value (whether 'yes' or 'no'), add color
    if [[ ${inputValue} == ${STATUS_UP} ]]; then
        outputValue=${FG_LIGHTGREEN}
    else    #inputValue == STATUS_DOWN
        outputValue=${FG_SOFTLIGHTRED}
    fi

    #Output
    echo ${outputValue}
}

bt_bind_status_handler__sub() 
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

    local printf_header_template=${EMPTYSTRING}

    #Print title
    printf "%s\n" "----------------------------------------------------------------------"
    printf "%s\n" "${FG_LIGHTBLUE}${PRINTF_BLUETOOTH_BIND_STATUS}${NOCOLOR}"
    printf "%s\n" "----------------------------------------------------------------------"

    #Update printf template
    printf_header_template="${PRINTF_DEVNAME_WIDTH}${PRINTF_MACADDR_WIDTH}${PRINTF_PAIRED_WIDTH}${PRINTF_BOUND_WIDTH}${PRINTF_RFCOMM_WIDTH}"

    #Print Header
    printf "${printf_header_template}\n" "${FOUR_SPACES}${PRINTF_HEADER_REMOTEDEVNAME}" "${PRINTF_HEADER_MACADDR}" "${PRINTF_HEADER_PAIRED}" "${PRINTF_HEADER_BIND}" "${PRINTF_HEADER_RFCOMM}"


    #Remove file (if present)
    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then
        rm ${bluetoothctl_bind_stat_tmp_fpath}
    fi

    #Get Paired MAC-addresses
    macAddrList_string=`${TIMEOUT_CMD} ${TIMEOUT_CMDVAL} ${BLUETOOTHCTL_CMD} paired-devices | awk '{print $2}'`

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
        bluetoothctl_retrieve_and_write_info_toFile__func "${macAddrList_arrayItem}"

        #Retrieve information
        devName=`bluetoothctl_retrieve_specific_info__func "${PATTERN_NAME}"`
        isPaired=`bluetoothctl_retrieve_specific_info__func "${PATTERN_PAIRED}"`
        rfcommDevNum=`rfcomm_retrieve_info__func "${macAddrList_arrayItem}"`
        if [[ ${rfcommDevNum} != ${DASH_CHAR} ]]; then
            isBound=${YES}
        else
            isBound=${NO}
        fi

        #Write to File
        echo "${devName} ${macAddrList_arrayItem} ${isPaired} ${isBound} ${rfcommDevNum}" >> ${bluetoothctl_bind_stat_tmp_fpath}

        #Select the color for values 'isPaired' and 'isBound' (GREEN or RED)
        printf_isPaired_color=`bt_bind_status_select_color__func "${isPaired}"`
        printf_isBound_color=`bt_bind_status_select_color__func "${isBound}"`
        #Compose the 'printf template'
        printf_body_template="${FG_LIGHTGREY}${PRINTF_DEVNAME_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_MACADDR_WIDTH}${NOCOLOR}${printf_isPaired_color}${PRINTF_PAIRED_WIDTH}${NOCOLOR}${printf_isBound_color}${PRINTF_BOUND_WIDTH}${NOCOLOR}${FG_LIGHTGREY}${PRINTF_RFCOMM_WIDTH}${NOCOLOR}"
        #Print
        printf "${printf_body_template}\n" "${FOUR_SPACES}${devName}" "${macAddrList_arrayItem}" "${isPaired}" "${isBound}" "${rfcommDevNum}"
    done

    #Append Empty Line
    printf '%s%b\n' "" 
}
function bt_bind_status_select_color__func()
{
    #Input args
    local inputValue=${1}

    #Define local variables
    local outputValue=${EMPTYSTRING}

    #Depending on the value (whether 'yes' or 'no'), add color
    if [[ ${inputValue} == ${YES} ]]; then
        outputValue=${FG_LIGHTGREEN}
    else    #inputValue == NO
        outputValue=${FG_SOFTLIGHTRED}
    fi

    #Output
    echo ${outputValue}
}
function bluetoothctl_retrieve_and_write_info_toFile__func()
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
function bluetoothctl_retrieve_specific_info__func()
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

bt_backup_file__func()
{
    #Copy file from '/tmp' to '/var/backups'
    if [[ -f ${bluetoothctl_bind_stat_tmp_fpath} ]]; then #file exists
        cp ${bluetoothctl_bind_stat_tmp_fpath} ${bluetoothctl_bind_stat_bck_fpath}
    fi
}

#---MAIN SUBROUTINE
main_sub() {
    load_env_variables__sub

    init_variables__sub

    load_tibbo_banner__sub

    checkIfisRoot__sub
    
    input_args_case_select__sub

    bt_intf_status_handler__Sub

    bt_bind_status_handler__sub

    #Backup '/tmp/bluetoothctl_bind_stat.tmp' as '/var/backups/bluetoothctl_bind_stat.bck'
    bt_backup_file__func

    #Press any key
    # press_any_key__func
}



#EXECUTE
main_sub


