{ pkgs, ... }:

{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
    ../../modules/git.nix
    ../../modules/server-management.nix
  ];

  targets.genericLinux.enable = true;
}
