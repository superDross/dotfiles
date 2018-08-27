"""""" KEY-MAP GUIDE """""""""""""""""""""""""""""""""""""
"F1 - //
"F2 - Paste Mode toggle
"F3 - ALEFix (white trailing space & autopep8)
"F4 - NERDTree toggle
"F5 - Dark/Light Theme toggle
"F6 - VIMRC reload
"F7 - FLAKE8 syntax check
"F8 - N/A
"F9 - N/A
"F10 - //
"F11 - //
"F12 - RunView
"ARROWS - change buffer
"SPACE - fold

"CTRL-P - preview markdown file


"""""" GLOBAL VARS """""""""""""""""""""""""""""""""""
let extension = expand('%:e')

"""""" VUNDLE """"""""""""""""""""""""""""""""""""""""
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'rakr/vim-togglebg'

" VUNDLE: vim package manager. within vim PluginInstall
Plugin 'gmarik/Vundle.vim'

" AUTOCOMPLETION: jedi-vim less intensive 
" VimCompletesMe only for non-python files
if extension == 'py'
	Plugin 'davidhalter/jedi-vim' 
else
	Plugin 'ajh17/VimCompletesMe'
endif

" SYNTAX: syntax checkers; dependent upon flake8, flake8 <F7>
if v:version < 800
    Plugin 'scrooloose/syntastic'     
else
    " lint as you type
    Plugin 'w0rp/ale'
endif
Plugin 'nvie/vim-flake8'        
Plugin 'koalaman/shellcheck'

" HIGHLIGHTING: syntax highlighters for non-python languages
" Plugin 'gabrielelana/vim-markdown'     
" Plugin 'vim-scripts/Vim-R-plugin'  
Plugin 'pangloss/vim-javascript'

" FILES: explore dirs in another buffer
Plugin 'scrooloose/nerdtree'    
Plugin 'jistr/vim-nerdtree-tabs'   

" GIT: use git commands in vim e.g. Glog
" Plugin 'tpope/vim-fugitive'          
"
" MARKDOWN: viewer
" requires additional installations, check github page
Plugin 'JamshedVesuna/vim-markdown-preview'

"OUTPUT: execute commands in a new buffer <F12>
Plugin 'vim-scripts/RunView'     

"HIGHLIGHTING: high
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

"CYGWIN: for cygwin only, not sure if this is actually required
if has("win32unix")
    Plugin 'mavnn/mintty-colors-solarized'
endif

" CSV: manipulate CSV files easily (READ THE DOCS)
Plugin 'chrisbra/csv.vim'

" HTML: automates HTML tags (check tutorial)
Plugin 'mattn/emmet-vim'


call vundle#end() 

""""" YCM/JEDI """""""""""""""""""""""""""""""""""""""""""
" set completion menu to preview
set completeopt-=preview


""""" ALE """"""""""""""""""""""""""""""""""""""""""""""""
if v:version >= 800
    let g:ale_fixers = {
    \    'python': ['trim_whitespace', 'remove_trailing_lines', 'autopep8'],
	\    'javascript': ['trim_whitespace', 'remove_trailing_lines', 'eslint', 'prettier-eslint'],
	\    'html': ['trim_whitespace', 'remove_trailing_lines', 'tidy'],
	\    'sh': ['trim_whitespace', 'remove_trailing_lines']
    \}
endif

let g:ale_completion_enabled = 1

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
    let g:syntastic_python_flake8_args="--ignore=E501,W601,E231,W291,W293,E302,E401,E101,W191,E261,E226,E303,W391,E304,E225,E271,E203"
endif

"""""" RUNVIEW """"""""""""""""""""""""""""""""""""""""""""
" runview works with python
let g:runview_filtcmd="python3"

" check file extension and parse appropriate command to runview and assign to
" F12
let filename = expand('%:p')
let extension = expand('%:e')
let extension_dict = {'py': '%RunView!python3', 'sh': '%RunView!sh', 'js': '%RunView!node'}
let extension_command = get(extension_dict, extension)

""""" NERDTree """""""""""""""""""""""""""""""""""""""""""""
" NERDTree thingy
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Hide .pyc files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree"

" Look at NERDTree with <F3>

""""" FOLDING """"""""""""""""""""""""""""""""
" see docstring for folded code
let g:SimpylFold_docstring_preview=1
set foldnestmax=2

" Enable folding, 
set foldmethod=indent
set foldlevel=99

" Set the space as key enabler
nnoremap <space> za

""""" COLORSCHEME """"""""""""""""""""""""""""""
set background=dark
colorscheme gruvbox
set t_Co=256

if g:colors_name != 'solarized'
    " This plugin brings GVIM like colors to colorschemes, but doesn't work
    " well with solarized
    Plugin 'godlygeek/csapprox'
endif


"""" KEY BINDINGS """"""""""""""""""""""""""""""""""""""
set pastetoggle=<F2>
map <F3> :ALEFix<CR>
map <F4> :NERDTreeToggle<CR>
"call on togglebg func and switch between dark and light solarized using F5
nnoremap <F6> :exec 'source $VIMRC'<cr>
nnoremap <buffer> <F12> :exec extension_command<Bar>exec 'resize 40'<cr>

" Stop using the arrow keys in both Insert and Escape mode respectively
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Switch panes by using CTRL + Arrow keys instead of CTRL + W
nnoremap <silent> <right> <c-w>l
nnoremap <silent> <left> <c-w>h
nnoremap <silent> <up> <c-w>k
nnoremap <silent> <down> <c-w>j

" turns off mouse use in vim
set mouse=c

"""" USER SETTINGS """"""""""""""""""""""""""""""""""""
" Alias for changing vertical size to 80
" nnoremap <F3> :exec 'vertical resize 80'<cr>

" stops the wrap text over line from doing so mid-word
set linebreak

" keeps indentation when tet wraps over line
set breakindent

" make indentations (tab characters) appear 4-spaces wide instead of 8
set tabstop=4

" Not sure why but the three things below are needed for some reason
set nocompatible            
filetype on                
filetype plugin on

" Insert line numbering
set nu

" use system clipboard
set clipboard+=unnamedplus
set guioptions+=a

" 'unlimited' number of undo's
set ul=10000000

" set a directory to store undo data 
set undodir=~/.vim/vimundo/

" create undo files allowing one to undo even after a system reboot
set undofile

" Uncomment the following to have Vim jump to the last position when
" " reopening a file
if has("autocmd")
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

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
let g:javascript_conceal_arrow_function = "⇒"

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
" set completeopt-=preview
" set completeopt+=menu,menuone,noinsert,noselect
" set shortmess+=c
" CTRL-X CTRL-O
augroup OmniCompletionSetup
    autocmd!
    autocmd FileType c          set omnifunc=ccomplete#Complete
    autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
    " autocmd FileType python     set omnifunc=jedi#completions
    autocmd FileType ruby       set omnifunc=rubycomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
augroup END

"""" VIMCOMPLETESME """"""""""""""""""""""""""""""""""""""""""""""""""
" TAB key in insert mode autocompletes OmniCompletion
let b:vcm_tab_complete = "omni"
