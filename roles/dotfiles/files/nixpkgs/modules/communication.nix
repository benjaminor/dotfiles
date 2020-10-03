{ pkgs, ... }: {
  home.packages = (with pkgs; [
    weechat
    weechatScripts.weechat-matrix
    signal-desktop
    mattermost-desktop
    element-desktop
  ]);
}
