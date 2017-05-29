if exists("b:current_syntax")
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif

let sc_import_line = search("import.*from.*styled-components", 'n')
let sc_require_line = search("require.*styled-components", 'n')

if sc_import_line == 0 && sc_require_line == 0
  finish
endif

syntax include syntax/css.vim

syntax match jsStyledKeyword /\<styled\>/ skipwhite skipempty nextgroup=jsStyledDot,jsStyledParens
" NOTE: This specific re-drecinition of jsFuncCall is to overwrite the current one
syntax match jsFuncCall /styled\%(\s*(\)\@=/ contained containedin=@jsExpression skipwhite skipempty nextgroup=jsStyledParens contains=jsStyledKeyword
syntax match jsStyledDot /\./ contained skipwhite skipempty nextgroup=jsStyledTag,jsStyledAttrs
syntax match jsStyledTag /\k\+/ contained nextgroup=jsStyledTemplate,jsStyledDot contains=jsTaggedTemplate
syntax keyword jsStyledAttrs attrs contained skipwhite skipempty nextgroup=jsStyledParens
syntax region jsStyledParens contained matchgroup=jsParens start=/(/ end=/)/  contains=@jsAll extend fold nextgroup=jsStyledTemplate,jsStyledDot

syntax match jsStyledDefinition /\k\+.extend\>`\@=/ contains=jsNoise nextgroup=jsStyledTemplate
syntax match jsStyledDefinition /\<css\>`\@=/ contains=jsTaggedTemplate nextgroup=jsStyledTemplate

syntax region jsStyledTemplate matchgroup=jsStyledTemplateTicks start=/`/ skip=/\\\(`\|$\)/ end=/`/ contained contains=cssPropDefinition,styledPosition,jsTemplateExpression keepend
syntax region jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend containedin=cssValueBlock keepend extend

highlight default link jsStyledTemplateTicks String
highlight default link jsStyledDot Noise

if exists("s:current_syntax")
  let b:current_syntax=s:current_syntax
endif
