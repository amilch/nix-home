{ ... }:

{
  imports = [ ./common.nix ];

  programs.zsh.shellAliases = {
    kitty = "/Applications/kitty.app/Contents/MacOS/kitty";
  };
}
