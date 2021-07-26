" Personal configuration for Vim

runtime! debian.vim
syntax on

set background=dark
set mouse=a
set number
set showcmd
set showmatch
set smartcase

" Source a global configuration file if available

if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
