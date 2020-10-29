{ config, pkgs, ... }:

let
  pkgs = import <nixpkgs> { };
  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    sha256 = "1qbl2w58s97q232aa6lnv7ws29n26fhff5nkdn3ip53sia50rn49";
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

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "user";
  home.homeDirectory = "/Users/user";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";


  home.packages = [
    pkgs.bat
    pkgs.mtr
    pkgs.tree
    pkgs.htop
    pkgs.fd
    pkgs.nix-prefetch-github
    pkgs.ncdu
    pkgs.httpie
    pkgs.glances
    pkgs.shellcheck
    pkgs.z-lua
    ls-colors 

    pkgs-20-09.ripgrep # currently broken

    pkgs.go
    pkgs.nodejs-15_x
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    vimAlias = true;
    extraConfig = ''
      set termguicolors
      colorscheme iceberg

      set number
      set autoindent  "already default in vim-sensible    
      set expandtab
      set backspace=2
      set shiftwidth=2
      set softtabstop=2

      set hidden
      set modelines=0
      set scrolloff=3

      set smartcase
    '';
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-nix
      iceberg-vim
      gruvbox
      molokai
    ];
  };

  programs.git = {
    enable = true;
    userName = "Andreas Milch";
    userEmail = "mail@andreasmilch.cc";
    extraConfig = {
      hub.protocol = "https";
      github.user = "andreasmilch";
      color.ui = true;
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.6.4";
          sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
        };
      }
    ];

    shellAliases = {
      g = "git";
      amend = "git add -A && git commit --amend --no-edit";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      ls = "ls --color=auto -F ";
      l = "ls";
      ll = "ls -alFh";
      la = "ls -A";
      zz = "z -c"; # restrict matches to subdirs of $PWD
      ssh-keygen = "ssh-keygen -t rsa -b 4096";
      dev-server-php = "sh -c 'php -S localhost:8000 & browser-sync start -f . -p localhost:8000 --no-notify & wait'";
    };

    initExtra = ''
      PROMPT='%F{245}%~%f %(?..%F{red}[%?]%f )%(!.#.$) '
      export EDITOR=vim

      . ~/.nix-profile/etc/profile.d/nix.sh

      eval $(dircolors ~/.nix-profile/share/LS_COLORS)
      eval "$(z --init zsh)"

      # History Search
      autoload -U up-line-or-beginning-search
      autoload -U down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey "^[[A" up-line-or-beginning-search
      bindkey "^[[B" down-line-or-beginning-search
      bindkey "^P" up-line-or-beginning-search
      bindkey "^N" down-line-or-beginning-search

      # Behaviour
      setopt auto_list
      setopt auto_menu
      setopt always_to_end
      setopt no_case_glob
      setopt auto_cd
      setopt correct_all
    '';
  };
}
