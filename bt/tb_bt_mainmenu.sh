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
trap 'errTrap__func $BASH_LINENO "$BASH_COMMAND" $(printf "::%s" ${FUNCNAME[@]})'  EXIT
trap CTRL_C_func INT



#---INPUT ARGS CONSTANTS
ARGSTOTAL_MIN=1

#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_PURPLERED=$'\e[30;38;5;198m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_SOFTLIGHTBLUE=$'\e[30;38;5;80m'
FG_GREEN=$'\e[30;38;5;76m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'

TIBBO_FG_WHITE=$'\e[30;38;5;15m'
TIBBO_BG_ORANGE=$'\e[30;48;5;209m'

#---CONSTANTS (OTHER)
TITLE="TIBBO"

EMPTYSTRING=""

PLUS_CHAR="+"
QUESTION_CHAR="?"

FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
THIRTYTWO_SPACES=${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
BLUETOOTHCTL_CMD="bluetoothctl"
RFCOMM_CMD="rfcomm"
HCICONFIG_CMD="hciconfig"
IW_CMD="iw"
SED_CMD="sed"

PAIRED_DEVICES="paired-devices"

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

LINENUM_1=1

#---READ INPUT CONSTANTS
INPUT_NO="n"
INPUT_YES="y"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

BT_UP="up"
BT_DOWN="down"

#---PATTERN CONSTANTS
PATTERN_BLUEZ="bluez"

PATTERN_BLUETOOTH="bluetooth"
PATTERN_HCI_UART="hci_uart"
PATTERN_RFCOMM="rfcomm"
PATTERN_BNEP="bnep"
PATTERN_HIDP="hidp"

PATTERN_HCI="hci"

PATTERN_PAIRED="Paired"
PATTERN_NO_DEFAULT_CONTROLLER_AVAILABLE="No default controller available"

#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Bluetooth Main-menu."



#---PRINTF PHASES
PRINTF_CONFIRM="CONFIRM:"
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_SUGGESTION="SUGGESTION:"

#---PRINTF ERROR MESSAGES
ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"



#---VARIABLES



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    tb_bt_inst_filename="tb_bt_inst.sh"
    tb_bt_inst_fpath=${current_dir}/${tb_bt_inst_filename}

    tb_bt_conn_filename="tb_bt_conn.sh"
    tb_bt_conn_fpath=${current_dir}/${tb_bt_conn_filename}

    tb_bt_onoff_filename="tb_bt_onoff.sh"
    tb_bt_onoff_fpath=${current_dir}/${tb_bt_onoff_filename}

    tb_bt_conn_info_filename="tb_bt_conn_info.sh"
    tb_bt_conn_info_fpath=${current_dir}/${tb_bt_conn_info_filename}

    tb_bt_uninst_filename="tb_bt_uninst.sh"
    tb_bt_uninst_fpath=${current_dir}/${tb_bt_uninst_filename}

    var_backups_dir=/var/backups
    tb_bt_mainmenu_reboot_isRequired_bck_filename="tb_bt_mainmenu_reboot_isRequired.bck"
    tb_bt_mainmenu_reboot_isRequired_bck_fpath=${var_backups_dir}/${tb_bt_mainmenu_reboot_isRequired_bck_filename}

    tb_bt_mainmenu_system_uptime_bck_filename="tb_bt_mainmenu_system_uptime.bck"
    tb_bt_mainmenu_system_uptime_bck_fpath=${var_backups_dir}/${tb_bt_mainmenu_system_uptime_bck_filename}
}



#---FUNCTIONS
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

