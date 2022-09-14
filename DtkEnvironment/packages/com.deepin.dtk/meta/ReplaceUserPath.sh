#! /bin/bash

TargetPath=$1
echo $TargetPath

DtkDirName=`ls $TargetPath | grep DtkDevelopment`
TargetDtkPath=${TargetPath}/${DtkDirName}
echo ${TargetDtkPath}

find $TargetPath -name "qt_lib_dtk*.pri" | xargs sed -i "s|\/github\/workspace\/QtInstalled\/5.15.3|${TargetDtkPath}|"
find $TargetPath -name "*.pc" | xargs sed -i "s|\[_PKG_CONFIG_PATH_MODULE_\]|${TargetDtkPath}|"
echo "Replace Done"
