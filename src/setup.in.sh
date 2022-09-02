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

function fedsafe_setup_print_help() {
    fedsafe_print_version

    local text=$(gettext "fedsafe" "setup help text bin=%s")
	printf "\n$text\n" $bin
}

function fedsafe_setup_hidepid() {
    echo -en "Execute the following commands:\n"
    echo -en 'sudo groupadd procmonitor\n'
	echo -en 'sudo usermod -a -G procmonitor polkitd\n'
	# sudo bash -c "echo -en \"\nproc\t/proc\tproc\tdefaults,hidepid=2,gid=$(getent group procmonitor | cut -d':' -f 3)\t0\t0\n\" >> /etc/fstab"
}

function fedsafe_setup_sandboxes() {
    echo -en "Execute the following command:\n"
    echo -en "sudo setsebool -P xserver_clients_write_xshm=1"
}

function fedsafe_setup() {
    local OPTIND opt
    while getopts "hi:" opt; do
        case "$opt" in
            "h")
                fedsafe_setup_print_help
                exit
                ;;

            *)
                fedsafe_setup_print_help
                exit 1
                ;;

        esac
    done

    shift $((OPTIND-1))

    local command=$1
    shift 1

    case $command in
        "hidepid")
            fedsafe_setup_hidepid
            ;;

        "sandboxes")
            fedsafe_setup_sandboxes
            ;;

        *)
            fedsafe_setup_print_help
            exit 1
            ;;
    esac

}
