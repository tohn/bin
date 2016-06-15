#!/bin/bash

bat=""
cmus=""
shellfm=""
weather=""
precast=""
mb="1048576"

#soundcard=0
soundcard=$(cat /tmp/soundcard.tmp)

function annoying_music() {
	notify-send "annoying song detected ... changing music"
	mocp -c && mocp -a "$HOME"/music/pls/JamClassical.m3u && mocp -p
#	amixer set Master off >/dev/null
	sleep "$1"
#	amixer set Master on >/dev/null
	mocp -c && mocp -a "$HOME"/music/pls/JamJazz.m3u && mocp -p
}

if acpi -a 2>/dev/null | grep off-line >/dev/null 2>&1 ; then
		bat="$(acpi -b | awk '{print $4 " " $5}' | tr -d ',') | "
fi

upt="$(uptime | sed 's/.*://; s/,//g; s/\ //') | "
vol_master=$(amixer -c "$soundcard" get Master | tail -1 | awk '{print $4}' | tr -d '[]')
vol_master_mute=$(amixer -c "$soundcard" get Master | tail -1 | awk '{print $6}' | tr -d '[]')
vol_pcm=$(amixer -c "$soundcard" get PCM | tail -1 | awk '{print $5}' | tr -d '[]')
vol="$vol_master ($vol_master_mute), $vol_pcm | "
datum="$(date)"
#db_status=$(dropbox status)

#if [[ $db_status != "Dropbox isn't running!" ]] ; then
#		db="$db_status | "
#fi

if ps aux | grep -e mpd -e mopidy 2>/dev/null | grep -v grep >/dev/null 2>&1 ; then
	mpc="$(mpc current) - $(mpc | \
	sed -n '2p' | sed 's/\ \#[[:digit:]]*\/[[:digit:]]*\ */\ /') | "
fi

# is cmus running?
cmus-remote 2>/dev/null
if [[ "$?" != 1 && "$?" != 127 ]] ; then
		if cmus-remote -Q | grep status >/dev/null 2>&1 ; then
				interpret=$(cmus-remote -Q | grep tag\ artist | sed 's/tag\ artist\ //')
				album=$(cmus-remote -Q | grep tag\ album\  | sed 's/tag\ album\ //')
				title=$(cmus-remote -Q | grep tag\ title | sed 's/tag\ title\ //')
				duration=$(cmus-remote -Q | grep duration | sed 's/duration\ //')
				position=$(cmus-remote -Q | grep position | sed 's/position\ //')
				state=$(cmus-remote -Q | grep status | sed 's/status\ //')
				if [[ "$state" == "playing" ]] ; then
						status="1"
				else
						status="0"
				fi
				#cmus="$interpret: $title ($album) - $position/$duration - $status | "
				cmus="$interpret: $title - $position/$duration - $status | "
		fi
fi

# is mocp running?
if psgrep mocp | grep -v grep >/dev/null 2>&1 ; then
	interpret=$(mocp -i | grep Artist | sed 's/Artist\:\ //')
	album=$(mocp -i | grep Album | sed 's/Album\:\ //')
	title=$(mocp -i | grep SongTitle | sed 's/SongTitle\:\ //')
	duration=$(mocp -i | grep TotalTime | sed 's/TotalTime\:\ //')
	position=$(mocp -i | grep TimeLeft | sed 's/TimeLeft\:\ //')
	state=$(mocp -i | grep State | awk '{print $2}')
	if [[ $state == "PLAY" ]] ; then
			status="1"
	else
			status="0"
	fi
	mocp="$interpret: $title - $position/$duration - $status | "

	# silence annoying jamendo tracks
	if [[ "$title" == "Funktastic - Bis Hierher" ]] ; then
		annoying_music 375
	elif [[ "$title" == "Funktastic - Soundtrack" ]] ; then
		annoying_music 320
	fi
fi

if psgrep shell-fm | grep -v grep >/dev/null 2>&1 ; then
#	shellfm="$(echo info '%a: %t (%l) - %R' | nc localhost 54311) | "
	shellfm="$(cat /home/benjo/.shell-fm/nowplaying) | "
fi

function netz {
	if [[ -e "$1" ]] ; then
		cat "$1"
	fi
}

#weather="$(head -1 $HOME/repos/bin/wetter_aktuell | sed 's/°//') | "
#precast="$(tail -1 $HOME/repos/bin/wetter_aktuell | sed 's/min\.\ \(.*\)\ °C\,\ max\.\ \(.*\)\ °C/\1-\2\ C/') | "

#mem="$(awk '/^-/ {print $3}' <(free -m))/$(free -m | sed '/Mem:/!d' | awk '{print $2}')MB | "
#mem="$(awk '/^-/ {print $3}' <(free -m)) | "

#hdd="$(df -P | sort -d | awk '/^\/dev\//{s=s (s?" ":"") $5} END {printf "%s", s}') | "

net=""
for i in $(ls /sys/class/net | grep -v lo) ; do
rx=$(netz "/sys/class/net/$i/statistics/rx_bytes")
tx=$(netz "/sys/class/net/$i/statistics/tx_bytes")
rxm=$((rx/mb))
txm=$((tx/mb))
if [[ "$rxm" != 0 || "$txm" != 0 ]] ; then
	net="$net$((rx/mb)). $((tx/mb))* | "
fi
done

sensors=$(sensors | grep -e high -e fan1 2>/dev/null | cut -d: -f2 | \
		awk '{print $1}' | tr '\n' ' ' | sed 's/\ $/\ \|\ /;s/[+°C]//g')
if [[ $(hostname) != "WST-40-020" ]] ; then
	nvidia="$(nvidia-settings -q gpucoretemp -t | tr '\n' ' ')| "
fi

#echo "$db$bat$mocp$cmus$shellfm$vol$weather$precast$mem$hdd$net$wnet$upt$datum"
#echo "$bat$mpc$mocp$cmus$sensors$nvidia$vol$weather$precast$net$upt$datum"
echo "$bat$mpc$mocp$cmus$sensors$nvidia$vol$net$upt$datum"
