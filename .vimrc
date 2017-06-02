"solarized options
set term=xterm-256color
set mouse=a
set number
set autoindent
set history=700
"Turn on the WiLd menu
set wildmenu
set wildmode=list:longest
set laststatus=2
set statusline+=%f
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
set confirm
"set expandtab
set encoding=utf-8
set scrolloff=3
" set cursorline
set ttyfast
set backspace=indent,eol,start
set relativenumber
set undofile
set undodir=~/undo_files/
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
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <tab> %
vnoremap <tab> %
nnoremap ; :
nnoremap } :BF<cr>
nnoremap { :BB<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>f :CtrlP<cr>
nnoremap <leader>d :BD<cr>
nnoremap K :Grepper -tool ag -cword -noprompt<cr>
nnoremap <leader>g :Grepper -tool ag<cr>
" nmap <silent> <C-[> <Plug>(ale_previous_wrap)
" nmap <silent> <C-]> <Plug>(ale_next_wrap)
set t_ku=OA
set t_kd=OB
set t_kr=OC
set t_kl=OD
set t_kB=[Z
let g:ctrlp_working_path_mode = 'w'
" The Silver Searcher
if executable('ag')

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor --ignore node_modules --ignore vendor --ignore logs --hidden -g "" --depth 15'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
	" Note we extract the column as well as the file and line number
	"set grepprg=ag\ --hidden\ --nogroup\ --nocolor\ --column
	"set grepformat=%f:%l:%c%m
endif
" Grepper search settings
let g:grepper = {}
let g:grepper.ag = { 'grepprg': 'ag --vimgrep --'}
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
" select first option
let g:neocomplete#enable_auto_select = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent><CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><Space> "\<Space>"
" AutoComplPop like behavior.
let g:neocomplete#enable_auto_select = 1

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets' behavior.
imap <expr><C-k> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><C-k> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: "\<TAB>"

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vimpkg/bundle/vim-react-snippets/snippets/'
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
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
" VDebug Config
let g:vdebug_features = { 'max_children': 500 }
" Airline Config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" ALE Config for linting
let g:ale_linters = {'javascript': ['eslint']}

" NERDCommenter Config
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

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

" PHP Debugging in VIM
Plugin 'joonty/vdebug'

Plugin 'scrooloose/nerdcommenter'

" Javascript Syntax Support
Plugin 'elzr/vim-json', { 'for': 'json' }
Plugin 'pangloss/vim-javascript'
" Plugin 'othree/yajs.vim', { 'for': ['javascript', 'javascript.jsx']  }" Javascript Syntax
" Plugin 'gavocanov/vim-js-indent', { 'for': ['javascript', 'javascript.jsx'] } " Javascript Indenting
Plugin 'mxw/vim-jsx'
Plugin 'heavenshell/vim-jsdoc', { 'for': ['javascript', 'javascript.jsx'] } "JSDoc suto-snippets
Plugin 'othree/javascript-libraries-syntax.vim', { 'for': ['javascript', 'javascript.jsx'] } " Extras for javascript Libraries
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/NERDTree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'vim-airline/vim-airline'
Plugin 'qpkorr/vim-bufkill'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-unimpaired'
Plugin 'justinj/vim-react-snippets'
Plugin 'ternjs/tern_for_vim'
Plugin 'mhinz/vim-grepper'
" All of your Plugins must be added before the following line
call vundle#end()            " required
syntax enable
colorscheme monokai
" To ignore plugin indent changes, instead use:
filetype plugin on
" autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
" set runtimepath^=~/.vim/bundle/ctrlp.vim

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
