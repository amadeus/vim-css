" Vim ftdetect file
" Language:     CSS Modules
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

autocmd BufNewFile,BufReadPost *.cssm set filetype=cssmodules
