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
" stops the wrap text over line from doing so mid-word
set linebreak

" keeps indentation when text wraps over line
set breakindent

" get backspace to work as expected
set backspace=indent,eol,start

" always show statusline
set laststatus=2

" all required for numerous plugins to work as expected
set nocompatible
filetype on
filetype plugin on

" syntax highlighting on for first 200 characters of each line
syntax on
set synmaxcol=200


" Insert line numbering
set relativenumber
set number

" use system clipboard
set clipboard+=unnamedplus
set guioptions+=a

" better colours
set background=dark
set t_Co=256

" termguicolors causes tmux vim sessions to go monochrome
if !exists('$TMUX')
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
set completeopt+=noinsert
set completeopt+=noselect
" disable preview window with completions
set completeopt-=preview

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

"""" FUNCTIONS """""""""""""""""""""""""""""""
" open terminal
function! TerminalSize(...)
  if len(a:000) ==# 0
    let rows = 15
  else
    let rows = a:1
  endif
  execute ':terminal ++rows=' . rows . '<CR>'
endfunction

command! -nargs=? LittleTerminal :call TerminalSize(<f-args>)
cnoreabbrev sterm LittleTerminal

" update the tag file
function! UpdateTagFile()
  let cmd =  '!ctags -R' .
             \ ' --exclude=.git' .
             \ ' --exclude=node_modules' .
             \ ' --exclude=venv' .
             \ ' --exclude=*.log' .
             \ ' --exclude=bundle' .
             \ ' --exclude=tmp' .
             \ ' --exclude=*.pyc' .
             \ ' --exclude=*.json' .
             \ ' --exclude=*.pyo'
  execute cmd
endfunction

command! UpdatedTags :call UpdateTagFile()
nnoremap <Leader>u : UpdatedTags<CR><CR>:echom 'Tag generation completed'<CR>

" convert a series of space delimited string to a list
function! String2List()
  execute ':s/\ /",\ "/g'
  execute ':s/^/["/'
  execute ':s/$/"]/'
endfunction

command! ListIt :call String2List()

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

" turns off mouse use in vim
set mouse=c

" source vimrc
nnoremap <leader>S :exec 'source $VIMRC'<CR>

" tab commands
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<CR>

" function keys
set pastetoggle=<F2>
nnoremap <F6> :call VimCheat() <CR>
nnoremap <F7> :call NewCommands()<CR>
noremap <F9> :set hlsearch! hlsearch?<CR>
noremap <F4> :Lexplore<CR>

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

"""" CHEATSHEET """""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! VimCheat()
  echo 'OPERATORS'
  echo '   c       change'
  echo '   d       delete'
  echo '   y       yank into register (does not change the text)'
  echo '   gq      text formatting'
  echo '   ~       swap case (only if tildeop is set)'
  echo '   >       shift right'
  echo '   <       shift left'
  echo '   !       filter through an external program'
  echo 'MOTIONS'
  echo '   l       a letter'
  echo '   b       last word'
  echo '   aw      a word'
  echo '   as      a sentence'
  echo '   ap      a paragraph'
  echo '   aa      an argument'
  echo '   a(      a parenthesis'
  echo '   at      a tag (html)'
  echo '   ia      in argument'
  echo '   i(      inside paranthesis'
  echo '   it      inside tag'
  echo '   t(      to paranthesis'
  echo '   f(      find paranthesis'
  echo 'NAVIGATION'
  echo '   zz      move cursor to middle screen'
  echo '   zt      move cursor to top screen'
  echo '   zb      move cursor to bottom screen'
  echo '   C-y     move screen up'
  echo '   C-e     move screen down'
  echo '   ^       first non whitespace character on the line'
  echo '   g_      last non whitespace character on the line'
  echo '   +       got to first non whitespace character on the next line'
  echo '   -       got to first non whitespace character on the previous line'
  echo '   W       move next big word'
  echo '   B       move to last big word'
  echo '   E       move to end big word'
  echo '   /pass   to "pass"'
  echo '   *       got to next occurrence of the string under the cursor'
  echo '   £       got to last occurrence of the string under the cursor'
  echo '   10%     move down 10% of the file'
  echo 'MARKS'
  echo '   mq      set mark to q'
  echo '   `q      move to mark'
  echo "   'q      move to the start of the marks line"
endfunction

function! NewCommands()
  echo 'NORMAL MODE'
  echo '   gi                                   start insert mode at the last inserted position'
  echo '   gx                                   open link under cursor in browser'
  echo '   6gcc                                 comment next 6 lines'
  echo '   ysw"                                 surround word with quotes'
  echo '   cs[{                                 change brackets to curly'
  echo '   z=                                   suggest spelling for word under cusor'
  echo '   gv                                   reselct last visual selection'
  echo '   C-o                                  normal mode for one command'
  echo '   *                                    search for word under cursor'
  echo '   d/Node                               delete from current os to word apple'
  echo 'COMMAND MODE'
  echo '   :tag ClassName                       jump to tag ClassName'
  echo '   :tjump ClassName                     jump to selected tag ClassName'
  echo '   :j                                   all selected text on the same line'
  echo '   :g/^$/d                              delete all empty lines'
  echo '   :v/^$/d                              delete all NON empty lines'
  echo '   :read !ls                            results of ls pate into buffer'
  echo '   :earier 10m                          undo to buffer 10 minutes ago'
  echo 'VISUAL'
  echo '   u                                    change to lower case'
  echo '   U                                    change to upper case'
  echo 'COMMANDLINE'
  echo '   find . -name "*.py" | xargs -o vim   open all py files in vim buffers'
endfunction
