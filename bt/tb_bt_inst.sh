#!/bin/bash
#---version:21.03.23-0.0.1
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
SLEEP_TIMEOUT=2

DAEMON_TIMEOUT=1    #second
DAEMON_RETRY=20

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
TRUE="true"
FALSE="false"

TOGGLE_UP="up"
TOGGLE_DOWN="down"

STATUS_UP="UP"
STATUS_DOWN="DOWN"



#---PATTERN CONSTANTS
PATTERN_BRCM_PATCHRAM_PLUS="brcm_patchram_plus"
PATTERN_GREP="grep"
PATTERN_DONE_SETTING_LINE_DISCIPLINE="Done setting line discpline"



#---ERROR MESSAGE CONSTANTS
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."

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
PRINTF_USAGE_DESCRIPTION="Utility to toggle BT-module & install BT-software"



#---PRINT CONSTANTS
PRINTF_COMPLETED="COMPLETED:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_FOUND="FOUND:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_VERSION="VERSION:"
PRINTF_WRITING="WRITING:"

PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."
PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE="Press (a)bort or any key to continue..."

PRINTF_ENABLING_BLUETOOTH_MODULES="---:ENABLING BT *MODULES*"
PRINTF_BT_CREATING_SCRIPT="CREATING SCRIPT:"
PRINTF_BT_CREATING_SERVICE="CREATING SERVICE:"
PRINTF_BT_FIRMWARE="BT *FIRMWARE*"
PRINTF_BT_FIRMWARE_IS_ALREADY_LOADED="BT *FIRMWARE* IS ALREADY ${FG_GREEN}LOADED${NOCOLOR}"
PRINTF_BT_FIRMWARE_WAS_LOADED_SUCCESSFULLY="BT *FIRMWARE* WAS LOADED ${FG_GREEN}SUCCESSFULLY${NOCOLOR}"
PRINTF_BT_SERVICE=" BT *SERVICE*"
PRINTF_BT_SOFTWARE="BT *SOFTWARE*"
PRINTF_BT_SUCCESSFULLY_KILLED_PID="${FG_GREEN}SUCCESSFULLY${NOCOLOR} KILLED:"
PRINTF_DAEMON_RELOAD="DAEMON RELOAD"
PRINTF_LOADING_BT_FIRMWARE="---:LOADING BT *FIRMWARE*"
PRINTF_RETRIEVING_BT_INTERFACE="---:RETRIEVING BT *INTERFACE*"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"



#---VARIABLES
dynamic_variables_definition__sub()
{
    printf_bluetooth_service_enabled="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bluetooth_service_is_already_enabled="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' IS ALREADY ${FG_GREEN}ENABLED${NOCOLOR}"
    printf_bluetooth_service_started="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' ${FG_GREEN}STARTED${NOCOLOR}"
    printf_bluetooth_service_is_already_started="BLUETOOTH SERVICE '${FG_LIGHTGREY}${bluetooth_service_filename}${NOCOLOR}' IS ALREADY ${FG_GREEN}STARTED${NOCOLOR}"
    printf_writing_bt_modules_to_config_file="---:WRITING BT *MODULES* TO '${FG_LIGHTGREY}${modules_conf_fpath}${NOCOLOR}'"
    printf_creating_script="---:CREATING SCRIPT '${FG_LIGHTGREY}${tb_bt_firmware_filename}${NOCOLOR}'"
    printf_creating_service="---:CREATING SERVICE '${FG_LIGHTGREY}${tb_bt_firmware_service_filename}${NOCOLOR}'"
}




