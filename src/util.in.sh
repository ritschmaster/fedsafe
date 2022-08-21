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

function fedsafe_determine_screen_size() {
    xdpyinfo | grep "dimensions" | awk '{ print $2 }'
}

# Create a new xserver for a sandbox
#
# The first parameter is the window title for the window containing the new xserver.
#
# The new display number is printed to stdout.
function fedsafe_new_display() {
    local window_title="$1"

    local displayno_file=$(mktemp)

    exec 5>"$displayno_file"
    # /usr/bin/systemd-run \
    #     --user \
    #     --collect \
    #     -p PrivateUsers=yes \
    #     -p TemporaryFileSystem=/tmp \
    #     -p BindPaths="$displayno_file" \
    #     /usr/bin/Xephyr -resizeable -screen $(fedsafe_determine_screen_size) -title "$window_title" -displayfd 5

    # /usr/bin/Xephyr \
    #     -resizeable \
    #     -screen $(fedsafe_determine_screen_size) \
    #     -title "$window_title" \
    #     -nolock \
    #     -terminate \
    #     -reset \
    #     -dpi 96.0 \
    #     -nolisten tcp \
    #     -displayfd 5 \
    #     >/dev/null & disown

    /usr/bin/Xephyr \
        -resizeable \
        -screen $(fedsafe_determine_screen_size) \
        -title "$window_title" \
        -displayfd 5 \
        >/dev/null & disown

    xephyr_pid=$(pidof /usr/bin/Xephyr | cut -d' ' -f 1)

    sleep 2s
    exec 5>&-

    local displayno=$(cat "$displayno_file")
    displayno=":$displayno"

    rm "$displayno_file"

    /usr/bin/systemd-run \
        --user \
        --collect \
        -E FEDSAFE_XEPHYR_PID=$xephyr_pid \
        -E DISPLAY="$displayno" \
        -p ProtectSystem=yes \
        -p ProtectHome=yes \
        /usr/bin/matchbox-window-manager \
        -use_titlebar no

    echo "$displayno"
}
