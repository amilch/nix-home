{ config, pkgs, lib, ... }:

let
  pkgs = import <nixpkgs> { };

  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    sha256 = "1cxa95qhg2x0az20rg19pc9larlgp1igl9w43bpbqqxs8m32qdka";
  };
  ls-colors = pkgs.runCommand "ls-colors" { } ''
    mkdir -p $out/bin/ $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  '';

  pkgs-20-09 = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz";
    sha256 = "1wg61h4gndm3vcprdcg7rc4s1v3jkm5xd7lw8r2f67w502y94gcy";
  }) { };

  kitty-iceberg = {
    foreground  = "#c6c8d1";
    background  = "#161821";
    cursor      = "#c6c8d1";
    color0      = "#161821";
    color8      = "#6b7089";
    color1      = "#e27878";
    color9      = "#e98989";
    color2      = "#b4be82";
    color10     = "#c0ca8e";
    color3      = "#e2a478";
    color11     = "#e9b189";
    color4      = "#84a0c6";
    color12     = "#91acd1";
    color5      = "#a093c7";
    color13     = "#ada0d3";
    color6      = "#89b8c2";
    color14     = "#95c4ce";
    color7      = "#c6c8d1";
    color15     = "#d2d4de";
  };

  kitty-gruvbox-dark = {
    background	= "#282828"; # hard contrast: background #1d2021
    foreground	= "#ebdbb2"; # soft contrast: background #32302f
    cursor	= "#fbf1c7";
    url_color	= "#83a598";
    color0	= "#282828"; # Black
    color8	= "#928374"; # DarkGrey
    color1	= "#cc241d"; # DarkRed
    color9	= "#fb4934"; # Red
    color2	= "#98971a"; # DarkGreen
    color10	= "#b8bb26"; # Green
    color3	= "#d79921"; # DarkYellow
    color11	= "#fabd2f"; # Yellow
    color4	= "#458588"; # DarkBlue
    color12	= "#83a598"; # Blue
    color5	= "#b16286"; # DarkMagenta
    color13	= "#d3869b"; # Magenta
    color6	= "#689d6a"; # DarkCyan
    color14	= "#8ec07c"; # Cyan
    color7	= "#a89984"; # LightGrey
    color15	= "#ebdbb2"; # White
  };

in {
  imports = [
    ./zsh/zsh.nix
    ./neovim/neovim.nix
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # moved to specific configs
  # home.username = "user";
  # home.homeDirectory = "/Users/user";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.file."Library/Application Support/abnerworks.Typora/themes/base.user.css".text = ''
    html,
    body,
    button,
    input,
    select,
    textarea {
      font-family: "iA Writer Duo S";
    }

    html {
      font-size: 16px; /* not modified */
    }
    '';


  home.file.".npmrc".text = ''
    prefix = ''${HOME}/.npm-packages
  '';

  home.packages = [
    pkgs.imagemagick
    pkgs.ranger
    pkgs.qtile
    pkgs.lua
    pkgs.shellcheck
    pkgs.cmake
    pkgs.mtr
    pkgs.mpv
    pkgs.socat
    pkgs.tree
    pkgs.htop
    pkgs.fd
    pkgs.jq
    pkgs.nix-prefetch-github
    pkgs.ncdu
    pkgs.httpie
    pkgs.gnugrep
    pkgs.glances
    pkgs.tealdeer
    pkgs.tor
    pkgs.nmap
    pkgs.shellcheck
    pkgs.sd
    pkgs.z-lua
    pkgs.wget
    ls-colors
    pkgs.fzf
    pkgs.poppler_utils
    pkgs.youtube-dl
    pkgs.ripgrep
    pkgs.wavemon
    pkgs.litecli
    pkgs.mycli

    pkgs.go
    pkgs.nodejs-15_x
    pkgs.nodePackages.yarn
    pkgs.rustup
    pkgs-20-09.php
    pkgs-20-09.php74Packages.composer

    pkgs.texlive.combined.scheme-medium
    pkgs.pandoc

    pkgs.python3
    pkgs.python38Packages.papis
    pkgs.python38Packages.papis-python-rofi
    pkgs.python38Packages.requests
    pkgs.python38Packages.pip
  ];

  home.sessionVariables = rec {
    EDITOR = "vim";
    TERMINAL = "/usr/bin/kitty";
    JAVA_HOME = "/opt/jdk-15.0.2";
    PATH = "$HOME/.npm-packages/bin:$HOME/.yarn/bin:/opt/gradle/bin:$JAVA_HOME/bin:$PATH";
    HOMEBREW_NO_ANALYTICS = "1";
    COMPOSER_MEMORY_LIMIT="4G";
  };

  programs.direnv.enable = true;
  # programs.direnv.enableNixDirenvIntegration = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox";
      italic-text = "always";
      style = "changes";
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    settings = lib.trivial.mergeAttrs kitty-gruvbox-dark {
      shell = "/usr/bin/zsh";
      allow_hyperlinks = true;
      url_style = "single";
      enable_audio_bell = false;
      tab_bar_style = "separator";
      tab_bar_edge = "top";
      tab_separator = "''";
      tab_title_template = "' {title} '";
      active_border_color = "none";
      inactive_text_alpha = "0.6";
      enabled_layouts = "vertical";
      macos_option_as_alt = true;
    };
    keybindings = {
      "cmd+d" = "new_window_with_cwd";
      "cmd+t" = "new_tab_with_cwd";
      "cmd+]" = "next_window";
      "cmd+[" = "previous_window";
      "cmd+enter" = "toggle_fullscreen";
      "cmd+n" = "new_os_window_with_cwd";
      "cmd+1" = "goto_tab 1";
      "cmd+2" = "goto_tab 2";
      "cmd+3" = "goto_tab 3";
      "cmd+4" = "goto_tab 4";
      "cmd+5" = "goto_tab 5";
      "cmd+6" = "goto_tab 6";
      "cmd+7" = "goto_tab 7";
      "cmd+8" = "goto_tab 8";
      "cmd+9" = "goto_tab 9";
    };
  };

  programs.git = {
    enable = true;
    userName = "Andreas Milch";
    userEmail = "mail@andreasmilch.cc";
    extraConfig = {
      hub.protocol = "https";
      github.user = "andreasmilch";
      color.ui = true;
      merge.tool = "vimdiff";
      merge.conflictstyle = "diff3";
      credential.helper = "osxkeychain";
      diff.algorithm = "patience";
      protocol.version = "2";
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
    aliases = {
      s = "status";
      d = "diff";
      co = "checkout";
      br = "branch";
      last = "log -1 HEAD";
      lo = "log --oneline -n 10";
      pr = "pull --rebase";
      a = "add .";
      c = "commit -m";
      rh = "reset --hard";
    };
  };

}
