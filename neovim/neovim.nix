{ pkgs, ... }:

{
  home.packages = [
    pkgs.xclip # for clipboard support
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    vimAlias = true;
    extraConfig = ''
      set termguicolors
      colorscheme gruvbox

      set title
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
      nnoremap <silent> <F3> :silent make \| redraw! <CR>

      " Quickfix window auto open
      " https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make
      au QuickFixCmdPost [^l]* nested cwindow
      au QuickFixCmdPOst    l* nested lwindow

      " Edit vimrc from home-manager config
      function! EditVimrc()
        let name = execute(":filter /init.vim/ scriptnames")
        execute(":edit " . split(name)[1])
      endfunction
      command! EditVimrc call EditVimrc()

      " latex
      let g:tex_flavor='latex'
      let g:vimtex_quickfix_mode=0
      set conceallevel=1
      let g:tex_conceal='abdmg'

      " shell scripts
      autocmd FileType sh :set makeprg=shellcheck\ -o\ all\ -f\ gcc\ %
      " autocmd Filetype sh :au BufWritePost * silent make | redraw!

      " java
      autocmd FileType java :set makeprg=javac\ %
      autocmd FileType java :set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#

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
}
