#!/bin/sh
cache=$HOME/repos/bin/proglist
(
	IFS=:
	sort -u "$cache" | dmenu "$@"
) | ${SHELL:-"/bin/sh"} &
