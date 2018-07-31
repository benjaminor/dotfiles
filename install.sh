#! /bin/bash
cd "$(dirname "$0")"

#!/bin/bash
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

f=n backup=$(pwd)/bak
# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in
		-b|--backup)
			backup="$2"
			shift
			;;
		-f|--force)
			f=y
			shift
			;;
		# *)
		#	echo "Programming error"
		#	exit 3
		#	;;
	esac
done

# handle non-option arguments
if [[ $# -ne 0 ]]; then
	echo "$0: There should be no input file."
	exit 4
fi


# make symlinks to sh files in bash
# TODO: make loop
# TODO: put files before in backup folder
# TODO: ask for backup to be deleted
if [[ "$f" == "y" ]]; then
	mkdir $backup
else
	backup = /dev/null
fi

backup_and_symlink(){
	# argument 1: file to backup
	# argument 2: file to symlink to
	/bin/mv $1 $backup_folder
	ln -s $2 $1
}

backup_and_symlink test.txt $(pwd)/link.txt

# ln -s $(pwd)/bash/.bash_profile ~/.bash_profile
# ln -s $(pwd)/bash/.bashrc ~/.bashrc
# ln -s $(pwd)/bash/.bash_aliases ~/.bash_aliases

# # make symlink to .profile
# ln -s $(pwd)/system/.profile ~/.profile

# # make symlink to .config/shell in home directory
# ln -s $(pwd)/bash/.config/shell ~/.config/shell
