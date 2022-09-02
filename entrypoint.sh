#!/bin/bash

ls
mv /etc/apt/sources.list /etc/apt/sources.list.back
cp .environment/sources.list /etc/apt/
cat /etc/apt/sources.list
apt update
apt install -y build-essential git libmd4c0 libssh-dev libgtest-dev libgmock-dev librsvg2-dev libxext-dev libudev-dev x11proto-xext-dev libxcb-util0-dev libstartup-notification0-dev libmtdev-dev libegl1-mesa-dev libudev-dev libfontconfig1-dev libfreetype6-dev libglib2.0-dev libxrender-dev libxi-dev libcups2-dev

git submodule init
git submodule update

INSTALLED_LIBPATH=`pwd`/QtInstalled/5.15.3/lib
echo $INSTALLED_LIBPATH >> /etc/ld.so.conf
echo "ld so file: "
cat /etc/ld.so.conf
ldconfig

echo "==============================="
cat /etc/ld.so.cache
echo "==============================="

cd QtInstalled/5.15.3/lib/pkgconfig
CURRENT_LIB_PATH=`pwd`/../..
sed -i "s/\[_PKG_CONFIG_PATH_MODULE_\]/${CURRENT_LIB_PATH}/" *.pc
cd -

PKG_CONFIG_PATH=`pwd`/QtInstalled pkg-config --cflags --libs gsettings-qt

# build cmake 
cd .environment/cmake-3.23.3
mkdir build
cd build
../configure --prefix="../../../QtInstalled/5.15.3/"
make -j16
make install
cd ../../../
echo "cmake build finished"
ldconfig

# build dtkcommon 
echo "Build dtkcommon"
cd dtkcommon
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcommon"
ldconfig

# build dtkcore
echo "Build dtkcore"
cd ../../dtkcore
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcore"
ldconfig

# build dtkgui
echo "Build dtkgui"
cd ../../dtkgui
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkgui"
ldconfig

# build dtkwidget
echo "Build dtkwidget"
cd ../../dtkwidget
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkwidget"
ldconfig