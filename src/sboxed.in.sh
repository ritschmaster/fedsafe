################################################################################
# This file is part of fedsafe.
#
# Copyright 2022 Richard Paul Baeck <richard.baeck@mailbox.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

FEDSAFE_SBOXED_HOME_DOWNLOADS=$HOME/Downloads

FEDSAFE_SBOXED_FIREFOX_UNIT="fedsafe-sboxed-firefox"
FEDSAFE_SBOXED_FIREFOX_MOZILLA="$HOME/.mozilla"
FEDSAFE_SBOXED_FIREFOX_MOZILLA_FIREFOX="$FEDSAFE_SBOXED_FIREFOX_MOZILLA/firefox"
FEDSAFE_SBOXED_FIREFOX_MOZILLA_PROFILES_INI="$FEDSAFE_SBOXED_FIREFOX_MOZILLA_FIREFOX/profiles.ini"

FEDSAFE_SBOXED_HEXCHAT_UNIT="fedsafe-sboxed-hexchat"
FEDSAFE_SBOXED_HEXCHAT_CONFIG="$HOME/.config/hexchat"

FEDSAFE_SBOXED_TELEGRAM_UNIT="fedsafe-sboxed-telegram"
FEDSAFE_SBOXED_TELEGRAM_CONFIG="$HOME/.local/share/TelegramDesktop"

FEDSAFE_SBOXED_THUNDERBIRD_UNIT="fedsafe-sboxed-thunderbird"
FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA="$HOME/.thunderbird"
FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_THUNDERBIRD="$FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA"
FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_PROFILES_INI="$FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_THUNDERBIRD/profiles.ini"

function fedsafe_sboxed_print_help() {
    fedsafe_print_version

    echo -en "\n"

    fedsafe_gettext "sboxed help text"
}

function fedsafe_sboxed_default_systemd_args() {
    echo "--user\n"
    echo "--collect\n"
    echo "-E DISPLAY=\"$displayno\"\n"
    echo "-p PrivateUsers=yes\n"
    echo "-p ProtectClock=yes\n"
    echo "-p BindPaths=\"$FEDSAFE_SBOXED_HOME_DOWNLOADS\"\n"
    echo "-p SystemCallFilter=~@reboot\n"
    echo "-p SystemCallFilter=\"~mount mount_setattr umount move_mount umount2\"\n"
    echo "-p SystemCallFilter=~@swap\n"
    echo "-p SystemCallFilter=~@module\n"
    #echo "-p SystemCallFilter=~@privileged\n" # TODO
    #echo "-p SystemCallFilter=~@process\n" # TODO
}

function fedsafe_sboxed_firefox() {
    local input_file="$1"
    local new_display="$2"
    shift 2

    ############################################################################
    # Analyze Firefox's arguments
    local next_contains_profile="0"
    local profile_name=""
    for arg in "$@"; do
        if [ "$next_contains_profile" = "1" ]; then
            profile_name=$(basename $arg)
            FEDSAFE_SBOXED_FIREFOX_UNIT="$FEDSAFE_SBOXED_FIREFOX_UNIT-$profile_name"
            FEDSAFE_SBOXED_FIREFOX_MOZILLA_FIREFOX="$FEDSAFE_SBOXED_FIREFOX_MOZILLA_FIREFOX/$profile_name"
            next_contains_profile="0"
        fi

        if [ "$arg" = "--profile" ]; then
            next_contains_profile="1"
        fi
    done

    ###########################################################################
    # Check if there is already a running instance
    local found_unit=$(/usr/bin/systemctl --user list-units | grep "$FEDSAFE_SBOXED_FIREFOX_UNIT")

    ############################################################################
    # Screen setup
    local displayno=":0"
    if [ "$new_display" -eq 1 ]; then
        ########################################################################
        # Deny opening a new window in the selected profile
        if [ -n "$found_unit" ]; then
            fedsafe_gettext "sboxed firefox newwindow error" >&2
            exit 1
        fi

        local title="Sandboxed Firefox"
        local nice_profile_name=""
        if [ -n "$profile_name" ]; then
            nice_profile_name=$(echo $profile_name | cut -d'.' -f 2)
        fi

        displayno=$(fedsafe_new_display "Sandboxed Firefox $nice_profile_name")
    else
        ########################################################################
        # Allow just opening a new window in the selected profile
        if [ -n "$found_unit" ]; then
            FEDSAFE_SBOXED_FIREFOX_UNIT="$FEDSAFE_SBOXED_FIREFOX_UNIT$RANDOM"
        fi
    fi

    ############################################################################
    # Start Firefox
    local systemd_args=$(fedsafe_sboxed_default_systemd_args)

    systemd_args="$systemd_args-p SystemCallFilter=~@setuid\n"
    systemd_args="$systemd_args-p ProtectSystem=yes\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=$HOME\n"
    #systemd_args="$systemd_args-p TemporaryFileSystem=/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/sbin\n"
    #systemd_args="$systemd_args-p TemporaryFileSystem=/usr/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/local/bin\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/firefox\"\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/sh\"\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/bash\"\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/rm\"\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/rmdir\"\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/ln\"\n"

    if [ -n "$input_file" ]; then
        systemd_args="$systemd_args-p BindPaths=\"$input_file\"\n"
    fi
    systemd_args="$systemd_args-p BindPaths=\"$FEDSAFE_SBOXED_FIREFOX_MOZILLA_FIREFOX\"\n"
    systemd_args="$systemd_args--unit=\"$FEDSAFE_SBOXED_FIREFOX_UNIT\"\n"
    systemd_args="$systemd_args/usr/bin/firefox $@"

    echo -en $systemd_args | xargs /usr/bin/systemd-run
}

