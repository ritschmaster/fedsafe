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

function fedsafe_sboxed_print_help() {
    fedsafe_print_version

    echo -en "\n"

    fedsafe_gettext "sboxed help text"
}

function fedsafe_sboxed_firefox() {
    input_file="$1"

    SBOXED_FIREFOX_INCLUDE=/usr/share/fedsafe/config/sboxed_firefox_include.txt
    SBOXED_FIREFOX_HOME=~/.local/share/fedsafe/sboxed_firefox

    mkdir -p "$SBOXED_FIREFOX_HOME"

    shift 1
    if [ -n "$input_file" ]; then
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_FIREFOX_HOME" \
            -I "$SBOXED_FIREFOX_INCLUDE" \
            -t sandbox_web_t \
            -i "$input_file" \
            firefox $@
    else
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_FIREFOX_HOME" \
            -I "$SBOXED_FIREFOX_INCLUDE" \
            -t sandbox_web_t \
            firefox $@
    fi
}

function fedsafe_sboxed_evince() {
    input_file="$1"

    SBOXED_EVINCE_INCLUDE=/usr/share/fedsafe/config/sboxed_evince_include.txt
    SBOXED_EVINCE_HOME=~/.local/share/fedsafe/sboxed_evince

    mkdir -p "$SBOXED_EVINCE_HOME"

    shift 1
    if [ -n "$input_file" ]; then
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_EVINCE_HOME" \
            -I "$SBOXED_EVINCE_INCLUDE" \
            -i "$input_file" \
            evince $@
    else
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_EVINCE_HOME" \
            -I "$SBOXED_EVINCE_INCLUDE" \
            evince $@
    fi
}

function fedsafe_sboxed_libreoffice_writer() {
    input_file="$1"

    SBOXED_LIBREOFFICE_INCLUDE=/usr/share/fedsafe/config/sboxed_libreoffice_include.txt
    SBOXED_LIBREOFFICE_HOME=~/.local/share/fedsafe/sboxed_libreoffice

    mkdir -p "$SBOXED_LIBREOFFICE_HOME"

    shift 1
    if [ -n "$input_file" ]; then
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_LIBREOFFICE_HOME" \
            -I "$SBOXED_LIBREOFFICE_INCLUDE" \
            -i "$input_file" \
            libreoffice -writer $@
    else
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_LIBREOFFICE_HOME" \
            -I "$SBOXED_LIBREOFFICE_INCLUDE" \
            libreoffice -writer $@
    fi
}

function fedsafe_sboxed_libreoffice_calc() {
    input_file="$1"

    shift 1
    if [ -n "$input_file" ]; then
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_LIBREOFFICE_HOME" \
            -I "$SBOXED_LIBREOFFICE_INCLUDE" \
            -i "$input_file" \
            libreoffice -calc $@
    else
        sandbox -X \
            -w $(fedsafe_determine_screen_size) \
            -H "$SBOXED_LIBREOFFICE_HOME" \
            -I "$SBOXED_LIBREOFFICE_INCLUDE" \
            libreoffice -calc $@
    fi
}

function fedsafe_sboxed() {
    input_file=""

    while getopts "hi:" opt; do
        case "$opt" in
            "h")
                fedsafe_sboxed_print_help
                exit
                ;;

            "i")
                input_file="${OPTARG}"
                ;;

            *)
                fedsafe_sboxed_print_help
                exit 1
                ;;

        esac
    done

    shift $((OPTIND-1))

    command=$1

    case $command in
        "firefox")
            shift 1
            fedsafe_sboxed_firefox "$input_file" $@
            ;;

        "evince")
            shift 1
            fedsafe_sboxed_evince "$input_file" $@
            ;;

        "libreoffice_writer")
            shift 1
            fedsafe_sboxed_libreoffice_writer "$input_file" $@
            ;;

        "libreoffice_calc")
            shift 1
            fedsafe_sboxed_libreoffice_calc "$input_file" $@
            ;;

        *)
            fedsafe_sboxed_print_help
            exit 1
            ;;
    esac
}
