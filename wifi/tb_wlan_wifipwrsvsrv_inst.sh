#!/bin/bash
#---COLOR CONSTANTS
NOCOLOR=$'\e[0m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'

FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'



#---SUBROUTINES
load_env_variables__sub() {
    current_dir=`dirname "$0"`
    thisScript_filename=$(basename $0)
    thisScript_fpath=$(realpath $0)

    wlan_wifi_powersave_off_name="wifi-powersave-off"
    wlan_wifi_powersave_off_service="${wlan_wifi_powersave_off_name}.service"
    wlan_etc_systemd_system_dir=/etc/systemd/system
    wlan_usr_local_bin_dir=/usr/local/bin
    wlan_wifi_powersave_off_service_fpath="${wlan_etc_systemd_system_dir}/${wlan_wifi_powersave_off_service}"
    wlan_wifi_powersave_off_timer_fpath="${wlan_etc_systemd_system_dir}/${wlan_wifi_powersave_off_name}.timer"
    wlan_wifi_powersave_off_sh_fpath="${wlan_usr_local_bin_dir}/${wlan_wifi_powersave_off_name}.sh"
}

Wln_WifiPowerSaveService_Handler() {
    Wln_WifiPowerSaveService_Create
    Wln_WifiPowerSaveService_Start
}
Wln_WifiPowerSaveService_Create() {
    #Remove 'wifi-powersave-off.service'
    if [[ -f ${wlan_wifi_powersave_off_service_fpath} ]]; then
        sudo rm ${wlan_wifi_powersave_off_service_fpath}
    fi

 #Create 'wifi-powersave-off.service'
sudo tee ${wlan_wifi_powersave_off_service_fpath} >/dev/null <<EOF
#--------------------------------------------------------------------
# Remarks: 
# 1. In order for the service to run after a reboot
#		make sure to create a 'symlink'
#		ln -s /etc/systemd/system/<myservice.service> /etc/systemd/system/multi-user.target.wants/<myservice.service>
# 2. Reload daemon: systemctl daemon-reload
# 3. Start Service: systemctl start <myservice.service>
# 4. Check status: systemctl status <myservice.service>
#--------------------------------------------------------------------
[Unit]
Description=Disable power management for wlan0
Requires=sys-subsystem-net-devices-wlan0.device
After=network.target
Wants=${wlan_wifi_powersave_off_name}.timer

[Service]
Type=oneshot
#User MUST BE SET TO 'root'
User=root
ExecStart=${wlan_wifi_powersave_off_sh_fpath} false

#Print messages
StandardInput=journal+console
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target

EOF

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Created ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.service${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    #Change permissions
    sudo chmod 755 ${wlan_wifi_powersave_off_service_fpath} 2>&1

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Changed permissions of ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.service${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"



    #Remove 'wifi-powersave-off.timer'
    if [[ -f ${wlan_wifi_powersave_off_timer_fpath} ]]; then
        sudo rm ${wlan_wifi_powersave_off_timer_fpath}
    fi

#Create 'wifi-powersave-off.timer'
sudo tee ${wlan_wifi_powersave_off_timer_fpath} >/dev/null <<EOF
#--------------------------------------------------------------------
# Remarks: 
# 1. In order for the service to run after a reboot
#		make sure to create a 'symlink'
#		ln -s /etc/systemd/system/<myservice.timer> /etc/systemd/system/multi-user.target.wants/<myservice.timer>
# 2. Reload daemon: systemctl daemon-reload
# 3. Start Service: systemctl start <myservice.timer>
# 4. Check status: systemctl status <myservice.timer>
#--------------------------------------------------------------------
[Unit]
Description=Run wifi-powersave-off.service every 30 sec (active-state) and 10 sec (idle-state)
Requires=${wlan_wifi_powersave_off_name}.service

[Timer]
#Run on boot after 1 seconds
OnBootSec=1s
#Run script every 5 sec when Device is Active
OnUnitActiveSec=5s
#Run script every 5 sec when Device is Idle
OnUnitInactiveSec=5s
AccuracySec=1s

[Install]
WantedBy=timers.target

EOF

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Created ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.timer${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    #Change permissions
    sudo chmod 755 ${wlan_wifi_powersave_off_timer_fpath} 2>&1

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Changed permissions of ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.timer${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"


    #Remove 'wifi-powersave-off.sh'
    if [[ -f ${wlan_wifi_powersave_off_sh_fpath} ]]; then
        sudo rm ${wlan_wifi_powersave_off_sh_fpath}
    fi

#Create 'wifi-powersave-off.sh'
sudo tee ${wlan_wifi_powersave_off_sh_fpath} >/dev/null <<EOF
#!/bin/bash
#---INPUT ARGS
PrintIsAllowed__in=\${1}



#---CONSTANTS
POWER_OFF="off"
POWER_ON="on"
STATEGET_DOWN="DOWN"
STATEGET_UP="UP"
STATESET_DOWN="down"
STATESET_UP="up"



#---COLORS CONSTANTS
NOCOLOR=$'\e[0m'
FG_ORANGE=$'\e[30;38;5;209m'
FG_LIGHTGREY=$'\e[30;38;5;246m'
FG_LIGHTGREEN=$'\e[30;38;5;71m'
FG_SOFTLIGHTRED=$'\e[30;38;5;131m'



#---PHASE CONSTANTS
PHASE_WIFI_POWERSAVE_GET=0
PHASE_WIFI_INTFSTATE=1
PHASE_WIFI_POWERSAVE_SET=2
PHASE_EXIT=3



#---VARIABLES
phase=\${PHASE_WIFI_POWERSAVE_GET}
phase_prev=\${PHASE_WIFI_POWERSAVE_GET}
wifiName="wlan0"



#---SUBROUTINES
wifi_state_set() {
    #CONSTANTS
    local RETRY_CTR_MAX=10

    #VARIABLES
    local exitCode=0
    local pid=0
    local retry_ctr=1

    #Check Wireless interface-state
    local isState=\`ip link show dev wlan0 | grep -o "state.*" | cut -d" " -f2 2>&1\`
    if [[ \${isState} == \${STATEGET_DOWN} ]]; then  #interface is down
        if [[ \${PrintIsAllowed__in} == true ]]; then
            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} is \${FG_LIGHTGREEN}\${STATEGET_DOWN}\${NOCOLOR}"
        fi

        #Loop till retry_ctr < RETRY_CTR_MAX
        while [[ \${retry_ctr} -lt \${RETRY_CTR_MAX} ]]
        do
            #Print
            if [[ \${PrintIsAllowed__in} == true ]]; then
                echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: Trying to bring \${FG_LIGHTGREEN}\${STATEGET_UP}\${NOCOLOR} \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} (\${retry_ctr} out-of \${RETRY_CTR_MAX})"
            fi

            #Bring interface up
            ip link set dev \${wifiName} \${STATESET_UP} 2>&1
            #Get PID
            pid=\$!
            #Wait for process to finish
            wait \${pid}

            #Break loop if 'stdOutput' contains data (which means that Status has changed to UP)
            stdOutput=\`ip link show dev \${wifiName} | grep -o "state.*" | cut -d" " -f2 2>&1\`
            if [[ \${stdOutput} == \${STATEGET_UP} ]]; then  #data found
                break
            fi

            #error was found, retry_ctr again
            retry_ctr=\$((retry_ctr + 1))
        done
    else
        stdOutput=\${STATEGET_UP}
    fi

    #State has correctly changed to UP
    if [[ -z \${stdOutput} ]]; then
        if [[ \${PrintIsAllowed__in} == true ]]; then
            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_SOFTLIGHTRED}Failed\${NOCOLOR} to bring \${FG_LIGHTGREEN}\${STATEGET_UP}\${NOCOLOR} \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} (\${retry_ctr} out-of \${RETRY_CTR_MAX})"

            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_SOFTLIGHTRED}Failed\${NOCOLOR} to set \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} Powersave to \${FG_SOFTLIGHTRED}\${POWER_OFF}\${NOCOLOR}"
        fi

        phase=\${PHASE_EXIT}
    else
        if [[ \${PrintIsAllowed__in} == true ]]; then
            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} is \${FG_LIGHTGREEN}\${STATEGET_UP}\${NOCOLOR}"
        fi

       phase=\${PHASE_WIFI_POWERSAVE_SET}
    fi
}

wifi_powersave_state_get() {
    #Get Powersave-state
    local isPowersaveState=\`iw dev wlan0 get power_save | grep -o "save.*" | cut -d" " -f2 2>&1\`
    if [[ \${isPowersaveState} == \${POWER_ON} ]]; then
        if [[ \${PrintIsAllowed__in} == true ]]; then
            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} Powersave is \${FG_LIGHTGREEN}\${POWER_ON}\${NOCOLOR}"
        fi

        #Take action based on the origin of the 'phase'
        if [[ \${phase_prev} == \${PHASE_WIFI_POWERSAVE_SET} ]]; then
            phase=\${PHASE_EXIT}
        else
            phase=\${PHASE_WIFI_INTFSTATE}
        fi
    else
        if [[ \${PrintIsAllowed__in} == true ]]; then
            echo -e ":-->\${FG_ORANGE}STATUS\${NOCOLOR}: \${FG_LIGHTGREY}\${wifiName}\${NOCOLOR} Powersave is \${FG_SOFTLIGHTRED}\${POWER_OFF}\${NOCOLOR}"
        fi

        phase=\${PHASE_EXIT}
    fi
}

wifi_powersave_state_set() {
    #Set powersave-state to off
    iw dev \${wifiName} set power_save off

    phase_prev=\${PHASE_WIFI_POWERSAVE_SET}
    phase=\${PHASE_WIFI_POWERSAVE_GET}
}



#---MAIN SUBROUTINE
main__sub() {
    #Print empty line
    if [[ \${PrintIsAllowed__in} == true ]]; then
        echo -e "\r"
    fi

    #Go thru phases
    phase=\${PHASE_WIFI_INTFSTATE}
    while true
    do
        case "\${phase}" in
            \${PHASE_WIFI_INTFSTATE})
                wifi_state_set
                ;;
            \${PHASE_WIFI_POWERSAVE_GET})
                wifi_powersave_state_get
                ;;
            \${PHASE_WIFI_POWERSAVE_SET})
                wifi_powersave_state_set
                ;;
            \${PHASE_EXIT})
                break
                ;;       
        esac
    done

    #Print empty line
    if [[ \${PrintIsAllowed__in} == true ]]; then
        echo -e "\r"
    fi
}



#---EXECUTE
main__sub

EOF
    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Created ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.sh${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    #Change permissions
    sudo chmod 755 ${wlan_wifi_powersave_off_sh_fpath} 2>&1

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Changed permissions of ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.sh${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"
}
Wln_WifiPowerSaveService_Start() {
    #Reload 'systemctl daemon'
    sudo systemctl daemon-reload 2>&1

    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Reload ${FG_LIGHTGREY}Daemon${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"


    #Enable and start service
    sudo systemctl enable ${wlan_wifi_powersave_off_service} 2>&1
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Enable ${FG_LIGHTGREY}${wlan_wifi_powersave_off_service}${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    sudo systemctl start ${wlan_wifi_powersave_off_service} 2>&1
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Start ${FG_LIGHTGREY}${wlan_wifi_powersave_off_service}${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"
}



#---MAIN SUBROUTINE
main__sub() {
    load_env_variables__sub
    Wln_WifiPowerSaveService_Handler
}



#---EXECUTE MAIN
main__sub
