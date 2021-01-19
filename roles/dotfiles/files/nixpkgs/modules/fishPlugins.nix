let
  sources = import ../nix/sources.nix;
  plugins = [
    "fzf"
    "theme-bobthefish"
    "z"
    "pisces"
    "bass"
    "fish-colored-man"
    "plugin-bang-bang"
    "fish-ssh-agent"
    "plugin-git"
  ];
  createPlugin = (plugin: {
    name = plugin;
    src = sources.${plugin};
  });

in { plugins = builtins.map createPlugin plugins; }
