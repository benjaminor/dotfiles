{ pkgs, ... }:

let helper = import ./helper.nix;
in (with helper; {
  imports = [ ./fonts.nix ./communication.nix ];

  home.packages = (with pkgs; [
    arandr
    autorandr

    feh
    zathura
    libsForQt5.okular

    redshift
    keepassxc # TODO: is this really desktop?
    vlc
    spotify

    i3
    i3status
    polybarFull
    playerctl

    borgbackup

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
    fonts = [ "xft:iosevkanerdfontmono:size=12:hinting=true:antialias=true" ];
    extraConfig = {
      boldFont =
        "xft:iosevkanerdfontmono:size=12:hinting=true:antialias=true:style=Bold";
      italicFont =
        "xft:iosevkanerdfontmono:size=12:hinting=true:antialias=true:style=Italic";
      boldItalicFont =
        "xft:iosevkanerdfontmono:size=12:hinting=true:antialias=true:style=Bold Italic";
      letterSpace = 0;
      lineSpace = 0;
      geometry = "92x42";
      internalBorder = 24;
      cursorBlink = true;
      cursorUnderline = false;
      urgentOnBell = true;
      depth = 24;
      loginShell = true;
      secondaryScroll = true;

    };
  };
  programs.rofi.enable = true;

  home.file = {
    ".xinputrc".text = ''
      run_im none

      set bell-style none
    '';

  };

  xdg = {
    enable = true;
    configFile = {
      "polybar".source = (resolveConfigLocation "polybar");
      "zathura".source = (resolveConfigLocation "zathura");
      "i3".source = (resolveConfigLocation "i3");
      "i3status".source = (resolveConfigLocation "i3status");
      "picom".source = (resolveConfigLocation "picom");
    };

  };

  xresources.extraConfig = ''
    rofi.combi-modi:    window,drun,ssh
    rofi.font:          Iosevka 12
    rofi.modi:          combi
    rofi.fuzzy:         true

    ! special
    *.foreground:   #d2c5bc
    *.background:   #101010
    *.cursorColor:  #d2c5bc

    ! black
    *.color0:       #202020
    *.color8:       #2c2c2c

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
