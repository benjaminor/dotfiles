{ pkgs, ... }:

{
  home.packages = (with pkgs;[
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

    # tex
    texlab

    meld

    # for website development
    hugo
  ]);
}
