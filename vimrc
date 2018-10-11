"""""" GLOBAL VARS """""""""""""""""""""""""""""""""""
" stores current opened file extension
let extension = expand('%:e')

"""""" VUNDLE """"""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set runtimepath+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" CODE JUMPING: jump to a function or class definition in the code base
Plugin 'ludovicchabant/vim-gutentags'

" VUNDLE: vim package manager. within vim PluginInstall
Plugin 'gmarik/Vundle.vim'

" AUTOCOMPLETION: autocompletes as you type
if extension ==# 'py'
	Plugin 'davidhalter/jedi-vim'
else
	Plugin 'ajh17/VimCompletesMe'
endif
" use tab for all completion needs
Plugin 'ervandew/supertab'

" LINTERS: syntax checkers; dependent upon flake8.
if v:version < 800
	" slow, only lints after saving
    Plugin 'scrooloose/syntastic'
else
    " lint as you type
    Plugin 'w0rp/ale'
endif
Plugin 'nvie/vim-flake8'
Plugin 'koalaman/shellcheck'
Plugin 'jimhester/lintr'

" HIGHLIGHTING: syntax highlighters for non-python languages
Plugin 'vim-scripts/Vim-R-plugin'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'sheerun/vim-polyglot'

" FILES: explore dirs in another buffer
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" INDENTLINES: indentations marked by vertical lines
Plugin 'Yggdroot/indentLine'

" GIT: use git commands in vim e.g. Glog
Plugin 'tpope/vim-fugitive'

" MARKDOWN: preview markdown files
Plugin 'JamshedVesuna/vim-markdown-preview'

"OUTPUT: execute commands in a new buffer
Plugin 'vim-scripts/RunView'

"HIGHLIGHTING: highlights regex changes during typing
Plugin 'markonm/traces.vim'

" COLORSCHEMES: various colorschemes. copy all schemes to ~/.vim/colors
Plugin 'flazz/vim-colorschemes'
Plugin 'owickstrom/vim-colors-paramount'
Plugin 'aereal/vim-colors-japanesque'
Plugin 'rakr/vim-two-firewatch'
Plugin 'hhsnopek/vim-firewatch'
Plugin 'bcicen/vim-vice'
Plugin 'pbrisbin/vim-colors-off'
Plugin 'thoresuenert/vim-github-colorscheme'
Plugin 'morhetz/gruvbox'

"EXTENDED FUNCTION: further improve editing
Plugin 'tpope/vim-surround'
Plugin 'tommcdo/vim-lion'  " align around a character

" CSV: manipulate CSV files easily (READ THE DOCS)
Plugin 'chrisbra/csv.vim'

" HTML: automates HTML tags (check tutorial)
Plugin 'mattn/emmet-vim'

" STATUSLINE: lightweight status line
Plugin 'itchyny/lightline.vim'

" FILEFINDER: fuzzy file finder
Plugin 'junegunn/fzf'

" TAB RENAMING: allows one to rename vim tabs and sustain them over sessions
Plugin 'gcmt/taboo.vim'

call vundle#end()


""""" JEDI """""""""""""""""""""""""""""""""""""""""""
" set completion menu to preview (no definitions in python)
set completeopt-=preview

" smart mappings break iabbrev, so turn it off
let g:jedi#smart_auto_mappings = 0

""""" ALE """"""""""""""""""""""""""""""""""""""""""""""""
if v:version >= 800
    let g:ale_fixers = {
	\    '*': ['remove_trailing_lines', 'trim_whitespace'],
    \    'python': ['autopep8'],
	\    'javascript': ['eslint', 'prettier-eslint'],
	\    'html': ['tidy'],
    \}
endif

let g:ale_completion_enabled = 1
let g:ale_echo_msg_format = '%s [%linter%]'

"""""" SYNTASTIC """"""""""""""""""""""""""""""""""""""
if v:version < 800
    " disable syntastic on the statusline (it messes with RunView F10)
    let g:statline_syntastic = 0

    " automatically load errors into location list
    let g:syntastic_always_populate_loc_list = 1

    " automatically check for errors when file is loaded
    let g:syntastic_check_on_open = 1

    " recommended settings
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    " ignore certain PEP8 guidelines that moan about whitespace/indentation errors
    let g:syntastic_python_flake8_args='--ignore=E501,W601,E231,W291,W293,E302,E401,E101,W191,E261,E226,E303,W391,E304,E225,E271,E203'
endif

"""""" RUNVIEW """"""""""""""""""""""""""""""""""""""""""""
" runview works with python
let g:runview_filtcmd='python3'

" check file extension and parse appropriate command to runview and assign to F12
let filename = expand('%:p')
let extension = expand('%:e')
let extension_dict = {'py': '%RunView!python3', 'sh': '%RunView!sh', 'js': '%RunView!node'}
let extension_command = get(extension_dict, extension)

""""" NERDTree """""""""""""""""""""""""""""""""""""""""""""
" refresh the file tree upon opening
function! NERDTreeRefresh()
    if &filetype ==# 'nerdtree'
        silent exe substitute(mapcheck('R'), '<CR>', '', '')
    endif
endfunction

autocmd BufEnter * call NERDTreeRefresh()

" git symbol definitions
let g:NERDTreeIndicatorMapCustom = {
    \ 'Modified'  : '✹',
    \ 'Staged'    : '✚',
    \ 'Untracked' : '✭',
    \ 'Renamed'   : '➜',
    \ 'Unmerged'  : '═',
    \ 'Deleted'   : '✖',
    \ 'Dirty'     : '✗',
    \ 'Clean'     : '✔︎',
    \ 'Ignored'   : '☒',
    \ 'Unknown'   : '?'
    \ }


" NERDTree thingy
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Hide .pyc files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree"

""""" FOLDING """"""""""""""""""""""""""""""""
" see docstring for folded code
let g:SimpylFold_docstring_preview=1
set foldnestmax=2