#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    tb_bt_version_info_filename="tb_bt_version.info"
    tb_bt_version_info_fpath=${thisScript_current_dir}/${tb_bt_version_info_filename}

    etc_modules_load_d_dir=/etc/modules-load.d
    modules_conf_filename="modules.conf"
    modules_conf_fpath=${etc_modules_load_d_dir}/${modules_conf_filename}

    usr_local_bin_dir=/usr/local/bin  #script location
    tb_bt_firmware_filename="tb_bt_firmware.sh"
    tb_bt_firmware_fpath=${usr_local_bin_dir}/${tb_bt_firmware_filename}

    etc_systemd_system_dir=/etc/systemd/system #service location
    tb_bt_firmware_service_filename="tb_bt_firmware.service"
    tb_bt_firmware_service_fpath=${etc_systemd_system_dir}/${tb_bt_firmware_service_filename}   

    etc_systemd_system_multi_user_target_wants_dir=/etc/systemd/system/multi-user.target.wants #service-symlink location
    tb_bt_firmware_service_symlink_filename="tb_bt_firmware.service"
    tb_bt_firmware_service_symlink_fpath=${etc_systemd_system_multi_user_target_wants_dir}/${tb_bt_firmware_service_symlink_filename} 

    usr_bin_dir=/usr/bin
    brcm_patchram_plus_filename=${PATTERN_BRCM_PATCHRAM_PLUS}
    brcm_patchram_plus_fpath=${usr_bin_dir}/${brcm_patchram_plus_filename}

    etc_firmware_dir=/etc/firmware
    hcd_filename="BCM4345C5_003.006.006.0058.0135.hcd"
    hcd_fpath=${etc_firmware_dir}/${hcd_filename}

    bluetooth_service_filename="bluetooth.service"
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

init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    myChoice=${EMPTYSTRING}
    trapDebugPrint_isEnabled=${FALSE}
    bt_firmware_isRunning=${FALSE}
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

input_args_print_unknown_option__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION} ${FG_LIGHTGREY}${arg1}${NOCOLOR}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

input_args_print_version__sub()
{
    debugPrint__func "${PRINTF_VERSION}" "${PRINTF_SCRIPTNAME_VERSION}" "${PREPEND_EMPTYLINES_1}"
}

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}


update_and_upgrade__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_UPDATES_UPGRADES}" "${PREPEND_EMPTYLINES_1}"
    
    DEBIAN_FRONTEND=noninteractive apt-get -y update   #install updates (non-interactive)

    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade   #install upgrades (non-interactive)
}

software_inst__sub()
{
    debugPrint__func "${PRINTF_INSTALLING}" "${PRINTF_BT_SOFTWARE}" "${PREPEND_EMPTYLINES_1}"

    DEBIAN_FRONTEND=noninteractive apt-get -y install bluez
    # DEBIAN_FRONTEND=noninteractive apt-get -y install screen    #will be needed to enable rfcomm
}

