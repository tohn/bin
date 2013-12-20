#!/bin/bash

function naechstes() {
	if cmus-remote -Q | grep status 2>&1 >/dev/null ; then
		cmus-remote -n
	fi

	if ps aux | grep mocp | grep -v grep 2>&1 >/dev/null ; then
		mocp -f
	fi

	#if ps aux | grep shell-fm | grep -v grep 2>&1 >/dev/null ; then
	#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	#fi
}

function pause() {
	if cmus-remote -Q | grep status 2>&1 >/dev/null ; then
		cmus-remote -u
	fi

	if ps aux | grep mocp | grep -v grep 2>&1 >/dev/null ; then
		mocp -G
	fi

	#if ps aux | grep shell-fm | grep -v grep 2>&1 >/dev/null ; then
	#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	#fi
}

function vorheriges() {
	if cmus-remote -Q | grep status 2>&1 >/dev/null ; then
		cmus-remote -r
	fi

	if ps aux | grep mocp | grep -v grep 2>&1 >/dev/null ; then
		mocp -r
	fi

	#if ps aux | grep shell-fm | grep -v grep 2>&1 >/dev/null ; then
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