" Enable folding,
set foldmethod=indent
set foldlevel=99

""""" COLORSCHEME """"""""""""""""""""""""""""""
set background=dark
colorscheme gruvbox
set t_Co=256

if g:colors_name !=# 'solarized'
    " This plugin brings GVIM like colors to colorschemes, but doesn't work
    " well with solarized
    Plugin 'godlygeek/csapprox'
endif

"""" CHEATSHEET """""""""""""""""""""""""""""""""""""""""""""""""""""""
function! Cheat()
	echo 'VIM'
	echo '    A            = append after end of line'
	echo '    U            = undo all cjhange on the line'
	echo '    R            = replace mode'
	echo '    r<letter>    = replace letter at cursor with <letter>'
	echo '    %            = skip to closing bracker'
	echo '    :%s/,/./gc   = c asks for permission to make each change'
	echo '    v :w         = save text highlighted in visual mode'
	echo '    :r <file>    = place <file> contents into current buffer'
	echo 'FUNCTION KEYS'
	echo '    F2           = paste toggle'
	echo '    F3           = ALEFix'
	echo '    F4           = NERDTreeToggle'
	echo '    F5           = view this cheatsheet'
	echo '    F6           = source .vimrc'
	echo '    F7           = call flake8'
	echo '    F8           = save generic session ~/Session.vim'
	echo '    F9           = toggle highlight search'
	echo '    F12          = RunView'
	echo 'GUTENTAGS'
    echo '    C-\\         = open definition in a new vs window'
    echo '    C-/          = open definition in a new sp window'
	echo '    \ C-]        = open definition in a new tab.'
	echo '    C-]          = go to definition location'
	echo '    g-]          = give a list of all possible locations'
	echo '    C-t          = got to previous location'
	echo 'FZF'
	echo '    \\-f         = fuzzy find file'
	echo '    C-v          = open fuzzy found file in a vs window'
	echo '    C-x          = open fuzzy found file in a sp window'
	echo '    C-t          = open fuzzy found file in a new tab window'
	echo 'ALE'
	echo '    \\-j         = go to line with next mistake'
	echo '    \\-k         = go to line with previous mistake'
	echo 'SESSIONS'
	echo '   :mks t.vim     = create vim session'
	echo '   vim -S t.vim   = reopen vim session'
	echo 'TABS'
	echo '   \\-Num          = go tab number'
	echo '   C-Right         = go to next tab'
	echo '   S-Tab           = go to next tab'
	echo '   C-Left          = go to previous tab'
	echo '   C-Up            = list all tabs'
	echo '   C-Down          = open the vim help page in a new tab'
	echo '   :tabe f.txt     = open file in a new tab'
	echo 'GENERAL'
	echo '   K             = show docs (python only)'
	echo '   C-b           = insert pudb trace'
	echo '   C-w x         = swap column/row panes'
	echo '   C-w K         = move window to the topmost'
	echo '   C-w H         = move window to the bottomost'
	echo 'LION'
	echo '   gl<key>       = align <key> vertically'
endfunction

