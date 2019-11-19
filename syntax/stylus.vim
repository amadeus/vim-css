" Vim syntax file
" Language:     Stylus
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

if !exists("main_syntax")
  let main_syntax = "stylus"
endif

if exists("b:current_syntax") && b:current_syntax == "stylus"
  finish
endif

syntax clear
syntax match  stylusVariable           /\<[_a-zA-Z$]\+[_a-zA-Z0-9-]*\>/ containedin=cssValueBlock,cssTransitionBlock

let b:embedded_rules = 1
runtime! syntax/css.vim
unlet b:embedded_rules

setlocal iskeyword+=$

syntax match  stylusAmpersand containedin=cssDefinitionBlock /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
syntax match  stylusComment "//.*" contains=@Spell containedin=cssDefinitionBlock

syntax match  stylusVariable           /[_a-zA-Z$]\+[_a-zA-Z0-9-]*\s*\%(=\)\@=/ skipwhite skipempty nextgroup=stylusValue
syntax region stylusValue    contained matchgroup=cssValueBlockDelimiters start=/=/ end=/\%(;\|$\)/ contains=@cssValues

highlight default link stylusAmpersand    Special
highlight default link stylusComment      Comment

let b:current_syntax = "stylus"

if main_syntax ==# 'stylus'
  unlet main_syntax
endif
