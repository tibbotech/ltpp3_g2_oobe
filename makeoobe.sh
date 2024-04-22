#!/bin/bash
#---CONSTANTS
RESET_COLOR=$'\033[0;0m'
FG_ORANGE_COLOR=$'\033[30;38;5;215m'
PRINT_CURRENT_DIR="---:${FG_ORANGE_COLOR}CURRENT DIR${RESET_COLOR}"
PRINT_REMOVE_FILES_WITH_EXTENSION="---:${FG_ORANGE_COLOR}REMOVE FILES WITH EXTENSION${RESET_COLOR}"
READDIALOG1="---:${FG_ORANGE_COLOR}INPUT${RESET_COLOR}: oobe version: "
READDIALOG2="---:${FG_ORANGE_COLOR}CONFIRM${RESET_COLOR}: continue (y/n): "



#---ARRAYS
applist__arr=("build-essential" \
                "debhelper" \
                "devscripts" \
                "dh-python"
                "dh-make" \
                "dh-systemd" \
                "gnupg2" \
                "lintian" \
                "reprepro" \
                "vim" \
                "lintian" \
                "config-package-dev")

#---CHECK & INSTALL APPS
dpkg_output=""
for applist__arritem in "${applist__arr[@]}"
do
    dpkg_output=$(dpkg -l | grep "ii" | grep -o "${applist__arritem}.*" | awk '{print $1}' | grep -w "^${applist__arritem}$")
    if [[ -z "${dpkg_output}" ]]; then
        echo -e "---:${FG_ORANGE_COLOR}INSTALL${RESET_COLOR}: $applist__arritem"

        apt-get -y install "${applist__arritem}"
    fi
done



#---READ DIALOGS
tput cud1

while true
do
    read -p "${READDIALOG1}" VER_NUM

    if [[ -n "${VER_NUM}" ]]; then
        break
    else
        tput cuu1
        tput el
    fi
done


while true
do
    read -e -N1 -r -p "${READDIALOG2}" mychoice

    if [[ "${mychoice}" == [yn] ]]; then
        tput cud1

        break
    else
        tput cuu1
        tput el
    fi
done

if [[ "${mychoice}" == "n" ]]; then
    exit 0
fi



#---PREP OOBE PACKAGE
OOBE_DIR="tibbo-oobe-${VER_NUM}"
DEBEMAIL="support@tibbo.com"
DEBFULLNAME="Tibbo Technology Inc."
LANG=C
export DEBEMAIL DEBFULLNAME LANG

if [[ -d "./${OOBE_DIR}" ]]; then
    rm -rf ./${OOBE_DIR}
fi

if [[ -f "./${OOBE_DIR}.orig.tar.xz" ]]; then
    rm ./${OOBE_DIR}.orig.tar.xz
fi

#---REMEMBER CURRENT DIR
curr__dir=$(pwd)

#---CREATE DIRECTORY
mkdir ${OOBE_DIR}

#---NAVIGATE INTO DIRECTORY
cd ${OOBE_DIR}
echo -e "${PRINT_CURRENT_DIR}: ${OOBE_DIR}"
tput cud1

#COPY FOLDERS FROM PREVIOUS DIRECTORY INTO THIS DIRECTORY (including subfolders and files) into this directory
cp -R ../wifi ./wifi
cp -R ../bt ./bt
cp -R ../daisy_chain ./daisy_chain
cp -R ../modules/tpd ./tpd
cp -R ../ntios ./ntios
cp -R ../modules ./modules

#---PREP DEBIAN PACKAGING FOR AN ORIGINAL SOURCE ARCHIVE
dh_make --indep --createorig

#---CREATE FILE
touch debian/install

#---READ FILE CONTENT AND APPEND INTO ANOTHER FILE
cat ../install_wifi >> debian/install 
cat ../install_bt >> debian/install 
cat ../install_daisy_chain >> debian/install 
cat ../install_modules >> debian/install 
cat ../install_ntios >> debian/install

#---COPY FILES
yes | cp ../rules debian/rules 
yes | cp ../control debian/control 
yes | cp ../copyright debian/copyright 
yes | cp ../tibbo-oobe.postinst debian/tibbo-oobe.postinst 
yes | cp ../tibbo-oobe.postrm debian/tibbo-oobe.postrm 

#---RECORD CHANGES IN THE SOURCE TREE
dpkg-source --commit

#---BUILD DEBIAN PACKAGE
debuild -us -uc



#---GO BACK TO 'curr__dir'
cd "${curr__dir}"
tput cud1
echo -e "${PRINT_CURRENT_DIR}: ${OOBE_DIR}"
tput cud1

#---CLEANUP UNNECESSARY FILES
extensionlist__arr=('*.xz' \
                    '*.dsc' \
                    '*.build' \
                    '*.buildinfo' \
                    '*.changes')
for extensionlist__arritem in "${extensionlist__arr[@]}"
do
    echo -e "${PRINT_REMOVE_FILES_WITH_EXTENSION}: ${extensionlist__arritem}"
    rm ${extensionlist__arritem}
done

tput cud1
