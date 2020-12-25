{ pkgs, ... }:

{
  home.packages = (with pkgs; [ iosevka font-awesome fira-code nerdfonts ]);

  fonts.fontconfig.enable = true;
}
