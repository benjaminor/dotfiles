{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    # fonts
    inconsolata-nerdfont
    iosevka
    font-awesome
  ]);

  fonts.fontconfig.enable = true;
}
