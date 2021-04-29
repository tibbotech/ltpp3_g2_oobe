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



#---INPUT-ARG CONSTANTS
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

QUESTION_CHAR="?"

FOUR_SPACES="    "
EIGHT_SPACES=${FOUR_SPACES}${FOUR_SPACES}
THIRTYTWO_SPACES=${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}${EIGHT_SPACES}

EXITCODE_99=99

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

#---PATTERN CONSTANTS
PATTERN_BCMDHD="bcmdhd"
PATTERN_IW="iw"

#---COMMAND RELATED CONSTANTS
IW_CMD="iw"
SED_CMD="sed"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"

INPUT_NO="n"
INPUT_YES="y"



#---PRINTF PHASES
PRINTF_CONFIRM="CONFIRM:"
PRINTF_QUESTION="QUESTION:"
PRINTF_STATUS="STATUS:"
PRINTF_SUGGESTION="SUGGESTION:"

#---HELPER/USAGE PRINT CONSTANTS
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---ERROR MESSAGE CONSTANTS
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

ERRMSG_CTRL_C_WAS_PRESSED="CTRL+C WAS PRESSED..."
ERRMSG_USER_IS_NOT_ROOT="USER IS NOT ${FG_LIGHTGREY}ROOT${NOCOLOR}"

#---PRINT MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Bluetooth Main-menu."



