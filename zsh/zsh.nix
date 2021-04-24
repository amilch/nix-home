{ pkgs, ... }:

let

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

in {
  home.packages = [
    pandoc-pdf-template
  ];

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
      r = "ranger";
      git = "/usr/bin/git";
      zsh = "/usr/bin/zsh";
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
      hc = "herbstclient";
      ssh-keygen = "ssh-keygen -t rsa -b 4096";
      dev-server-php = "sh -c 'php -S localhost:8000 & browser-sync start -f . -p localhost:8000 --no-notify & wait'";
      kitty-beamer = "kitty -o font_size=20 -o macos_quit_when_last_window_closed=yes";
    };

    sessionVariables = rec {
      PROMPT="%F{245}%~%f %(?..%F{red}[%?]%f )%(!.#.$) ";
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

      # Dirs
      export htw=~/Sync/HTW

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

      # URL
      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic
      autoload -Uz bracketed-paste-magic
      zle -N bracketed-paste bracketed-paste-magic


      # Functions
      function pandoc-pdf {
        title=$(grep -oP '(?<=^title: ).*' ''${1})
        pdf_name="''${title:-''${1:r}}"
        pandoc --metadata-file=${pandoc-pdf-template}/share/pdf.yaml \
          "''${@:2}" "$1" -o "''${pdf_name}.pdf" && open "''${pdf_name}.pdf"
      }
      function cht {
        curl "https://cht.sh/''${1}" | less -R
      }
    '';
  };
}