bt_module_handler__sub()
{
    #Enable BT-Module
    debugPrint__func "${PRINTF_START}" "${PRINTF_ENABLING_BLUETOOTH_MODULES}" "${PREPEND_EMPTYLINES_1}"
        
        bt_module_toggle_onOff__func "${MODPROBE_BLUETOOTH}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_HCI_UART}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_RFCOMM}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_BNEP}" "${TRUE}"
        bt_module_toggle_onOff__func "${MODPROBE_HIDP}" "${TRUE}"

    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_ENABLING_BLUETOOTH_MODULES}" "${PREPEND_EMPTYLINES_0}"

    #Add BT-Modules to Config file 'modules.conf'
    debugPrint__func "${PRINTF_START}" "${printf_writing_bt_modules_to_config_file}" "${PREPEND_EMPTYLINES_1}"

        bt_module_add_to_configFile__func "${MODPROBE_BLUETOOTH}" "${TRUE}"
        bt_module_add_to_configFile__func "${MODPROBE_HCI_UART}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_RFCOMM}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_BNEP}" "${FALSE}"
        bt_module_add_to_configFile__func "${MODPROBE_HIDP}" "${FALSE}"
    
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_writing_bt_modules_to_config_file}" "${PREPEND_EMPTYLINES_0}"
}
bt_module_toggle_onOff__func()
{
    #Input args
    local mod_name=${1}
    local toggleMod_isEnabled=${2}

    #Local variables
    local errMsg=${EMPTYSTRING}
    local stdError=${EMPTYSTRING}
    local btList_string=${EMPTYSTRING}

    #Print messages
    errmsg_failed_to_load_mod="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    printf_successfully_unloaded_mod="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

    printf_mod_is_already_up="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
    printf_mod_is_already_down="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"

    printf_successfully_loaded_mod="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

    #Check if BT-modules are present
    mod_isPresent=`lsmod | grep ${mod_name}`

    #Toggle WiFi Module (enable/disable)
    if [[ ${toggleMod_isEnabled} == ${TRUE} ]]; then
        if [[ ! -z ${mod_isPresent} ]]; then   #contains data (thus WLAN interface is already enabled)
            debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_up}" "${PREPEND_EMPTYLINES_0}"

            return
        fi

        modprobe ${mod_name}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${FALSE}" "${EXITCODE_99}" "${errmsg_failed_to_load_mod}" "${TRUE}"
        else
            debugPrint__func "${PRINTF_STATUS}" "${printf_successfully_loaded_mod}" "${PREPEND_EMPTYLINES_0}"
        fi
    else
        if $[[ -z ${btList_string} ]]; then   #contains NO data (thus WLAN interface is already disabled)
            debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_down}" "${PREPEND_EMPTYLINES_0}"

            return
        fi

        modprobe -r ${mod_name}
        exitCode=$? #get exit-code
        if [[ ${exitCode} -ne 0 ]]; then    #exit-code!=0 (which means an error has occurred)
            errExit__func "${FALSE}" "${EXITCODE_99}" "${printf_successfully_unloaded_mod}" "${TRUE}"
        else
            debugPrint__func "${PRINTF_STATUS}" "${printf_successfully_unload_mod}" "${PREPEND_EMPTYLINES_0}"
        fi
    fi
}
bt_module_add_to_configFile__func()
{
    #Input args
    local mod_name=${1}
    local leading_emptyLine_isAdded=${2}

    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Write to file
    stdOutput=`cat ${modules_conf_fpath} | grep ${mod_name}`
    if [[ -z ${stdOutput} ]]; then
        if [[ ${leading_emptyLine_isAdded} == ${TRUE} ]]; then
            printf '%b%s\n' "" >> ${modules_conf_fpath}
        fi

        debugPrint__func "${PRINTF_WRITING}" "${mod_name}" "${PREPEND_EMPTYLINES_0}"

        printf '%b%s\n' "${mod_name}" >> ${modules_conf_fpath}
    else
        printf_mod_is_already_added="MODULE '${FG_LIGHTGREY}${mod_name}${NOCOLOR}' IS ALREADY ${FG_GREEN}ADDED${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_added}" "${PREPEND_EMPTYLINES_0}"
    fi
}


bt_firmware_handler__sub()
{
    #Create BT Load-Unload Firmware script
    bt_firmware_create_loadUnload_script__func

    #Create Bluetooth Firmware Service 'bt_fw_loadUnload.service'
    bt_firmware_create_loadUnload_service_and_symlink__func

    #Reload Daemon (IMPORTANT)
    bt_daemon_reload__func

    #Load BT-firmware
    bt_firmware_load__func

}
function bt_firmware_create_loadUnload_script__func()
{
    #-------------------------------------------------------------------------------------
    #This script will be used by service '/etc/systemd/system/tb_bt_firmware.service'
    #-------------------------------------------------------------------------------------

    #Defile local variables
    local sed_version_matchdPattern="version"
    local sed_version_newPattern="${scriptVersion}"
    local sed_to_be_updated_value="to_be_updated_value"
    local sed_fw_matchPAttern="FIRMWARE_FILENAME"
    local sed_fw_newPAttern="${hcd_filename}"
    local sed_sleeptime_matchPattern="FIRMWARE_SLEEPTIME"
    local sed_sleeptime_newPattern="${BT_SLEEPTIME}"
    local sed_ttysxLine_matchdPattern="FIRMWARE_TTYSX_LINE"
    local sed_ttysxLine_newPattern="${BT_TTYSX_LINE}"


    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_script}" "${PREPEND_EMPTYLINES_1}"

    #Write the following contents to file 'tb_bt_firmware.service'
cat > ${tb_bt_firmware_fpath} << "EOL"
#!/bin/bash
#---version:to_be_updated_value
#---Input args
ACTION=${1}

#---Boolean Constants
ENABLE="enable"
DISABLE="disable"

#---Pattern Constants
PATTERN_GREP="grep"

