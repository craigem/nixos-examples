# An example of a stub vim configuration for NixOS

with import <nixpkgs> {};

vim_configurable.customize {
  name = "vim";   # Specifies the vim binary name.
  # Below you can specify what usually goes into `~/.vimrc`
  vimrcConfig.customRC = ''
    " Preferred global default settings:
    set number                    " Enable line numbers by default
    set background=dark           " Set the default background to dark or light
    set smartindent               " Automatically insert extra level of indentation
    set tabstop=4                 " Default tabstop
    set shiftwidth=4              " Default indent spacing
    set expandtab                 " Expand [TABS] to spaces
    syntax enable                 " Enable syntax highlighting
    colorscheme solarized         " Set the default colour scheme
    set t_Co=256                  " use 265 colors in vim
    set spell spelllang=en_au     " Default spell checking language
    hi clear SpellBad             " Clear any unwanted default settings
    hi SpellBad cterm=underline   " Set the spell checking highlight style
    hi SpellBad ctermbg=NONE      " Set the spell checking highlight background
    match ErrorMsg '\s\+$'        "

    let g:airline_powerline_fonts = 1   " Use powerline fonts
    let g:airline_theme='solarized'     " Set the airline theme

    set laststatus=2   " Set up the status line so it's coloured and always on

    " Add more settings below
  '';
  # store your plugins in Vim packages
  vimrcConfig.packages.myVimPackage = with pkgs.vimPlugins; {
    start = [               # Plugins loaded on launch
      airline               # Lean & mean status/tabline for vim that's light as air
      solarized             # Solarized colours for Vim
      vim-airline-themes    # Collection of themes for airlin
      vim-nix               # Support for writing Nix expressions in vim
    ];
    # manually loadable by calling `:packadd $plugin-name`
    # opt = [ phpCompletion elm-vim ];
    # To automatically load a plugin when opening a filetype, add vimrc lines like:
    # autocmd FileType php :packadd phpCompletion
  };
}
