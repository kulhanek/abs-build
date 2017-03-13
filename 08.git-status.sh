#!/bin/bash

# ------------------------------------------------------------------------------
function dowload_code() {
    echo ""
    echo "# $2 ?? $1"
    echo "# -------------------------------------------" 
    OLDPWD=$PWD
    cd $1 || exit 1
    git status || exit 1
    cd $OLDPWD
}

# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B; do
   dowload_code $A $B || exit 1
done

echo ""

