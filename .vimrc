set term=xterm-256color
"solarized options 
set mouse=a
set number
set autoindent
set history=700
"Turn on the WiLd menu
set wildmenu
set wildmode=list:longest
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set ruler
set hlsearch
set showmatch
set noerrorbells
set novisualbell
set nocompatible              " be iMproved, required
filetype off                  " required
set clipboard=unnamed
set ts=4
set lcs=tab:>.,trail:-
set list
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab
set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set visualbell
" set cursorline
set ttyfast
set backspace=indent,eol,start
set relativenumber
set undofile
set undodir="~/undo_files"
"set leader key
let mapleader = ","
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set incsearch
set ignorecase smartcase
set gdefault
"leader keys and remaps
nnoremap <leader><space> :noh<cr>
nnoremap <leader>v V`]
nnoremap <leader>n :NERDTree<cr>
nnoremap <leader>y :YRShow<cr>
inoremap <leader>y <ESC>:YRShow<cr>
inoremap jj <ESC>
inoremap xx <C-x><C-o>
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <tab> %
vnoremap <tab> %
nnoremap ; :
nnoremap <leader>] :tabn<cr>
nnoremap <leader>[ :tabp<cr>
nnoremap <leader>p :tabe 
nnoremap <leader>/ :ls<cr>:pwd<cr>
"end leader keys 
set nowrap
set textwidth=79
set formatoptions=qrn1
let &t_Co=256
au BufNewFile,BufRead *.phph set filetype=php
au BufNewFile,BufRead *.php3 set filetype=php
au BufNewFile,BufRead *.html set filetype=php
au BufNewFile,BufRead *.phtml set filetype=php
au BufNewFile,BufRead *.js set filetype=javascript
au BufNewFile,BufRead *.jsx set filetype=javascript
"Highlight JSX in non-JSX files
let g:jsx_ext_required = 0
"Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Syntastic config
let g:syntastic_enable_signs = 1 " check if this slows things down
let g:syntastic_check_on_open = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_auto_jump = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 1
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS

call vundle#begin()
Bundle 'gmarik/vundle'
"alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
"The following are examples of different formats supported.
"Keep Plugin commands between vundle#begin/end.
"plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
"plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'

Plugin 'yankring.vim'
Plugin 'git://git.wincent.com/command-t.git'
"git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
"The sparkup vim script is in a subdirectory of this repo called vim.
"Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Plugin 'joonty/vdebug'

" Javascript Syntax Support
Plugin 'elzr/vim-json', { 'for': 'json' }
Plugin 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx']  }" Javascript Syntax
" Plugin 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx']  }" Javascript Syntax
" Plugin 'gavocanov/vim-js-indent', { 'for': ['javascript', 'javascript.jsx'] } " Javascript Indenting
Plugin 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] } " JSX Support for React
Plugin 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'javascript.jsx'] } "JSDoc suto-snippets
Plugin 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] } " Extras for javascript Libraries
Plugin 'editorconfig/editorconfig-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'Syntastic'
Plugin 'scrooloose/NERDTree'
Plugin 'jistr/vim-nerdtree-tabs'

" All of your Plugins must be added before the following line
call vundle#end()            " required
syntax enable
" To ignore plugin indent changes, instead use:
filetype plugin on
"
" Brief help
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
