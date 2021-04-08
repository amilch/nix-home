{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.zsh.sessionVariables.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  
  programs.zsh.shellAliases = {
    kitty = "/usr/bin/kitty";
  };

  programs.rofi = {
    enable = true;
    theme = "slate";
    extraConfig = ''
      rofi.modi: window,run,drun,ssh
      rofi.lines: 3
      rofi.font: Roboto 11
    '';
  };
}
