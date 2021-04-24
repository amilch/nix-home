{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./polybar/polybar.nix
    ./rofi/rofi.nix
    ./herbstluftwm/herbstluftwm.nix
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  programs.zsh.sessionVariables.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  
  programs.zsh.shellAliases = {
    kitty = "/usr/bin/kitty";
  };
}
