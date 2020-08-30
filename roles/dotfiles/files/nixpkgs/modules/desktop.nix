{ pkgs, ... }:

let
  common = import ./common.nix;
in
# TODO: later import here only, put programs in extra modules like sw-devel, images, e.g.
(with common;
{
  home.packages = (with pkgs;[
    feh
    zathura

    kdeApplications.okular

    signal-desktop
    redshift
    keepassxc # TODO: is this really desktop?
    vlc
    spotify

    i3
    i3status
    polybarFull

    # these have all xorg / xauth problems
    # xorg.xbacklight
    # xorg.xhost
    # xorg.xauth
    # or qt problems
    # virtualbox
    # qpdfview
    # libsForQt5.vlc
    # calibre

  ]);

  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:Iosevka:size=12"
      "xft:Inconsolata Nerd Font:size=12"
    ];
  };

  home.file = {
    ".xinputrc".text =
      ''
run_im none

set bell-style none
'';

  };

  xdg = {
    enable = true;
    configFile = {
      "polybar".source = "/${configLocation}" + "polybar";
      "zathura".source = "/${configLocation}" + "zathura";
      "i3".source = "/${configLocation}" + "i3";
      "i3status".source = "/${configLocation}" + "i3status";
      "picom".source = "/${configLocation}" + "picom";
    };

  };

  xresources.extraConfig =
    ''
rofi.combi-modi:    window,drun,ssh
rofi.font:          Iosevka 12
rofi.modi:          combi
rofi.fuzzy:     true

!! URxvt Appearance*.font: xft:Iosevka:style=Regular:size=8
URxvt.boldFont: xft:Iosevka:style=Bold:size=12,xft:Inconsolata Nerd Font:size=12
URxvt.italicFont: xft:Iosevka:style=Italic:size=12,xft:Inconsolata Nerd Font:size=12
URxvt.boldItalicFont: xft:Iosevka:style=Bold Italic:size=12,xft:Inconsolata Nerd Font:size=12
URxvt.letterSpace: 0
URxvt.lineSpace: 0
URxvt.geometry: 92x42
URxvt.internalBorder: 24
URxvt.cursorBlink: true
URxvt.cursorUnderline: false
URxvt.urgentOnBell: true
URxvt.depth: 24
URxvt.loginShell: true
URxvt.secondaryScroll: true
! special
*.foreground:   #d2c5bc
*.background:   #101010
*.cursorColor:  #d2c5bc

! black
*.color0:       #202020
*.color8:       #606060

! red
*.color1:       #b91e2e
*.color9:       #d14548

! green
*.color2:       #81957c
*.color10:      #a7b79a

! yellow
*.color3:       #f9bb80
*.color11:      #fae3a0

! blue
*.color4:       #356579
*.color12:      #7491a1

! magenta
*.color5:       #2d2031
*.color13:      #87314e

! cyan
*.color6:       #268ad3
*.color14:      #0f829d

! white
*.color7:       #909090
*.color15:      #fff0f0

! perl extensions
URxvt.perl-ext-common: default,matcher,font-size
URxvt.urlLauncher: firefox
URxvt.keysym.C-S-Up:   font-size:incglobal
URxvt.keysym.C-S-Down: font-size:decglobal
URxvt.keysym.C-slash:  font-size:show
'';

})
