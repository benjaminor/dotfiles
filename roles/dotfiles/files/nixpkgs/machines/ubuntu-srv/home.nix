{ pkgs, ... }:
# let
#   sources = import ../../nix/sources.nix;
# in

{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
  ];

  targets.genericLinux.enable = true;

  home.packages = [
	pkgs.weechat
];
}
