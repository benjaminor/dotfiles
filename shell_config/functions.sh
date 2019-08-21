#!/usr/bin/env bash

# functions for bash use

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

function move-and-symlink() {
	while [ $# -gt 1 ]; do
		eval "target=\${$#}"
		original="$1"
		if [ -d "$target" ]; then
			target="$target/${original##*/}"
		fi
		mv -- "$original" "$target"
		case "$original" in
		*/*)
			case "$target" in
			/*) : ;;
			*) target="$(cd -- "$(dirname -- "$target")" && pwd)/${target##*/}" ;;
			esac
			;;
		esac
		ln -s -- "$target" "$original"
		shift
	done
}

function lnabs() {
	#http://stackoverflow.com/questions/4187210/convert-relative-symbolic-links-to-absolute-symbolic-links
	ln -sf "$(readlink -f "$1")" "$*"
}

# alias for cheat.sh/
function cht() {
	curl -s cheat.sh/"$1"
}
