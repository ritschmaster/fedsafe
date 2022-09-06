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

function fedsafe_dboxed_print_help() {
    fedsafe_print_version

    local text=$(gettext "fedsafe" "dboxed help text bin=%s")
	printf "\n$text\n" $bin
}

function fedsafe_dboxed_firefox() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -t sandbox_web_t -i "$input_file" firefox "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) -t sandbox_web_t firefox "$@" & disown
    fi
}

function fedsafe_dboxed_evince() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -i "$input_file" evince "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) evince "$@" & disown
    fi
}

function fedsafe_dboxed_libreoffice_calc() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -i "$input_file" libreoffice -calc "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) libreoffice -calc "$@" & disown
    fi
}

function fedsafe_dboxed_libreoffice_impress() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -i "$input_file" libreoffice -impress "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) libreoffice -impress "$@" & disown
    fi
}

function fedsafe_dboxed_libreoffice_writer() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -i "$input_file" libreoffice -writer "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) libreoffice -writer "$@" & disown
    fi
}

function fedsafe_dboxed_xterm() {
    local input_file="$1"
    shift 1

    if [ -n "$input_file" ]; then
        sandbox -X -w $(fedsafe_determine_screen_size) -i "$input_file" xterm "$@" & disown
    else
        sandbox -X -w $(fedsafe_determine_screen_size) xterm "$@" & disown
    fi

    #sleep 2s && fedsafe_box_print_display -c 0
    #local displayno=$(fedsafe_box_print_display -c 0)
    #echo $displayno
    ## fedsafe_box_set_host_kbmap # TODO
}

function fedsafe_dboxed() {
    local input_file=""

    local OPTIND opt
    while getopts "hi:" opt; do
        case "$opt" in
            "h")
                fedsafe_dboxed_print_help
                exit
                ;;

            "i")
                input_file="${OPTARG}"
                ;;

            *)
                fedsafe_dboxed_print_help
                exit 1
                ;;

        esac
    done

    shift $((OPTIND-1))

    local command=$1
    shift 1

    case $command in
        "firefox")
            fedsafe_dboxed_firefox "$input_file" "$@"
            ;;

        "evince")
            fedsafe_dboxed_evince "$input_file" "$@"
            ;;

        "libreoffice_calc")
            fedsafe_dboxed_libreoffice_calc "$input_file" "$@"
            ;;

        "libreoffice_impress")
            fedsafe_dboxed_libreoffice_impress "$input_file" "$@"
            ;;

        "libreoffice_writer")
            fedsafe_dboxed_libreoffice_writer "$input_file" "$@"
            ;;

        "xterm")
            fedsafe_dboxed_xterm "$input_file" "$@"
            ;;

        *)
            fedsafe_dboxed_print_help
            exit 1
            ;;
    esac
}
