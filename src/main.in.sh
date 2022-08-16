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

bin="$0"

while getopts "vh" opt; do
	case "$opt" in
		"v")
			fedsafe_print_version
			exit
			;;
		"h")
			fedsafe_print_help
			exit
			;;
		*)
			fedsafe_print_help $bin
			exit 1
			;;
	esac
done

shift $((OPTIND-1))

command="$1"

case "$command" in
	"setup")
		shift 1
		fedsafe_setup $@
		;;

	"sbox")
		shift 1
		fedsafe_sbox $@
		;;

	"sboxed")
		shift 1
		fedsafe_sboxed $@
		;;

	"dboxed")
		shift 1
		fedsafe_dboxed $@
		;;

	*)
		fedsafe_print_help $bin
		exit 1
		;;
esac
