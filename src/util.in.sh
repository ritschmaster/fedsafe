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

    local xephyr_unit="fedsafe-xephyr-$RANDOM"
    /usr/bin/systemd-run \
        --user \
        --collect \
        --unit=$xephyr_unit \
        /usr/bin/Xephyr \
        -resizeable \
        -screen $(fedsafe_determine_screen_size) \
        -title "$window_title" \
        -no-host-grab \
        -nolock \
        -displayfd 1

    sleep 2s
    local xephyr_pid=$(systemctl show --user --property MainPID --value $xephyr_unit)
    local displayno=$(systemctl status --user --output=json-pretty $xephyr_unit | grep "MESSAGE" | tail -n 1)
    displayno=":${displayno:14:-2}"

    /usr/bin/systemd-run \
        --user \
        --collect \
        -E FEDSAFE_XEPHYR_PID=$xephyr_pid \
        -E DISPLAY="$displayno" \
        -p ProtectSystem=yes \
        -p ProtectHome=yes \
        /usr/bin/matchbox-window-manager \
        -use_titlebar no

    host_setxkbmap=$(setxkbmap -query | grep layout: | awk '{ print $2 }')

    bash -c "sleep 5s && setxkbmap -display \"$displayno\" \"$host_setxkbmap\"" & disown

    echo "$displayno"
}