function checkIf_fileExists__func() {
    #Input args
    local file_toBeChecked=${1}

    #Define local variables
    local errmsg_file_not_found="FILE ${FG_LIGHTRED}NOT${NOCOLOR} FOUND '${FG_LIGHTGREY}${file_toBeChecked}${NOCOLOR}'"

    #Check if file exist
    if [[ ! -f ${file_toBeChecked} ]]; then #file not found
        errExit__func "${TRUE}" "${EXITCODE_99}" "${errmsg_file_not_found}" "${TRUE}"
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
        printf '%s%b\n' ${EMPTYSTRING}
    fi

    printf '%s%b\n' "***${FG_LIGHTRED}ERROR${NOCOLOR}(${errCode}): ${errMsg}"
    if [[ ${show_exitingNow} == ${TRUE} ]]; then
        printf '%s%b\n' "${FG_ORANGE}EXITING:${NOCOLOR} ${thisScript_filename}"
        printf '%s%b\n' ${EMPTYSTRING}
        
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
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: START"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "BASH COMMAND: ${FG_LIGHTGREY}${bash_command}${NOCOLOR}"
        printf '%s%b\n' "LINE-NUMBER: ${FG_LIGHTGREY}${bash_lineNum}${NOCOLOR}"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' "***${FG_PURPLERED}TRAP${NOCOLOR}: END"
        printf '%s%b\n' ${EMPTYSTRING}
        printf '%s%b\n' ${EMPTYSTRING}
    fi
}

function CTRL_C_func() {
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_CTRL_C_WAS_PRESSED}" "${TRUE}"
}



#---SUBROUTINES
update_system_uptime__sub() {
    #Get new uptime
    system_uptime_new=`uptime -s`

    if [[ ! -f ${tb_bt_mainmenu_system_uptime_bck_fpath} ]]; then #file does NOT exist
        #set flag to FALSE
        system_uptime_isSame=${FALSE}
    else
        if [[ ! -s ${tb_bt_mainmenu_system_uptime_bck_fpath} ]]; then #file does NOT contain any data
            #set flag to FALSE
            system_uptime_isSame=${FALSE}
        else    #file contains data
            #Get uptime from file
            system_uptime_old=`${SED_CMD} -n ${LINENUM_1}p ${tb_bt_mainmenu_system_uptime_bck_fpath}`

            #Compare 'old' with 'new' uptime
            if [[ ${system_uptime_old} != ${system_uptime_new} ]]; then #system was rebooted
                system_uptime_isSame=${FALSE}
            else    #system was NOT rebooted
                system_uptime_isSame=${TRUE}
            fi
        fi
    fi

    #write 'new' uptime to file
    echo "${system_uptime_new}" > ${tb_bt_mainmenu_system_uptime_bck_fpath} 
}

checkIf_reboot_isRequired_flag_isPending__func() {
    if [[ ! -f ${tb_bt_mainmenu_reboot_isRequired_bck_fpath} ]]; then #file does NOT exist
        #set flag to FALSE
        reboot_isRequired=${FALSE}

        #write to file
        echo "${reboot_isRequired}" > ${tb_bt_mainmenu_reboot_isRequired_bck_fpath}
    else
        if [[ ! -s ${tb_bt_mainmenu_reboot_isRequired_bck_fpath} ]]; then #file does NOT contain any data
            #set flag to FALSE
            reboot_isRequired=${FALSE}

            #write to file
            echo "${reboot_isRequired}" > ${tb_bt_mainmenu_reboot_isRequired_bck_fpath} 
        else    #file contains data
            #Check if system uptime is the same (which means there was NO REBOOT)
            if [[ ${system_uptime_isSame} == ${TRUE} ]]; then #system was NOT rebooted
                #Get flag from file
                reboot_isRequired=`${SED_CMD} -n ${LINENUM_1}p ${tb_bt_mainmenu_reboot_isRequired_bck_fpath}`
            else    #system was rebooted
                #set flag to FALSE
                reboot_isRequired=${FALSE}

                #write to file
                echo "${reboot_isRequired}" > ${tb_bt_mainmenu_reboot_isRequired_bck_fpath}                
            fi
        fi
    fi
}

load_tibbo_banner__sub() {
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
}

checkIfisRoot__sub()
{
    #Define Local variables
    local currUser=`whoami`
    local ROOTUSER="root"
    local ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}SUDO${NOCOLOR} OR ${FG_LIGHTGREY}ROOT${NOCOLOR}"

    #Check if user is 'root'
    if [[ ${currUser} != ${ROOTUSER} ]]; then   #not root
        errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_USER_IS_NOT_ROOT}" "${TRUE}"    
    fi
}

init_variables__sub()
{
    errExit_isEnabled=${TRUE}
    exitCode=0
    isInitStartup=${TRUE}   #this variable will be changed to 'FALSE' in subroutine 'bt_mainmenu__sub'
    trapDebugPrint_isEnabled=${FALSE}
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
}

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}

