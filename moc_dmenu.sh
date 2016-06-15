#!/bin/bash

if [[ "$#" -gt 0 ]] ; then
	ACTION="load"
else
	ACTION=$(printf "playlist\nstart\nexit\nopen\nload\nshuffle\nrepeat\n" | dmenu -i "$@")
fi
root="$HOME/music/pls"

if [ "$ACTION" == 'playlist' ]; then
	mocp -p
fi

if [ "$ACTION" == 'start' ]; then
	mocp -S
	$0
fi

if [ "$ACTION" == 'exit' ]; then
	mocp -x
fi

if [ "$ACTION" == 'open' ]; then 
	urxvt -e mocp
fi

if [ "$ACTION" == 'load' ]; then
	mocp -c && play=$(ls "$root" | sed 's/\.m3u//' | dmenu -i "$@")
	if [[ -n "$play" ]] ; then
		mocp -a "$root/${play}.m3u"
		mocp -p
	fi
fi

if [ "$ACTION" == 'shuffle' ]; then
	mocp -t shuffle
fi

if [ "$ACTION" == 'repeat' ]; then
	mocp -t repeat	
fi
