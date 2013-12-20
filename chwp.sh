#!/bin/bash

# Change Wallpaper

export DISPLAY=:0.0

#dual=$(xrandr | grep -i vga | awk '{print $2}')
dual=$(xrandr | grep -i dp2 | awk '{print $2}')
res=$(xrandr | grep -i lvds | awk '{print $3}' | sed 's/+\(.*\)//')
cur=$(xrandr | sed '1q' | awk '{print $8,$9,$10}' | sed 's/\ //g;s/,//')
root="$HOME/pics/wallpaper"

function getrand() {
	lines=$(ls $src | wc -l)
	rand=$(shuf -i 1-$lines -n 1)
	pic=$(ls $src | sed -n "${rand}p")
}

if [[ $dual == "disconnected" ]] ; then
	src="$root/$res"
	getrand
	feh --bg-scale $src/$pic
else
	src="$root/$cur"
	getrand
	feh --bg-tile $src/$pic
fi
