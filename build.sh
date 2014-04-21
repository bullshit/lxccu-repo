#!/bin/bash
PACKAGENAME="lxccurepo"
MAINTAINER="Oskar Holowaty <me@oskarholowaty.com>"
VENDOR="$MAINTAINER"
VERSION="1.0-1"
URL="https://www.biglan.at/oskar/lxccu/"
LICENSE="GPLv3"
DESCRIPTION="Install lxccu repository"

EXCLUDE="*DS_Store*"

fpm -f -s dir -t deb -a all \
	-x "$EXCLUDE" \
	-n "$PACKAGENAME" \
	-m "$MAINTAINER" \
	--vendor "$VENDOR" \
	--license "$LICENSE" \
	--url $URL \
	--description "$DESCRIPTION" \
	--after-install "install_apt_key.sh" \
	-v "$VERSION" \
	./src

