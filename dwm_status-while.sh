#!/bin/bash

while true ; do
	xsetroot -name "$($HOME/repos/bin/dwm_status.sh)"
	sleep 1s
done &
