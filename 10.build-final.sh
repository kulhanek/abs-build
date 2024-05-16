#!/bin/bash

SITES="pbspro"
PREFIX="core"
REV="01"
LOG="$PWD/abs.log"

set -o pipefail

# ------------------------------------
if [ -z "$AMS_ROOT_V9" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

# ------------------------------------------------------------------------------
module add cmake git

# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
    if [ "$N" -gt 4 ]; then
        N=4
    fi
fi

# ------------------------------------------------------------------------------
# run pre-installation hook if available
if [ -f ./preinstall-hook ]; then
    source ./preinstall-hook || exit 1
fi

# names ------------------------------
NAME="abs"
ARCH=`uname -m`
MODE="single" 
echo "Build: $NAME:$VERS:$ARCH:$MODE"
echo ""

echo ">>> Number of CPUs for building: $N"
echo ""

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX="$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" . | tee $LOG
if [ $? -ne 0 ]; then exit 1; fi

make -j "$N" install | tee -a $LOG
if [ $? -ne 0 ]; then exit 1; fi

# make link to global setup
unlink "$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/etc/sites" 2> /dev/null
ln -s "$AMS_ROOT_V9/etc/abs/$REV" "$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/etc/sites"

# prepare build file -----------------
SOFTBLDS="$SOFTREPO/$PREFIX/_ams_bundle/blds/"
cd $SOFTBLDS || exit 1
VERIDX=`ams-bundle newverindex $NAME:$VERS:$ARCH:$MODE`

cat > $NAME:$VERS:$ARCH:$MODE.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="$NAME" ver="$VERS" arch="$ARCH" mode="$MODE" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/bin" operation="prepend"/>
        <variable name="ABS_ROOT" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set"/>
        <script   name="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/etc/boot/init.abs" type="inline"/>
    </setup>
    <deps>
        <dep name="abs-rsync"               type="sync"/>
        <dep name="tigervnc"                type="sync"/>
        <dep name="screen"                  type="sync"/>
        <dep name="ncbr-personal-libpbspro" type="deb"/>
    </deps>
</build>
EOF
if [ $? -ne 0 ]; then exit 1; fi

echo ""
echo "Rebuilding bundle ..."
ams-bundle rebuild | tee -a $LOG
if [ $? -ne 0 ]; then exit 1; fi

echo "LOG: $LOG"
echo ""

