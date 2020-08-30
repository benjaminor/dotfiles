# let
#   sources = import ../../nix/sources.nix;
# in

{
  imports = [
    ../../modules/general.nix
    ../../modules/git.nix
    ../../modules/desktop.nix
  ];
}
