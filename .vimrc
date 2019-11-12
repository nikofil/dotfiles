set nocompatible              " be iMproved, required

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'sjl/badwolf'
Plug 'moll/vim-bbye'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'mileszs/ack.vim'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'raimondi/delimitmate'
Plug 'schickling/vim-bufonly'
Plug 'henrik/vim-indexed-search'
Plug 'tpope/vim-repeat'
Plug 'scrooloose/nerdcommenter'
Plug 'myusuf3/numbers.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ajh17/VimCompletesMe'
Plug 'rodjek/vim-puppet'
Plug 'junegunn/fzf'
Plug 'posva/vim-vue'


" All of your Plugins must be added before the following line
call plug#end()

let mapleader=","       " leader is comma

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
set timeoutlen=500      " timeout for key combinations

set so=5                " lines to cursor
set backspace=2         " make backspace work like most other apps
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase          " do case insensitive matching
set smartcase           " do smart case matching
set hidden

" CtrlP settings
let g:ctrlp_cmd='CtrlPMRU'
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 2
let g:Powerline_symbols = 'fancy'

nnoremap <C-t> :FZF<CR>

" Indexed-search settings
let g:indexed_search_numbered_only = 1

" Settings for airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#use_vcscommand = 1
let g:airline#extensions#tabline#enabled = 1

set encoding=utf-8
set t_Co=256
colorscheme badwolf         " awesome colorscheme
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
nnoremap <leader>q :bp<CR>:bd #<CR>
" close other tabs
nnoremap <leader>Q :BufOnly<CR>
" start an Ag search
nnoremap <leader>a :Ag<space>

" global yank/put
vnoremap <leader>y :write! $HOME/.vim/yankbuffer<CR>
nnoremap <leader>y :.write! $HOME/.vim/yankbuffer<CR>
nnoremap <leader>p :read $HOME/.vim/yankbuffer<CR>

nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>

map <C-n> :NERDTreeToggle<CR>
" cd to current file dir
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" EasyMotion bindings
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
vmap s <Plug>(easymotion-f2)
" use smartcase
let g:EasyMotion_smartcase = 1
" indentLine line color
let g:indentLine_color_term = 239

" Path commands
command P :echo expand('%:p')
command Path :echo expand('%:p')
command Pwd :echo expand('%:p:h')
" Ag command
command -nargs=* Ag Ack <args>
" Delete / keep lines with pattern
command! -nargs=1 Del :%!grep -av '<args>'
command! -nargs=1 Keep :%!grep -a '<args>'
" UltiSnips config
let g:UltiSnipsExpandTrigger="<C-a>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:tern_request_timeout = 1
" let g:tern_show_signature_in_pum = 0
" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
" Use ag for Ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" move in insert mode
inoremap <C-w> <C-o>w
inoremap <C-b> <C-o>b
inoremap <C-e> <C-o>e
inoremap <C-h> <C-o>h
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-l> <C-o>l

" scroll with up/down
nmap <Up> <C-y>
nmap <Down> <C-e>

" close vim if NerdTree is last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
