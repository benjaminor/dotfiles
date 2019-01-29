# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
# NOT NECESSARY because .bash_profile already sources .bashrc
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
#	. "$HOME/.bashrc"
#     fi
# fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

EDITOR='emacsclient -t -a "emacs -nw"'
SUDO_EDITOR="$EDITOR"

# added by Anaconda3 installer
PATH="/home/ben/anaconda3/bin:$PATH"

#texlive
PATH="$PATH:/home/ben/texlive/2018/bin/x86_64-linux"

if [ -f "~/.profile_personal" ]; then
	source "~/.profile_personal"
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# add GOPATH to PATH
GOPATH="$HOME/go"
# PATH="$PATH:${GOPATH//://bin:}/bin"
PATH="$PATH:$GOPATH/bin"

PATH="/home/ben/anaconda3/bin:$PATH"

# set custom NVM dir
export NVM_DIR="$HOME/.nvm"
