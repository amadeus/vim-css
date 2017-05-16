" Vim syntax file
" Language:     CSS Modules
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

syntax clear
syntax match  stylusVariable           /\<[_a-zA-Z$]\+[_a-zA-Z0-9-]*\>/ containedin=cssValueBlock,cssTransitionBlock

let b:embedded_rules = 1
runtime! syntax/css.vim
unlet b:embedded_rules

setlocal iskeyword+=$

highlight default link stylusAmpersand    Special
highlight default link stylusComment      Comment

let b:current_syntax = "css-modules"
