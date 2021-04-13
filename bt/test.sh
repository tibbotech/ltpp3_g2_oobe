#!/bin/bash
#---Constants
DASH_CHAR="-"

EMPTYSTRING=""

RFCOMM_CHANNEL_1="1"
RFCOMM_CMD="rfcomm"



#---Variables
exitCode=0



#---Environment variables
dev_dir=/dev
var_backups_dir=/var/backups
bluetoothctl_conn_stat_bck_filename="bluetootctl_conn_stat.bck"
bluetoothctl_conn_stat_bck_fpath=${var_backups_dir}/${bluetoothctl_conn_stat_bck_filename}



#---Functions
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

function rfcomm_connect_uniq_rfcommDevNum_to_chosen_macAddr__func()
{
    #Input args
    local macAddr_input=${1}
    local dev_refcommDevNum_input=${2}   

    #Define local variables
    local mac_isFound=${EMPTYSTRING}
    local retry_param=0
    local RETRY_MAX=10
    local rfcommDevNum=${EMPTYSTRING}

    #Define printf messages
    errmsg_unable_to_connect_macAddr_to_rfcommDevNum="---:***ERROR:->*UNABLE* TO CONNECT '${macAddr_input}' TO '${dev_refcommDevNum_input}'"
    errmsg_reason_device_might_not_be_online="---:***REASON:->'${macAddr_input}' MAY *NOT BE ONLINE"
    printf_connected_macAddr_to_rfcommDevNum_successfully="---:STATUS:->CONNECTED '${macAddr_input}' TO '${dev_refcommDevNum_input}' *SUCCESSFULLY*"

    #Start Connection and run in the BACKGROUND
    ${RFCOMM_CMD} connect ${dev_refcommDevNum_input} ${macAddr_input} ${RFCOMM_CHANNEL_1} 2>&1 > /dev/null &
    
    #Get exit-code
    exitCode=$?
    if [[ ${exitCode} -eq 0 ]]; then    #command was executed successfully
        #This while-loop acts as a waiting time allowing the command to finish its execution process
        while [[ -z ${mac_isFound} ]]
        do
            mac_isFound=`${RFCOMM_CMD} | grep -w ${macAddr_input}`  #connection is found when running 'rfcomm' command

            sleep 1 #if no PID found yet, sleep for 1 second

            retry_param=$((retry_param+1))  #increment retry paramter

            #a Maxiumum of 10 retries is allowed
            if [[ ${retry_param} -gt ${RETRY_MAX} ]]; then  #maximum retries has been exceeded
                break
            fi
        done

        if [[ ! -z ${mac_isFound} ]]; then    #contains data
            #Print
            printf '%b\n' "${printf_connected_macAddr_to_rfcommDevNum_successfully}"
        else    #contains NO data
            printf '%b\n' "${errmsg_unable_to_connect_macAddr_to_rfcommDevNum}"
            printf '%b\n' "${errmsg_reason_device_might_not_be_online}"
        fi
    else    #exit-code!=0
        printf '%b\n' "${errmsg_unable_to_connect_macAddr_to_rfcommDevNum}"
        printf '%b\n' "${errmsg_reason_device_might_not_be_online}"
    fi
}



#---Subroutines
reconnect_to_btDevices__sub()
{
    #Define local variables
    local macAddr=${EMPTYSTRING}
    local macAddr_isPaired=${EMPTYSTRING}
    local macAddr_isAlreadyConnected=${EMPTYSTRING}
    local rfcommDevNum=${EMPTYSTRING}
    local rfcommDevNum_isPresent=${EMPTYSTRING}
    local dev_refcommDevNum=${EMPTYSTRING}
    local dev_refcommDevNum_isPresent=${EMPTYSTRING}


    #Check if file 'bluetootctl_conn_stat.tmp' exist
    #If FALSE, then exit script
    if [[ ! -f ${bluetoothctl_conn_stat_bck_fpath} ]]; then #file exists
        exit 0
    fi

    #In case file 'bluetootctl_conn_stat.tmp' exist, then...
    #...read line by line
    while read -r line
    do
        #Get 'rfcomm-dev-number' from 'line' (if any)
        dev_refcommDevNum=`echo ${line} | awk '{print $5}'`

        #Check if 'dev_refcommDevNum' contains 'rfcomm'
        dev_refcommDevNum_isPresent=`echo ${dev_refcommDevNum} | grep "${RFCOMM_CMD}"`

        if [[ ! -z ${dev_refcommDevNum_isPresent} ]]; then    #contains data
            #Get MAC-address
            macAddr=`echo ${line} | awk '{print $2}'`

            #Check if MAC-address is still paired with the LTPP3-G2
            macAddr_isPaired=`bluetoothctl paired-devices | grep ${macAddr}`

            if [[ ! -z ${macAddr_isPaired} ]]; then #contains data
                macAddr_isAlreadyConnected=`${RFCOMM_CMD} | grep "${macAddr}"`

                if [[ ! -z ${macAddr_isAlreadyConnected} ]]; then   #contains data
                    printf_macAddr_is_already_connected_to_dev_refcommDevNum="---:STATUS:->'${macAddr}' IS ALREADY CONNECTED TO '${dev_refcommDevNum}'"
                    printf '%b\n' "${printf_macAddr_is_already_connected_to_dev_refcommDevNum}"
                else    #contains NO data
                    #Get rfcomm-dev-number (without '/dev')
                    rfcommDevNum=`basename ${dev_refcommDevNum}`
                    
                    #Check if 'rfcommDevNum' is already in-use
                    rfcommDevNum_isPresent=`${RFCOMM_CMD} | grep "${rfcommDevNum}"`

                    #If TRUE, then get generate a Unique rfcomm-dev-number
                    if [[ ! -z ${rfcommDevNum_isPresent} ]]; then   #contains data
                        #Get a unique rfcomm-dev-number
                        rfcommDevNum=`rfcomm_get_uniq_rfcommDevNum__func`

                        #Combine prepend '/dev'
                        dev_refcommDevNum=${dev_dir}/${rfcommDevNum}
                    fi

                    #Connect MAC-address to rfcomm-dev-number
                    rfcomm_connect_uniq_rfcommDevNum_to_chosen_macAddr__func "${macAddr}" "${dev_refcommDevNum}"
                fi
            else    #contains NO data
                errmsg_unable_to_connect_rfcommDevNum_to_macAddr="---:***ERROR:->*UNABLE* TO CONNECT '${dev_refcommDevNum}' TO '${macAddr}'"
                errmsg_reason_no_pairing_with_device="---:***REASON:->NO PAIRING WITH DEVICE '${macAddr}'"

                printf '%b\n' "${errmsg_unable_to_connect_rfcommDevNum_to_macAddr}"
                printf '%b\n' "${errmsg_reason_no_pairing_with_device}"
            fi
        fi
    done < ${bluetoothctl_conn_stat_bck_fpath}
}


main__sub()
{
    reconnect_to_btDevices__sub
}



#---Execute
main__sub