#! /bin/bash

export dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

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
timezone="Europe/Berlin"
# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in
		-i|--inquire)
			i=y
			shift
			;;
		-t|--timezone)
			timezone="$2"
			shift 2
			;;
		-h|--help)
			echo "Install packages and libraries I usually need on a new debian-based system."
			echo "Options -h|--help to show this message"
			echo "-i|--inquire to ask for each option"
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

# temp files
temp_files="$dotfiles"/tmp
mkdir -p "$temp_files"

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
pip_libs=()


# keepass2
ppa_libs+=("keepass2")

# silversearcher-ag
ppa_libs+=("silversearcher-ag")

ppa_libs+=("firefox")

ppa_libs+=("curl")
# GNU global
ppa_libs+=("global")


# classic stuff
ppa_libs+=("build-essential")
ppa_libs+=("make")
ppa_libs+=("git")
ppa_libs+=("default-jdk")
ppa_libs+=("openjdk-8-jdk")


# vlc media player
ppa_libs+=("vlc")

# autojump for easier changing directories
ppa_libs+=("autojump")

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
pip_libs+=("powerline-shell")
pip_libs+=("flake8")
pip_libs+=("uncompyle6")
pip_libs+=("tox")

##############################################
### set up basic settings ####################

echo "$timezone" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

##############################################
### install necessary packages ###############

sudo apt-get update
sudo apt-get install -y software-properties-common


for repo in "${ppa_repos[@]}"; do
	sudo add-apt-repository "$install_opt" "$repo"
done

for lib in "${ppa_libs[@]}"; do
	sudo apt-get install "$install_opt" "$lib"
done

# stuff for building emacs26
sudo apt build-dep emacs25

cd "$temp_files"

git clone --depth 1 --branch master https://github.com/emacs-mirror/emacs.git

cd emacs && ./autogen.sh && ./configure --prefix=/home/"$USER"/.local
make && make install && make clean
# install packages not in debian ppa_repos

#texlive

flag_python_installed=0

# conda and anaconda
install_anaconda(){
	echo "Installing Anaconda 5.2. If you want to install a different version, please go to https://docs.anaconda.com/anaconda/install/linux."
	curl -L https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -o "$temp_files"/Anaconda3-5.2.0-Linux-x86_64.sh

	if [[ $(sha256sum "$temp_files"/Anaconda3-5.2.0-Linux-x86_64.sh ) = "09f53738b0cd3bb96f5b1bac488e5528df9906be2480fe61df40e0e0d19e3d48  Anaconda3-5.2.0-Linux-x86_64.sh" ]]; then
		bash "$temp_files"/Anaconda3-5.2.0-Linux-x86_64.sh
		flag_python_installed=1
	else
		echo "sha265 checksum of downloaded file not correct"
	fi

}

install_python(){
	echo "Installing python3..."
	sudo apt-get install "$install_opt" python3 python3-pip python3-dev
	flag_python_installed=1
}

install_pip_libs(){
	for lib in "${pip_libs[@]}"; do
		python -m pip install "$lib"
	done
}

# texlive
install_texlive(){
	sudo rm -r /usr/local/texlive/2018
	sudo rm -r ~/.texlive2018
	mkdir -p "$temp_files"/texlive
	wget 'http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz' -P "$temp_files"
	tar -xzf "$temp_files"/install-tl-unx.tar.gz -C "$temp_files"/texlive --strip-components 1
	cd "$temp_files"/texlive/ && ./install-tl
}

if [[ "$i" = "y" ]]; then
	echo "Do you wish to install Anaconda 5.2?"
	select yn in "Yes" "No"; do
		case "$yn" in
			Yes ) install_anaconda; break;;
			No ) break;;
		esac
	done


	if [[ "$flag_python_installed" -eq 0 ]]; then
		echo "Do you wish to install Python from the official Ubuntu repositories?"
		select yn in "Yes" "No"; do
			case "$yn" in
				Yes ) install_python; break;;
				No ) break;;
			esac
		done
	fi



	if [[ "$flag_python_installed" -eq 1 ]];then
		echo "Do you wish to install the preselected list of python libraries from PyPi"
		select yn in "Yes" "No"; do
			case "$yn" in
				Yes ) install_pip_libs; break;;
				No ) break;;
			esac
		done
	fi


	echo "Do you wish to install Texlive?"
	select yn in "Yes" "No"; do
		case "$yn" in
			Yes ) install_texlive; break;;
			No ) break;;
		esac
	done
else
	install_anaconda
	if [[ "$flag_python_installed" -eq 1 ]]; then
		install_pip_libs
	fi
	install_texlive
fi

# install linuxbrew
echo "----------------------------------"
echo "----------------------------------"
echo "You should install linuxbrew, too!"
echo "----------------------------------"
echo "----------------------------------"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# not using .bash_profile because .profile is enough
# test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile

# install bat (better than cat)
brew install bat

# with brew, install fzf
brew install fzf
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install

# install ripgrep
brew install ripgrep

# install node.js
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

# better man
npm install -g tldr


rm -rf "$temp_files"
