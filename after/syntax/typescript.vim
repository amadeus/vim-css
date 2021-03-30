let sc_import_line = search("import.*from.*styled-components", 'n')
let sc_require_line = search("require.*styled-components", 'n')

let la_import_line = search("import.*from.*\@linaria", 'n')
let la_require_line = search("require.*\@linaria", 'n')

let em_import_line = search("import.*from.*emotion", 'n')
let em_require_line = search("require.*emotion", 'n')

if sc_import_line == 0 && sc_require_line == 0 && la_import_line == 0 && la_require_line == 0 && em_require_line == 0 && em_import_line == 0
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

syntax match tsStyledKeyword /\<styled\>/ skipwhite skipempty nextgroup=tsStyledDot,tsStyledParens
" NOTE: This specific re-definition of tsFuncCall is to overwrite the current one
syntax match tsFuncCall /styled\%(\s*(\)\@=/ contained skipwhite skipempty nextgroup=tsStyledParens contains=tsStyledKeyword
syntax match tsStyledDot /\./ contained skipwhite skipempty nextgroup=tsStyledTag,tsStyledMethods
syntax match tsStyledTag /\k\+/ contained nextgroup=tsStyledTemplate,tsStyledDot
syntax keyword tsStyledMethods attrs withConfig contained skipwhite skipempty nextgroup=tsStyledParens
syntax region tsStyledParens contained matchgroup=tsParens start=/(/ end=/)/  contains=@tsAll extend fold nextgroup=tsStyledTemplate,tsStyledDot
syntax match tsStyledAmpersand contained /&/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax match tsStyledDefinition /\k\+.extend\>`\@=/ contains=tsNoise nextgroup=tsStyledTemplate containedin=@tsExpression,@tsAll,tsBlock,tsFuncBlock
syntax match tsStyledDefinition /\<css\>`\@=/ nextgroup=tsStyledTemplate containedin=@tsExpression,@tsAll,tsBlock,tsFuncBlock extend keepend

syntax match tsStyledLabelValue contained /[0-9a-zA-Z-_@$]\+/ nextgroup=tsStyledLabelNoise
syntax match tsStyledLabelNoise contained /[;:]/
syntax match tsStyledLabel contained /\<label\>:/ containedin=tsStyledTemplate contains=tsStyledLabelNoise nextgroup=tsStyledLabelValue skipwhite skipempty

syntax region tsStyledTemplate matchgroup=tsStyledTemplateTicks start=/`/ skip=/\\\(`\|$\)/ end=/`/ contained keepend contains=cssPropDefinition,@cssSelectors,cssMediaDefinition,tsTemplateExpression,tsStyledAmpersand
syntax region tsTemplateExpression contained matchgroup=tsTemplateBraces start=+${+ end=+}+ contains=@tsExpression keepend containedin=cssValueBlock,cssDefinitionBlock keepend extend

highlight default link tsStyledAmpersand Special
highlight default link tsStyledTemplateTicks String
highlight default link tsStyledDot Noise
highlight default link tsStyledLabel cssProp
highlight default link tsStyledLabelNoise Noise
highlight default link tsStyledLabelValue cssValueKeyword
highlight default link tsStyledDefinition tsTaggedTemplate

if exists("s:current_syntax")
  let b:current_syntax=s:current_syntax
endif
