#!/bin/bash

MODE=$1
if [ -z "$MODE" ]; then
    MODE="quick"
fi

echo ""
echo "Clean mode: $MODE"


OLD_PWD=$PWD
cat repositories | grep -v '^#' | while read A B C; do
    echo ""
    echo "# $B"
    echo "# -------------------------------------------"  
    if [ -f $A/CMakeClean.sh ]; then
        cd "$A"
        ./CMakeClean.sh $MODE < /dev/null
        cd "$OLD_PWD"
    else
        echo "> Nothing to clean ..."
    fi
done

echo ""