#---Command Constants
BRCM_PATCHRAM_PLUS_FILENAME="brcm_patchram_plus"
BRCM_PATHRAM_PLUS_FPATH=/usr/bin/${BRCM_PATCHRAM_PLUS_FILENAME}
FIRMWARE_FILENAME="to_be_updated_value"
FIRMWARE_FPATH=/etc/firmware/${FIRMWARE_FILENAME}
FIRMWARE_SLEEPTIME=to_be_updated_value
FIRMWARE_TTYSX_LINE=to_be_updated_value


#---local Variables
btDevice_isFound=""

#---Local Functions
usage_sub() 
{
    printf '%b\n' "Usage: $0 {enable|disable}"
	
    exit 1
}
pid_kill_and_check__func()
{
    #Input args
    local pid_input=${1}
    local proc_input=${2}

    #Define local variables
    local RETRY_MAX=3
    local retry_param=0
    local pid_isKilled=$EMPTYSTRING}

    #Kill specified PID and check if it really has been killed
    while true
    do
        #Check if the number of retries have exceeded the allowed maximum
        if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum exceeded
            printf '%b\n' ":--*ERROR: Unable to kill '${pid_input}'"

            return
        fi

        #Kill PID
        kill -9 ${pid_input}

        #Check if PID has been killed
        #REMARK: if TRUE, then 'pid_isKilled' is an EMPTY STRING
        pid_isKilled=`pgrep -f ${proc_input} | grep ${pid_input}` 
        if [[ -z ${pid_isKilled} ]]; then   #pid was not found
            printf '%b\n' ":------>Service-Stop: Killed PID: ${pid_input}"

            break   #exit loop
        fi

        #Process could not be killed...yet
        #Wait for 1 second
        sleep 1

        #Incrememty retry-parameter
        retry_param=$((retry_param+1))
    done  
}

do_enable_sub() {
    #Load Bluetooth Firmware
    printf '%b\n' ""
    printf '%b\n' ":-->Service-Start: Loading BT-firmware '${BRCM_PATCHRAM_PLUS_FILENAME}'"
    printf '%b\n' ":------>Service-Start: Please wait..."
    ${BRCM_PATHRAM_PLUS_FPATH}  -d \
                                --enable_hci \
                                    --no2bytes \
                                        --tosleep ${FIRMWARE_SLEEPTIME} \
                                            --patchram ${FIRMWARE_FPATH} \
                                                ${FIRMWARE_TTYSX_LINE} &

    printf '%b\n' ""
}

do_disable_sub() {
    printf '%b\n' ""
    printf '%b\n' ":-->Service-Stop: Unloading BT-firmware '${BRCM_PATCHRAM_PLUS_FILENAME}'"

    #Get PID List
    local ps_pidList_string=`pgrep -f "${BRCM_PATCHRAM_PLUS_FILENAME}" 2>&1`

    #Convert string to array
    local ps_pidList_array=()
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL FIRMWARE
    for ps_pidList_item in "${ps_pidList_array[@]}"; do
        pid_kill_and_check__func "${ps_pidList_item}" "${BRCM_PATCHRAM_PLUS_FILENAME}"
    done

    printf '%b\n' ":-->Service-Stop: Completed Unloading BT-firmware '${BRCM_PATCHRAM_PLUS_FILENAME}'"
    printf '%b\n' ""
}


#---Check input args
if [[ $# -ne 1 ]]; then	#input args is not equal to 2 
    usage_sub
else
	if [[ ${1} != ${ENABLE} ]] && [[ ${1} != ${DISABLE} ]]; then
		usage_sub
	fi
fi

#---Select case
case "${ACTION}" in
    ${ENABLE})
        do_enable_sub
        ;;
    ${DISABLE})
        do_disable_sub
        ;;
    *)
        usage_sub
        ;;