bt_mainmenu__sub() {
    #Define local constants
    local CONNECTTO_RFCOMM="Connect to rfcomm"
    local PAIR="Pair"
    local NONE="none"
    local REQUIRED="required"

    local MEMUHEADER_WIFI_MAINMENU="BLUETOOTH MAIN-MENU"
    local MENUMSG_INSTALL="Install"
    local MENUMSG_BT_ONOFF="Bluetooth Up/Down"   #show indications like (N/A, UP, DOWN)
    local MENUMSG_BT_INFO="Bluetooth Info"  #run tb_bt_conn_info.sh
    local MENUMSG_UNINSTALL="Uninstall"
    local MENUMSG_REBOOT="Reboot"
    local MENUMSG_Q_QUIT="Quit (Ctrl+C)"

    local MENUMSG_REQUIRED=${EMPTYSTRING}
    local MENUMSG_BT_STATE="${EMPTYSTRING}"

    local REGEX_INST="1,q"
    local REGEX_PAIR_AND_CONNTO_RFCOMM="2,q"
    local REGEX_BLUETOOTH_UPDOWN="3,q"
    local REGEX_ALL_EXCL_INST="2-3,i,u,r,q"
    local REGEX_REBOOT="r,q"

    #Define local variables
    local myChoice=${EMPTYSTRING}
    local regEx=${EMPTYSTRING}

    local preCheck_isPass=${FALSE}
    local bt_isEnabled=${FALSE}
    local isPaired=${FALSE}
    local isBound=${FALSE}

    #Start loop
    while true
    do
        #Show Tibbo Banner
        if [[ ${isInitStartup} == ${FALSE} ]]; then
            load_tibbo_banner__sub
        else
            isInitStartup=${FALSE}  #change flag to FALSE
        fi

        #Choose the most suitable 'regEx' based on:
        preCheck_isPass=`validate_handler__func`
        if [[ ${preCheck_isPass} == ${FALSE} ]]; then  #not all components are available
            #Remark: 'reboot_isRequired' is set to {TRUE|FALSE} in subroutine 'bt_mainmenu_uninstall__sub'
            if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                regEx=${REGEX_REBOOT}
            else
                regEx=${REGEX_INST}
            fi
        else    #all componenents are available
            bt_isEnabled=`bluetooth_checkIf_isUp__func`
            if [[ ${bt_isEnabled} == ${FALSE} ]]; then
                #Remark: 'reboot_isRequired' maybe have been set by a previous action
                if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                    regEx=${REGEX_REBOOT}
                else
                    regEx=${REGEX_BLUETOOTH_UPDOWN}
                fi
            else
                #Check if there are any Paired Devices
                isPaired=`bluetoothctl_checkIf_pairedDevice_isPresent__func`
                isBound=`rfcomm_checkIf_isBound__func`
                if [[ ${isPaired} == ${FALSE} ]]; then  #no paired-devices found
                    #Remark: 'reboot_isRequired' maybe have been set by a previous action
                    if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                        regEx=${REGEX_REBOOT}
                    else
                        regEx=${REGEX_PAIR_AND_CONNTO_RFCOMM}
                    fi
                else    #at least one paired-device was found
                    if [[ ${isBound} == ${FALSE} ]]; then  #at least one of the paired-devices are NOT bound
                        #Remark: 'reboot_isRequired' maybe have been set by a previous action
                        if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                            regEx=${REGEX_REBOOT}
                        else
                            regEx=${REGEX_PAIR_AND_CONNTO_RFCOMM}
                        fi
                    else    #all paired-devices are bound
                        #Remark: 'reboot_isRequired' maybe have been set by a previous action
                        if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                            regEx=${REGEX_REBOOT}
                        else
                            regEx=${REGEX_ALL_EXCL_INST}
                        fi
                    fi
                fi
            fi
        fi

#-------!!!BACKUP!!! Write 'reboot_isRequired' to file '/tmp/tb_bt_mainmenu.tmp'
        #REMARK: cannot write this in function 'bt_checkIf_intf_isPresent__func', because...
        #........this function outputs a value
        echo "${reboot_isRequired}" > ${tb_bt_mainmenu_reboot_isRequired_bck_fpath}
    

#-------Initial values
        local menuMsg_pair_colored="${FG_LIGHTGREY}${PAIR}${NOCOLOR}" #initial value
        local menuMsg_connectTo_rfcomm_colored="${FG_LIGHTGREY}${CONNECTTO_RFCOMM}${NOCOLOR}" #initial value
        local menuMsg_pair_connectTo_rfcomm_colored=${EMPTYSTRING}
        local menuMsg_bluetooth_onOff_colored="${FG_LIGHTGREY}${MENUMSG_BT_ONOFF}${NOCOLOR}"  #initial value
        local menuMsg_bluetooth_info_colored="${FG_LIGHTGREY}${MENUMSG_BT_INFO}${NOCOLOR}"
        local menuMsg_uninstall_colored="${FG_LIGHTGREY}${MENUMSG_UNINSTALL}${NOCOLOR}"
        local menuMsg_reboot_colored="${FG_LIGHTGREY}${MENUMSG_REBOOT}${NOCOLOR}"
        local menuMsg_quit_colored="${FG_LIGHTGREY}${MENUMSG_Q_QUIT}${NOCOLOR}"

        local numOf_pairs=0
        local numOf_binds=0

        local numOf_pairs_colored=${EMPTYSTRING}
        local numOf_binds_colored=${EMPTYSTRING}
        local btState_colored=${EMPTYSTRING}
        local required_colored="${FG_SOFTLIGHTRED}${REQUIRED}${NOCOLOR}"

        #Show menu items based on the chosen 'regEx'
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FG_LIGHTBLUE}${MEMUHEADER_WIFI_MAINMENU}${NOCOLOR}${THIRTYTWO_SPACES}v21.03.17-0.0.1"
        printf "%s\n" "----------------------------------------------------------------------"
        if [[ ${regEx} == ${REGEX_INST} ]]; then  #WiFi software not installed
