{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
    ../../modules/git.nix
  ];

  home.packages = (with pkgs; [ wireguard-tools ]);

  targets.genericLinux.enable = true;
}
