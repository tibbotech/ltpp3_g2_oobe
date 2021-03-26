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

BT_TTYSX_LINE=/dev/ttyS4
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
ERRMSG_UNKNOWN_OPTION="UNKNOWN OPTION: '${arg1}'"



#---HELPER/USAGE PRINT CONSTANTS
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to toggle BT-module & install BT-software"



#---PRINT CONSTANTS
PRINTF_COMPLETED="COMPLETED:"
PRINTF_CONFIGURE="CONFIGURE:"
PRINTF_CREATING="CREATING:"
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_INFO="INFO:"
PRINTF_INSTALLING="INSTALLING:"
PRINTF_QUESTION="QUESTION:"
PRINTF_SET="SET:"
PRINTF_START="START:"
PRINTF_STARTING="STARTING:"
PRINTF_STATUS="STATUS:"
PRINTF_TERMINATING="TERMINATING:"
PRINTF_TOGGLE="TOGGLE:"
PRINTF_VERSION="VERSION:"
PRINTF_WRITING="WRITING:"

PRINTF_ONE_MOMENT_PLEASE="ONE MOMENT PLEASE..."
PRINTF_PRESS_ABORT_OR_ANY_KEY_TO_CONTINUE="Press (a)bort or any key to continue..."

PRINTF_ENABLING_BLUETOOTH_MODULES="---:ENABLING BT *MODULES*"

PRINTF_BT_FIRMWARE="---:BT *FIRMWARE*"
PRINTF_BT_FIRMWARE_IS_RUNNING="BT *FIRMWARE* IS ${FG_GREEN}RUNNING${NOCOLOR}"
PRINTF_BT_FIRMWARE_IS_ALREADY_RUNNING="BT *FIRMWARE* IS ALREADY ${FG_GREEN}RUNNING${NOCOLOR}"
PRINTF_BT_FIRMWARE_START_SCRIPT="BT *FIRMWARE* START SCRIPT"
PRINTF_BT_SOFTWARE="BT *SOFTWARE*"
PRINTF_UPDATES_UPGRADES="UPDATES & UPGRADES"




#---VARIABLES
dynamic_variables_definition__sub()
{
    printf_writing_bt_modules_to_config_file="---:WRITING BT *MODULES* TO '${FG_LIGHTGREY}${modules_conf_fpath}${NOCOLOR}'"
}




#---PATHS
load_env_variables__sub()
{
    thisScript_fpath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    thisScript_current_dir=$(dirname ${thisScript_fpath})
    thisScript_filename=$(basename $0)

    etc_modules_load_d_dir=/etc/modules-load.d
    modules_conf_filename="modules.conf"
    modules_conf_fpath=${etc_modules_load_d_dir}/${modules_conf_filename}

    usr_local_bin_dir=/usr/local/bin  #script location
    bt_daemon_onoff_filename="bt_daemon_onoff.sh"
    bt_daemon_onoff_fpath=${usr_local_bin_dir}/${bt_daemon_onoff_filename}
    
    etc_systemd_system_dir=/etc/systemd/system #service location
    bt_daemon_onoff_service_filename="bt_daemon_onoff.service"
    bt_daemon_onoff_service_fpath=${etc_systemd_system_dir}/${bt_daemon_onoff_service_filename}   

    etc_systemd_system_multi_user_target_wants_dir=/etc/systemd/system/multi-user.target.wants #service-symlink location
    bt_daemon_onoff_service_symlink_filename="bt_daemon_onoff.service"
    bt_daemon_onoff_service_symlink_fpath=${etc_systemd_system_multi_user_target_wants_dir}/${bt_daemon_onoff_service_symlink_filename} 

    usr_bin_dir=/usr/bin
    brcm_patchram_plus_filename=${PATTERN_BRCM_PATCHRAM_PLUS}
    brcm_patchram_plus_fpath=${usr_bin_dir}/${brcm_patchram_plus_filename}

    etc_firmware_dir=/etc/firmware
    hcd_filename="BCM4345C5_003.006.006.0058.0135.hcd"
    hcd_fpath=${etc_firmware_dir}/${hcd_filename}

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
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_UNKNOWN_OPTION}" "${FALSE}"
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
    local wlanList_string=${EMPTYSTRING}

    #Print messages
    errmsg_failed_to_load_mod="FAILED TO LOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    printf_successfully_unloaded_mod="FAILED TO UNLOAD MODULE: ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

    printf_mod_is_already_up="MODULE ${FG_LIGHTGREY}${mod_name}${NOCOLOR} IS ALREADY ${FG_GREEN}${STATUS_UP}${NOCOLOR}"
    printf_mod_is_already_down="MODULE ${FG_LIGHTGREY}${mod_name}${NOCOLOR} IS ALREADY ${FG_LIGHTRED}${STATUS_DOWN}${NOCOLOR}"

    printf_successfully_loaded_mod="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *LOADED* MODULE ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"
    PRINTF_SUCCESSFULLY_UNLOADED_WIFI_MODULE_BCMDHD="${FG_GREEN}SUCCESSFULLY${NOCOLOR} *UNLOADED* MODULE ${FG_LIGHTGREY}${mod_name}${NOCOLOR}"

   #Check if 'wlanSelectIntf' is present
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
        if $[[ -z ${wlanList_string} ]]; then   #contains NO data (thus WLAN interface is already disabled)
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
        printf_mod_is_already_added="MODULE ${FG_LIGHTGREY}${mod_name}${NOCOLOR} IS ALREADY ${FG_GREEN}ADDED${NOCOLOR}"
        debugPrint__func "${PRINTF_STATUS}" "${printf_mod_is_already_added}" "${PREPEND_EMPTYLINES_0}"
    fi
}


