#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    /usr/bin/fedsafe dboxed -i "$1" evince "$1"
else
    /usr/bin/fedsafe dboxed evince
fi
