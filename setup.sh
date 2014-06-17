#!/usr/bin/env
LSB_RELEASE="/usr/bin/lsb_release"

# Check if we can use colours in our output
use_colour=0
[ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null && use_colour=1

# Some useful functions
progress() {
	[ $use_colour -eq 1 ] && echo -ne "\033[01;32m"
	echo "$@" >&2
	[ $use_colour -eq 1 ] && echo -ne "\033[00m"
}

info() {
	[ $use_colour -eq 1 ] && echo -ne "\033[01;34m"
	echo "$@" >&2
	[ $use_colour -eq 1 ] && echo -ne "\033[00m"
}

die () {
	[ $use_colour -eq 1 ] && echo -ne "\033[01;31m"
	echo "$@" >&2
	[ $use_colour -eq 1 ] && echo -ne "\033[00m"
	exit 1
}

install_package() {
	package=$1
	info "install ${package}"
	apt-get -qq -y install $package 2>&1 > /dev/null
	return $?
}

[ "x$(id -un)" == "xroot" ] || die "Sorry, this script must be run as root."

[ -x $LSB_RELEASE ] || install_package "lsb-release"
[ -x "$(which wget)" ] || install_package "wget"
[ -x "$(which dialog)" ] || install_package "dialog" 

# check architecture
test "`dpkg --print-architecture`" == "armhf" || die "This Repos is only for armhf."

DIST_ID="$($LSB_RELEASE -is)"
CODENAME="$($LSB_RELEASE -cs)"
DIST=""

# Check the distribution is in the supported list
case "$DIST_ID:$CODENAME" in
Debian:wheezy)	DIST="debian";;
Ubuntu:trusty)	DIST="ubuntu";;
#Debian:jessie)	DIST="debian";;
*)		die "Sorry, this script does not support your distribution/release ($DIST_ID $CODENAME)." ;;
esac

progress "download latest repository package"
TMP=`mktemp`
DEBPKG="$(wget -nv -O $TMP http://www.lxccu.com/latest-repo.php)" || die "Download failed."
progress "install latest repository package"
dpkg -i $TMP || die "repo installation failed!"

progress "updated sources"
apt-get -q=2 update

trap '' 2 #disable ctrl+c
dialog --title "Achtung!" \
--backtitle "LXCCU Installer" \
--yesno "Derzeit gibt es noch einen Bug mit fixen IPs!!\nSolltest du eine fixe IP eingestellt haben,\nmusst du derzeit die Bridge selbst konfigurieren!\n\nhttp://homematic-forum.de/forum/viewtopic.php?f=26&t=18359&p=151485#p151482\n\nBenutzt du statische/fixe ip? (y/n)" 14 60
response=$?
trap 2 #enable ctrl+c

case $response in
   0) die "bitte passe deine netzwerkkonfiguration händisch an!" ;;
   1) clear; info "okey lets do it!" ;;
   255) die "bitte passe deine netzwerkkonfiguration händisch an!" ;;
esac

export DEBIAN_FRONTEND=noninteractive
progress "install lxccu"
apt-get install -y lxccu
exit 0
