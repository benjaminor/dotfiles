{ config, pkgs, ... }:

let helper = import ./helper.nix;
in (with helper; {
  imports = [ ./fonts.nix ];
  home.packages = (with pkgs; [
    # aspell and its dictionaries
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
  ]);

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacsWithPackagesFromUsePackage {
        alwaysEnsure = true;
        config = (resolveConfigLocation "emacs/config.org");
        package = pkgs.emacsGcc;
      };
    };

  };

  home.file.".aspell.conf".text =
    ("data-dir " + (builtins.getEnv "HOME" + "/.nix-profile/lib/aspell"));
})
