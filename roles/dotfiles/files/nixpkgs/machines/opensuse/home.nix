# let
#   sources = import ../../nix/sources.nix;
# in

{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
    ../../modules/emacs.nix
    ../../modules/software-development.nix
    ../../modules/git.nix
    ../../modules/desktop.nix
  ];

  targets.genericLinux.enable = true;
}
