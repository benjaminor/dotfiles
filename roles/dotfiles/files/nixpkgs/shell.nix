let
  sources = import ./nix/sources.nix;
  nixpkgs = sources."nixpkgs";
  pkgs = import nixpkgs { };
  home-manager = import sources.home-manager { inherit pkgs; };
in pkgs.mkShell {

  buildInputs = with pkgs; [ niv home-manager.home-manager cachix ];

  shellHook = ''
    export NIX_PATH="nixpkgs=${nixpkgs}:home-manager=${sources."home-manager"}"
    export HOME_MANAGER_CONFIG="./home.nix"
  '';
}
