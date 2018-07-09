# basic commands
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias rr="rm -rf"

alias emacs='emacs --no-splash'
alias today='date +"%A, %B %-d, %Y"'

alias uu='sudo apt update && sudo apt upgrade -y  && sudo apt autoremove -y && sudo apt autoclean -y && conda clean -a -y'
alias night='redshift -l 48.15:11.58 &'

###alias sember='emacs ~/Documents/Latex/Semesterberichte/SemesterberichtSS2016/semesterbericht.tex &'
alias et='exit'
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
if [[ $OSTYPE == darwin* ]]
then
    # power
    alias shutdown='sudo shutdown -hP now'
    alias reboot='sudo reboot now'
    alias sleep='shutdown -s now'

    # misc
    alias unlock_files='chflags -R nouchg *'
elif [[ $OSTYPE == linux-gnu ]]
then
    # power
    alias shutdown='sudo shutdown -P now'
    alias reboot='sudo shutdown -r now'
    alias halt='sudo halt -P'
fi

alias sudo='sudo ' # enable alias expansion for sudo

alias ..="cd .."
alias ...="cd ../.."

alias tree="tree -A"
alias treed="tree -d"
alias tree1="tree -d -L 1"
alias tree2="tree -d -L 2"
