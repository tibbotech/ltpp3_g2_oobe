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
    #Stop Service
    sudo systemctl stop ${wlan_wifi_powersave_off_service} 2>&1 > /dev/null
    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Stopped ${FG_LIGHTGREY}${wlan_wifi_powersave_off_service}${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    #Disable Service
    sudo systemctl disable ${wlan_wifi_powersave_off_service} 2>&1 > /dev/null
    #Print
    echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Disabled ${FG_LIGHTGREY}${wlan_wifi_powersave_off_service}${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"

    if [[ -f ${wlan_wifi_powersave_off_service_fpath} ]]; then
        #Remove file
        sudo rm ${wlan_wifi_powersave_off_service_fpath}
        #Print
        echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Removed ${FG_LIGHTGREY}${wlan_wifi_powersave_off_service}${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"
    fi

    if [[ -f ${wlan_wifi_powersave_off_timer_fpath} ]]; then
        #Remove file
        sudo rm ${wlan_wifi_powersave_off_timer_fpath}
        #Print
        echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Removed ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.timer${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"
    fi

    if [[ -f ${wlan_wifi_powersave_off_sh_fpath} ]]; then
        #Remove file
        sudo rm ${wlan_wifi_powersave_off_sh_fpath}
        #Print
        echo -e ":-->${FG_ORANGE}STATUS${NOCOLOR}: Removed ${FG_LIGHTGREY}${wlan_wifi_powersave_off_name}.sh${NOCOLOR}: ${FG_LIGHTGREEN}DONE${NOCOLOR}"
    fi
}



#---MAIN SUBROUTINE
main__sub() {
    load_env_variables__sub
    Wln_WifiPowerSaveService_Handler
}



#---EXECUTE MAIN
main__sub
