let sc_import_line = search("import.*from.*styled-components", 'n')
let sc_require_line = search("require.*styled-components", 'n')

let la_import_line = search("import.*from.*\@linaria", 'n')
let ls_require_line = search("require.*\@linaria", 'n')

let em_import_line = search("import.*from.*emotion", 'n')
let em_require_line = search("require.*emotion", 'n')

if sc_import_line == 0 && sc_require_line == 0 && la_import_line == 0
  finish
endif

" NOTE: It might've actually been a mistake to disable this?
" if exists("b:current_syntax")
"   let s:current_syntax=b:current_syntax
"   unlet b:current_syntax
" endif

let b:embedded_rules = 1
runtime! syntax/css.vim
unlet b:embedded_rules

syntax match jsStyledKeyword /\<styled\>/ skipwhite skipempty nextgroup=jsStyledDot,jsStyledParens
" NOTE: This specific re-definition of jsFuncCall is to overwrite the current one
syntax match jsFuncCall /styled\%(\s*(\)\@=/ contained skipwhite skipempty nextgroup=jsStyledParens contains=jsStyledKeyword
syntax match jsStyledDot /\./ contained skipwhite skipempty nextgroup=jsStyledTag,jsStyledMethods
syntax match jsStyledTag /\k\+/ contained nextgroup=jsStyledTemplate,jsStyledDot contains=jsTaggedTemplate
syntax keyword jsStyledMethods attrs withConfig contained skipwhite skipempty nextgroup=jsStyledParens
syntax region jsStyledParens contained matchgroup=jsParens start=/(/ end=/)/  contains=@jsAll extend fold nextgroup=jsStyledTemplate,jsStyledDot
syntax match jsStyledAmpersand contained /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax match jsStyledDefinition /\k\+.extend\>`\@=/ contains=jsNoise nextgroup=jsStyledTemplate containedin=@tsExpression,@tsAll,tsBlock,tsFuncBlock
syntax match jsStyledDefinition /\<css\>`\@=/ contains=jsTaggedTemplate nextgroup=jsStyledTemplate containedin=@tsExpression,@tsAll,tsBlock,tsFuncBlock

syntax region jsStyledTemplate matchgroup=jsStyledTemplateTicks start=/`/ skip=/\\\(`\|$\)/ end=/`/ contained keepend contains=cssPropDefinition,@cssSelectors,cssMediaDefinition,jsTemplateExpression,jsStyledAmpersand
syntax region jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend containedin=cssValueBlock,cssDefinitionBlock keepend extend

highlight default link jsStyledAmpersand Special
highlight default link jsStyledTemplateTicks String
highlight default link jsStyledDot Noise

if exists("s:current_syntax")
  let b:current_syntax=s:current_syntax
endif
