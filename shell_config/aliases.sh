# basic commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias rr="rm -rf"

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias emacs='emacs --no-splash'
alias today='date +"%A, %B %-d, %Y"'

alias upub='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y && sudo snap refresh'
alias upfi='fisher self-update && fisher'
alias upnix='nix-channel --update && nix-env -u && nix-collect-garbage'
alias upco='conda update --all -y && conda clean -a -y'
alias uu='upub && upfi && upnix'

alias night='redshift -l 48.15:11.58 &'

alias psudo='sudo env PATH="$PATH"'
alias savilerow='/home/data/savilerow-1.6.5-linux/savilerow'
alias vale='/usr/local/bin/vale'
alias semacs='emacsclient -n -a emacs'

# Emacs as editor
alias e='emacsclient --alternate-editor="" --no-wait'
# and open a new frame
alias ec='e --create-frame'
# in the terminal
alias et='emacsclient --alternate-editor="" --tty'

# system dependent
if [[ $OSTYPE == darwin* ]]; then
	# power
	alias shutdown='sudo shutdown -hP now'
	alias reboot='sudo reboot now'
	alias sleep='shutdown -s now'

	# misc
	alias unlock_files='chflags -R nouchg *'
elif [[ $OSTYPE == linux-gnu ]]; then
	# power
	alias shutdown='sudo shutdown -p now'
	alias reboot='sudo shutdown -r now'
	alias halt='sudo halt -p'
fi

alias sudo='sudo ' # enable alias expansion for sudo

alias ..="cd .."
alias ...="cd ../.."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias tree="tree -A"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"

alias help="tldr"
alias jenkins="sudo docker run -u root --rm -d --name my_jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean:latest"

# alias for z open directory
alias zd="z -d"

alias psi="python setup.py install"

alias python3="python3.7"
alias python="python3.7"
alias pip="pip3"

## arch
alias pac="sudo pacman"

## tmux
alias tat="tmux attach -t"
