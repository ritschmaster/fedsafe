#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    if [ -f "$1" ]; then
        fedsafe dboxed -i "$1" firefox "$1"
    else
        fedsafe dboxed firefox "$1"
    fi
else
    fedsafe dboxed firefox
fi
