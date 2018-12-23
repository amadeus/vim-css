" Vim ftdetect file
" Language:     SCSS
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1
let b:undo_ftplugin = ""

autocmd BufNewFile,BufReadPost *.scss set filetype=scss
