#!/bin/bash

export DEVELOPMENT_ROOT=$PWD/src

# ------------------------------------------------------------------------------
function run_test() {
    echo ""
    echo "# $1 ($2)"
    echo "# -------------------------------------------" 
    OLDPWD=$PWD
    cd $1 || exit 1
    ctest || exit 1
    cd $OLDPWD
}
# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B C; do
   if [ "$C" == "T" ]; then
      run_test $A $B || exit 1
   fi
done

echo ""