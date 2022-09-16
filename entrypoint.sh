#!/bin/bash

ls
mv /etc/apt/sources.list /etc/apt/sources.list.back
cp .environment/sources.list /etc/apt/
cat /etc/apt/sources.list
apt update
cat build_pakages.txt | xargs apt install -y
git submodule init
git submodule update

INSTALLED_LIBPATH=`pwd`/QtInstalled/5.15.3/lib
echo $INSTALLED_LIBPATH >> /etc/ld.so.conf
echo "ld so file: "
cat /etc/ld.so.conf
ldconfig

cd QtInstalled/5.15.3/lib/pkgconfig
CURRENT_LIB_PATH=`pwd`/../..
sed -i "s|\[_PKG_CONFIG_PATH_MODULE_\]|${CURRENT_LIB_PATH}|" *.pc
cd -

PKG_CONFIG_PATH=`pwd`/QtInstalled/5.15.3/lib/pkgconfig pkg-config --cflags --libs gsettings-qt

# Create cxxflags
export CXXFLAGS="${CXXFLAGS} -L${INSTALLED_LIBPATH}"
export LDFLAGS="${LDFLAGS} -L${INSTALLED_LIBPATH}"
echo "CXXFLAGS: " $CXXFLAGS "LDFLAGS: " $LDFLAGS

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
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=on -DMKSPECS_INSTALL_DIR="../../QtInstalled/5.15.3/mkspecs" -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcommon"
ldconfig

# build dtkcore
echo "Build dtkcore"
cd ../../dtkcore
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_VERBOSE_MAKEFILE=on -DMKSPECS_INSTALL_DIR="../../QtInstalled/5.15.3/mkspecs/modules" -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkcore"
ldconfig

# build dtkgui
echo "Build dtkgui"
cd ../../dtkgui
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DDCMAKE_BUILD_TYPE=Debug -DNOTPACKAGE=false -DCMAKE_VERBOSE_MAKEFILE=on -DMKSPECS_INSTALL_DIR="../../QtInstalled/5.15.3/mkspecs/modules" -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkgui"
ldconfig

# build dtkwidget
echo "Build dtkwidget"
cd ../../dtkwidget
mkdir build
cd build
../../QtInstalled/5.15.3/bin/cmake -DDCMAKE_BUILD_TYPE=Debug -DNOTPACKAGE=false -DMKSPECS_INSTALL_DIR="../../QtInstalled/5.15.3/mkspecs/modules" -DCMAKE_VERBOSE_MAKEFILE=on -DCMAKE_PREFIX_PATH="../../QtInstalled/5.15.3/" -DCMAKE_INSTALL_PREFIX="../../QtInstalled/5.15.3/" -DBUILD_DOCS=false ..
../../QtInstalled/5.15.3/bin/cmake --build . -j12
../../QtInstalled/5.15.3/bin/cmake --install .
echo "Finished dtkwidget"
ldconfig

# build qt5integration
echo "Build qt5integration"
cd ../../qt5integration
mkdir build
cd build
../../QtInstalled/5.15.3/bin/qmake CONFIG+=debug ..
make -j12
make install
echo "Finished qt5integration"

echo "Build qt5platform-plugins"
cd ../../qt5platform-plugins
mkdir build
cd build
../../QtInstalled/5.15.3/bin/qmake CONFIG+=debug ..
make -j12
make install
echo "Finished qt5platform-plugins"

cd ../../QtInstalled/5.15.3/lib/pkgconfig
sed -i "s|${CURRENT_LIB_PATH}|\[_PKG_CONFIG_PATH_MODULE_\]|" *.pc

cd ../../
tar zcvf ../../DtkDevelopment.tar.gz .
cd ../../
mv DtkDevelopment.tar.gz DtkEnvironment/packages/com.deepin.dtk/data
./binarycreator -c DtkEnvironment/config/config.xml  -p DtkEnvironment/packages/ -t installerbase DtkInstaller
