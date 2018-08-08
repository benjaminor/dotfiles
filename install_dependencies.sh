#! /bin/bash

# install all dependencies with ppas
# either all recommended or ask one by one
# only works with debian based systems

if ! [[ -f "/etc/debian_version" ]]; then
	echo "Sorry, only works for debian based systems."
	exit 1
fi

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

ppa_repos=()
ppa_libs=()
snap_libs=()
pip_libs=()
# emacs
ppa_repos+=("ppa:kelleyk/emacs")
ppa_libs+=("emacs26")

# keepass2
ppa_libs+=("keepass2")
echo "You still have to specify file for keepass2."

# fish shell
ppa_repos+=("ppa:fish-shell/release-2")
ppa_libs+=("fish")

# silversearcher-ag
ppa_libs+=("silversearcher-ag")

# firefox
snap_libs+=("firefox")

# sudo snap install --classic go
snap_libs+=("--classic go")


###########################################
#### packages from PyPi ###################

pip_libs+=("fuck")
pip_libs+=("black")
pip_libs+=("python-language-server[all]")
pip_libs+=("mypy")
pip_libs+=("bandit")
pip_libs+=("codecov")
pip_libs+=("autopep8")
pip_libs+=("pycodestyle")


for pack in "${ppa_repos[@]}"; do
    sudo add-apt-repository $pack
done

# install packages not in debian ppa_repos

#texlive
temp_files=$dotfiles/tmp
mkdir -p temp_files

# conda and anaconda
# TODO: verify hash 3e58f494ab9fbe12db4460dc152377b5
echo "Installing Anaconda 5.2. If you want to install a different version, please go to https://docs.anaconda.com/anaconda/install/linux."
curl -L https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -o $temp_files/Anaconda3-5.2.0-Linux-x86_64.sh
bash $temp_files/Anaconda3-5.2.0-Linux-x86_64.sh

# texlive
rm -r /usr/local/texlive/2018
rm -r ~/.texlive2018
mkdir -p $temp_files/texlive
wget 'http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz' -P $temp_files
tar -xzf $temp_files/install-tl-unx.tar.gz -C $temp_files/texlive --strip-components 1
# TODO: ask if user wants to install texlive
bash $temp_files/texlive/install-tl




rm -rf $temp_files

# vale
# wget 'https://github.com/errata-ai/vale/releases/download/v0.11.2/vale_0.11.2_Linux_64-bit.tar.gz'
