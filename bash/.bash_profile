# this file is sourced by login shells only

# use settings in .profile, too
[[ -e ~/.profile ]] && source ~/.profile

# source everything else
[[ -e ~/.bashrc ]] && source ~/.bashrc
