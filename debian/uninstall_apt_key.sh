#!/bin/sh
# postrm script for lxcu-repo
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <postrm> `remove'
#        * <postrm> `purge'
#        * <old-postrm> `upgrade' <new-version>
#        * <new-postrm> `failed-upgrade' <old-version>
#        * <new-postrm> `abort-install'
#        * <new-postrm> `abort-install' <old-version>
#        * <new-postrm> `abort-upgrade' <old-version>
#        * <disappearer's-postrm> `disappear' <r>overwrit>r> <new-version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

. /usr/share/debconf/confmodule


REPO_KEY_ID_SHORT="D7C6BA0C"

case "$1" in
	upgrade)
	;;
	remove|failed-upgrade|abort-install|abort-upgrade|disappear)
		apt-key del $REPO_KEY_ID_SHORT || exit 78
	;;

	purge)
		apt-key del $REPO_KEY_ID_SHORT || exit 78
	;;

	*)
	echo "postrm called with unknown argument \`$1'" >&2
	exit 1
	;;

esac

exit 0
