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

#texlive
PATH="$PATH:/home/ben/texlive/2019/bin/x86_64-linux"

if [ -f "$HOME/.profile_personal" ]; then
	source "$HOME/.profile_personal"
fi

if [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
	source $HOME/.nix-profile/etc/profile.d/nix.sh
fi


# add GOPATH to PATH
GOPATH="$HOME/go"
PATH="$PATH:$GOPATH/bin"

# set custom NVM dir
export NVM_DIR="$HOME/.nvm"

export PATH="$HOME/.cargo/bin:$PATH"

export DOTNET_CLI_TELEMETRY_OPTOUT=1

export PATH="$PATH:$HOME/.local/bin"

export TERM="rxvt"
