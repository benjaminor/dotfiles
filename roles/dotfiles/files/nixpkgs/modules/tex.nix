{ pkgs, ... }: {
  home.packages = (with pkgs; [ texlab ]);
  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };
  };
}
