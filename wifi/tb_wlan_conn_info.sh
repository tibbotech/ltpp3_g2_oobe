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
FG_SOFLIGHTRED=$'\e[30;38;5;131m'
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

DASH_CHAR="-"
QUESTION_CHAR="?"
SQUARE_BRACKET_LEFT="["
SQUARE_BRACKET_RIGHT="]"

FOUR_SPACES="    "

EXITCODE_99=99

#---LINE CONSTANTS
EMPTYLINES_0=0
EMPTYLINES_1=1

#---PATTERN CONSTANTS
PATTERN_ADDRESSES="addresses"
PATTERN_GLOBAL="global"
PATTERN_INET="inet"
PATTERN_INET6="inet6"
PATTERN_INTERFACE="Interface"

#---STATUS/BOOLEANS
TRUE="true"
FALSE="false"

#---PRINTF ERROR MESSAGES
ERRMSG_FOR_MORE_INFO_RUN="FOR MORE INFO, RUN: '${FG_LIGHTSOFTYELLOW}${scriptName}${NOCOLOR} --help'"
ERRMSG_INPUT_ARGS_NOT_SUPPORTED="INPUT ARGS NOT SUPPORTED."
ERRMSG_UNKNOWN_OPTION="${FG_LIGHTRED}UNKNOWN${NOCOLOR} INPUT ARG '${FG_YELLOW}${arg1}${NOCOLOR}'"

#---HELPER/USAGE PRINT CONSTANTS
PRINTF_SCRIPTNAME_VERSION="${scriptName}: ${FG_LIGHTSOFTYELLOW}${scriptVersion}${NOCOLOR}"
PRINTF_USAGE_DESCRIPTION="Utility to retrieve WiFi Connection Information."

#---PRINT CONSTANTS
PRINTF_DESCRIPTION="DESCRIPTION:"
PRINTF_INFO="INFO:"
PRINTF_VERSION="VERSION:"

#---PRINT MESSAGES
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
}



