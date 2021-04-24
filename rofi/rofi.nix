{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "/usr/bin/kitty";
    lines = 3;
    theme = ./slate.rasi;
    font = "Roboto 11";
    extraConfig = ''
      rofi.modi: window,run,drun,ssh,combi
    '';
  };
}
