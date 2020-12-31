# basic commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias rr="rm -rf"

# some more ls aliases
alias lg='exa -aalmg@hH --git'
alias ll='exa -aalmg@hH'
alias lls='ll --sort=size'

alias emacs='emacs --no-splash'
alias vi='nvim'
alias vim='nvim'
alias today='date +"%A, %B %-d, %Y"'

alias upub='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y'
alias upzy='sudo zypper refresh && sudo zypper update -y'
alias upfi='fisher update'
alias upar='sudo pacman -Syu && sudo pacman -Scc'
alias upnix='nix-channel --update && nix-env -u && nix-collect-garbage -d && nix optimise-store'
alias upco='conda update --all -y && conda clean -a -y'
alias up='upfi && upnix'
alias uu='upub && up'
alias us='upzy && up'
alias ua='upar && up'

alias hs='$XDG_CONFIG_HOME/nixpkgs/switch.sh'
alias nu='$XDG_CONFIG_HOME/nixpkgs/niv-update.sh'

alias night='redshift -l 48.15:11.58 &'

alias psudo='sudo env PATH="$PATH"'
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

alias tree="tree -AC"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"

alias help="tldr"
alias jenkins="sudo docker run -u root --rm -d --name my_jenkins -p 8080:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean:latest"

alias cab='conda activate bx'

# alias for z open directory
alias zd="z -d"

alias psi="python setup.py install"

## arch
alias pac="sudo pacman"

## tmux
alias tat="tmux attach -t"
alias tn="tmux new"
alias tls="tmux ls"

alias za='zathura'
alias q='qpdfview --unique'
alias ports='netstat -tulanp' ## shortcut  for iptables and pass it via sudo#
alias ipt='sudo /sbin/iptables'

# display all rules #
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist

alias ah='autorandr -l home'
alias am='autorandr -l mobile'

alias xc='xclip -sel clip'