#---FUNCTIONS
function press_any_key__func() {
	#Define constants
	local ANYKEY_TIMEOUT=10

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


wlan_connect_info__sub() {
    #Get Interface-name
    retrieve_wifi_interface_name__func

    #Get WiFi Connection Info and Write to a Temporary File
    retrieve_wifi_connect_info__func

    #Get WiFi IP-address(es) and append to the existing Temporary File
    retrieve_ip46_addr__func

    #Show WiFi Connection Info
    printf "%s\n" "----------------------------------------------------------------------"
    printf "%s\n" "${FG_LIGHTBLUE}${PRINTF_WIFI_CONNECTION_INFO}${NOCOLOR}"
    printf "%s\n" "----------------------------------------------------------------------"

        cat ${tb_wlan_conn_info_tmp__fpath}
    
    printf "%s\n" ${EMPTYSTRING}

    #Press any key
    press_any_key__func
}
function retrieve_wifi_interface_name__func() {
    wlanSelectIntf=`iw dev | grep Interface | cut -d" " -f2`
}
function retrieve_wifi_connect_info__func() {
    #Define local constants
    local SLEEP_TIMEOUT=1
    local RETRY_MAX=30
    local SIGNAL_STRENGTH_MAX=-30
    local SIGNAL_STRENGTH_MIN=-90

    local INTF="Intf"
    local SSID="SSID"
    local FREQ="Freq"
    local SIGNAL="Signal"
    local SPEED="Speed"

    local PATTERN_NOT_CONNECTED="Not connected"

    #Define local variables
    local fieldName=${EMPTYSTRING}
    local fieldValue=${EMPTYSTRING}
    local fieldValue_org=${EMPTYSTRING}
    local fieldValue_tmp1=${EMPTYSTRING}
    local fieldValue_tmp2=${EMPTYSTRING}
    local lineNum=1
    local retry_param=1
    local signal_strenth=${SIGNAL_STRENGTH_MIN}
    local signal_strength_diff=$(( SIGNAL_STRENGTH_MAX-SIGNAL_STRENGTH_MIN ))   #difference: -30-(-90) dBm = 60 dBm
    local isNotConnected=${EMPTYSTRING}

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

    #Get WiFi Connection Information using tool 'iw'
    #...and write to file 'tb_wlan_conn_info.tmp1'
    while true   #loop while file is EMPTY for a maximum of 10 seconds
    do
        #Get data
        iw dev ${wlanSelectIntf} link | awk '{$1=$1};1' > ${tb_wlan_conn_info_tmp1__fpath}

        #Check if file contains data
        if [[ -s ${tb_wlan_conn_info_tmp1__fpath} ]]; then  #file contains data
            isNotConnected=`cat ${tb_wlan_conn_info_tmp1__fpath} | grep "${PATTERN_NOT_CONNECTED}"`

            if [[ -z ${isNotConnected} ]]; then  #no match was found (which is good)
                break
            fi
        fi

        #Sleep for 1 second
        sleep ${SLEEP_TIMEOUT}  #wait for 1 second

        #Check if the maximum retry has exceeded
        #If TRUE, then break loop (not exit script)
        if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then
            break
        else
            retry_param=$((retry_param+1))
        fi
    done

    #There are 2 situations:
    #1. file 'tb_wlan_conn_info_tmp1__fpath' is NOT empty & pattern 'PATTERN_NOT_CONNECTED' was NOT found
    #2. for all other cases
    if [[ ! -z ${tb_wlan_conn_info_tmp1__fpath} ]] && [[ -z ${isNotConnected} ]]; then  #case 1
        #Go through each line of file 'tb_wlan_conn_info.tmp1'
        #Line1: shows connection to which SSID-MAC-address
        #Line2: SSID-name
        #Line3: Frequency (Ghz)
        #Line4: Signal-Strength (-30 dBm: Excellent, -90 dBm: Poorest)
        #Line5: Transfer-rate (Mbit/s)
        while read line
        do
            #Initialize variables
            fieldName=${EMPTYSTRING}
            fieldValue=${EMPTYSTRING}
            fieldValue_org=${EMPTYSTRING}
            fieldValue_tmp1=${EMPTYSTRING}
            fieldValue_tmp2=${EMPTYSTRING}

            #Get the value belonging to the field-name (e.g. SSID, Frequency, etc.)
            if [[ ${lineNum} -gt 1 ]]; then #do not retrieve the value for the 1st line
                fieldValue_org=`echo ${line} | cut -d":" -f2 | awk '{$1=$1;print}'`   #get field-value (e.g. Tibbo9F)
            fi

            #Get field-name
            case $lineNum in
                1)
                    fieldName=${INTF}
                    fieldValue=${FG_LIGHTGREY}${wlanSelectIntf}${NOCOLOR}
                    ;;
                2)
                    fieldName=${SSID}
                    fieldValue=${FG_YELLOW}${fieldValue_org}${NOCOLOR}
                    ;;
                3)
                    fieldName=${FREQ}
                    fieldValue1=`echo "${fieldValue_org}" | convertTo_thousands__func`   #insert comma-delimiter
                    fieldValue="${FG_LIGHTGREY}${fieldValue1}${NOCOLOR} Ghz"
                    ;;
                4)
                    fieldName=${SIGNAL}
                    fieldValue1=`echo ${fieldValue_org} | cut -d" " -f1` #get rid off 'dBm'
                    fieldValue2=$(( ( (fieldValue1-SIGNAL_STRENGTH_MIN)*100 )/signal_strength_diff ))
                    fieldValue="${FG_LIGHTGREY}${fieldValue2}${NOCOLOR}% (${fieldValue_org})"
                    ;;
                5)
                    fieldName=${SPEED}
                    fieldValue1=`echo ${fieldValue_org} | cut -d" " -f1` #get rid off 'MBit/s'
                    fieldValue="${FG_YELLOW}${fieldValue1}${NOCOLOR} Mbit/s"
                    ;;
            esac

            #Write to file 'tb_wlan_conn_info.tmp'
            #REMARK:
            #   -do NOT color 'fieldName'
            #   -color 'fieldValue' with 'FG_LIGTHGREY'
            echo -e "${FOUR_SPACES}${fieldName}:\t${fieldValue}" >> ${tb_wlan_conn_info_tmp__fpath}

            #Increment line-number by 1
            lineNum=$((lineNum+1))  
        done < ${tb_wlan_conn_info_tmp1__fpath}
    else    #case 2
        while [[ ${lineNum} -le 5 ]]
        do
            #Initialize variables
            fieldName=${EMPTYSTRING}
            fieldValue=${EMPTYSTRING}
            fieldValue_org=${EMPTYSTRING}
            fieldValue_tmp1=${EMPTYSTRING}
            fieldValue_tmp2=${EMPTYSTRING}

            #Get field-name
            case $lineNum in
                1)
                    fieldName=${INTF}
                    fieldValue=${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}
                    ;;
                2)
                    fieldName=${SSID}
                    fieldValue=${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}
                    ;;
                3)
                    fieldName=${FREQ}
                    fieldValue=${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}
                    ;;
                4)
                    fieldName=${SIGNAL}
                    fieldValue=${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}
                    ;;
                5)
                    fieldName=${SPEED}
                    fieldValue=${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}
                    ;;
            esac

            #Write to file 'tb_wlan_conn_info.tmp'
            #REMARK:
            #   -do NOT color 'fieldName'
            #   -color 'fieldValue' with 'FG_LIGTHGREY'
            echo -e "${FOUR_SPACES}${fieldName}:\t${fieldValue}" >> ${tb_wlan_conn_info_tmp__fpath}

            #Increment line-number by 1
            lineNum=$((lineNum+1))  
        done
    fi
}
function convertTo_thousands__func {
    #REMARK:
    #   In sed, the 't' command specifies a label that will be jumped to...
    #...if the last 's/x/x/x' command was successful.
    #...Therefore a label called ':restart' has to be defined...
    #...in order for it jumps back.
    sed -re ' :restart ; s/([0-9])([0-9]{3})($|[^0-9])/\1,\2\3/ ; t restart '
} 
function retrieve_ip46_addr__func() {
    #Define Local constants
    local FIELDNAME_IPV4="IPv4"
    local FIELDNAME_IPV6="IPv6"
    local PATTERN_UG="UG"

    #Define local variables
    local ipv4=${EMPTYSTRING}
    local ipv6=${EMPTYSTRING}
    local gw4=${EMPTYSTRING}
    local gw6=${EMPTYSTRING}


    #IPv4 Address
    ipv4=`ifconfig ${wlanSelectIntf} | grep "${PATTERN_INET}" | xargs | cut -d" " -f2`

    #Gateway (IPv4)
    gw4=`route -n | grep "${wlanSelectIntf}" | grep "${PATTERN_UG}" | awk '{print $2}'`

    if [[ ! -z ${ipv4} ]]; then #NOT an EMPTY STRING
        if [[ ! -z ${gw4} ]]; then
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${ipv4}${NOCOLOR} via ${FG_LIGHTGREY}${gw4}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        else
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${ipv4}${NOCOLOR} via ${FG_LIGHTGREY}(no route)${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        fi
    else
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV4}:\t${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
    fi

    #IPv6 Address
    ipv6=`ifconfig ${wlanSelectIntf}  | grep "${PATTERN_INET6}" | grep "${PATTERN_GLOBAL}" | xargs | cut -d" " -f2`

    #Gateway (IPv4)
    gw6=`route -6 -n | grep "${wlanSelectIntf}" | grep "${PATTERN_UG}" | awk '{print $2}'`

    if [[ ! -z ${ipv6} ]]; then #NOT an EMPTY STRING
        if [[ ! -z ${gw6} ]]; then
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${ipv6}${NOCOLOR} via ${FG_LIGHTGREY}${gw6}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        else
            echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${ipv6}${NOCOLOR} via ${FG_LIGHTGREY}(no route)${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
        fi
    else
        echo -e "${FOUR_SPACES}${FIELDNAME_IPV6}:\t${FG_LIGHTGREY}${DASH_CHAR}${NOCOLOR}" >> ${tb_wlan_conn_info_tmp__fpath}
    fi       
}



#---MAIN SUBROUTINE
main_sub() {
    load_env_variables__sub

    load_tibbo_banner__sub

    init_variables__sub

    checkIfisRoot__sub
    
    input_args_case_select__sub

    wlan_connect_info__sub
}



#EXECUTE
main_sub


