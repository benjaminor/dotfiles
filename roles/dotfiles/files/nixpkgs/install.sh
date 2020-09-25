#!/usr/bin/env sh

# Where first arg is directory under machines, can be one of opensuse, ubuntu-srv, arch-vps
mkdir -p "${XDG_CONFIG_HOME:=$HOME/.config}"
ln -s "$(pwd)" "$XDG_CONFIG_HOME/nixpkgs"
ln -s "$(pwd)/machines/$1/home.nix" "$XDG_CONFIG_HOME/nixpkgs/home.nix"
ln -s "$(pwd)/machines/$1/config.nix" "$XDG_CONFIG_HOME/nixpkgs/config.nix"
