#!/usr/bin/env sh
cd "$(dirname "$(readlink -f "$0")")"
nix-shell --run "niv update"
cd -
