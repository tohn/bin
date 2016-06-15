#!/bin/bash

function naechstes() {
	if ps aux | grep -e mpd -e mopidy | grep -v grep >/dev/null 2>&1 ; then
		mpc next
		return
	fi

	if cmus-remote -Q | grep status >/dev/null 2>&1 ; then
		cmus-remote -n
		return
	fi

	if psgrep mocp | grep -v grep >/dev/null 2>&1 ; then
		mocp -f
		return
	fi

	#if ps aux | grep shell-fm | grep -v grep >/dev/null 2>&1 ; then
	#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	#fi
}

function pause() {
	if ps aux | grep -e mpd -e mopidy | grep -v grep >/dev/null 2>&1 ; then
		mpc toggle
		return
	fi

	if cmus-remote -Q | grep status >/dev/null 2>&1 ; then
		cmus-remote -u
		return
	fi

	if psgrep mocp | grep -v grep >/dev/null 2>&1 ; then
		mocp -G
		return
	fi

	#if ps aux | grep shell-fm | grep -v grep >/dev/null 2>&1 ; then
	#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	#fi
}

function vorheriges() {
	if ps aux | grep -e mpd -e mopidy | grep -v grep >/dev/null 2>&1 ; then
		mpc prev
		return
	fi

	if cmus-remote -Q | grep status >/dev/null 2>&1 ; then
		cmus-remote -r
		return
	fi

	if psgrep mocp | grep -v grep >/dev/null 2>&1 ; then
		mocp -r
		return
	fi

	#if ps aux | grep shell-fm | grep -v grep >/dev/null 2>&1 ; then
	#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	#fi
}

function usage() {
	echo "Usage: $0 [h|n|p|v]"
	echo "  h: hilfe"
	echo "  n: naechstes lied"
	echo "  p: pause (toggle)"
	echo "  v: vorheriges lied"
}

if [[ $# == 0 ]] ; then
	usage
	exit 1
fi

while getopts "hnpv" options; do
	case $options in
		n) naechstes ;;
		p) pause ;;
		v) vorheriges ;;
		*) usage ; exit 1 ;;
	esac
done
