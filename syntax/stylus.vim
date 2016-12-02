" Vim syntax file
" Language:     Stylus
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

let b:embedded_rules = 1
runtime! syntax/css.vim
unlet b:embedded_rules

syntax match  stylusAmpersand containedin=cssDefinitionBlock /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
syntax match  stylusComment "//.*" contains=@Spell containedin=cssDefinitionBlock

syntax match  stylusVariable           /\k\+\s*\%(=\)\@=/ skipwhite skipempty nextgroup=stylusValue
syntax region stylusValue    contained matchgroup=cssValueBlockDelimiters start=/=/ end=/\%(;\|$\)/ contains=@cssValues

highlight default link stylusAmpersand    Special
highlight default link stylusComment      Comment
highlight default link stylusVariable     Identifier

let b:current_syntax = "stylus"
