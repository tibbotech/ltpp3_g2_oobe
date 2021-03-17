VER_NUM="0.1"
OOBE_DIR="tibbo-oobe-${VER_NUM}"
DEBEMAIL="support@tibbo.com"
DEBFULLNAME="Tibbo Technology Inc."
export DEBEMAIL DEBFULLNAME

mkdir $OOBE_DIR


cd $OOBE_DIR

cp -R ../wifi ./wifi

dh_make --indep --createorig

touch debian/install
cat ../install_wifi >> debian/install 

dpkg-source --commit

debuild -us -uc


