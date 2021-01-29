{ pkgs, ... }:

let
  helper = import ./helper.nix;
  fishPlugins = import ./fishPlugins.nix;
in (with helper; {

  imports = [ ./nix-utils.nix ];

  home.packages = (with pkgs; [
    # little helpers
    atool
    pandoc
    exa
    hexyl
    mosh
    zip
    tldr
    rsync
    tree
    pdftk

    # command line tools
    ripgrep
    ripgrep-all
    fd
    ranger
    bandwhich
    htop
    iptables
    du-dust

    mpv
    silver-searcher
    pinentry
    curl

    # networking
    wireguard-tools
    ipcalc
  ]);

  programs = {
    broot = { enable = true; };

    tmux = {
      enable = true;
      extraConfig = ''
        set -g default-terminal "tmux-256color"

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
      plugins = fishPlugins.plugins;
      shellInit = ''
        # if not functions -q fisher
        #   set -q XDG_CONFIG_HOME;
        #   curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        # end
        if test -e ~/conda3/etc/fish/conf.d/conda.fish
            source ~/conda3/etc/fish/conf.d/conda.fish
          end

          # for f in "XDG_CONFIG_HOME/fish/conf.d/*.fish
          #   source $f
          # end

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

          if test "$TERM" = "tramp"
             function fish_prompt
             echo "\$ "
          end

             function fish_right_prompt; end
             function fish_greeting; end
             function fish_title; end
          end

      '';
    };

    direnv = {
      enable = true;
      enableFishIntegration = true;
      stdlib = ''
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
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      # changeDirWidgetCommand = "fd --type d";
    };

  };

  services = {
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      maxCacheTtl = 999999;
      enableSshSupport = true;
    };
    lorri.enable = true;
  };

  systemd.user = {
    startServices = "sd-switch";
    systemctlPath = "/usr/bin/systemctl";
  };

  home.file = {

    ".globalrc".source = (resolveConfigLocation ".globalrc");

    ".profile".source = (resolveConfigLocation "./.profile");

    ".bash_profile".source = (resolveConfigLocation "./.bash_profile");

    ".bashrc".source = (resolveConfigLocation "./.bashrc");
  };

  xdg = {
    enable = true;
    configFile = { "shell".source = (resolveConfigLocation "shell"); };
  };

})
