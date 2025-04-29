set encoding=utf-8
set number
set title
set softtabstop=2
set binary noeol
set nohlsearch
set laststatus=2
set wildmenu
set clipboard+=unnamed
set path+=$PWD/**

set incsearch
set hlsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac
set wrap
set shiftwidth=2
set background=dark
set syntax=enable

if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
  exe 'set undodir=' .. undo_path
  set undofile
endif

call plug#begin('~/.vim/plugged')
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'fatih/vim-go'
  Plug 'google/vim-jsonnet'
  Plug 'hashivim/vim-terraform' , { 'for': 'terraform' }
  Plug 'towolf/vim-helm'
call plug#end()


if executable('terraform-lsp')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'terraform-lsp',
    \ 'cmd': {server_info->['terraform-lsp']},
    \ 'whitelist': ['terraform','tf'],
    \ })
endif