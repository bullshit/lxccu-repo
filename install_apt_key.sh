#!/bin/bash
REPO_KEY_ID_LONG="5371D7FED7C6BA0C"
REPO_KEY_ID_SHORT="D7C6BA0C"
KEYSERVER=keys.gnupg.net
URL_TO_GPG_KEY="https://www.biglan.at/oskar/lxccu/me@oskarholowaty.com.gpg.key"

apt-key adv --keyserver "$KEYSERVER" --recv-keys "$REPO_KEY_ID_LONG"; RET=$?

if [ $RET -ne 0 ]; then
	# Try again, using wget this time
	KEYDATA="$(wget -nv -O- $URL_TO_GPG_KEY)" || die "Key download failed."
	echo "$KEYDATA" | apt-key add - || die "Adding the key failed."
fi