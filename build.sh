#!/bin/bash
PACKAGENAME="lxcu-repo"
MAINTAINER="Oskar Holowaty <me@oskarholowaty.com>"
VENDOR="LXCU Team <team@lxcu.org>"
VERSION="1.0-1"
URL="https://www.biglan.at/oskar/lxccu/"
LICENSE="GPLv3"
DESCRIPTION="Install lxcu repository"

EXCLUDE="*DS_Store*"

fpm -f -s dir -t deb -a all \
	-x "$EXCLUDE" \
	-n "$PACKAGENAME" \
	-m "$MAINTAINER" \
	--vendor "$VENDOR" \
	--category "misc" \
	--license "$LICENSE" \
	--url $URL \
	--description "$DESCRIPTION" \
	--after-install "install_apt_key.sh" \
	-v "$VERSION" \
	./src/

