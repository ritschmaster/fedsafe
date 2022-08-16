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

function fedsafe_sbox_print_help() {
    fedsafe_print_version

    echo -en "\n"

    fedsafe_gettext "sbox help text"
}

function fedsafe_sbox_print_display() {
    window_name=$(xprop | grep WM_NAME)
    window_name=${window_name:19:-2}

    window_pid=$(ps -x | grep "$window_name" | head -n 1 | cut -d' ' -f 3)
    matchbox_pid=$(pstree -p | grep -A 3 $window_pid | grep matchbox | cut -d'(' -f 2 | cut -d')' -f 1)

    window_display=$(cat /proc/$matchbox_pid/environ | tr '\0' '\n' | grep 'DISPLAY=')
    window_display=${window_display:8}

    echo $window_display
}

function fedsafe_sbox_clipboard_copy() {
    xsel -b -o --display $(fedsafe_sbox_print_display) | xsel -b -i
}

function fedsafe_sbox_clipboard_paste() {
    xsel -b -o | xsel -b -i --display $(fedsafe_sbox_print_display)
}

function fedsafe_sbox() {
    while getopts "h" opt; do
        case "$opt" in
            "h")
                fedsafe_sbox_print_help
                exit
                ;;
            *)
                fedsafe_sbox_print_help
                exit 1
                ;;
        esac
    done

    shift $((OPTIND-1))

    command=$1

    case $command in
        "print_display")
            shift 1
            fedsafe_sbox_print_display $@
            ;;

        "clipboard_copy")
            shift 1
            fedsafe_sbox_clipboard_copy $@
            ;;

        "clipboard_paste")
            shift 1
            fedsafe_sbox_clipboard_paste $@
            ;;

        *)
            fedsafe_sboxed_print_help
            exit 1
            ;;
    esac
}
