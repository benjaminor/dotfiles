{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Benjamin Orthen";
    userEmail = "benjamin@orthen.net";
  };
  home.packages = (with pkgs; [ git-secret ]);
}
