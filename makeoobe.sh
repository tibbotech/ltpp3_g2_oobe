VER_NUM="0.3.5"
OOBE_DIR="tibbo-oobe-${VER_NUM}"
DEBEMAIL="support@tibbo.com"
DEBFULLNAME="Tibbo Technology Inc."
LANG=C
export DEBEMAIL DEBFULLNAME LANG

rm -rf ./tibbo-oobe-${VER_NUM}
rm ./tibbo-oobe-${VER_NUM}.orig.tar.xz

mkdir $OOBE_DIR


cd $OOBE_DIR



cp -R ../wifi ./wifi
cp -R ../bt ./bt
cp -R ../tpd ./tpd
cp -R ../ntios ./ntios
cp -R ../modules ./modules
dh_make --indep --createorig

touch debian/install
cat ../install_wifi >> debian/install 
cat ../install_bt >> debian/install 
cat ../install_modules >> debian/install 
cat ../install_ntios >> debian/install 
yes | cp ../rules debian/rules 
yes | cp ../control debian/control 
yes | cp ../copyright debian/copyright 
yes | cp ../tibbo-oobe.postinst debian/tibbo-oobe.postinst 
yes | cp ../tibbo-oobe.postrm debian/tibbo-oobe.postrm 

dpkg-source --commit

debuild -us -uc
