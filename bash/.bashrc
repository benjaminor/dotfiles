# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac



# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# unlimited history
HISTSIZE=
HISTFILESIZE=

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	else
		color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	xterm*|rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias sudo='sudo '

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# get shell config (aliases, function)
shell_config="$HOME/.config/shell"

if [[ ! -x "$shell_config" ]]; then
	mkdir -p "$shell_config"
fi


# source custom functions

if [ -f $shell_config/functions.sh ]; then
	source $shell_config/functions.sh
fi

# source temporary command completion in folders
if [ -f $shell_config/run.sh ]; then
	source $shell_config/run.sh
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $shell_config/aliases.sh ]; then
	source $shell_config/aliases.sh
fi

# source personal aliases (not in repo)
if [ -f ~/.bash_aliases_personal ]; then
	source ~/.bash_aliases_personal
fi

# autojump activation
if [ -f /usr/share/autojump/autojump.sh ]; then
	source /usr/share/autojump/autojump.sh
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# enable powerline in bash
# powerline-shell has to be installed (with pip)
function _update_ps1() {
	PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
	PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi


# cd options
shopt -s autocd cdspell dirspell

# glob options
shopt -s dotglob extglob globstar nocaseglob

# job options
shopt -s checkjobs huponexit

# shell options
shopt -s checkhash checkwinsize

# history
shopt -s cmdhist histappend histverify

# set_prompt () {
#     local last_command=$?
#     PS1=''

#     # save after every command
#     history -a

#     # color escape codes
#     local color_off='\[\e[0m\]'
#     local color_red='\[\e[0;31m\]'
#     local color_green='\[\e[0;32m\]'
#     local color_yellow='\[\e[0;33m\]'
#     local color_blue='\[\e[0;34m\]'
#     local color_purple='\[\e[0;35m\]'
#     local color_cyan='\[\e[0;36m\]'

#     # hostname
#     PS1+=$color_blue
#     PS1+="@\h "
#     PS1+=$color_off

#     # add purple exit code if non-zero
#     if [[ $last_command != 0 ]]; then
#   PS1+=$color_purple
#   PS1+='$? '
#   PS1+=$color_off
#     fi

#     # shortened working directory
#     PS1+='\w '

#     # add Git status with color hints
#     PS1+="$(__git_ps1 '%s ')"

#     # red for root, off for user
#     if [[ $EUID == 0 ]]; then
#   PS1+=$color_red
#     else
#   PS1+=$color_off
#     fi

#     # end of prompt
#     PS1+='|-'
#     PS1+=$color_red
#     PS1+='/ '
#     PS1+=$color_off
# }
# PROMPT_COMMAND='set_prompt'

# enable ls colors
if ls --color=auto &> /dev/null; then
	alias ls='ls --color=auto'
else
	export CLICOLOR=1
fi


# colored man pages
man() {
	env LESS_TERMCAP_mb=$'\E[01;31m' \
		LESS_TERMCAP_md=$'\E[01;38;5;74m' \
		LESS_TERMCAP_me=$'\E[0m' \
		LESS_TERMCAP_se=$'\E[0m' \
		LESS_TERMCAP_so=$'\E[38;5;246m' \
		LESS_TERMCAP_ue=$'\E[0m' \
		LESS_TERMCAP_us=$'\E[04;38;5;146m' \
		man "$@"
}


# uses 'thefuck' to fix common command mistakes
# https://github.com/nvbn/thefuck
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'

if [ -f ~/anaconda3/etc/profile.d/conda.sh ]; then
	source ~/anaconda3/etc/profile.d/conda.sh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# added by Anaconda3 5.3.0 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/ben/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
	\eval "$__conda_setup"
else
	if [ -f "/home/ben/anaconda3/etc/profile.d/conda.sh" ]; then
		. "/home/ben/anaconda3/etc/profile.d/conda.sh"
		CONDA_CHANGEPS1=false conda activate base
	else
		\export PATH="/home/ben/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda init <<<

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

__fzf_history__() {
	local line
	countskip="$(history | tail -n 1 | grep -E '^ *[0-9]+' -o | wc -c)"
	countskip="$(( countskip + 1 ))"
	line=$(
		HISTTIMEFORMAT= history |
			grep '^.\{1,130\}$' --text |
			sed 's/ *$//g' |
			{ i=$(cat); head --lines=-50 <<<"$i" ; cat ~/shared_history | while read line; do echo " 0000  $line"; done; tail -n 50 <<< "$i"; } |
			tac |
			nauniq --skip-chars="$countskip" |
			tac |
			$(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r |
			\grep '^ *[0-9]') && sed 's/ *\([0-9]*\)\** \(.*\)/\2/' <<< "$line"
}
