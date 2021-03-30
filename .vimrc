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
Plug 'junegunn/fzf.vim'
Plug 'posva/vim-vue'
Plug 'wsdjeg/vim-fetch'
Plug 'jpalardy/vim-slime'


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
nnoremap <leader>q :bp<CR>:bd! #<CR>
" close other tabs
nnoremap <leader>Q :BufOnly<CR>
" start an Rg search
nnoremap <leader>a :Ack!<space>
nnoremap <leader>/ :Rg<CR>
" find refs to current symbol
nnoremap gs :execute "Ack! -w '" . expand("<cword>")."'"<CR>

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
" Delete / keep lines with pattern
command! -nargs=1 Del :%!rg -avS '<args>'
command! -nargs=1 Keep :%!rg -aS '<args>'
" Use as hex editor
command! -nargs=* Xc :!xc "<args>"
command Hex :%!xxd
command Unhex :%!xxd -r
" Cat contents to output for copying to clipboard
command -range=% Cat :<line1>,<line2>.write! $HOME/.vim/buffer_tmp | execute "!cat $HOME/.vim/buffer_tmp" | call delete(expand("$HOME/.vim/buffer_tmp"))
" Use ripgrep with fzf to search in all files
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
" UltiSnips config
let g:UltiSnipsExpandTrigger="<C-a>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
let g:tern_request_timeout = 1
" let g:tern_show_signature_in_pum = 0
" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]
" Use rg for Ack
let g:ackprg = 'rg --vimgrep'
" Navigate Ack list
nnoremap <silent> [a :cprevious<CR>
nnoremap <silent> ]a :cnext<CR>
" Vim slime target is tmux
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_no_mappings = 1
xmap <leader>c <Plug>SlimeRegionSend
nmap <leader>c <Plug>SlimeParagraphSend


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
