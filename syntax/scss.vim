if !exists("main_syntax")
  let main_syntax = 'css'
elseif exists("b:current_syntax") && b:current_syntax == "scss"
  finish
endif

let b:embedded_rules = 1
runtime! syntax/css.vim
unlet b:embedded_rules

syntax match  scssAmpersand containedin=cssDefinitionBlock /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
syntax match  scssComment /\/\/.*/ contains=@Spell containedin=cssDefinitionBlock

syntax match  scssVariableDefinition                /\$\k\+/ skipwhite skipempty nextgroup=scssValue
syntax region scssValue                 contained   matchgroup=cssValueBlockDelimiters start=/:/ end=/\%(;\|$\)/ contains=@cssValues,cssProp,scssMap,scssOperator
syntax region scssValueMap              contained   matchgroup=cssValueBlockDelimiters start=/:/ end=/\%(,\)/ contains=@cssValues,cssProp,scssOperator
syntax match  scssVariable              contained   /\$\k\+/ containedin=scssValue
syntax region scssMap                   contained   matchgroup=scssMapNoise start=/(/ end=/)/ contains=scssMapKey
syntax match  scssMapKey                contained   /\k\+/ skipwhite skipempty nextgroup=scssValueMap
syntax match  scssOperator              contained   / [+-/*] /

highlight default link scssAmpersand            Special
highlight default link scssComment              Comment
highlight default link scssVariableDefinition   Identifier
highlight default link scssVariable             Identifier
highlight default link scssMapNoise             Noise
highlight default link scssMapKey               Identifier
highlight default link scssOperator             Operator

let b:current_syntax = "scss"
