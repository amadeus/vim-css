if exists("b:current_syntax")
  let s:current_syntax=b:current_syntax
  unlet b:current_syntax
endif

let sc_import_line = search("import.*from.*styled-components", 'n')
let sc_require_line = search("require.*styled-components", 'n')

if sc_import_line == 0 && sc_require_line == 0
  finish
endif

syn include syntax/css.vim

syntax match jsStyledDefinition /styled\.\k\+/ contains=jsNoise nextgroup=jsStyledTemplate
syntax region jsStyledTemplate matchgroup=jsStyledTemplateTicks start=/`/ end=/`/ contained contains=cssPropDefinition,styledPosition,jsTemplateExpression
syntax region  jsTemplateExpression contained matchgroup=jsTemplateBraces start=+${+ end=+}+ contains=@jsExpression keepend containedin=cssValueBlock

highlight default link jsStyledTemplateTicks String

if exists("s:current_syntax")
  let b:current_syntax=s:current_syntax
endif
