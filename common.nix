{ config, pkgs, lib, ... }:

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

  pandoc-pdf-template = pkgs.writeTextDir "share/pdf.yaml" ''
    ---
    documentclass: scrartcl
    classoption:
      - fleqn
      - fontsize: 11pt
    papersize: a4
    geometry:
      - includeheadfoot
      - left=15mm
      - right=15mm
      - top=10mm
      - bottom=10mm
    header-includes: |
      \newcommand{\lt}{<}
      \newcommand{\gt}{>}
    ---
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

  home.packages = [
    pkgs.shellcheck
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
    pkgs.shellcheck
    pkgs.z-lua
    pkgs.wget
    ls-colors
    pkgs.fzf
    pkgs.poppler_utils

    pkgs-20-09.ripgrep # currently broken

    pkgs.go
    pkgs.nodejs-15_x
    pkgs.nodePackages.yarn
    pkgs.rustup
    pkgs-20-09.php
    pkgs-20-09.php74Packages.composer

    pkgs.texlive.combined.scheme-medium
    pkgs.pandoc
    pandoc-pdf-template
    pkgs.python38Packages.papis
    pkgs.python38Packages.papis-python-rofi
  ];

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
    settings = lib.trivial.mergeAttrs kitty-gruvbox-dark {
      font_family = "Fira Code";
      font_size = 13;
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

  programs.kakoune = {
    enable = false;
    config = {
      colorScheme = "gruvbox";
      tabStop = 4;
      numberLines = {
        enable = true;
        relative = true;
        separator = "' '";
      };
    };
  };

  programs.neovim = {
    enable = true;
    withRuby = false;
    vimAlias = true;
    extraConfig = ''
      set termguicolors
      colorscheme gruvbox

      set number
      set autoindent  " already default in vim-sensible
      set expandtab
      set backspace=2
      set shiftwidth=2
      set softtabstop=2
      " set textwidth=80
      set hidden
      set modelines=0
      set scrolloff=3
      set smartcase
      set mouse=a
      set inccommand=split

      " Keyboard shortcuts
      nnoremap <silent> <F3> :make <CR>

      " Quickfix window auto open
      " https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
      au QuickFixCmdPost [^l]* nested cwindow
      au QuickFixCmdPOst    l* nested lwindow

      " latex
      let g:tex_flavor='latex'
      let g:vimtex_quickfix_mode=0
      set conceallevel=1
      let g:tex_conceal='abdmg'

      " shell scripts
      autocmd FileType sh :set makeprg=shellcheck\ -o\ all\ -f\ gcc\ %
      autocmd Filetype sh :au BufWritePost * silent make | redraw!

      " java
      autocmd FileType java :set makeprg=javac\ %
      autocmd FileType java :set errorformat=%A:%f:%l:\ %m,%-Z%p^,%-C%.%#

    '';
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      vim-nix
      iceberg-vim
      gruvbox
      molokai
      vimtex
      vim-fugitive
      vim-dispatch
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
    history.share = false;

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
      code = "code-insiders";
      g = "git";
      amend = "git add -A && git commit --amend --no-edit";
      grep = "grep --color=auto";
      date = "${pkgs.coreutils}/bin/date";
      diff = "diff --color=auto";
      ls = "ls --color=auto -F ";
      l = "ls";
      ll = "ls -alFh";
      la = "ls -A";
      zz = "z -c"; # restrict matches to subdirs of $PWD
      hm = "home-manager";
      ssh-keygen = "ssh-keygen -t rsa -b 4096";
      dev-server-php = "sh -c 'php -S localhost:8000 & browser-sync start -f . -p localhost:8000 --no-notify & wait'";
      kitty-beamer = "kitty -o font_size=20 -o macos_quit_when_last_window_closed=yes";
    };

    sessionVariables = rec {
      PROMPT="%F{245}%~%f %(?..%F{red}[%?]%f )%(!.#.$) ";
      EDITOR = "vim";
      PATH = "$HOME/.yarn/bin:$PATH";
      HOMEBREW_NO_ANALYTICS = "1";
    };

    initExtra = ''
      . ~/.nix-profile/etc/profile.d/nix.sh

      eval $(dircolors ~/.nix-profile/share/LS_COLORS)
      eval "$(z --init zsh)"

      # terminal title
      case $TERM in
        xterm*)
          precmd () {print -Pn "\e]0;%1~\a"}
          ;;
      esac

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

      # Functions
      function pandoc-pdf {
        pandoc --metadata-file=${pandoc-pdf-template}/share/pdf.yaml \
          "''${@:2}" "$1" -o "''${1:r}.pdf" && open "''${1:r}.pdf"
      }
      function cht {
        curl "https://cht.sh/''${1}" | less -R
      }
    '';
  };
}
