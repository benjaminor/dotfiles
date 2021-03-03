{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    iosevka
    font-awesome
    fira-code
    nerdfonts
    symbola
    noto-fonts
  ]);

  fonts.fontconfig.enable = true;
}
