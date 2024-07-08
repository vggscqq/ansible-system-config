set mouse=
syntax on

"------------------------------
" Indentation
"------------------------------
set autoindent
set copyindent                    " copy indent from the previous line
set expandtab                     " tabs are space
set shiftwidth=4                  " number of spaces to use for autoindent
set softtabstop=4                 " number of spaces in tab when editing
set tabstop=4                     " number of visual spaces per TAB

:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/