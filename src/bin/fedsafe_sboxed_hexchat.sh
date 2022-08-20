#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    /usr/bin/fedsafe sboxed -i "$1" hexchat --existing "$1"
else
    /usr/bin/fedsafe sboxed hexchat --existing
fi
