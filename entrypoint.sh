#!/bin/bash

ls
mv /etc/apt/sources.list /etc/apt/sources.list.back
mv .environment/sources.list /etc/apt/
cat /etc/apt/sources.list
apt update
apt install -y build-essential git libssh-dev libgtest-dev libgmock-dev librsvg2-dev libxext-dev libudev-dev x11proto-xext-dev libxcb-util0-dev libstartup-notification0-dev libmtdev-dev libegl1-mesa-dev libudev-dev libfontconfig1-dev libfreetype6-dev libglib2.0-dev libxrender-dev libxi-dev libcups2-dev

git submodule init
git submodule update

# build cmake 
cd .environment/cmake-3.23.3
mkdir build
cd build
../configure --prefix="../../../QtInstalled/5.15.3/"
make -j16
make install
cd ../../../
echo "cmake build finished"

# build dtkcommon 
echo "Build dtkcommon"
cd dtkcommon
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcommon"

# build dtkcore
echo "Build dtkcore"
cd ../../dtkcore
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcore"

# build dtkgui
echo "Build dtkgui"
cd ../../dtkgui
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkgui"

# build dtkwidget
echo "Build dtkwidget"
cd ../../dtkwidget
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkwidget"
