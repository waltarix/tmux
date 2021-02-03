#!/bin/sh

if [ "x$(uname)" = "xOpenBSD" ]; then
	[ -z "$AUTOMAKE_VERSION" ] && export AUTOMAKE_VERSION=1.15
	[ -z "$AUTOCONF_VERSION" ] && export AUTOCONF_VERSION=2.69
fi

die()
{
    echo "$@" >&2
    exit 1
}

has_command()
{
	command -v "$1" > /dev/null
}

http_download()
{
	if has_command curl; then
		curl -sL "$@"
	elif has_command wget; then
		wget -q -O - "$@"
	else
		echo "curl or wget is not found" 1>&2
		return 1
	fi
}

http_download "https://github.com/waltarix/localedata/releases/download/13.0.0-r1/wcwidth9.h" > wcwidth9.h

mkdir -p etc
aclocal || die "aclocal failed"
automake --add-missing --force-missing --copy --foreign || die "automake failed"
autoreconf || die "autoreconf failed"
