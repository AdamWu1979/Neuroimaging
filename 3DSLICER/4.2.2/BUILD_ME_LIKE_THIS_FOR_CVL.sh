clear

NAME=3dslicer
VERSION=4.2.2
BUILD_DIR=`pwd`/binaries

DEST_PATH=${NAME^^}/$VERSION

if [ `pwd | grep /usr/local/src/$DEST_PATH | wc -c` -eq 0 ]; then
        echo "Please copy directory contents to '/usr/local/src/$DEST_PATH' and execute this script there!"
        exit -1;
fi

tar xvzf $NAME-$VERSION-sources.tar.gz
if [ $? -ne 0 ]; then
        echo "WARNING: $NAME-$VERSION-sources.tar.gz IS NOT PRESENT! If this is the first run of the script, the build WILL fail later on. If it isn't, you can safely ignore this message."
fi

echo -e "\n\n******************************************"
echo -e "!!! CVL PACKAGE 3D SLICER !!!"
echo -e "********************************************\n\n"

rm -rf $NAME-$VERSION-sources.tar.gz
mkdir -p ./etc/profile.d
echo "This is a binary build" > $BUILD_DIR/$NAME/$VERSION/readme.txt

rm -rf ./etc/profile.d/3dslicer_modules.sh
cat > ./etc/profile.d/3dslicer_modules.sh <<EOF
#!/bin/bash
echo -n "Checking 3D SLICER 'modules' requirements..."
if [ ! -f /etc/profile.d/modules.sh ]; then echo -e "FAILED\nERROR: Modules package is not installed !!!!!\n"; fi;

. /etc/profile.d/modules.sh

if [ ! -f /tmp/build_mod_load ]; then touch /tmp/build_mod_load; chmod 777 /tmp/build_mod_load; fi;

module load mesalib 2> /tmp/build_mod_load
module load libjpeg-turbo 2> /tmp/build_mod_load
module load 3dslicer/4.2.2 2> /tmp/build_mod_load
CHECK_SIZE=\`stat -c%s /tmp/build_mod_load\`
if [ \$CHECK_SIZE -ne 0 ]; then echo -e "FAILED\nERROR: Could not locate 3dslicer package. Please install it and load it: 'module load 3dslicer' !!!!!\n"
fi

rm -rf /tmp/build_mod_load

echo -e "Finished.\n"
EOF
chmod 777 ./etc/profile.d/3dslicer_modules.sh

rm -rf $BUILD_DIR/bin/slicer_mod_load
cat >  $BUILD_DIR/bin/slicer_mod_load <<EOF
#!/bin/sh
module load mesalib
module load glu
module load libjpeg-turbo
Slicer
EOF
chmod 777 $BUILD_DIR/bin/slicer_mod_load

rm -rf $NAME-$VERSION-binaries.tar.gz
tar cvfz $NAME-$VERSION-binaries.tar.gz $BUILD_DIR

echo -e "\n\n*******************************************************************"
echo -e "\tNOW GO AHEAD AND CVL BUILD ME FROM THE TAR JUST CREATED"
echo -e "*******************************************************************\n\n"
