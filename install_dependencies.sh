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
# snap_libs=()
pip_libs=()
# emacs
ppa_repos+=("ppa:kelleyk/emacs")
ppa_libs+=("emacs26")

# keepass2
ppa_libs+=("keepass2")

# fish shell
ppa_repos+=("ppa:fish-shell/release-2")
ppa_libs+=("fish")

# silversearcher-ag
ppa_libs+=("silversearcher-ag")

# firefox
ppa_libs+=("firefox")

# GNU global
ppa_libs+=("global")

# go
ppa_repos+=("ppa:gophers/archive")
ppa_libs+=("golang-1.10-go")


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

##############################################
### set up basic settings ####################

echo "$timezone" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

##############################################
### install necessary packages ###############

sudo apt-get update
sudo apt-get install -y software-properties-common
# sudo apt-get install -y snapd

for repo in "${ppa_repos[@]}"; do
    sudo add-apt-repository "$install_opt" "$repo"
done

for lib in "${ppa_libs[@]}"; do
    sudo apt-get install "$install_opt" "$lib"
done

# for lib in "${snap_libs[@]}"; do
#     sudo snap install "$lib"
# done

# install packages not in debian ppa_repos

#texlive
temp_files="$dotfiles"/tmp
mkdir -p temp_files

flag_python_installed=0

# conda and anaconda
install_anaconda(){
    echo "Installing Anaconda 5.2. If you want to install a different version, please go to https://docs.anaconda.com/anaconda/install/linux."
    curl -L https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -o "$temp_files"/Anaconda3-5.2.0-Linux-x86_64.sh

    if [[ $(sha256sum "$temp_files"/Anaconda3-5.2.0-Linux-x86_64.sh ) -eq "09f53738b0cd3bb96f5b1bac488e5528df9906be2480fe61df40e0e0d19e3d48  Anaconda3-5.2.0-Linux-x86_64.sh" ]]; then
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
    rm -r /usr/local/texlive/2018
    rm -r ~/.texlive2018
    mkdir -p "$temp_files"/texlive
    wget 'http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz' -P "$temp_file"s
    tar -xzf "$temp_files"/install-tl-unx.tar.gz -C "$temp_files"/texlive --strip-components 1
    bash "$temp_files"/texlive/install-tl
}

if [[ "$i" -eq "y" ]]; then
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


rm -rf "$temp_files"

echo "You should install ripgrep, too. At this moment, it is not yet available in an Ubuntu repo."
