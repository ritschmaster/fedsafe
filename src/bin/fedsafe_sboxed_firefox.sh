#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    /usr/bin/fedsafe sboxed -i "$1" firefox "$1"
else
    /usr/bin/fedsafe sboxed firefox
fi
