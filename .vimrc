set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/badwolf'
Plugin 'moll/vim-bbye'
Plugin 'bling/vim-airline'
" Plugin 'vim-scripts/vcscommand.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ludovicchabant/vim-lawrencium'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader=","       " leader is comma

set t_Co=256
colorscheme badwolf         " awesome colorscheme
syntax enable           " enable syntax processing
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " spaces in newline start
set expandtab       " tabs are spaces
set number              " show line numbers
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
set showmatch           " highlight matching [{()}]

set so=5                " lines to cursor
set backspace=2         " make backspace work like most other apps
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " do case insensitive matching
set smartcase           " do smart case matching
set hidden

" CtrlP settings
"let g:ctrlp_match_window = 'bottom,order:ttb'
"let g:ctrlp_switch_buffer = 0
"let g:ctrlp_working_path_mode = 0
"let g:Powerline_symbols = 'fancy'

" Settings for airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#use_vcscommand = 1
let g:airline#extensions#tabline#enabled = 1

set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set laststatus=2
set guifont=Inconsolata-g\ for\ Powerline\ Medium:h13

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>

map <C-n> :NERDTreeToggle<CR>