"""" CUSTOM KEY BINDINGS """"""""""""""""""""""""""""""""""""""
" function keys
set pastetoggle=<F2>
map <F3> :ALEFix<CR>
map <F4> :NERDTreeToggle<CR>
noremap <F5> :call Cheat() <CR>
nnoremap <F6> :exec 'source $VIMRC'<CR>
nnoremap <F8> :mks!<CR>
noremap <F9> :set hlsearch! hlsearch?<CR>
" runview
nnoremap <buffer> <F12> :exec extension_command<Bar>exec 'resize 40'<CR>

" jump to next and previous error
nmap <silent> <leader>j :ALENext<CR>
nmap <silent> <leader>k :ALEPrevious<CR>

" CTRL+\ to open definition location in a new vertical window
map <C-\> :vs<CR><C-]><C-w>
" Leader CTRL+] to open definition in new tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
" CTRL+/ to open definition location in a new horizontal window
map <C-_> :sp<CR><C-]><C-w>

" tab commands
nnoremap <C-j> :tabs<CR>
nnoremap <C-k> :tab help<CR>
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

" fuzzy file finder key
nnoremap <leader>f :FZF<CR>

" open terminal, resize height, change pane position to bottom.
nnoremap <leader>t :bo new<bar>terminal ++curwin ++rows=15<CR>

" Set the space as key enabler
nnoremap <space> za

" Stop using the arrow keys in both Insert and Escape mode respectively
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" turns off mouse use in vim
set mouse=c

"""" SNIPPETS """""""""""""""""""""""""""""""""""""""
" type pudb.remote in innsert mode and space afterward will insert the below
" text
iabbrev pudb_remote from pudb.remote import set_trace; set_trace(term_size=(160, 40),host='0.0.0.0', port=6900)

" C-b in insert mode will add test string into file
imap <C-b> test

"""" USER SETTINGS """"""""""""""""""""""""""""""""""""
" stops the wrap text over line from doing so mid-word
set linebreak

" keeps indentation when text wraps over line
set breakindent

" make indentations (tab characters) appear 4-spaces wide instead of 8
set tabstop=4

" all required for numerous plugins to work as expected
set nocompatible
filetype on
filetype plugin on

" Insert line numbering
set relativenumber

" use system clipboard
set clipboard+=unnamedplus
set guioptions+=a

" Uncomment the following to have Vim jump to the last position when reopening a file
if has('autocmd')
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"""" VIMUNDO """"""""""""""""""""""""""""""""""""""""""""""""""""
" 'unlimited' number of undo's
set undolevels=10000000

" set a directory to store undo data
set undodir=~/.vim/vimundo/

" create undo files allowing one to undo even after a system reboot
set undofile

""""" PYTHON SETTINGS """"""""""""""""""""""""""""""""""""""""""""""
" automatic indentation i.e. after def(x):
filetype plugin indent on

" UTF8 for python use
set encoding=utf-8

" Make your python code pretty with superior syntax highlighting
let python_highlight_all=1
syntax on

""""" R SETTINGS """"""""""""""""""""""""""""""""""""""""""""""""""""
let vimrplugin_assign = 0

""""" JAVASCRIPT SETTINGS """""""""""""""""""""""""""""""""""""""""""
" syntax highlighting for jsdocs
let g:javascript_plugin_jsdocs = 1

" sets tab key to 2 spaces
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab

" folding comments
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END
let g:javascript_conceal_arrow_function = '⇒'

""""" DICTIONARY """"""""""""""""""""""""""""""""""""""""""""""""""""
" Allows autocompletion with words
set dictionary=/usr/share/dict/words

"""" GRIP SETTINGS """"""""""""""""""""""""""""""""""""""""""""""""""
" makes all markdown previews in GitHub style
let vim_markdown_preview_github=1

"""" HTML/CSS """""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable emmet only for HTML and CSS files
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"""" OMNICOMPLETION """""""""""""""""""""""""""""""""""""""""""""""""
augroup OmniCompletionSetup
    autocmd!
    autocmd FileType c          set omnifunc=ccomplete#Complete
    autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
    " autocmd FileType python     set omnifunc=python3complete#Complete
    autocmd FileType python     set omnifunc=jedi#completions
    autocmd FileType ruby       set omnifunc=rubycomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
augroup END

"""" VIMCOMPLETESME """"""""""""""""""""""""""""""""""""""""""""""""""
" TAB key in insert mode autocompletes OmniCompletion
let b:vcm_tab_complete = 'omni'

""" LIGHTLINE """"""""""""""""""""""""""""""""""""""""""""""""""""""""
" always show statusline
set laststatus=2
" mo longer show mode in bottom line
set noshowmode

" show git branch in status line
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

"""" INDENTLINE """""""""""""""""""""""""""""""""""""""""""""""""""""""
" make it more efficient
let g:indentLine_faster = 1
let g:indentLine_setConceal = 0

"""" SUPERTAB """""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map tab to omni-completion
let g:SuperTabDefaultCompletionType = '<C-X><C-O>'

"""" POLYGLOT """""""""""""""""""""""""""""""""""""""""""""""""""""""""
" work around for the PolyGlot GraphQL error in Javascript files
let g:polyglot_disabled = ['graphql', 'markdown']

"""" GUTENTAGS """""""""""""""""""""""""""""""""""""""""""""""""""""""
" add tag generation messages to statusline
set statusline+=%{gutentags#statusline()}

"""" TABOO """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" sustain tab names over sessions
set sessionoptions+=tabpages,globals
" naming format
let g:taboo_renamed_tab_format = " %l %m "
