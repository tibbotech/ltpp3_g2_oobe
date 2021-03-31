VER_NUM="0.2"
OOBE_DIR="tibbo-oobe-${VER_NUM}"
DEBEMAIL="support@tibbo.com"
DEBFULLNAME="Tibbo Technology Inc."
export DEBEMAIL DEBFULLNAME

mkdir $OOBE_DIR


cd $OOBE_DIR

cp -R ../wifi ./wifi
cp -R ../bt ./bt

dh_make --indep --createorig

touch debian/install
cat ../install_wifi >> debian/install 
cat ../install_bt >> debian/install 

dpkg-source --commit

debuild -us -uc