#-----------Option: 1
            printf "%s\n" "${FOUR_SPACES}1 ${FG_LIGHTGREY}${MENUMSG_INSTALL}${NOCOLOR}"
        else    #WiFi software has been installed
#-----------Option: 2
            if [[ ${regEx} == ${REGEX_PAIR_AND_CONNTO_RFCOMM} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
#---------------Compose: 'Pair' message
                if [[ ${isPaired} == ${FALSE} ]]; then
                    numOf_pairs_colored="${FG_SOFTLIGHTRED}${NONE}${NOCOLOR}"
                else    #bt_isEnabled = TRUE
                    numOf_pairs=`${BLUETOOTHCTL_CMD} ${PAIRED_DEVICES} | wc -l`
                    numOf_pairs_colored="${FG_LIGHTGREEN}${numOf_pairs}${NOCOLOR}"
                fi
                #Combine 'menuMsg_pair_colored' with 'numOf_binds_colored'    
                menuMsg_pair_colored="${menuMsg_pair_colored} (${numOf_pairs_colored})"


                #Compose 'Connect tp rfcomm' message
                if [[ ${isBound=$FALSE} == ${FALSE} ]]; then
                    numOf_binds_colored="${FG_SOFTLIGHTRED}${NONE}${NOCOLOR}"
                else    #bt_isEnabled = TRUE
                    numOf_binds=`${RFCOMM_CMD} | wc -l`
                    numOf_binds_colored="${FG_LIGHTGREEN}${numOf_binds}${NOCOLOR}"
                fi
                #Combine 'CONNECTTO_RFCOMM_LIGHTGREY' with 'numOf_binds_colored'    
                menuMsg_connectTo_rfcomm_colored="${menuMsg_connectTo_rfcomm_colored} (${numOf_binds_colored})"


#---------------Compose: 'menuMsg_pair_connectTo_rfcomm_colored'
                menuMsg_pair_connectTo_rfcomm_colored="${menuMsg_pair_colored} ${PLUS_CHAR} ${menuMsg_connectTo_rfcomm_colored}"

                #Print
                printf "%s\n" "${FOUR_SPACES}2 ${menuMsg_pair_connectTo_rfcomm_colored}"
            fi

#-----------Option: 3
            if [[ ${regEx} == ${REGEX_BLUETOOTH_UPDOWN} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                if [[ ${bt_isEnabled} == ${FALSE} ]]; then
                    btState_colored="${FG_SOFTLIGHTRED}${BT_DOWN}${NOCOLOR}"
                else    #bt_isEnabled = TRUE
                    btState_colored="${FG_LIGHTGREEN}${BT_UP}${NOCOLOR}"
                fi
                #Combine 'MENUMSG_BT_ONOFF' with 'btState_colored'
                menuMsg_bluetooth_onOff_colored="${menuMsg_bluetooth_onOff_colored} (${btState_colored})"

                printf "%s\n" "${FOUR_SPACES}3 ${menuMsg_bluetooth_onOff_colored}"

                printf "%s\n" "----------------------------------------------------------------------"
            fi

#-----------Option: i
            if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                printf "%s\n" "${FOUR_SPACES}i ${menuMsg_bluetooth_info_colored}"

#-----------Option: u
                printf "%s\n" "${FOUR_SPACES}u ${menuMsg_uninstall_colored}"

                printf "%s\n" "----------------------------------------------------------------------"
            fi

#-----------Option: r
            if [[ ${regEx} == ${REGEX_REBOOT} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Only show 'required' if 'regEx = REGEX_REBOOT'
                if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                    menuMsg_reboot_colored="${menuMsg_reboot_colored} (${required_colored})"
                fi

                printf "%s\n" "${FOUR_SPACES}r ${menuMsg_reboot_colored}"

                printf "%s\n" "----------------------------------------------------------------------"
            fi
        fi

#-----------Option: q        
        printf "%s\n" "${FOUR_SPACES}q ${menuMsg_quit_colored}"
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" ${EMPTYSTRING}

        #Make a choice
        while true
        do
            #Select an option
            read -N 1 -e -p "Please choose an option: " myChoice
            printf "%s\n" ${EMPTYSTRING}

            #Only continue if a valid option is selected
            if [[ ! -z ${myChoice} ]]; then
                if [[ ${myChoice} =~ [${regEx}] ]]; then
                    break
                else
                    tput cuu1	#move UP with 1 line
                    tput cuu1	#move UP with 1 line
                    tput el		#clear until the END of line
                fi
            else
                tput cuu1	#move UP with 1 line
                tput el		#clear until the END of line
            fi
        done
            
        #Goto the selected option
        case ${myChoice} in
            1)
                bt_mainmenu_install__sub
                ;;

            2)
                bt_mainmenu_pair_plus_connectTo_rfcomm__sub
                ;;

            3)
                bt_mainmenu_bluetooth_upDown__sub
                ;;

            i)
                bt_mainmenu_bluetooth_info__sub
                ;;

            u)
                bt_mainmenu_uninstall__sub
                ;;

            r)
                bt_mainmenu_reboot__sub
                ;;

            q)
                exit
                ;;
        esac
    done
}
function validate_handler__func() {
    #Define local variables
    local mods_arePresent=${FALSE}
    local software_isInstalled=${FALSE}
    local firmware_service_isPresent=${FALSE}
    local bluetooth_service_isPresent=${FALSE}
    local errMsg=${EMPTYSTRING}

    #Check if BT-modules are loaded and 'bluez' is installed
    mods_arePresent=`bt_validate_mods_func`
    if [[ ${mods_arePresent} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi

    software_isInstalled=`software_checkIf_isInstalled__func "${PATTERN_BLUEZ}"`
    if [[ ${software_isInstalled} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi

    firmware_service_isPresent=`service_checkIf_isPresent__func "${tb_bt_firmware_service_filename}"`
    if [[ ${firmware_service_isPresent} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi
    bluetooth_service_isPresent=`service_checkIf_isPresent__func "${bluetooth_service_filename}"`
    if [[ ${bluetooth_service_isPresent} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi

    #All modules, software, and services are OK
    echo ${TRUE}
}
function bt_validate_mods_func() {
    #Define local variables
    local bluetooth_isLoaded=${FALSE}
    local hci_uart_isLoaded=${FALSE}
    local rfcomm_isLoaded=${FALSE}
    local bnep_isLoaded=${FALSE}
    local hdip_isLoaded=${FALSE}
    
    #First: check if ALL modules are Loaded
    #REMARK: if FALSE, then exit function immediately
    bluetooth_isLoaded=`mod_checkIf_isPresent ${PATTERN_BLUETOOTH}`
    if [[ ${bluetooth_isLoaded} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi
    hci_uart_isLoaded=`mod_checkIf_isPresent ${PATTERN_HCI_UART}`
    if [[ ${hci_uart_isLoaded} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi
    rfcomm_isLoaded=`mod_checkIf_isPresent ${PATTERN_RFCOMM}`
    if [[ ${rfcomm_isLoaded} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi
    bnep_isLoaded=`mod_checkIf_isPresent ${PATTERN_BNEP}`
    if [[ ${bnep_isLoaded} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi
    hdip_isLoaded=`mod_checkIf_isPresent ${PATTERN_HIDP}`
    if [[ ${hdip_isLoaded} == ${FALSE} ]]; then
        echo ${FALSE}

        return
    fi

    #In case all modules have been loaded, return the value 'TRUE'
    echo ${TRUE}
}
function mod_checkIf_isPresent() {
    #Input args
    local mod_name=${1}

    #Check if a specified module is loaded
    stdOutput=`lsmod | grep ${mod_name} 2>&1`
    if [[ -z ${stdOutput} ]]; then   #contains NO data
        echo "${FALSE}"
    else    #contains data
        echo "${TRUE}"
    fi
}
function software_checkIf_isInstalled__func() {
    #Input args
    local software_input=${1}

    #Define local variables
    local stdOutput=`apt-mark showinstall | grep ${software_input} 2>&1`

    #If 'stdOutput' is an EMPTY STRING, then software is NOT installed yet
    if [[ -z ${stdOutput} ]]; then #contains NO data
        echo ${FALSE}
    else    #contains data
        echo ${TRUE}
    fi
}
function service_checkIf_isPresent__func() {
    #Input args
    local service_input=${1}

    #Define local constants
    local PATTERN_COULD_NOT_BE_FOUND="could not be found"

    #Check if service is present
    local stdOutput=`${SYSTEMCTL_CMD} status ${service_input} 2>&1`
    if [[ ${stdOutput} == ${PATTERN_COULD_NOT_BE_FOUND} ]]; then    #service does not exist
        echo ${FALSE}
    else    #service does exist
        echo ${TRUE}
    fi
}

function bluetooth_checkIf_isUp__func() {
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Bluetooth is 'UP' means:
# 1. Bluetooth interface (e.g. hci0) is AVAILABLE
#    This automatically means that:
#    - firmware BCM4345C5_003.006.006.0058.0135.hcd is loaded
#    - service 'tb_bt_firmware.service' is running and enabled
# 2. Bluetooth interface (e.g. hci0) is UP
#    This could mean that: 
#   - service 'bluetooth.service' is running and enabled
#   However, in order to bring UP the bluetooth interface,...
#   ...it is NOT necessary for this service be running and enabled
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    #Define local variables
    local btList_string=${EMPTYSTRING}
    local btList_array=()
    local btList_arrayItem=${EMPTYSTRING}
    local stdOutput=${EMPTYSTRING}

    #Get available BT-interfaces
    btList_string=`${HCICONFIG_CMD} | grep "${PATTERN_HCI}" | awk '{print $1}' | cut -d":" -f1 | xargs`

    if [[ ! -z ${btList_string} ]]; then    #contains data
        #Convert string to array
        eval "btList_array=(${btList_string})"

        #Show available BT-interface(s)
        for btList_arrayItem in "${btList_array[@]}"
        do
            #Check if BT-interface is UP?
            stdOutput=`${HCICONFIG_CMD} ${btList_arrayItem} | grep "${STATUS_UP}"`  
            if [[ ! -z ${stdOutput} ]]; then   #contains data (interface is UP)
                echo ${TRUE}

                #Do not exit function nor break loop
                #Continue on and check other interfaces as well (if any)
            else    #contains no data (interface is DOWN)
                echo ${FALSE}

                return  #exit function right away
            fi    
        done   
    else    #contains NO data
        echo ${FALSE}
    fi
}

function rfcomm_checkIf_isBound__func() {
    #Define local variables
    local stdOutput=${EMPTYSTRING}

    #Check if there are any MAC-addresses bound to rfcomm
    stdOutput=`rfcomm 2>&1`
    if [[ -z ${stdOutput} ]]; then  #contains NO data (no bindings found)
        echo ${FALSE}
    else    #contains data (at least one binding found)
        echo ${TRUE}
    fi
}

function bluetoothctl_checkIf_pairedDevice_isPresent__func() {
    #Define local variables
    local stdOutput1=${EMPTYSTRING}
    local stdOutput2=${EMPTYSTRING}

    #Get information regarding Paired Devices
    stdOutput1=`bluetoothctl paired-devices`
    if [[ -z ${stdOutput1} ]]; then #contains NO data
        echo ${FALSE}
    else    #contains data
        stdOutput2=`echo ${stdOutput1} | grep "${PATTERN_NO_DEFAULT_CONTROLLER_AVAILABLE}"`
        if [[ ! -z ${stdOutput2} ]]; then #contains data matching the specified pattern
            echo ${FALSE}  
        else    #contains NO data matching the specified pattern
            echo ${TRUE}
        fi
    fi
}

bt_mainmenu_install__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${tb_bt_inst_fpath}"

    #Execute file
    ${tb_bt_inst_fpath}
}

bt_mainmenu_pair_plus_connectTo_rfcomm__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${tb_bt_conn_fpath}"

    #Execute file
    ${tb_bt_conn_fpath}
}

bt_mainmenu_bluetooth_upDown__sub() {
    #Define local variables
    local oldState_isUP=${EMPTYSTRING}
    local newState_isUP=${EMPTYSTRING}

    #Get the 'old' state
    oldState_isUP=`bluetooth_checkIf_isUp__func`

    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${tb_bt_onoff_fpath}"

    #Execute file
    ${tb_bt_onoff_fpath}

    #Get the 'new' state
    newState_isUP=`bluetooth_checkIf_isUp__func`

    #Check if the bluetooth state has changed by comparing 'oldState_isUP' with 'newState_isUP'
    if [[ ${oldState_isUP} == ${newState_isUP} ]]; then   #state has NOT changed (FAILED to load firmware)
        reboot_isRequired=${TRUE}
    else    #state has changed (SUCCESSFULLY loaded firmware)
        if [[ ${oldState_isUP} == ${FALSE} ]]; then #the 'old' state was 'DOWN' and changed to 'UP'
            reboot_isRequired=${TRUE}
        else    #the 'old' state was 'UP' and changed to 'DOWN'
            reboot_isRequired=${FALSE}
        fi
    fi
}

bt_mainmenu_bluetooth_info__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${tb_bt_conn_info_fpath}"

    #Execute file
    ${tb_bt_conn_info_fpath}
}

bt_mainmenu_uninstall__sub() {
    #Check if file exists
    #REMARK: if file does NOT exist, then exit
    checkIf_fileExists__func "${tb_bt_uninst_fpath}"

    #Execute file
    ${tb_bt_uninst_fpath}

    #IMPORTANT: set flag to TRUE
    reboot_isRequired=${TRUE}    
}

bt_mainmenu_reboot__sub() {
    #Define local constants
    local QUESTION_REBOOT_NOW="REBOOT NOW (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"
    local QUESTION_ARE_YOU_VERY_SURE="ARE YOU VERY SURE (${FG_YELLOW}y${NOCOLOR}es/${FG_YELLOW}n${NOCOLOR}o)?"

    #Define local variables
    local myChoice=${EMPTYSTRING}

    #Print Question
    debugPrint__func "${PRINTF_QUESTION}" "${QUESTION_REBOOT_NOW}" "${EMPTYLINES_0}"

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
main_sub() {
    load_env_variables__sub

    update_system_uptime__sub

    checkIf_reboot_isRequired_flag_isPending__func

    load_tibbo_banner__sub

    checkIfisRoot__sub
    
    init_variables__sub

    input_args_case_select__sub

    bt_mainmenu__sub
}



#EXECUTE
main_sub
