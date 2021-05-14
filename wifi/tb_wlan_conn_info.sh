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


#---INPUT-ARG CONSTANTS
ARGSTOTAL_MIN=1

#---COLORS CONSTANTS
NOCOLOR=$'\e[0m'
FG_LIGHTRED=$'\e[1;31m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_YELLOW=$'\e[1;33m'
FG_LIGHTSOFTYELLOW=$'\e[30;38;5;229m'
FG_LIGHTBLUE=$'\e[30;38;5;51m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'

TIBBO_FG_WHITE=$'\e[30;38;5;15m'
TIBBO_BG_ORANGE=$'\e[30;48;5;209m'

#---CONSTANTS (OTHER)
TITLE="TIBBO"

EMPTYSTRING=""

QUESTION_CHAR="?"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"

FOUR_SPACES="    "

NO_ROUTE="no route"

ZERO=0
HUNDRED=100

#---EXIT CODES
EXITCODE_99=99

#---COMMAND RELATED CONSTANTS
IFCONFIG_CMD="ifconfig"
IW_CMD="iw"
ROUTE_CMD="route"
SED_CMD="sed"

#---LINE CONSTANTS
EMPTYLINES_0=0
EMPTYLINES_1=1
EMPTYLINES_3=3

LINENUM_2=2
LINENUM_3=3
LINENUM_4=4
LINENUM_5=5

#---PATTERN CONSTANTS
PATTERN_ADDRESSES="addresses"
PATTERN_GLOBAL="global"
PATTERN_INET="inet"
PATTERN_INET6="inet6"
PATTERN_INTERFACE="Interface"
PATTERN_GREP="grep"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

STATUS_UP="UP"
STATUS_DOWN="DOWN"


#---HELPER/USAGE PRINTF PHASES
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_VERSION="VERSION:"

#---HELPER/USAGE PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINTF MESSAGES
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to retrieve WiFi Connection Information."



#---PRINTF PHASES
PRINTF_INFO="INFO:"
PRINTF_STATUS="STATUS:"

#---PRINT MESSAGES
PRINTF_PLEASE_WAIT="PLEASE WAIT..."
PRINTF_RETRIEVING_WIFI_CONNECTION_STATUS_INFO="RETRIEVING WIFI CONNECTION INFO"
PRINTF_WIFI_CONNECTION_INFO="WIFI CONNECTION INFO"



#---PATHS
load_env_variables__sub()
{
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    tmp_dir=/tmp
    tb_wlan_conn_info_tmp1__filename="tb_wlan_conn_info.tmp1"
    tb_wlan_conn_info_tmp1__fpath=${tmp_dir}/${tb_wlan_conn_info_tmp1__filename}
    tb_wlan_conn_info_tmp__filename="tb_wlan_conn_info.tmp"
    tb_wlan_conn_info_tmp__fpath=${tmp_dir}/${tb_wlan_conn_info_tmp__filename}

    run_netplan_dir=/run/netplan
    wpa_wlan0_conf_filename="wpa-wlan0.conf"
    wpa_wlan0_conf_fpath=${run_netplan_dir}/${wpa_wlan0_conf_filename}
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

#---SUBROUTINE
load_tibbo_banner__sub() {
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" "${TIBBO_BG_ORANGE}                                 ${TIBBO_FG_WHITE}${TITLE}${TIBBO_BG_ORANGE}                                ${NOCOLOR}"
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

init_variables__sub()
{
    netplanDaemon_isRunning=${TRUE}
    wlanSelectIntf=${EMPTYSTRING}
    wlanIntState=${STATUS_DOWN}
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
    
    printf "%s\n" ${EMPTYSTRING}
    printf "%s\n" ${EMPTYSTRING}
}

input_args_print_no_input_args_required__sub()
{
    errExit__func "${TRUE}" "${EXITCODE_99}" "${ERRMSG_INPUT_ARGS_NOT_SUPPORTED}" "${FALSE}"
    errExit__func "${FALSE}" "${EXITCODE_99}" "${ERRMSG_FOR_MORE_INFO_RUN}" "${TRUE}"
}


wifi_connect_info_handler__sub() {
    #Get Interface-name (if present)
    wifi_intf_retrieveName__func

    #Get WiFi Connection Info and Write to a Temporary File
    wifi_connect_info_retrieve__func

    #Get WiFi IP-address(es) and append to the existing Temporary File
    retrieve_ip46_addr__func

    #Clear the 2 STATUS printf messages
    #REMARK: these messages were printed in function 'Show WiFi Connection Info'
    clear_lines__func   ${EMPTYLINES_3}

    #Show WiFi Connection Info
    wifi_connect_info_show__func

    #Press any key
    press_any_key__func
}
function wifi_intf_retrieveName__func() {
    wlanSelectIntf=`${IW_CMD} dev | grep Interface | cut -d" " -f2`
}
function wifi_connect_info_retrieve__func() {
    #Define local constants
    local SLEEP_TIMEOUT=1
    local RETRY_MAX=20

    #REMARK: The following SIGNAL-LEVEL (or SIGNAL-STRENGTH)...
    #        ...are based on my calculations done using...
    #        ...command: iwlist wlan0 scan
    #        FORMULA: LEVEL = QUALITY + 110
    local SIGNAL_LEVEL_MAX=-40
    local SIGNAL_LEVEL_MIN=-110

    local NOT_AVAILABLE="n/a"
    local NOT_CONNECTED="not connected"

    #Define local variables
    local intf_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
    local ssid_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
    local freq_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
    local signal_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
    local speed_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
    local fieldValue_org=${EMPTYSTRING}
    local fieldValue1=${EMPTYSTRING}
    local fieldValue2=${EMPTYSTRING}
    local fieldValue3=${EMPTYSTRING}
    local retry_param=1
    local signal_level_diff=$((SIGNAL_LEVEL_MAX-SIGNAL_LEVEL_MIN))  #MAX SIGNAL-QUALITY=(-40)-(-110)=70
    local wifi_state=${STATUS_DOWN}

    local isConnected=${FALSE}

    local iw_get_wlanIntfInfo_isSkipped=${FALSE}


    #Print message (will be removed at a later time in this function)
    debugPrint__func "${PRINTF_STATUS}" "${PRINTF_RETRIEVING_WIFI_CONNECTION_STATUS_INFO}" "${EMPTYLINES_1}"

    #Remove Temporary Files
    if [[ -f ${tb_wlan_conn_info_tmp1__fpath} ]]; then
        rm ${tb_wlan_conn_info_tmp1__fpath}
    fi

    if [[ -f ${tb_wlan_conn_info_tmp__fpath} ]]; then
        rm ${tb_wlan_conn_info_tmp__fpath}
    fi

    #Create EMPTY Temporary Files
    touch ${tb_wlan_conn_info_tmp1__fpath}
    touch ${tb_wlan_conn_info_tmp__fpath}

    #Check if 'wlanSelectIntf' contains data (if FALSE, then NO WiFi-interface was found)
    if [[ -z ${wlanSelectIntf} ]]; then #no data found
        #Set to 'DOWN'
        wlanIntState=${STATUS_DOWN}

        #Set flag to TRUE
        iw_get_wlanIntfInfo_isSkipped=${TRUE}
    else
        #Get WiFi-status (UP or DOWN)
        wlanIntState=`wifi_get_state__func`
        if [[ ${wlanIntState} == ${STATUS_DOWN} ]]; then
            #Write to file 'tb_wlan_conn_info.tmp'
            wifi_state="${FG_SOFTLIGHTRED}${wlanIntState}${NOCOLOR}"

            #Set flag to TRUE
            iw_get_wlanIntfInfo_isSkipped=${TRUE}
        else    #wlanIntState = UP
            #REMARK: this value will be used later on in this function
            wifi_state="${FG_LIGHTGREEN}${wlanIntState}${NOCOLOR}"

            #Update variable, set to 'UP'
            # wlanIntState=${STATUS_UP}
        fi

        #Update variable 'intf_fieldvalue'
        intf_fieldvalue="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} (${wifi_state})"
    fi

    #Check if Daemon is Running
    netplanDaemon_isRunning=`daemon_checkIf_isRunning__func "${wpa_wlan0_conf_fpath}"`
    if [[ ${netplanDaemon_isRunning} == ${FALSE} ]]; then
        #Set flag to TRUE
        iw_get_wlanIntfInfo_isSkipped=${TRUE}
    fi

    #In case 'iw_get_wlanIntfInfo_isSkipped = TRUE', then...
    #...write data to file and exit function immediately.
    #REMARK: 
    #   This would prevent the command 'iw dev wlan0 link'...
    #...from being executed resulting in a timeout of 20 seconds,...
    #...because:
    #   1. WiFi-interface is DOWN
    #   2. Netplan daemon is not running, thus no WiFi-connection
    if [[ ${iw_get_wlanIntfInfo_isSkipped} == ${TRUE} ]]; then
        wifi_connect_info_writeToFile__func "${intf_fieldvalue}" \
                                                "${ssid_fieldvalue}" \
                                                    "${freq_fieldvalue}" \
                                                        "${signal_fieldvalue}" \
                                                            "${speed_fieldvalue}"

        #Exit function
        return
    fi

    #Only continue if 'wlanSelectIntf' contains data (which means WiFi-interface was found)
    #Get WiFi Connection Information using tool 'iw'
    #...and write to file 'tb_wlan_conn_info.tmp1'
    while true   #loop while file is EMPTY for a maximum of 10 seconds
    do
        #Update Please Wait (with seconds indication)
        debugPrint__func "${PRINTF_STATUS}" "${PRINTF_PLEASE_WAIT} ${FG_LIGHTGREY}${retry_param}${NOCOLOR} out-of ${FG_LIGHTGREY}${RETRY_MAX}${NOCOLOR} sec" "${EMPTYLINES_0}"

        #Get data
        ${IW_CMD} dev ${wlanSelectIntf} link | awk '{$1=$1};1' > ${tb_wlan_conn_info_tmp1__fpath}

        #Check if file contains data
        if [[ -s ${tb_wlan_conn_info_tmp1__fpath} ]]; then  #file contains data
            isConnected=`checkIf_connectedTo_ssid__func`

            if [[ ${isConnected} == ${TRUE} ]]; then  #no data found (which means 'is connected')
                break
            fi
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}  #wait for 1 second

        #Check if the maximum retry has exceeded
        #If TRUE, then break loop (not exit script)
        if [[ ${retry_param} -eq ${RETRY_MAX} ]]; then
            break
        else
            #Increment parameter by 1
            retry_param=$((retry_param+1))

            #Move-up 1 line and clear 'Please Wait (with seconds indication)'
            clear_lines__func "${EMPTYLINES_1}"
        fi
    done

    #In case WiFi-Interface is NOT connected to SSID
    if [[ ${isConnected} == ${FALSE} ]]; then
        #Write to file 'tb_wlan_conn_info.tmp'
        wifi_state="${FG_SOFTLIGHTRED}${NOT_CONNECTED}${NOCOLOR}"
        intf_fieldvalue="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} (${wifi_state})"
        ssid_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
        freq_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
        signal_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"
        speed_fieldvalue="${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}"

        wifi_connect_info_writeToFile__func "${intf_fieldvalue}" \
                                                "${ssid_fieldvalue}" \
                                                    "${freq_fieldvalue}" \
                                                        "${signal_fieldvalue}" \
                                                            "${speed_fieldvalue}"

        #Exit function
        return
    fi 


    #Read from File 'tb_wlan_conn_info.tmp1'
    if [[ ! -z ${tb_wlan_conn_info_tmp1__fpath} ]]; then
#-------INTERFACE
        #Get the required information
        wifi_state="${FG_LIGHTGREEN}${STATUS_UP}${NOCOLOR}"
        intf_fieldvalue="${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR} (${wifi_state})"

#-------SSID
        #Get the value of the 2nd line
        fieldValue_org=`${SED_CMD} -n ${LINENUM_2}p ${tb_wlan_conn_info_tmp1__fpath}`
        fieldValue1=`echo "${fieldValue_org}" | cut -d":" -f2 | awk '{$1=$1};1'` #get rid off 'SSID: '
        ssid_fieldvalue=${fieldValue1}

#-------FREQ
        #Get the value of the 3rd line
        fieldValue_org=`${SED_CMD} -n ${LINENUM_3}p ${tb_wlan_conn_info_tmp1__fpath}`
        fieldValue1=`echo "${fieldValue_org}" | cut -d":" -f2 | awk '{$1=$1};1'` #get rid off 'freq: '
        fieldValue2=`echo "${fieldValue1}" | cut -d" " -f1` #get rid off 'Ghz'
        fieldValue3=`echo "${fieldValue2}" | convertTo_thousands__func`   #insert comma-delimiter
        freq_fieldvalue="${FG_LIGHTGREY}${fieldValue3}${NOCOLOR} Ghz"

#-------SIGNAL-QUALITY
        #Get the value of the 4th line
        fieldValue_org=`${SED_CMD} -n ${LINENUM_4}p ${tb_wlan_conn_info_tmp1__fpath}`
        fieldValue1=`echo "${fieldValue_org}" | cut -d":" -f2 | awk '{$1=$1};1'` #get rid off 'signal: '
        fieldValue2=`echo "${fieldValue1}" | cut -d" " -f1` #get rid off 'dBm'
        fieldValue3=$(( ( (fieldValue2-SIGNAL_LEVEL_MIN)*100 )/signal_level_diff ))
        #Corrective-action if 'fieldValue3 < 0' or fieldValue3 < 100'
        if [[ ${fieldValue3} -lt ${ZERO} ]]; then
            fieldValue3=${ZERO}
        else
            if [[ ${fieldValue3} -gt ${HUNDRED} ]]; then
                fieldValue3=${HUNDRED}
            fi
        fi

        #Choose color based on 'fieldValue3' value
        fieldValue3_chosenColor=`wifi_connect_info_chooseColor__func "${fieldValue3}"`
        
        #Compose 'signal_fieldvalue' to be printed
        signal_fieldvalue="${fieldValue3_chosenColor}${fieldValue3}${NOCOLOR}% (${FG_LIGHTGREY}${fieldValue2}${NOCOLOR} dBm)"

#-------RATE
        #Get the value of the 5th line
        fieldValue_org=`${SED_CMD} -n ${LINENUM_5}p ${tb_wlan_conn_info_tmp1__fpath}`
        fieldValue1=`echo "${fieldValue_org}" | cut -d":" -f2 | awk '{$1=$1};1'` #get rid off 'tx bitrate: '
        fieldValue2=`echo "${fieldValue1}" | cut -d" " -f1` #get rid off 'MBit/s'
        speed_fieldvalue="${FG_LIGHTGREY}${fieldValue2}${NOCOLOR} Mbit/s"

        wifi_connect_info_writeToFile__func "${intf_fieldvalue}" \
                                                "${ssid_fieldvalue}" \
                                                    "${freq_fieldvalue}" \
                                                        "${signal_fieldvalue}" \
                                                            "${speed_fieldvalue}"
    fi
}
function daemon_checkIf_isRunning__func()
{
    #Input args
    local configFpath_input=${1}
    
    #Check if Daemon is running
    if [[ ! -f ${configFpath_input} ]]; then  #file does NOT exist
        echo ${FALSE}
    else    #file does exist
        local ps_pidList_string=`ps axf | grep -E "${configFpath_input}" | grep -v "${PATTERN_GREP}" | awk '{print $1}'`
        if [[ ! -z ${ps_pidList_string} ]]; then  #daemon is running
            echo ${TRUE}
        else    #daemon is NOT running
            echo ${FALSE}
        fi
    fi
}
function wifi_connect_info_chooseColor__func()
{
    #Input args
    local perc_input=${1}

    #Define local colors
    local FG_GREEN_46=$'\e[30;38;5;46m'
    local FG_GREEN_82=$'\e[30;38;5;82m'
    local FG_GREEN_118=$'\e[30;38;5;118m'
    local FG_GREENYELLOW_154=$'\e[30;38;5;155m'
    local FG_GREENYELLOW_148=$'\e[30;38;5;148m'
    local FG_YELLOW_226=$'\e[30;38;5;226m'
    local FG_YELLOWORANGE_215=$'\e[30;38;5;215m'
    local FG_ORANGE_208=$'\e[30;38;5;208m'
    local FG_DARKERORANGE_202=$'\e[30;38;5;202m'
    local FG_RED_196=$'\e[30;38;5;196m'

    #Define local constants
    local PERC_10=10
    local PERC_20=20
    local PERC_30=30
    local PERC_40=40
    local PERC_50=50
    local PERC_60=60
    local PERC_70=70
    local PERC_80=80
    local PERC_90=90

    #Choose color based on input parameter
    if [[ ${perc_input} -lt ${PERC_10} ]]; then
        chosenColor=${FG_RED_196}
    elif [[ ${perc_input} -ge ${PERC_10} ]] && [[ ${perc_input} -lt ${PERC_20} ]]; then
        chosenColor=${FG_DARKERORANGE_202}
    elif [[ ${perc_input} -ge ${PERC_20} ]] && [[ ${perc_input} -lt ${PERC_30} ]]; then
        chosenColor=${FG_ORANGE_208}
    elif [[ ${perc_input} -ge ${PERC_30} ]] && [[ ${perc_input} -lt ${PERC_40} ]]; then
        chosenColor=${FG_YELLOWORANGE_215}
    elif [[ ${perc_input} -ge ${PERC_40} ]] && [[ ${perc_input} -lt ${PERC_50} ]]; then
        chosenColor=${FG_YELLOW_226}
    elif [[ ${perc_input} -ge ${PERC_50} ]] && [[ ${perc_input} -lt ${PERC_60} ]]; then
        chosenColor=${FG_GREENYELLOW_148}
    elif [[ ${perc_input} -ge ${PERC_60} ]] && [[ ${perc_input} -lt ${PERC_70} ]]; then
        chosenColor=${FG_GREENYELLOW_154}
    elif [[ ${perc_input} -ge ${PERC_70} ]] && [[ ${perc_input} -lt ${PERC_80} ]]; then
        chosenColor=${FG_GREEN_118}
    elif [[ ${perc_input} -ge ${PERC_80} ]] && [[ ${perc_input} -lt ${PERC_90} ]]; then
        chosenColor=${FG_GREEN_82}
    else    #perc_input > 90%
        chosenColor=${FG_GREEN_46}
    fi

    #Output
    echo ${chosenColor}
}
function wifi_connect_info_writeToFile__func()
{
    #Input args
    local intf_fieldvalue=${1}
    local ssid_fieldvalue=${2}
    local freq_fieldvalue=${3}
    local signal_fieldvalue=${4}
    local speed_fieldvalue=${5}

    #Define local constants
    local FIELD_INTF="intf"
    local FIELD_SSID="SSID"
    local FIELD_FREQ="freq"
    local FIELD_SIGNAL="sign"
    local FIELD_RATE="rate"
    local TAB_CHAR="\t"
    local COLON_CHAR=":"

    #Define local variables
    local fieldName=${EMPTYSTRING}
    local fieldValue=${EMPTYSTRING}
    local lineNum=1

    while [[ ${lineNum} -le 5 ]]
    do
        #Initialize variables
        fieldName=${EMPTYSTRING}
        fieldValue=${EMPTYSTRING}

        #Get field-name
        case $lineNum in
            1)
                fieldName=${FIELD_INTF}
                fieldValue=${intf_fieldvalue}
                ;;
            2)
                fieldName=${FIELD_SSID}
                fieldValue=${ssid_fieldvalue}
                ;;
            3)
                fieldName=${FIELD_FREQ}
                fieldValue=${freq_fieldvalue}
                ;;
            4)
                fieldName=${FIELD_SIGNAL}
                fieldValue=${signal_fieldvalue}
                ;;
            5)
                fieldName=${FIELD_RATE}
                fieldValue=${speed_fieldvalue}
                ;;
        esac

        #Write to file 'tb_wlan_conn_info.tmp'
        #REMARK:
        #   -do NOT color 'fieldName'
        #   -color 'fieldValue' with 'FG_LIGTHGREY'
        echo -e "${FOUR_SPACES}${fieldName}${COLON_CHAR}${TAB_CHAR}${fieldValue}" >> ${tb_wlan_conn_info_tmp__fpath}

        #Increment line-number by 1
        lineNum=$((lineNum+1))  
    done
}
function wifi_get_state__func() {
    local stdOutput=`ip link show ${wlanSelectIntf} | grep ${STATUS_UP} 2>&1`
    if [[ -z ${stdOutput} ]]; then #no data found
        echo ${STATUS_DOWN}
    else    #data was found
         echo ${STATUS_UP}
    fi
}
function checkIf_connectedTo_ssid__func() {
    #Define local constants
    local PATTERN_NOT_CONNECTED="Not connected"

    #Check if connected to SSID
    local stdOutput=`cat ${tb_wlan_conn_info_tmp1__fpath} | grep "${PATTERN_NOT_CONNECTED}"`
    if [[ ! -z ${stdOutput} ]]; then    #data was found
        echo ${FALSE}
    else    #no data found
        echo ${TRUE}
    fi
}

