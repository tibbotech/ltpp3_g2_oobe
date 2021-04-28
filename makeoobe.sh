VER_NUM="0.2"
OOBE_DIR="tibbo-oobe-${VER_NUM}"
DEBEMAIL="support@tibbo.com"
DEBFULLNAME="Tibbo Technology Inc."
LANG=C
export DEBEMAIL DEBFULLNAME LANG

rm -rf ./tibbo-oobe-0.2
rm ./tibbo-oobe-0.2.orig.tar.xz

mkdir $OOBE_DIR


cd $OOBE_DIR



cp -R ../wifi ./wifi
cp -R ../bt ./bt
cp -R ../tpd ./tpd
dh_make --indep --createorig

touch debian/install
cat ../install_wifi >> debian/install 
cat ../install_bt >> debian/install 
cat ../install_tpd >> debian/install 
yes | cp ../rules debian/rules 
yes | cp ../control debian/control 
yes | cp ../control debian/copyright 

cp ../tpd/tibbo-oobe.tpd.service debian/

dpkg-source --commit

debuild -us -uc


