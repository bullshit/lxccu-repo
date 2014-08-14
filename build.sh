#!/bin/bash
PACKAGENAME="lxccu-repo"
MAINTAINER="Oskar Holowaty <me@oskarholowaty.com>"
VENDOR="LXCU Team <team@lxccu.com>"
VERSION="1.4"
URL="http://www.lxccu.com"
LICENSE="GPLv3"
DESCRIPTION="Install lxccu repository"

firstline="${PACKAGENAME} (${VERSION}) stable; urgency=low"
sed -i "1s/.*/$firstline/" ./debian/changelog

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

# cd "${ROOT}/src-testing"
# PACKAGENAME_TESTING="lxccu-testingrepo"
# DESCRIPTION_TESTING="Install the testing branch of lxccu repository"
# #VERSION="1.3-2"
# fpm -f -s dir -t deb -a all \
# 	-n "$PACKAGENAME_TESTING" \
# 	-m "$MAINTAINER" \
# 	--vendor "$VENDOR" \
# 	-d "$PACKAGENAME" \
# 	--category "misc" \
# 	--license "$LICENSE" \
# 	--url $URL \
# 	--description "$DESCRIPTION_TESTING" \
# 	-v "$VERSION" \
# 	-p "${ROOT}/${PACKAGENAME_TESTING}_${VERSION}_all.deb" \
# 	--config-files "/etc/apt/" \
# 	--deb-changelog "${ROOT}/debian/changelog" \
# 	--deb-compression "xz" \
# 	.