#!/bin/bash

{
	perm_mask='0027'
	maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
	valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
	awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (while read -r user home; do
		mode=$( stat -L -c '%#a' "$home" )
		if [ $(( $mode & $perm_mask )) -gt 0 ]; then
			printf "Modifying User $user home directory: \"$home\"\n\tremoving excessive permissions from current mode of \"$mode\"\n"
			chmod g-w,o-rwx "$home"
		fi
	done
	)
}

