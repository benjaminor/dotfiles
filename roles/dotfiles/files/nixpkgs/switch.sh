#!/usr/bin/env sh
cd "$(dirname "$(readlink -f "$0")")"
nix-shell --run "home-manager switch"
cd -
