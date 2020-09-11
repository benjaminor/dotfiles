{ pkgs, ... }:

{
  home.packages = (with pkgs; [ niv nix-index lorri ]);
}
