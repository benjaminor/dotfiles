#! /bin/bash
cd "$(dirname "$0")"

# make symlinks to sh files in bash
# TODO: make loop
# TODO: put files before in backup folder
# TODO: ask for backup to be deleted

ln -s $(pwd)/bash/.bash_profile ~/.bash_profile
ln -s $(pwd)/bash/.bashrc ~/.bashrc
ln -s $(pwd)/bash/.bash_aliases ~/.bash_aliases

# make symlink to .profile
ln -s $(pwd)/system/.profile ~/.profile

# make symlink to .config/shell in home directory
ln -s $(pwd)/bash/.config/shell ~/.config/shell
