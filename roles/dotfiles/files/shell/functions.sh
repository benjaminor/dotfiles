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

# search jobs fast
function aux() {
	ps aux | grep -i "$1"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
function fkill() {
	local pid
	if [ "$UID" != "0" ]; then
		pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
	else
		pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
	fi

	if [ "x$pid" != "x" ]; then
		echo $pid | xargs kill -${1:-9}
	fi
}

##### git #####
# fshow - git commit browser
function fshow() {
	git log --graph --color=always \
		--format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
		fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
			--bind "ctrl-m:execute:
				(grep -o '[a-f0-9]\{7\}' | head -1 |
				xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
				{}
FZF-EOF"
}

#### tmux ####
# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

function tm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	if [ $1 ]; then
		tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1")
		return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux $change -t "$session" || echo "No sessions found."
}

function zz() {
	cd "$(z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
}

#### Docker ####
# Select a docker container to start and attach to
function da() {
	local cid
	cid=$(sudo docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

	[ -n "$cid" ] && sudo docker start "$cid" && sudo docker attach "$cid"
}

#### Man pages ####
function fman() {
	man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}

function dv() {
	sudo docker top "$1" | rg "0\s+\./vuln" | awk '{print $2}'
}

function gdba() {
	sudo gdb -ex "br $2" -p $(dv "$1")
}

function rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}
