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
  ]);
}
