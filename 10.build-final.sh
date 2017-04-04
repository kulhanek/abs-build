#!/bin/bash

SITES="pbspro"
PREFIX="core"

# ------------------------------------------------------------------------------
# add cmake from modules if they exist
if type module &> /dev/null; then
    module add cmake
fi

# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
fi

# ------------------------------------------------------------------------------
# update revision number
_PWD=$PWD
if ! [ -d src/projects/abs/3.0 ]; then
    echo "src/projects/abs/3.0 - not found"
    exit 1
fi

cd src/projects/abs/3.0
./UpdateGitVersion activate
VERS="3.`git rev-list --count HEAD`.`git rev-parse --short HEAD`"
cd $_PWD

# ------------------------------------
if [ -z "$AMS_ROOT" ]; then
   echo "ERROR: This installation script works only in the Infinity environment!"
   exit 1
fi

# names ------------------------------
NAME="abs"
ARCH=`uname -m`
MODE="single" 
echo "Build: $NAME:$VERS:$ARCH:$MODE"
echo ""

# build and install software ---------
cmake -DCMAKE_INSTALL_PREFIX="$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" .
make install
if [ $? -ne 0 ]; then exit 1; fi

# make link to global setup
ln -s /software/ncbr/softmods/8.0/etc/abs $SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/etc/sites

# prepare build file -----------------
SOFTBLDS="$AMS_ROOT/etc/map/builds/$PREFIX"
VERIDX=`ams-map-manip newverindex $NAME:$VERS:$ARCH:$MODE`

cat > $SOFTBLDS/$NAME:$VERS:$ARCH:$MODE.bld << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Advanced Module System (AMS) build file -->
<build name="$NAME" ver="$VERS" arch="$ARCH" mode="$MODE" verindx="$VERIDX">
    <setup>
        <variable name="AMS_PACKAGE_DIR" value="$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set" priority="modaction"/>
        <variable name="PATH" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/bin" operation="prepend"/>
        <variable name="ABS_ROOT" value="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE" operation="set"/>
        <script   name="\$SOFTREPO/$PREFIX/$NAME/$VERS/$ARCH/$MODE/etc/boot/init.abs" type="inline"/>
    </setup>
</build>
EOF

ams-map-manip addbuilds $SITES $NAME:$VERS:$ARCH:$MODE
if [ $? -ne 0 ]; then exit 1; fi

ams-map-manip distribute
if [ $? -ne 0 ]; then exit 1; fi

ams-cache rebuildall


