"""" LOWSPEC """""""""""""""""""""""""""""""""""""""
" These settings increase speed of vim on low spec hardware

" UNCOMMENT ME ON OLD SYSTEMS use old regex engine
"set re=1

" does stuff woth Highlighting_matching_pairs()
" let g:loaded_matchparen=1
" let g:matchparen_timeout = 2
" let g:matchparen_insert_timeout = 2
" set noshowmatch

"""" FUNCTIONS """"""""""""""""""""""""""""""""""""""""""""""
function! SpellingToggle()
  if &spell ==# 0
    echo 'spelling on'
    setlocal spell spelllang=en_gb
    hi SpellBad cterm=underline ctermfg=Red
  else
    echo 'spelling off'
    setlocal nospell
  endif
endfunction

function! ShowLeaderMappings()
  redir @a
  execute "silent! map \<leader\>"
  redir END
  let mappings = split(getreg("a"), "\n")
  let mappingz = map(mappings, "v:val[1:]")
  let sorted_maps = join(uniq(sort(mappingz)), "\n")
  echo "LEADER MAPPINGS:\n" . sorted_maps
endfunction

"""" GENERAL """"""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <Leader>s :call SpellingToggle()<CR>

" stop vim equalising window sizes when a window is closed or opened
set noequalalways

" vertical split adds to right of current window
set splitright

" reduce update time; good for multiple async plugins
set updatetime=100

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

" do not maintain compatability with vi
set nocompatible

" filetype detection with plugin and indentation loading
filetype plugin indent on

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

" extends functionality of %
runtime macros/matchit.vim

" automatically resizes the window when it has moved
autocmd VimResized * wincmd =

"""" KEY BINDINGS """"""""""""""""""""""""""""""""""""
" make space leader
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" Copy and paste to clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p

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
nnoremap <silent> <Leader>T :vertical terminal<CR>


" toggle spelling
nnoremap <silent> <Leader>s :call SpellingToggle()<CR>

" show all leader mappings
nnoremap <Leader>l :call ShowLeaderMappings()<CR>

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

"""" SNIPPETS """""""""""""""""""""""""""""""""""""""
" type pudb.remote in innsert mode and space afterward will insert the below
" text
iabbrev pudb_remote from pudb.remote import set_trace; set_trace(term_size=(160, 40),host='0.0.0.0', port=6900)  # fmt: skip
iabbrev pudb import pudb;pudb.set_trace()  # fmt: skip
iabbrev pdb import pdb;pdb.set_trace()  # fmt: skip
iabbrev remote_pdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip
iabbrev rpdb from remote_pdb import RemotePdb;RemotePdb('0.0.0.0', 4444).set_trace()  # fmt: skip
iabbrev ipdb import ipdb;ipdb.set_trace()  # fmt: skip
iabbrev pytrace import pytest;pytest.set_trace()  # fmt: skip