function fedsafe_sboxed_hexchat() {
    local input_file="$1"
    local new_display="$2"
    shift 2

    ############################################################################
    # Screen setup
    local displayno=":0"
    if [ "$new_display" -eq 1 ]; then
        displayno=$(fedsafe_new_display "Sandboxed Hexchat")
    fi

    ############################################################################
    # Start HexChat
    local systemd_args=$(fedsafe_sboxed_default_systemd_args)

    systemd_args="$systemd_args-p ProtectSystem=yes\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=$HOME\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/local/bin\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/hexchat\"\n"

    if [ -n "$input_file" ]; then
        systemd_args="$systemd_args-p BindPaths=\"$input_file\"\n"
    fi
    systemd_args="$systemd_args-p BindPaths=\"$FEDSAFE_SBOXED_HEXCHAT_CONFIG\"\n"
    systemd_args="$systemd_args--unit=\"$FEDSAFE_SBOXED_HEXCHAT_UNIT\"\n"
    systemd_args="$systemd_args/usr/bin/hexchat $@"

    echo -en $systemd_args | xargs /usr/bin/systemd-run

}

function fedsafe_sboxed_telegram() {
    local input_file="$1"
    local new_display="$2"
    shift 2

    ############################################################################
    # Screen setup
    local displayno=":0"
    if [ "$new_display" -eq 1 ]; then
        displayno=$(fedsafe_new_display "Sandboxed Telegram")
    fi

    ############################################################################
    # Start HexChat
    local systemd_args=$(fedsafe_sboxed_default_systemd_args)

    systemd_args="$systemd_args-p SystemCallFilter=~@setuid\n"
    systemd_args="$systemd_args-p ProtectSystem=yes\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=$HOME\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/local/bin\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/telegram-desktop\"\n"

    if [ -n "$input_file" ]; then
        systemd_args="$systemd_args-p BindPaths=\"$input_file\"\n"
    fi
    systemd_args="$systemd_args-p BindPaths=\"$FEDSAFE_SBOXED_TELEGRAM_CONFIG\"\n"
    systemd_args="$systemd_args--unit=\"$FEDSAFE_SBOXED_TELEGRAM_UNIT\"\n"
    systemd_args="$systemd_args/usr/bin/telegram-desktop $@"

    echo -en $systemd_args | xargs /usr/bin/systemd-run

}

