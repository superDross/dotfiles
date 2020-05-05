"""" LOWSPEC """""""""""""""""""""""""""""""""""""""
" These settings increase speed of vim on low spec hardware

" UNCOMMENT ME ON OLD SYSTEMS use old regex engine
"set re=1

" does stuff woth Highlighting_matching_pairs()
" let g:loaded_matchparen=1
" let g:matchparen_timeout = 2
" let g:matchparen_insert_timeout = 2
" set noshowmatch

"""" GENERAL """"""""""""""""""""""""""""""""""""""""""""""""

" vertical split adds to right of current window
set splitright

" stops the wrap text over line from doing so mid-word
set linebreak

" keeps indentation when text wraps over line
set breakindent

" get backspace to work as expected
set backspace=indent,eol,start

" always show statusline
set laststatus=2

" ignore casing when searching
set ignorecase
set smartcase

" incremental highlighting
set incsearch

" all required for numerous plugins to work as expected
set nocompatible
filetype on
filetype plugin on

" syntax highlighting on for first 200 characters of each line
syntax on
if expand('%:e') !=# 'md'
  set synmaxcol=1000
endif

" Insert line numbering
set relativenumber
set number

" turns off mouse use in vim
set mouse=c

" use system clipboard
if has('macunix')
  set clipboard+=unnamed
else
  set clipboard+=unnamedplus
  set guioptions+=a
endif

" better colours
set background=dark
set t_Co=256

" " termguicolors causes tmux vim sessions to go monochrome
" if !exists('$TMUX')
"   set termguicolors
" endif

" Enable true colours in TMUX
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Allows completion with words
set dictionary=/usr/share/dict/words
set thesaurus=~/.vim/thesaurus.txt

" split creates pane on bottom of the screen
set splitbelow

" previw window height set to 10
set previewheight=10

" sustain tab names over sessions
set sessionoptions+=tabpages,globals

" prevents autocompletion and auto selection, must press key to complete
set completeopt+=noinsert,noselect
" allow menu popup even if there is only one match
set completeopt+=menu,menuone
" disable preview window with completions, but allow popup
set completeopt-=preview
if v:version >= 802
  set completeopt+=popup
endif

" stops completion messages being spammed
set shortmess=c

" Vim jumps to the last position when reopening a file
if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" spellchecker for commit messages
if expand('%:t') ==# 'COMMIT_EDITMSG'
  set spell spelllang=en_gb
endif

" extends functionality of %
runtime macros/matchit.vim

" automatically resizes the window when it has moved
autocmd VimResized * wincmd =

"""" KEY BINDINGS """"""""""""""""""""""""""""""""""""
" make space leader
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" Stop using the arrow keys in both Insert and Escape mode respectively
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" tab commands
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>

" function keys
noremap <leader>0 :set hlsearch! hlsearch?<CR>
noremap <leader>5 :Lexplore<CR>
noremap <F1> <nop>
inoremap <F1> <nop>

" open terminal
nnoremap <silent> <Leader>t :term ++rows=15<CR>

"""" FOLDING """"""""""""""""""""""""""""""""
" see docstring for folded code
let g:SimpylFold_docstring_preview=1
set foldnestmax=2

" Enable folding,
if expand('%:t') =~# 'vimrc' || expand('%:e') ==# 'vim'
    set foldmethod=expr
    set foldexpr=getline(v:lnum)=~#'^\"\"\"\"'?'\>1':'='
else
    set foldmethod=indent
endif

" automatically fold everything in vim files
autocmd VimEnter *vimrc :normal zM
autocmd VimEnter *.vim :normal zM

set foldlevel=99

"""" STATUSLINE """"""""""""""""""""""""""""""""""""""""""""
" vy basic, needs more work
set statusline=%f%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

"""" VIMGREP """"""""""""""""""""""""""""""""""""""""""""""""""""""
" open results in the quickfix menu
augroup myvimrc
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    lwindow
augroup END

" grep excutables
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('rg')
    set grepprg=rg
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
"""" WILD SETTINGS """"""""""""""""""""""""""""""""""""""""""""
" built-in fuzzy file menu
" current buffer e.g. :find Ap<TAB>
" new tab        e.g. :tabfind Ap<TAB>
" horz split     e.g. :sfind Ap<TAB>
set path+=**
set wildmenu

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico,*.pyc
set wildignore+=*.pdf,*.psd
set wildignore+=*node_modules/*,*bower_components/*,*venv/*,*__pycache__/*
"""" VIMUNDO """"""""""""""""""""""""""""""""""""""""""""""""""""
" 'unlimited' number of undo's
set undolevels=10000000

" set a directory to store undo data
set undodir=~/.vim/vimundo/

" create undo files allowing one to undo even after a system reboot
set undofile

"""" PYTHON SETTINGS """"""""""""""""""""""""""""""""""""""""""""""
" automatic indentation i.e. after def(x):
filetype plugin indent on

" UTF8 for python use
set encoding=utf-8

" Make your python code pretty with superior syntax highlighting
let python_highlight_all=1

"""" JAVASCRIPT SETTINGS """""""""""""""""""""""""""""""""""""""""""
" syntax highlighting for jsdocs
let g:javascript_plugin_jsdocs = 1

" set syntax to jsx
autocmd FileType javascript setlocal filetype=javascript.jsx
autocmd FileType javascript setlocal syntax=javascript.jsx

" folding comments
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END
let g:javascript_conceal_arrow_function = '⇒'

" indentation spacing
augroup BufNewFile,BufRead *.js,*.html,*.css,*.jsx
  set expandtab
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
augroup END

"""" OMNICOMPLETION """""""""""""""""""""""""""""""""""""""""""""""""
set omnifunc=syntaxcomplete#Complete

"""" NETRW """""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_winsize = 25    " set width 25% of page
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

"""" SNIPPETS """""""""""""""""""""""""""""""""""""""
" type pudb.remote in innsert mode and space afterward will insert the below
" text
iabbrev pudb_remote from pudb.remote import set_trace; set_trace(term_size=(160, 40),host='0.0.0.0', port=6900)
iabbrev pudb import pudb;pudb.set_trace()
iabbrev pdb import pdb;pdb.set_trace()
iabbrev remote_pdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 6900).set_trace()
iabbrev ipdb import ipdb;ipdb.set_trace()
iabbrev pytrace import pytest;pytest.set_trace()
