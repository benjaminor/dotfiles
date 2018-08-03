#! /bin/bash
# TODO: use click as python script
# install all dependencies with ppas
# either all recommended or ask one by one
# only works with debian based systems

if ! [[ -f "/etc/debian_version" ]]; then
	echo "Sorry, only works for debian based systems."
	exit 1
fi

ppa_repos=()
ppa_libs=()
snap_libs=()
# TODO: remove installer scripts
installer_scripts=()

# emacs
repos+=("ppa:kelleyk/emacs")
ppa_libs+=("emacs26")

# keepass2
ppa_libs+=("keepass2")
echo "You still have to specify file for keepass2."

# fish shell
repos+=("ppa:fish-shell/release-2")
ppa_libs+=("fish")

# silversearcher-ag
ppa_libs+=("silversearcher-ag")

# firefox
snap_libs+=("firefox")

# sudo snap install --classic go
snap_libs+=("--classic go")

#texlive
installer_scripts+=('http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz')


# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
	echo "I’m sorry, `getopt --test` failed in this environment."
	exit 1
fi

OPTIONS=i
LONGOPTS=inquire

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

i=n
# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in
		-i|--inquire)
			i=y
			shift
			;;
		--)
			shift
			break
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

install_opt="-y"
if [[ "$i" == "y" ]]; then
	install_opt=""
fi

# TODO: add repos, install packages

# install packages not in debian ppa_repos

#texlive
rm -r /usr/local/texlive/2018
rm -r ~/.texlive2018
temp_files=$dotfiles/tmp
mkdir -p temp_files


# texlive
wget 'http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz' -P $temp_files -o texlive-installer.tar.gz
tar -xzf $temp_files/texlive-installer.tar.gz

# vale
wget 'https://github.com/errata-ai/vale/releases/download/v0.11.2/vale_0.11.2_Linux_64-bit.tar.gz'
