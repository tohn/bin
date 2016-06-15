#!/bin/sh

#~/bin/dwm_status | while true ; do
while true ; do
	# Log stderror to a file 
	dwm 2>>"$XDG_CACHE_HOME"/dwm/dwm.log
	# No error logging
	#dwm >/dev/null 2>&1
done
