#!/usr/bin/env bash

if [ "$#" -eq "1" ]; then
    /usr/bin/fedsafe dboxed -i "$1" libreoffice_writer "$1"
else
    /usr/bin/fedsafe dboxed libreoffice_writer
fi