function convertTo_thousands__func {
    #REMARK:
    #   In sed, the 't' command specifies a label that will be jumped to...
    #...if the last 's/x/x/x' command was successful.
    #...Therefore a label called ':restart' has to be defined...
    #...in order for it jumps back.
    ${SED_CMD} -re ' :restart ; s/([0-9])([0-9]{3})($|[^0-9])/\1,\2\3/ ; t restart '
}

function retrieve_ip46_addr__func() {
    #Define Local constants
    local FIELDNAME_IPV4="ipv4"
    local FIELDNAME_IPV6="ipv6"
    local PATTERN_UG="UG"
    local SLEEP_TIMEOUT=1
    local IPV4_RETRY_MAX=20
    local GW4_RETRY_MAX=1
    local IPV6_RETRY_MAX=1
    local GW6_RETRY_MAX=1
    

    local NOT_AVAILABLE="n/a"

    #Define local variables
    local ipv4=${EMPTYSTRING}
    local ipv6=${EMPTYSTRING}
    local gw4=${EMPTYSTRING}
    local gw6=${EMPTYSTRING}
    local ipv4_retry_param=1
    local gw4_retry_param=1
    local ipv6_retry_param=1
    local gw6_retry_param=1

    #Check if Interface is DOWN
    #REMARK: 
    #   if that's the case then exit function, because...
    #   ...it's no use trying to retrieve the ip-address and gateway, if:
    #   1. WiFi-interface is already DOWN.
    #   2. Netplan Daemon is NOT running
    if [[ ${wlanIntState} == ${STATUS_DOWN} ]] || [[ ${netplanDaemon_isRunning} == ${FALSE} ]];  then
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}

        return  #exit function
    fi

    #Get IPv4 Address
    #REMARK: max retry is 3, which means wait for a maximum of 3 seconds
    while [[ ${ipv4_retry_param} -le ${IPV4_RETRY_MAX} ]]
    do
        #Get IPv4 Address (if possible)
        ipv4=`${IFCONFIG_CMD} ${wlanSelectIntf} | grep -w "${PATTERN_INET}" | xargs | cut -d" " -f2`
        
        #Check if 'ipv4' contains any data
        if [[ ! -z ${ipv4} ]]; then #contains data
            break
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment by 1
        ipv4_retry_param=$((ipv4_retry_param+1))
    done

    #Get IPv4 Gateway Address
    #REMARK: max retry is 3, which means wait for a maximum of 3 seconds
    while [[ ${gw4_retry_param} -le ${GW4_RETRY_MAX} ]]
    do
        #Get IPv4 Gateway-Address (if possible)
        gw4=`${ROUTE_CMD} -n | grep "${wlanSelectIntf}" | grep "${PATTERN_UG}" | awk '{print $2}'`
        
        #Check if 'gw4' contains any data
        if [[ ! -z ${gw4} ]]; then #contains data
            break
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment by 1
        gw4_retry_param=$((gw4_retry_param+1))
    done
    

    if [[ ! -z ${ipv4} ]]; then #NOT an EMPTY STRING
        if [[ ! -z ${gw4} ]]; then
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${ipv4}${NOCOLOR} via ${FG_LIGHTGREY}${gw4}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        else
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${ipv4}${NOCOLOR} via ${FG_LIGHTGREY}(${NO_ROUTE})${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        fi
    else
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
    fi

    #Get IPv6 Address
    #REMARK: max retry is 1, which means wait for a maximum of 1 seconds
    while [[ ${ipv6_retry_param} -le ${IPV6_RETRY_MAX} ]]
    do
        #Get IPv6-address (if possible)
        ipv6=`${IFCONFIG_CMD} ${wlanSelectIntf}  | grep -w "${PATTERN_INET6}" | grep "${PATTERN_GLOBAL}" | xargs | cut -d" " -f2`
        
        #Check if 'ipv6' contains any data
        if [[ ! -z ${ipv6} ]]; then #contains data
            break
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment by 1
        ipv6_retry_param=$((ipv6_retry_param+1))
    done

    #Get IPv6 Gateway Address
    #REMARK: max retry is 1, which means wait for a maximum of 1 seconds
    while [[ ${gw6_retry_param} -le ${GW6_RETRY_MAX} ]]
    do
        #Get IPv6 Gateway-Address (if possible)
        gw6=`${ROUTE_CMD} -6 -n | grep "${wlanSelectIntf}" | grep "${PATTERN_UG}" | awk '{print $2}'`
        
        #Check if 'gw6' contains any data
        if [[ ! -z ${gw6} ]]; then #contains data
            break
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}

        #Increment by 1
        gw6_retry_param=$((gw6_retry_param+1))
    done

    if [[ ! -z ${ipv6} ]]; then #NOT an EMPTY STRING
        if [[ ! -z ${gw6} ]]; then
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${ipv6}${NOCOLOR} via ${FG_LIGHTGREY}${gw6}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        else
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${ipv6}${NOCOLOR} via ${FG_LIGHTGREY}(${NO_ROUTE})${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        fi
    else
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${NOT_AVAILABLE}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
    fi       
}

function wifi_connect_info_show__func() {
    printf "%s\n" "----------------------------------------------------------------------"
    printf "%s\n" "${FG_LIGHTBLUE}${PRINTF_WIFI_CONNECTION_INFO}${NOCOLOR}"
    printf "%s\n" "----------------------------------------------------------------------"

        cat ${tb_wlan_conn_info_tmp__fpath}
    
    printf "%s\n" ${EMPTYSTRING}
}


#---MAIN SUBROUTINE
main_sub() {
    load_env_variables__sub

    load_tibbo_banner__sub

    init_variables__sub

    checkIfisRoot__sub
    
    input_args_case_select__sub

    wifi_connect_info_handler__sub
}



#EXECUTE
main_sub


