{ config, pkgs, ... }:

let
  common = import ./common.nix;
in
(with common;
  {

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    # targets.genericLinux.enable = true;

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
      pandoc
      exa
      hexyl

      # command line tools
      ripgrep
      ripgrep-all
      fd
      ranger
      bandwhich
      htop
      iptables
      du-dust
      ipcalc

      # software development
      autogen
      # tree-sitter
      ## language servers
      rust-analyzer
      yaml-language-server
      clang-tools # clangd included
      ## rust development
      rustup

      arandr
      autorandr
      asmfmt
      playerctl
      mpv
      meld
      texlab
      hunspell
      hugo
      silver-searcher
      pinentry
      curl

      # aspell dictionaries
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.es

      # fonts
      inconsolata-nerdfont
      iosevka
      font-awesome
    ]);

    programs ={
      broot = {
        enable = true;
      };

      tmux = {
        enable = true;
        extraConfig =
          ''
set -g mouse on
unbind C-b
set -g prefix F1
bind h split-window -h
bind v split-window -v

# switch panes using Alt-arrow without prefix
bind -n M-h select-pane -L
bind -n M-l select-pane -R
bind -n M-j select-pane -U
bind -n M-k select-pane -D

# reload config file (change file location to your the tmux.conf you want to use)
bind r source-file ~/.tmux.conf

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

set -g @continuum-restore 'on'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

if "test ! -d ~/.tmux/plugins/tpm" \
   "run 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins'"

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'
'';
      };

      fish = {
        enable = true;
        shellInit =
          ''
if not functions -q fisher
  set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
  curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
  fish -c fisher
end

if test -e ~/conda3/etc/fish/conf.d/conda.fish
  source ~/conda3/etc/fish/conf.d/conda.fish
end

set shell_config "$HOME/.config/shell"

if functions -q bass
  bass source ~/.profile
  bass source "$shell_config/.commonrc"
  bass source /etc/profile
end

if type -q awk
  set functions_file "$shell_config/functions.sh"
  set personal_functions_file "$HOME/.functions_personal"
  if test -e $functions_file
    for line in (awk '/function .*\(\)/ {print substr($2, 1, length($2)-2)}' $functions_file)
      function $line
        bass source $functions_file ';' $_ $argv
      end
    end
  end
  if test -e $personal_functions_file
    for line in (awk '/function .*\(\)/ {print substr($2, 1, length($2)-2)}' $personal_functions_file)
      function $line
        bass source $personal_functions_file ';' $_ $argv
      end
    end
  end

end

function vterm_printf;
    if [ -n "$TMUX" ]
        # tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

function autotmux --on-variable TMUX_SESSION_NAME
    if test -n "$TMUX_SESSION_NAME" #only if set
  if test -z $TMUX #not if in TMUX
    if tmux has-session -t $TMUX_SESSION_NAME
    exec tmux new-session -t "$TMUX_SESSION_NAME"
    else
    exec tmux new-session -s "$TMUX_SESSION_NAME"
    end
  end
  end
end

# bob-the-fish customization
set -g theme_show_exit_status yes
set -g theme_color_scheme solarized-light
set -g theme_nerd_fonts yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_stashed_verbose yes

# cheat.sh
# cht aready defined in functions.sh
# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cht -xa '(curl -s cheat.sh/:list)'

# opam configuration
source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true

'';
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

      bat.enable = true;
      neovim.enable = true;
      fzf.enable = true;

      emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          config = ("/${configLocation}" + "emacs/init.el");
          package = pkgs.emacsGcc;
          extraEmacsPackages = epkgs: (with epkgs;[
            magit
            lsp-mode
            helm
            treemacs
            projectile
          ]);
        };
      };

      rofi.enable = true;

      texlive = {
        enable = true;
        extraPackages = tpkgs : {
          inherit (tpkgs)
            scheme-full;
        };

      };
    };

    fonts.fontconfig.enable = true;

    #   xsession.enable = true;
    #   xsession.windowManager.command = "i3";

    #   services.polybar = {
    #     enable = false;
    #     config = {
    #       "bar/bar" = {
    #         monitor = "\${env:MONITOR:}";
    #         width = "100%";
    #         height = "3%";
    #         radius = 0;
    #         modules-center = "date";
    #       };

    #       "module/date" = {
    #         type = "internal/date";
    #         internal = 5;
    #         date = "%d.%m.%y";
    #         time = "%H:%M";
    #         label = "%time%  %date%";
    #       };

    #     };
    #     script =  ''
    # # for m in $(polybar --list-monitors | cut -d":" -f1); do
    # #     MONITOR=$m polybar --reload example &
    # # done
    # # '';
    #   };

    #   services.lorri.enable = true;

    #   systemd.user.startServices = true;
    # use i3 as wm
    # xsession.enable = true;
    # xsession.windowManager.i3.enable = true;
    # services.screen-locker.lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p -t ''";

    # services.nextcloud-client.enable = true;

    home.file = {
      ".aspell.conf".text = "data-dir /home/ben/.nix-profile/lib/aspell";

      ".globalrc".source = ("/${configLocation}" + "./.globalrc");

      ".profile".source = ("/${configLocation}" + "./.profile");

      ".bash_profile".source = ("/${configLocation}" + "./bash_profile");

      ".bashrc".source = ("/${configLocation}"+ "./.bashrc");
    };

    xdg = {
      enable = true;
      configFile = {
        "fish/fishfile".source = "/${configLocation}" + "fish/fishfile";

        "shell".source = "/${configLocation}" + "shell";

        "powerline-shell".source = "/${configLocation}" + "powerline-shell";
      };
    };

  })
