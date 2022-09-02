#!/bin/bash

ls
mv /etc/apt/sources.list /etc/apt/sources.list.back
mv .environment/sources.list /etc/apt/
cat /etc/apt/sources.list
apt update
apt install -y build-essential
apt install -y git
apt install -y libssh-dev
apt install -y libgtest-dev
apt install -y libgmock-dev
apt install -y librsvg2-dev
apt install -y libxext-dev
apt install -y libudev-dev
apt install -y x11proto-xext-dev
apt install -y libxcb-util0-dev
apt install -y libstartup-notification0-dev
apt install -y libmtdev-dev
apt install -y libegl1-mesa-dev
apt install -y libudev-dev
apt install -y libfontconfig1-dev
apt install -y libfreetype6-dev
apt install -y libglib2.0-dev
apt install -y libxrender-dev
apt install -y libxi-dev
apt install -y libcups2-dev

git submodule init
git submodule update

# build cmake 
cd .environment/cmake-3.23.3
mkdir build
cd build
../configure --prefix="../../QtInstalled/5.15.3/"
make -j16
make install
cd ../../../
echo "cmake build finished"
which cmake

# build dtkcommon 
echo "Build dtkcommon"
cd dtkcommon
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
echo "Finished dtkcommon"

# build dtkcore
echo "Build dtkcore"
cd ../../dtkcore
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
echo "Finished dtkcore"

# build dtkgui
echo "Build dtkgui"
cd ../../dtkgui
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
echo "Finished dtkgui"

# build dtkwidget
echo "Build dtkwidget"
cd ../../dtkwidget
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
echo "Finished dtkwidget"
