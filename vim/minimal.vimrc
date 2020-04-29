" break vi compatability and allows one to use vim features
set nocompatible

" allow backspacing over indent
" delete any text that was previously inserted
set backspace=indent,eol,start

" line numbering
set number
set relativenumber

" ignore casing when searching
set ignorecase
set smartcase

" maintain indentation and full word over line break
set linebreak
set breakindent

" search recursively for file and show basic menu
set path+=**
set wildmenu
set wildignore+=*node_modules/*,*__pycache__/*,*.pyc

" syntax highlighting on
syntax on
