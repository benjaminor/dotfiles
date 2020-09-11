{ pkgs, ... }:

{
  home.packages = (with pkgs; [ inconsolata-nerdfont iosevka font-awesome ]);

  fonts.fontconfig.enable = true;
}
