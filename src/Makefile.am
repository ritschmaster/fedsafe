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

bin_SCRIPTS = fedsafe

fedsafe_SCRIPTS_SOURCES =  gettext.in.sh
fedsafe_SCRIPTS_SOURCES += help.in.sh
fedsafe_SCRIPTS_SOURCES += util.in.sh
fedsafe_SCRIPTS_SOURCES += setup.in.sh
fedsafe_SCRIPTS_SOURCES += box.in.sh
fedsafe_SCRIPTS_SOURCES += sboxed.in.sh
fedsafe_SCRIPTS_SOURCES += dboxed.in.sh
fedsafe_SCRIPTS_SOURCES += main.in.sh

desktopdir 	 = $(datadir)/applications
desktop_DATA =  applications/fedsafe-dboxed-evince.desktop
desktop_DATA += applications/fedsafe-dboxed-firefox.desktop
desktop_DATA += applications/fedsafe-dboxed-libreoffice-calc.desktop
desktop_DATA += applications/fedsafe-dboxed-libreoffice-impress.desktop
desktop_DATA += applications/fedsafe-dboxed-libreoffice-writer.desktop
desktop_DATA += applications/fedsafe-dboxed-xterm.desktop
desktop_DATA += applications/fedsafe-sboxed-firefox.desktop
desktop_DATA += applications/fedsafe-sboxed-hexchat.desktop
desktop_DATA += applications/fedsafe-sboxed-telegram.desktop

fedsafebindir = $(datadir)/fedsafe/bin
fedsafebin_DATA =  bin/fedsafe_dboxed_evince.sh
fedsafebin_DATA += bin/fedsafe_dboxed_firefox.sh
fedsafebin_DATA += bin/fedsafe_dboxed_libreoffice_calc.sh
fedsafebin_DATA += bin/fedsafe_dboxed_libreoffice_impress.sh
fedsafebin_DATA += bin/fedsafe_dboxed_libreoffice_writer.sh
fedsafebin_DATA += bin/fedsafe_sboxed_firefox.sh
fedsafebin_DATA += bin/fedsafe_sboxed_hexchat.sh
fedsafebin_DATA += bin/fedsafe_sboxed_telegram.sh

CLEANFILES = $(bin_SCRIPTS)

EXTRA_DIST = $(fedsafe_SCRIPTS_SOURCES)

fedsafe: $(fedsafe_SCRIPTS_SOURCES)
	echo '#!/bin/bash' > fedsafe
	cat $(fedsafe_SCRIPTS_SOURCES) >> fedsafe
	chmod +x fedsafe
	sed -i s/PACKAGE_NAME/@PACKAGE_NAME@/g fedsafe
	sed -i s/PACKAGE_VERSION/@PACKAGE_VERSION@/g fedsafe
	sed -i '/#.*/{25,$$d}' fedsafe
