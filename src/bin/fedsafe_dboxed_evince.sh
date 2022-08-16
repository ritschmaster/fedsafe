#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    fedsafe dboxed -i "$1" evince "$1"
else
    fedsafe dboxed evince
fi
