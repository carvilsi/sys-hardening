#!/bin/bash

{
	output=""
	perm_mask='0027'
	maxperm="$( printf '%o' $(( 0777 & ~$perm_mask)) )"
	valid_shells="^($( sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' - ))$"
	awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (while read -r user home; do
		if [ -d "$home" ]; then
			mode=$( stat -L -c '%#a' "$home" )
			[ $(( $mode & $perm_mask )) -gt 0 ] && output="$output\n User $userhome directory: \"$home\" is too permissive\"$mode\" (should be:\"$maxperm\" or more restrictive)"
		fi
	done
	if [ -n "$output" ]; then
		printf "\n Failed:$output"
		printf "\n Going to fix the permissions\n"
		sh change_home_directories_permissions.sh
	else
		printf "\n Passed:\n All user home directories are mode:\"$maxperm\" or more restrictive\n"
	fi
	)
}

