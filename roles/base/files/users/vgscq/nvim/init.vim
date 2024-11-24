set mouse=
"set termguicolors
syntax on


"------------------------------
" Colors
"------------------------------
augroup MyColors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=none guibg=none
  autocmd ColorScheme * highlight NonText ctermbg=none guibg=none
augroup END
colorscheme default

"------------------------------
" Indentation
"------------------------------
set autoindent
set copyindent                    " copy indent from the previous line
set expandtab                     " tabs are spaces
set shiftwidth=4                  " number of spaces to use for autoindent
set softtabstop=4                 " number of spaces in tab when editing
set tabstop=4                     " number of visual spaces per TAB

