#!/bin/bash
PACKAGENAME="lxccu-repo"
MAINTAINER="Oskar Holowaty <me@oskarholowaty.com>"
VENDOR="LXCU Team <team@lxccu.com>"
VERSION="1.2-6"
URL="http://www.lxccu.com"
LICENSE="GPLv3"
DESCRIPTION="Install lxccu repository"

#TODO sed version number in changelog and setup.sh

ROOT=`pwd`

cd ./src
fpm -f -s dir -t deb -a all \
	-n "$PACKAGENAME" \
	-m "$MAINTAINER" \
	--vendor "$VENDOR" \
	--category "misc" \
	--license "$LICENSE" \
	--url $URL \
	--description "$DESCRIPTION" \
	--after-install "${ROOT}/debian/install_apt_key.sh" \
	--post-uninstall "${ROOT}/debian/uninstall_apt_key.sh" \
	-v "$VERSION" \
	-p "${ROOT}/${PACKAGENAME}_${VERSION}_all.deb" \
	--config-files "/etc/apt/" \
	--deb-changelog "${ROOT}/debian/changelog" \
	--deb-compression "xz" \
	.