bt_firmware_handler__sub()
{
    #Create Bluetooth bt_firmware_startstop.sh'  scripts


    #Create Bluetooth Firmware Service 'bt_firmware_startstop.service'
    #Add Symlink
    #sudo udevadm control --reload-rules
    #sudo systemctl daemon-reload

    #Load firmware if not done yet (by starting the 'bt_firmware_startstop.service')
    debugPrint__func "${PRINTF_STARTING}" "${PRINTF_BT_FIRMWARE}" "${PREPEND_EMPTYLINES_1}"
        bt_firmware_load__func "${BT_TTYSX_LINE}" "${BT_BAUDRATE}" "${BT_SLEEPTIME}" "${hcd_fpath}"
   #>>>>>>>>>>>>>>>>>SOMETHING HAS TO BE DONE HERE!!!! in function 'bt_firmware_load__func' 


}
function bt_firmware_load__func()
{
    #Input args
    local ttySxLine_input=${1}
    local baudRate_input=${2}
    local sleepTime_input=${3}
    local firmware_fpath=${4}

    #Define local variables
    local printf_msg=${EMPTYSTRING}    
    local ps_pidList_string=${EMPTYSTRING}
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*20=20) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0


    #Check if Bluetooth Daemon is running
    ps_pidList_string=`ps axf | grep -E "${PATTERN_BRCM_PATCHRAM_PLUS}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
    if [[ ! -z ${ps_pidList_string} ]]; then
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_IS_ALREADY_RUNNING}" "${PREPEND_EMPTYLINES_0}"

        return  #exit function
    fi


    #Print
    printf_msg="TTYS-LINE: ${FG_LIGHTGREY}${ttySxLine_input}${NOCOLOR}"
    debugPrint__func "${PRINTF_SET}" "${printf_msg}" "${PREPEND_EMPTYLINES_0}"

    printf_msg="BAUD-RATE: ${FG_LIGHTGREY}${baudRate_input}${NOCOLOR}"
    debugPrint__func "${PRINTF_SET}" "${printf_msg}" "${PREPEND_EMPTYLINES_0}"

    printf_msg="SLEEP-TIME: ${FG_LIGHTGREY}${sleepTime_input} [msec]${NOCOLOR}"
    debugPrint__func "${PRINTF_SET}" "${printf_msg}" "${PREPEND_EMPTYLINES_0}"

    printf_msg="FIRMWARE-LOCATION: ${FG_LIGHTGREY}${firmware_fpath}${NOCOLOR}"
    debugPrint__func "${PRINTF_SET}" "${printf_msg}" "${PREPEND_EMPTYLINES_0}"

    #Execute command
    #REMARK:
    #   baudrate-option is NOT used 
    #       ISSUE:      Due to a bug, which is, once the BT-Daemon is killed,...
    #                   it cannot be restarted without a reboot of the LTPP3-G2 device.
    #       RESOLUTION: This issue can be resolved by NOT setting the baudrate-option!!!.
    #   Notice the '&' at the end of this command. This means that this command is running in the Background
    ${brcm_patchram_plus_fpath} --enable_hci \
                                    --no2bytes \
                                        --tosleep ${sleepTime_input} \
                                            --patchram ${firmware_fpath} \
                                                ${ttySxLine_input} &

    # ${brcm_patchram_plus_fpath} -d \
    #                             --enable_hci \
    #                                 --no2bytes \
    #                                     --tosleep ${sleepTime_input} \
    #                                         --baudrate ${baudRate_input} \
    #                                             --patchram ${firmware_fpath} \
    #                                                 ${ttySxLine_input} &

    #Check if Bluetooth Daemon is running 
    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        ps_pidList_string=`ps axf | grep -E "${PATTERN_BRCM_PATCHRAM_PLUS}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ ! -z ${ps_pidList_string} ]]; then  #BT-firmware is running
            debugPrint__func "${PRINTF_STATUS}" "${PRINTF_BT_FIRMWARE_IS_RUNNING}" "${PREPEND_EMPTYLINES_0}"

            break
        fi

        sleep ${DAEMON_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        #Print
        clear_lines__func ${NUMOF_ROWS_1}
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 10 times
            errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_START_BT_DAEMON}" "${TRUE}"

            break
        fi
    done

    #Check if Bluetooth Device (e.g. hci0) is Found
    #REMARK: use hciconfig
