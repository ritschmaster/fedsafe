#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    if [ -f "$1" ]; then
        /usr/bin/fedsafe dboxed -i "$1" firefox "$1"
    else
        /usr/bin/fedsafe dboxed firefox "$1"
    fi
else
    /usr/bin/fedsafe dboxed firefox
fi
