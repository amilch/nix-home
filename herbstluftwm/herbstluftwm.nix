{ pkgs, ... }:

{
  home.packages = [
    pkgs.herbstluftwm
  ];
  home.file.".config/herbstluftwm/autostart".source = ./autostart;
}
