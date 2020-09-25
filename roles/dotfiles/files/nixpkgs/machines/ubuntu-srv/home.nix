{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
    ../../modules/git.nix
  ];

  targets.genericLinux.enable = true;

}
