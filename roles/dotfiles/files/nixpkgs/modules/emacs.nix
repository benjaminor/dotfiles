{ config, pkgs, ... }:

let
  common = import ./common.nix;
in
(with common;
  {
    imports = [
      ./fonts.nix
    ];
    home.packages = (with pkgs;[
      # aspell and its dictionaries
      aspell
      aspellDicts.de
      aspellDicts.en
      aspellDicts.es
    ]);

    programs = {
      emacs = {
        enable = true;
        package = pkgs.emacsWithPackagesFromUsePackage {
          alwaysEnsure = true;
          config = (resolveConfigLocation "emacs/init.el");
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


    };

    home.file."aspell.conf".text = ("data dir" + (builtins.getEnv "HOME" + "/home/ben/.nix-profile/lib/aspell"));
  }
)