function fedsafe_sboxed_thunderbird() {
    local input_file="$1"
    local new_display="$2"
    shift 2

    ############################################################################
    # Analyze Thunderbird's arguments
    local next_contains_profile="0"
    local profile_name=""
    for arg in "$@"; do
        if [ "$next_contains_profile" = "1" ]; then
            profile_name=$(basename $arg)
            FEDSAFE_SBOXED_THUNDERBIRD_UNIT="$FEDSAFE_SBOXED_THUNDERBIRD_UNIT-$profile_name"
            FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_THUNDERBIRD="$FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_THUNDERBIRD/$profile_name"
            next_contains_profile="0"
        fi

        if [ "$arg" = "--profile" ]; then
            next_contains_profile="1"
        fi
    done

    ###########################################################################
    # Check if there is already a running instance
    local found_unit=$(/usr/bin/systemctl --user list-units | grep "$FEDSAFE_SBOXED_THUNDERBIRD_UNIT")

    ############################################################################
    # Screen setup
    local displayno=":0"
    if [ "$new_display" -eq 1 ]; then
        ########################################################################
        # Deny opening a new window in the selected profile
        if [ -n "$found_unit" ]; then
            fedsafe_gettext "sboxed thunderbird newwindow error" >&2
            exit 1
        fi

        local title="Sandboxed Thunderbird"
        local nice_profile_name=""
        if [ -n "$profile_name" ]; then
            nice_profile_name=$(echo $profile_name | cut -d'.' -f 2)
        fi

        displayno=$(fedsafe_new_display "Sandboxed Thunderbird $nice_profile_name")
    else
        ########################################################################
        # Allow just opening a new window in the selected profile
        if [ -n "$found_unit" ]; then
            FEDSAFE_SBOXED_THUNDERBIRD_UNIT="$FEDSAFE_SBOXED_THUNDERBIRD_UNIT$RANDOM"
        fi
    fi

    ############################################################################
    # Start Thunderbird
    #
    local systemd_args=$(fedsafe_sboxed_default_systemd_args)

    systemd_args="$systemd_args-p SystemCallFilter=~@setuid\n"
    systemd_args="$systemd_args-p ProtectSystem=yes\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=$HOME\n"
    #systemd_args="$systemd_args-p TemporaryFileSystem=/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/sbin\n"
    #systemd_args="$systemd_args-p TemporaryFileSystem=/usr/bin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/sbin\n"
    systemd_args="$systemd_args-p TemporaryFileSystem=/usr/local/bin\n"
    systemd_args="$systemd_args-p BindPaths=\"/usr/bin/thunderbird\"\n"

    if [ -n "$input_file" ]; then
        systemd_args="$systemd_args-p BindPaths=\"$input_file\"\n"
    fi

    systemd_args="$systemd_args-p BindPaths=\"$FEDSAFE_SBOXED_THUNDERBIRD_MOZILLA_THUNDERBIRD\"\n"
    systemd_args="$systemd_args--unit=\"$FEDSAFE_SBOXED_THUNDERBIRD_UNIT\"\n"
    systemd_args="$systemd_args/usr/bin/thunderbird $@"

    echo -en $systemd_args | xargs /usr/bin/systemd-run
}

function fedsafe_sboxed() {
    local input_file=""
    local new_display="1"

    local OPTIND opt
    while getopts "hi:n:" opt; do
        case "$opt" in
            "h")
                fedsafe_sboxed_print_help
                exit
                ;;

            "i")
                input_file="${OPTARG}"
                ;;

            "n")
                new_display="${OPTARG}"
                if [ "$new_display" -ne 0 -a "$new_display" -ne 1 ]; then
                    fedsafe_sboxed_print_help
                    exit 1
                fi
                ;;

            *)
                fedsafe_sboxed_print_help
                exit 1
                ;;

        esac
    done

    shift $((OPTIND-1))

    local command=$1
    shift 1

    case $command in
        "firefox")
            fedsafe_sboxed_firefox "$input_file" "$new_display" "$@"
            ;;

        "hexchat")
            fedsafe_sboxed_hexchat "$input_file" "$new_display" "$@"
            ;;

        "telegram")
            fedsafe_sboxed_telegram "$input_file" "$new_display" "$@"
            ;;

        "thunderbird")
            fedsafe_sboxed_thunderbird "$input_file" "$new_display" "$@"
            ;;

        *)
            fedsafe_sboxed_print_help
            exit 1
            ;;
    esac
}
