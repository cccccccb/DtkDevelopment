QT -= gui
TARGET = DebBuild_env

CONFIG += c++11 console release
CONFIG -= app_bundle

DESTDIR = $${_PRO_FILE_PWD_}/../.environment
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += \
        main.cpp
