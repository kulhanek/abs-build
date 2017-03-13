#!/bin/bash

# ------------------------------------------------------------------------------

echo -n "export PATH=$PATH:"

I=0
cat repositories | grep -v '^#' | while read A B C; do
    if [[ -d $PWD/$A/bin ]]; then
        if [[ I -gt 0 ]]; then echo -n ":"; fi 
        echo -n "$PWD/$A/bin"
        ((I++))
    fi
done
echo

echo
if [[ -n "$LD_LIBRARY_PATH" ]]; then
    echo -n "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"
else
    echo -n "export LD_LIBRARY_PATH="
fi

I=0
cat repositories | grep -v '^#' | while read A B C; do 
    if [[ -d $PWD/$A/lib ]]; then
        if [[ I -gt 0 ]]; then echo -n ":"; fi
        echo -n "$PWD/$A/lib"
        ((I++))
    fi
    if [[ -d $PWD/$A/lib/drivers ]]; then
        if [[ I -gt 0 ]]; then echo -n ":"; fi
        echo -n "$PWD/$A/lib/drivers"
        ((I++))
    fi
done
echo 
