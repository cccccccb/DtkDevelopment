#! /bin/bash

TargetPath=$1
echo $TargetPath

DtkDirName=`ls $TargetPath | grep DtkDevelopment`

if [ ! -n "$DtkDirName" ]; then
    TargetDtkPath=${TargetPath}
else
    TargetDtkPath=${TargetPath}/${DtkDirName}
fi

find $TargetPath -name "qt_lib_dtk*.pri" | xargs sed -i "s|\/github\/workspace\/QtInstalled\/5.15.3|${TargetDtkPath}|"
find $TargetPath -name "Dtk*Config.cmake" | xargs sed -i "s|\/github\/workspace\/QtInstalled\/5.15.3|${TargetDtkPath}|"
find $TargetPath -name "*.pc" | xargs sed -i "s|\[_PKG_CONFIG_PATH_MODULE_\]|${TargetDtkPath}|"
find $TargetPath -name "*.pc" | xargs sed -i "s|\/github\/workspace\/QtInstalled\/5.15.3|${TargetDtkPath}|"

echo "Replace Done"
