# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

source ~/.zplug/init.zsh

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Customize to your needs...
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zplug "plugins/git", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh

zplug "modules/python", from:prezto

zplug "bhilburn/powerlevel9k", from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
	if read -q; then
		echo
		zplug install
	fi
fi

zplug load --verbose

# source commonrc file
if [ -f ~/.commonrc ]; then
	source ~/.commonrc
fi

if [ -n "${commands[fzf-share]}" ]; then
	source "$(fzf-share)/key-bindings.zsh"
fi

# added by travis gem
[ -f /home/ben/.travis/travis.sh ] && source /home/ben/.travis/travis.sh
