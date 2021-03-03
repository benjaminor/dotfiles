{ pkgs, ... }:

{
  home.packages = (with pkgs; [
    autogen
    # tree-sitter
    yaml-language-server
    rustup
    clang-tools # includes clangd

    ## rust development
    rust-analyzer
    rustup

    nixfmt
    asmfmt

    meld

    # c and c++
    cmake
    ninja

    # for website development
    hugo

    # python
    python39Packages.bandit
    python39Packages.flake8
    python39Packages.pytest
    python39Packages.pytest-flake8
    nodePackages.pyright
    black
  ]);
}
