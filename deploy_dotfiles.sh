#! /bin/bash

cd "$(dirname "$0")"
export dotfiles=$(pwd)

# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=b:f
LONGOPTS=backup:,force

# -use ! and PIPESTATUS to get exit code with errexit set
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

f=n backup="$dotfiles"/bak
# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
	-b|--backup)
	    backup="$2"
	    shift 2
	    ;;
	-f|--force)
	    f=y
	    shift
	    ;;
	--)
	    shift
	    break
	    ;;
	# *)
	#       echo "Programming error"
	#       exit 3
	#       ;;
    esac
done

# handle non-option arguments
if [[ "$#" -ne 0 ]]; then
    echo "$0: There should be no input file."
    exit 4
fi

if [[ "$f" == "n" ]]; then
    mkdir -p "$backup"
fi

backup_and_symlink(){
    # argument 1: file to backup
    # argument 2: file to symlink to
    # TODO: $1 might be a directory
    if [[ "$f" == "n" && (-f "$1" || -d "$1") ]]; then
	/bin/mv "$1" "$backup"
    fi
    if [[ "$f" == "y" ]]; then
	rm -rf "$1"
    fi
    mkdir -p $(dirname "$1")
    ln -s "$2" "$1"
}

# TODO: add new firefox user.js
backup_and_symlink ~/.bash_profile "$dotfiles"/bash/.bash_profile
backup_and_symlink ~/.bashrc "$dotfiles"/bash/.bashrc
backup_and_symlink  ~/.bash_aliases "$dotfiles"/bash/.bash_aliases

# make symlink to .profile
backup_and_symlink ~/.profile "$dotfiles"/system/.profile

# make symlink to .config/shell in home directory
backup_and_symlink ~/.config/shell "$dotfiles"/bash/.config/shell
