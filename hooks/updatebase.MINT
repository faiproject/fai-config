#! /bin/bash

# prepare Linuxmint package installation

target=/target
ctam

# remove packages from the Ubuntu base file, adjust sources.list
$ROOTCMD apt -y purge ubuntu-pro-client ubuntu-pro-client-l10n ubuntu-minimal
ainsl -v /etc/apt/sources.list "deb $mintmirror $mintdist main upstream import backport"

cat <<EOM > $target/etc/apt/preferences.d/official-package-repositories.pref
Package: *
Pin: release o=linuxmint,c=upstream
Pin-Priority: 700
EOM

cat <<EOM > $target/etc/apt/preferences.d/official-extra-repositories.pref
Package: *
Pin: origin "build.linuxmint.com"
Pin-Priority: 700
EOM

$ROOTCMD apt -y update
$ROOTCMD apt -y --reinstall install base-files
ctau
