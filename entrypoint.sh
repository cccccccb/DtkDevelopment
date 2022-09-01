#!/bin/bash

ls
mv /etc/apt/sources.list /etc/apt/sources.list.back
mv .environment/sources.list /etc/apt/
cat /etc/apt/sources.list
apt update
apt install -y build-essential
apt install -y cmake
apt build-dep -y libdtkcore-dev
apt build-dep -y libdtkgui-dev
apt build-dep -y libdtkwidget-dev

cd dtkcommon
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
cd ../../dtkcore
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
cd ../../dtkgui
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .
cd ../../dtkwidget
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
cmake --build . -j12
cmake --install .