{
  imports = [
    ../../modules/home-manager-basis.nix
    ../../modules/cli.nix
    ../../modules/software-development.nix
    ../../modules/git.nix
    ../../modules/fonts.nix
  ];

  targets.genericLinux.enable = true;
}
