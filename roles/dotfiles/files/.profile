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

# from opensuse
test -z "$PROFILEREAD" && . /etc/profile  || true

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

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH

# fix for https://github.com/NixOS/nix/issues/599
# and for issue https://github.com/NixOS/nixpkgs/issues/38991
# man from nix has a locale problem
export LOCALE_ARCHIVE_2_11="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
export LOCALE_ARCHIVE_2_27="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
export LOCALE_ARCHIVE=/usr/bin/locale


# set custom NVM dir
export NVM_DIR="$HOME/.nvm"

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$PATH:$HOME/.local/bin"

export TERM="rxvt"
