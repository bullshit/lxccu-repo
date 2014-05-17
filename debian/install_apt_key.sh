#!/bin/sh
# postinst script for lxcu-repo
#
# see: dh_installdeb(1)

set -e

# summary of how this script can be called:
#        * <postinst> `configure' <most-recently-configured-version>
#        * <old-postinst> `abort-upgrade' <new version>
#        * <conflictor's-postinst> `abort-remove' `in-favour' <package>
#          <new-version>
#        * <postinst> `abort-remove'
#        * <deconfigured's-postinst> `abort-deconfigure' `in-favour'
#          <failed-install-package> <version> `removing'
#          <conflicting-package> <version>
# for details, see http://www.debian.org/doc/debian-policy/ or
# the debian-policy package

# source debconf library
. /usr/share/debconf/confmodule

case "$1" in

  configure)
	REPO_KEY_ID_LONG="5371D7FED7C6BA0C"
	REPO_KEY_ID_SHORT="D7C6BA0C"
	KEYSERVER=keys.gnupg.net
	URL_TO_GPG_KEY="http://www.lxccu.com/me@oskarholowaty.com.gpg.key"

	apt-key adv --keyserver "$KEYSERVER" --recv-keys "$REPO_KEY_ID_LONG"; RET=$?

	if [ $RET -ne 0 ]; then
		# Try again, using wget this time
		KEYDATA="$(wget -nv -O- $URL_TO_GPG_KEY)" || die "Key download failed."
		echo "$KEYDATA" | apt-key add - || die "Adding the key failed."
	fi

	
	REPO_KEY_ID_LONG="58F167B86220726A"
	REPO_KEY_ID_SHORT="6220726A"
	URL_TO_GPG_KEY="http://www.lxccu.com/team@lxccucom.asc"
	apt-key adv --keyserver "$KEYSERVER" --recv-keys "$REPO_KEY_ID_LONG"; RET=$?

	if [ $RET -ne 0 ]; then
		# Try again, using wget this time
		KEYDATA="$(wget -nv -O- $URL_TO_GPG_KEY)" || die "Key download failed."
		echo "$KEYDATA" | apt-key add - || die "Adding the key failed."
	fi	
    db_go lxccu-repo $@ || true
  ;;

  abort-upgrade|abort-remove|abort-deconfigure)
    exit 0
  ;;

  *)
    echo "postinst called with unknown argument \`$1'" >&2
    exit 1
  ;;

esac

exit 0