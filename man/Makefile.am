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

man1_MANS =  fedsafe.1
man1_MANS += fedsafe-box.1
man1_MANS += fedsafe-dboxed.1
man1_MANS += fedsafe-sboxed.1
man1_MANS += fedsafe-setup.1

man1dedir 	 = $(datadir)/man/de/man1
man1de_DATA =  de/fedsafe.1
man1de_DATA += de/fedsafe-box.1
man1de_DATA += de/fedsafe-dboxed.1
man1de_DATA += de/fedsafe-sboxed.1
man1de_DATA += de/fedsafe-setup.1

EXTRA_DIST =  fedsafe.1.in
EXTRA_DIST += fedsafe-box.1.in
EXTRA_DIST += fedsafe-dboxed.1.in
EXTRA_DIST += fedsafe-sboxed.1.in
EXTRA_DIST += fedsafe-setup.1.in

all-local: ${man1_MANS} ${man1de_DATA}

%.1: %.1.in
	cp ${@:.1=.1.in} $@
	sed -i s/PACKAGE_NAME/@PACKAGE_NAME@/g $@
	sed -i s/PACKAGE_VERSION/@PACKAGE_VERSION@/g $@
	sed -i s/PACKAGE_DATE/@PACKAGE_DATE@/g $@
