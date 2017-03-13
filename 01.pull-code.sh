#!/bin/bash

# ------------------------------------------------------------------------------
function dowload_code() {
    echo ""
    echo "# $2 -> $1"
    echo "# -------------------------------------------" 
    OLDPWD=$PWD
    mkdir -p $1 || exit 1
    cd $1 || exit 1
    if ! [ -d .git ]; then
        git init || exit 1
        git remote add github https://github.com/kulhanek/${2}.git || exit 1
    fi 
    git pull github master || exit 1
    cd $OLDPWD
}

# ------------------------------------------------------------------------------

_PWD=$PWD
if [ -d src/projects/abs/3.0 ]; then
    cd  src/projects/abs/3.0
    git checkout -- src/lib/abs/ABSMainHeader.cpp
    cd $_PWD
fi

cat repositories | grep -v '^#' | while read A B; do
   dowload_code $A $B || exit 1
done

echo ""

