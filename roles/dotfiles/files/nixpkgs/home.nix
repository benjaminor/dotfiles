{ config, pkgs, ... }:

{

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  nixpkgs.config.allowUnfree = true;

  home.packages = (with pkgs;[

    # little helpers
    atool
    ripgrep
    ripgrep-all
    pandoc
    fd
    exa
    hexyl

    ranger
    kdeApplications.okular
    arandr
    autorandr
    autogen
    asmfmt
    signal-desktop
    bandwhich
    redshift
    keepassxc
    vlc
    playerctl
    meld
    htop
    iptables
    texlab
    ipcalc
    du-dust
    spotify
    hunspell
    hugo
    silver-searcher
    pinentry
    curl

    # language servers
    rust-analyzer
    yaml-language-server
    clang-tools # clangd included

    # fonts
    inconsolata-nerdfont
    iosevka

    # rust development
    rustup

    # these have all xorg / xauth problems
    # xorg.xbacklight
    # xorg.xhost
    # xorg.xauth
    # i3
    # i3lock-fancy
    # i3status
    # or qt problems
    # virtualbox
    # qpdfview
    # libsForQt5.vlc
    # calibre
    # tmux

  ]);

  programs ={
    broot = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      stdlib=''
layout_anaconda() {
  local ACTIVATE="''${HOME}/conda3/bin/activate"

  if [ -n "$1" ]; then
  # Explicit environment name from layout command.
  local env_name="$1"
  source $ACTIVATE ''${env_name}
  elif (grep -q name: environment.yml); then
  # Detect environment name from `environment.yml` file in `.envrc` directory
  source $ACTIVATE `grep name: environment.yml | sed -e 's/name: //' | cut -d "'" -f 2 | cut -d '"' -f 2`
  else
  (>&2 echo No environment specified);
  exit 1;
  fi;
}

session_name(){
  export TMUX_SESSION_NAME="''${*:?session_name needs a name as argument}"
}

'';
    };
    git = {
      enable = true;
      userName = "Benjamin Orthen";
      userEmail = "benjamin@orthen.net";
    };
    bat.enable = true;
    neovim.enable = true;
    fzf.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacsGit;
    };

    # texlive.enable = true;
    # texlive.extraPackages = tpkgs: {
    #   inherit (tpkgs)
    #     scheme-small
    #     cm-super
    #     algorithms
    #     tikz-cd
    #     csquotes
    #     braket
    #     turnstile
    #     dashbox
    #     chktex
    #     cleveref
    #     bussproofs
    #     latexmk;
    # };

  };
  fonts.fontconfig.enable = true;
  services.polybar = {
    enable = true;
    config = {
      "bar/bar" = {
        monitor = "\${env:MONITOR:}";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-center = "date";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };

    };
    script =  ''
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload example &
done
'';
  };

  services.lorri.enable = true;

  # use i3 as wm
  # xsession.enable = true;
  systemd.user.startServices = true;
  # xsession.windowManager.i3.enable = true;
  # services.screen-locker.lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p -t ''";

  # services.nextcloud-client.enable = true;
}