#>>>>>>>>>>>>>>>>>SOMETHING HAS TO BE DONE HERE!!!!



}

bt_daemon_create_script__sub()
{
    debugPrint__func "${PRINTF_CREATING}" "${PRINTF_BT_FIRMWARE_START_SCRIPT}" "${PREPEND_EMPTYLINES_1}"

}


bt_firmware_unload__sub()
{
    bt_daemon_stop__func
}
function bt_daemon_stop__func()
{
    #Define local variables
    local prepend_emptylines=${PREPEND_EMPTYLINES_0}
    local ps_pidList_string=${EMPTYSTRING}
    local ps_pidList_array=()
    local ps_pidList_item=${EMPTYSTRING}
    local sleep_timeout_max=$((DAEMON_TIMEOUT*DAEMON_RETRY))    #(1*20=20) seconds max
    local RETRY_PARAM_MAX=sleep_timeout_max
    local retry_param=0
    local stdOutput=${EMPTYSTRING}

    #Check if the BT-firmware is already stopped
    #If TRUE, then exit function immediately
    if [[ ${bt_firmware_isRunning} == ${FALSE} ]]; then
        return
    fi 
    
    #If that's the case, kill the BT-firmware
    if [[ ${errExit_isEnabled} == ${TRUE} ]]; then
        prepend_emptylines=${PREPEND_EMPTYLINES_1}
    fi
    debugPrint__func "${PRINTF_TERMINATING}" "${PRINTF_BT_FIRMWARE}" "${prepend_emptylines}"

    #Get PID List
    local ps_pidList_string=`ps axf | grep -E "${PATTERN_BRCM_PATCHRAM_PLUS}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`

    #Convert string to array
    eval "ps_pidList_array=(${ps_pidList_string})"

    #KILL FIRMWARE
    for ps_pidList_item in "${ps_pidList_array[@]}"; do 
        printf '%b\n' "${EIGHT_SPACES}${FG_LIGHTRED}Killed${NOCOLOR} PID: ${ps_pidList_item}"

        kill -9 ${ps_pidList_item}
    done

    #INITIAL: ONE MOMENT PLEASE message
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"


    #CHECK IF FIRMWARE HAS BEEN KILLED AND EXIT
    while true
    do
        #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
        ps_pidList_string=`ps axf | grep -E "${PATTERN_BRCM_PATCHRAM_PLUS}" | grep -v "${PATTERN_GREP}" | awk '{print $1}' 2>&1`
        if [[ -z ${ps_pidList_string} ]]; then  #deamons are NOT running
            bt_firmware_isRunning=${FALSE}

            break
        else    #deamons are running
            bt_firmware_isRunning=${TRUE}
        fi

        sleep ${DAEMON_TIMEOUT}  #wait

        retry_param=$((retry_param+1))  #increment counter

        #Print
        clear_lines__func ${NUMOF_ROWS_1}
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_ONE_MOMENT_PLEASE}${retry_param} (${sleep_timeout_max})" "${PREPEND_EMPTYLINES_0}"

        #Only allowed to retry 10 times
        #Whether the SSID Connection is Successful or NOT, exit Loop!!!
        if [[ ${retry_param} -ge ${RETRY_PARAM_MAX} ]]; then    #only allowed to retry 10 times
            break
        fi
    done

    #HANDLE RESULT
    if [[ ${bt_firmware_isRunning} == ${TRUE} ]]; then    #BT-firmware is still running (not good)
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_FAILED_TO_TERMINATE_BLUETOOTH_FIRMWARE}" "${TRUE}"
    fi
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


#>>>CONTINUE HERE
    bt_firmware_handler__sub

    #NOTE: once you have created the rules/services, make sure to RELOAD:
    #sudo udevadm control --reload-rules
    #sudo systemctl daemon-reload


    # bt_services_handler__sub
    # 2 things to be done here:
    #1. systemctl enable bluetooth.service
    #2. systemctl start bluetoot.service check_bluetooth_service sudo systemctl status bluetooth.service


#Once every thing is done, test the systemctl stop 'bt_firmware_startstop.service'


}


#---EXECUTE
main__sub