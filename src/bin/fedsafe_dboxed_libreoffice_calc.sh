#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    fedsafe dboxed -i "$1" libreoffice_calc "$1"
else
    fedsafe dboxed libreoffice_calc
fi
