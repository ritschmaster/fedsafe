#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    /usr/bin/fedsafe sboxed -i "$1" telegram "$1"
else
    /usr/bin/fedsafe sboxed telegram
fi