#---VARIABLES



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)


    var_backups_dir=/var/backups
    tb_bt_mainmenu_bck_filename="tb_bt_mainmenu.bck"
    tb_bt_mainmenu_bck_fpath=${var_backups_dir}/${tb_bt_mainmenu_bck_filename}
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
    if [[ ! -f ${wlan_inst_fpath} ]]; then #file not found
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

    if [[ ! -f ${tb_bt_mainmenu_bck_fpath} ]]; then #file does NOT exist
        reboot_isRequired=${FALSE}
    else
        if [[ ! -s ${tb_bt_mainmenu_bck_fpath} ]]; then #file does NOT contain any data
            reboot_isRequired=${FALSE}
        else
            reboot_isRequired=`${SED_CMD} -n ${LINENUM_1}p ${tb_bt_mainmenu_bck_fpath}`
        fi
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
    local MEMUHEADER_WIFI_MAINMENU="BLUETOOTH MAIN-MENU"
    local MENUMSG_INSTALL="Install"
    local MENUMSG_PAIR_CONNECTTO_RFCOMM="Pair + Connect to rfcomm"
    local MENUMSG_BT_ONOFF="Bluetooth On/Off"
    local MENUMSG_BT_INFO="Bluetooth Info"
    local MENUMSG_UNINSTALL="Uninstall"
    local MENUMSG_REBOOT="Reboot"
    local MENUMSG_Q_QUIT="Quit (Ctrl+C)"

    local MENUMSG_REQUIRED=${EMPTYSTRING}
    local MENUMSG_BT_STATE="${EMPTYSTRING}"

    local REGEX_INST="1,q"
    local REGEX_PAIR_CONNECT_TO_RFCOMM="2,q"
    local REGEX_ALL_EXCL_INST="2-3,i,u,r,q"
    local REGEX_UINST_REBOOT="u,r,q"

    local software_isInstalled=${FALSE}
    local mod_isLoaded=${FALSE} #If TRUE, then it doesn't mean that BT-interface is Present (BT-firmware still needs to be loaded)
    local bt_isPresent=${FALSE} #this means that the BT-firmware is Loaded
    local bt_state=${STATUS_DOWN}   #By default the BT-interface goes UP automatically after loading the BT-firmware


    #Define local variables
    local myChoice=${EMPTYSTRING}
    local regEx=${EMPTYSTRING}

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
        #1. WiFi-software installation and module status
        #2. WiFi-interface presence
        #3. SSID-configuration status
        #4. Netplan-configuration status
        software_isInstalled=`bt_validate_mod_and_software__func`
        if [[ ${software_isInstalled} == ${FALSE} ]]; then
            #Remark: 'reboot_isRequired' is set to {TRUE|FALSE} in subroutine 'bt_mainmenu_uninstall__sub'
            if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                regEx=${REGEX_UINST_REBOOT}
            else
                regEx=${REGEX_INST}
            fi
        else    #software_isInstalled = TRUE
            #Check if WiFi is PRESENT
            bt_isPresent=`bt_checkIf_intf_isPresent__func`
            if [[ ${bt_isPresent} == ${FALSE} ]]; then
                #Remark: 'reboot_isRequired' is set to TRUE in function 'bt_checkIf_intf_isPresent__func'
                regEx=${REGEX_UINST_REBOOT}
            else    #bt_isPresent = TRUE
                #Get Wifi-Interface
                bt_retrieve_intfName__func

                #Get WiFi-status (UP or DOWN)
                bt_state=`bt_get_state__func`


            fi
        fi

        #!!!BACKUP!!! Write 'reboot_isRequired' to file '/tmp/tb_bt_mainmenu.tmp'
        #REMARK: cannot write this in function 'bt_checkIf_intf_isPresent__func', because...
        #........this function outputs a value
        echo "${reboot_isRequired}" > ${tb_bt_mainmenu_bck_fpath}
    

        #Show menu items based on the chosen 'regEx'
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FG_LIGHTBLUE}${MEMUHEADER_WIFI_MAINMENU}${NOCOLOR}${THIRTYTWO_SPACES}v21.03.17-0.0.1"
        printf "%s\n" "----------------------------------------------------------------------"
        if [[ ${regEx} == ${REGEX_INST} ]]; then  #WiFi software not installed
            printf "%s\n" "${FOUR_SPACES}1 ${FG_LIGHTGREY}${MENUMSG_INSTALL}${NOCOLOR}"
        else    #WiFi software has been installed
            if [[ ${regEx} == ${REGEX_PAIR_CONNECT_TO_RFCOMM} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                printf "%s\n" "${FOUR_SPACES}2 ${FG_LIGHTGREY}${MENUMSG_SSID_PLUS_NETPLAN_CONFIG}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_NETPLAN_CONF} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                printf "%s\n" "${FOUR_SPACES}3 ${FG_LIGHTGREY}${MENUMSG_NETPLAN_CONFIG}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Change the contents of 'MENUMSG_INTERFACE_ONOFF' based on 'bt_state'
                if [[ ${bt_state} == ${STATUS_DOWN} ]]; then
                    MENUMSG_BT_STATE="${FG_SOFTLIGHTRED}${STATUS_DOWN}${NOCOLOR}"
                else
                    MENUMSG_BT_STATE="${FG_LIGHTGREEN}${STATUS_UP}${NOCOLOR}"
                fi
                printf "%s\n" "${FOUR_SPACES}4 ${FG_LIGHTGREY}${MENUMSG_INTERFACE_ONOFF}${NOCOLOR} (${MENUMSG_BT_STATE})"
                printf "%s\n" "----------------------------------------------------------------------"
                printf "%s\n" "${FOUR_SPACES}i ${FG_LIGHTGREY}${MENUMSG_INTERFACE_INFO}${NOCOLOR}"
            fi
            if [[ ${regEx} == ${REGEX_UINST_REBOOT} ]] || [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                #Only show 'recommended' if 'regEx = REGEX_UINST_REBOOT'
                if [[ ${reboot_isRequired} == ${TRUE} ]]; then
                    MENUMSG_REQUIRED=" (${FG_SOFTLIGHTRED}required${NOCOLOR})"
                fi

                #Only print horizontal line if 'regEx = REGEX_ALL_EXCL_INST'
                if [[ ${regEx} == ${REGEX_ALL_EXCL_INST} ]]; then
                    printf "%s\n" "----------------------------------------------------------------------"
                fi
                printf "%s\n" "${FOUR_SPACES}u ${FG_LIGHTGREY}${MENUMSG_UNINSTALL}${NOCOLOR}"
                printf "%s\n" "${FOUR_SPACES}r ${FG_LIGHTGREY}${MENUMSG_REBOOT}${NOCOLOR}${MENUMSG_REQUIRED}"
            fi
        fi
        printf "%s\n" "----------------------------------------------------------------------"
        printf "%s\n" "${FOUR_SPACES}q ${FG_LIGHTGREY}${MENUMSG_Q_QUIT}${NOCOLOR}"
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
                bt_mainmenu_ssid_netplan_config__sub
                ;;

            3)
                bt_mainmenu_netplan_config__sub
                ;;

            4)
                bt_mainmenu_interface_onoff__sub
                ;;

            i)
                bt_mainmenu_connect_info__sub
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

bt_mainmenu_install__sub() {
    echo "IN PROGRESS"
}

bt_mainmenu_connect_info__sub() {
    echo "IN PROGRESS"
}

bt_mainmenu_uninstall__sub() {
    echo "IN PROGRESS"
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

    load_tibbo_banner__sub

    checkIfisRoot__sub
    
    init_variables__sub

    input_args_case_select__sub

    bt_mainmenu__sub
}



#EXECUTE
main_sub
