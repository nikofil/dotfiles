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
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'

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
set timeoutlen=300      " timeout for key combinations

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
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 14
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=L  "remove left-hand scroll bar
set clipboard=unnamedplus  "X clipboard as unnamed

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" close current tab
nnoremap <leader>q :bp<cr>:bd #<cr>

nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>

map <C-n> :NERDTreeToggle<CR>

" EasyMotion bindings
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" move in insert mode
inoremap <C-w> <C-o>w
inoremap <C-b> <C-o>b
inoremap <C-e> <C-o>e
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l

" start nerdtree if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" close vim if NerdTree is last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