esac
EOL

    #There are 3 steps:
    #1. Update the values within file 'tb_bt_firmware_template.sh':
    #   1.1 FIRMWARE_SLEEPTIME=to_be_updated_value
    #   1.2 FIRMWARE_TTYSX_LINE=to_be_updated_value
    #2. Save file as '/usr/local/bin/${tb_bt_firmware_fpath}'
    sed -i "/${sed_version_matchdPattern}/s/${sed_to_be_updated_value}/${sed_version_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_fw_matchPAttern}/s/${sed_to_be_updated_value}/${sed_fw_newPAttern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_sleeptime_matchPattern}/s/${sed_to_be_updated_value}/${sed_sleeptime_newPattern}/g" ${tb_bt_firmware_fpath}
    sed -i "/${sed_ttysxLine_matchdPattern}/s/${sed_to_be_updated_value}/${sed_ttysxLine_newPattern}/g" ${tb_bt_firmware_fpath}

    #3. Change file permission to '755'
    chmod 755 ${tb_bt_firmware_fpath}

    
    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${printf_creating_script}" "${PREPEND_EMPTYLINES_0}"
}
function bt_firmware_create_loadUnload_service_and_symlink__func()
{
    #Print
    debugPrint__func "${PRINTF_START}" "${printf_creating_service}" "${PREPEND_EMPTYLINES_1}"

    #There are 2 steps:
    #1.1 Write the following contents to file 'tb_bt_firmware.service'
cat > ${tb_bt_firmware_service_fpath} << EOL
#--------------------------------------------------------------------
#---version:${scriptVersion}
#--------------------------------------------------------------------
# Remarks:
# 1. In oder for the service to run after a reboot
#		make sure to create a 'symlink'
#		ln -s /etc/systemd/system/<myservice.service> /etc/systemd/system/multi-user.target.wants/<myservice.service>
# 2. Reload daemon: systemctl daemon-reload
# 3. Start Service: systemctl start <myservice.service>
# 4. Check status: systemctl status <myservice.service>
#--------------------------------------------------------------------
[Unit]
Description=Loads/Unloads the Bluetooth Firmware.
After=systemd-networkd.service

[Service]
Type=oneshot
#In order to run '${tb_bt_firmware_fpath}' as 'root',
#   'User' has to be defined. In this case it's 'ubuntu'. 
User=ubuntu
RemainAfterExit=true
#In order to run '${tb_bt_firmware_fpath}' as 'root',
#   the to-be-executed script has to be place within
#   /usr/bin/sudo /bin/bash -lc '<script.sh>'
ExecStart=/usr/bin/sudo /bin/bash -lc '${tb_bt_firmware_fpath} enable'
ExecStop=/usr/bin/sudo /bin/bash -lc '${tb_bt_firmware_fpath} disable'
StandardInput=journal+console
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOL

    #1.2. Change file permission to '644'
    chmod 644 ${tb_bt_firmware_service_fpath}

    #2.1 Create a Symlink of 'tb_bt_firmware.service'
    if [[ ! -f ${tb_bt_firmware_service_symlink_fpath} ]]; then
        ln -s ${tb_bt_firmware_service_fpath} ${tb_bt_firmware_service_symlink_fpath}

        #2.2 Change file permission to '777'
        chmod 777 ${tb_bt_firmware_service_symlink_fpath}
    fi

    #Print
    debugPrint__func "${PRINTF_STARTING}" "${printf_creating_service}" "${PREPEND_EMPTYLINES_0}"
}
function bt_daemon_reload__func()
{
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_DAEMON_RELOAD}" "${PREPEND_EMPTYLINES_1}"
    sudo systemctl daemon-reload
}
function bt_firmware_load__func()
{
    #Define local constants
    local RETRY_MAX=3

    #Define local variables
    local pid_isLoaded=${EMPTYSTRING}
    local retry_param=0

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_LOADING_BT_FIRMWARE}" "${PREPEND_EMPTYLINES_1}"

    #Check if BT-firmware is already loaded
    local ps_pidList_string=`pgrep -f "${PATTERN_BRCM_PATCHRAM_PLUS}" 2>&1`
    if [[ ! -z ${ps_pidList_string} ]]; then    #contains data
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_IS_ALREADY_LOADED}" "${PREPEND_EMPTYLINES_0}"
    else
        #In case BT-firmware is not loaded yet
        debugPrint__func "${PRINTF_STARTING}" "${PRINTF_BT_SERVICE}" "${PREPEND_EMPTYLINES_0}"

        #Start BT-firmware service
        systemctl start ${tb_bt_firmware_service_filename}

        #Check if 'Firmware is loaded and running'
        while true
        do
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then
                    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNABLE_TO_LOAD_BT_FIRMWARE}" "${TRUE}"

                    return  #exit loop
            fi

            #REMARK: if TRUE, then 'pid_isKilled' is an EMPTY STRING
            pid_isLoaded=`pgrep -f ${PATTERN_BRCM_PATCHRAM_PLUS}` 
            if [[ ! -z ${pid_isLoaded} ]]; then   #pid was found
                debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_WAS_LOADED_SUCCESSFULLY}" "${PREPEND_EMPTYLINES_0}"

                break   #exit loop
            fi

            #Wait for 1 second
            sleep 1

            #Increment retry-parameter'
            retry_param=$((retry_param+1))

            #Restart
            systemctl restart ${tb_bt_firmware_service_filename}
        done
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_LOADING_BT_FIRMWARE}" "${PREPEND_EMPTYLINES_0}"
}

