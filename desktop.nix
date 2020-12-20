{ ... }:

{
  imports = [ ./common.nix ];

  home.username = "user";
  home.homeDirectory = "/Users/user";

  programs.zsh.shellAliases = {
    kitty = "/Applications/kitty.app/Contents/MacOS/kitty";
  };
}
