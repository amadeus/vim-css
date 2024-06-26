" Vim syntax file
" Language:     CSS Modules
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

if !exists('main_syntax')
  let main_syntax = 'css.module'
endif

if exists('b:current_syntax') && b:current_syntax ==# 'css.module'
  finish
endif

syntax clear
syntax match  cssmVariable           /\<[_a-zA-Z$]\+[_a-zA-Z0-9-]*\>/ containedin=cssValueBlock,cssTransitionBlock

runtime! syntax/css.vim

syntax region cssmImport matchgroup=cssmImportKeywords start=/import/ end=/from/ contains=cssmClass skipwhite skipempty nextgroup=cssString
syntax match cssmNoise /;/

syntax match  cssmAmpersand containedin=cssDefinitionBlock /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax match cssmComposes contained /composes/ skipwhite skipempty nextgroup=cssmComposesValue containedin=cssDefinitionBlock
syntax region cssmComposesValue contained matchgroup=cssComposesValueDelims start=/:/ end=/;/ contains=cssmClass
syntax match cssmComposesFrom /from/ contained skipwhite skipempty nextgroup=cssString

syntax match cssmClass contained /\k\+/ skipwhite skipempty nextgroup=cssmComposesFrom

syntax region cssPseudoFunctionGlobal  contained matchgroup=cssFunctionDelimiters start=/global(/ end=/)/ contains=@cssSelectors containedin=cssPseudoFunction

syntax match  cssmComment "//.*" contains=@Spell containedin=cssDefinitionBlock

syntax match cssModuleValue /@value/ nextgroup=cssModuleValueName skipwhite skipempty
syntax match cssModuleValueName contained /\k\+/ nextgroup=cssModuleValueComma,cssModuleValueName,cssModuleValueFrom skipwhite skipempty
syntax match cssModuleValueComma contained /,/  nextgroup=cssModuleValueName skipwhite skipempty
syntax match cssModuleValueFrom contained /from/ nextgroup=cssString skipwhite skipempty
syntax match cssModuleUse /@use/ nextgroup=cssModuleUseSpecial skipwhite skipempty
syntax match cssModuleUseSpecial contained /\%(\k\|-\)\+/

highlight default link cssmAmpersand    Special
highlight default link cssmComment Comment
highlight default link cssmImportKeywords Comment
highlight default link cssmComposesFrom Comment
highlight default link cssmClass cssClassSelector
highlight default link cssmNoise Noise
highlight default link cssmGlobalParens Noise
highlight default link cssComposesValueDelims Noise
highlight default link cssmComposes cssProp
highlight default link cssModuleValue PreProc
highlight default link cssModuleValueFrom PreProc
highlight default link cssModuleValueName Special
highlight default link cssModuleUse PreProc
highlight default link cssModuleUseSpecial Special

setlocal iskeyword+=$

let b:current_syntax = 'css.module'

if main_syntax ==# 'css.module'
  unlet main_syntax
endif