bt_service_handler__sub() 
{
    #Define local variables
    local ENABLED="enabled"
    local ACTIVE="active"

    #Define local variables
    local isEnabled=${FALSE}
    local isActive=${FALSE}

    #Check if Service is Enabled
    isEnabled=`systemctl is-enabled ${bluetooth_service_filename}`
    if [[ ${isEnabled} != ${ENABLED} ]]; then   #is NOT enabled yet
        #Enable bluetooth.service
        systemctl enable ${bluetooth_service_filename}
    
        #Wait for 1 second
        sleep 1
        
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_enabled}" "${PREPEND_EMPTYLINES_1}"
    else    #is already enabled
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_is_already_enabled}" "${PREPEND_EMPTYLINES_1}"
    fi



    #Check if Service is Enabled
    isActive=`systemctl is-active ${bluetooth_service_filename}`
    if [[ ${isEnabled} != ${ENABLED} ]]; then   #is NOT enabled yet
        #Enable bluetooth.service
        systemctl start ${bluetooth_service_filename}
    
        #Wait for 1 second
        sleep 1
        
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_started}" "${PREPEND_EMPTYLINES_0}"
    else    #is already enabled
        #Print
        debugPrint__func "${PRINTF_STATUS}" "${printf_bluetooth_service_is_already_started}" "${PREPEND_PREPEND_EMPTYLINES_0EMPTYLINES_1}"
    fi
}

bt_intf_handler__sub()
{
    #Check if Bluetooth interface is present
    bt_intf_selection__func
}
function bt_intf_selection__func()
{
    #Define local variables
    local btList_string=${EMPTYSTRING}
    local btList_array=()
    local btList_arrayLen=0
    local btList_arrayItem=${EMPTYSTRING}

    #Print
    debugPrint__func "${PRINTF_START}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${PREPEND_EMPTYLINES_1}"

    #Get available BT-interfaces
    #Explanation:
    #   hcitool dev:        get interface names
    #   tr -d '\r\n':       trim '\r' and '\n'
    #   cut -d":" -f2:      get substring right-side of ':'
    #   awk '{print $1}':   get results of column#: 1
    btList_string=`hcitool dev | tr -d '\r\n' | cut -d":" -f2 | awk '{print $1}'`
    if [[ ! -z ${btList_string} ]]; then    #contains data
        #Convert string to array
        eval "btList_array=(${btList_string})"

        #Show available BT-interface(s)
        for btList_arrayItem in "${btList_array[@]}"; do
            debugPrint__func "${PRINTF_FOUND}" "${btList_arrayItem}" "${PREPEND_EMPTYLINES_0}"
        done   
    else    #contains NO data
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_NO_BT_INTERFACE_FOUND}" "${TRUE}"
    fi

    #Print
    debugPrint__func "${PRINTF_COMPLETED}" "${PRINTF_RETRIEVING_BT_INTERFACE}" "${PREPEND_EMPTYLINES_0}"
}



#---MAIN SUBROUTINE
main__sub()
{
    load_env_variables__sub

    load_header__sub
    
    init_variables__sub

    input_args_case_select__sub

    dynamic_variables_definition__sub

    # update_and_upgrade__sub

    # software_inst__sub

    bt_module_handler__sub

    bt_firmware_handler__sub

    bt_service_handler__sub

    bt_intf_handler__sub
}


#---EXECUTE
main__sub