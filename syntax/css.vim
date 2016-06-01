if !exists("main_syntax")
  let main_syntax = 'css'
elseif exists("b:current_syntax") && b:current_syntax == "css"
  finish
endif

syntax sync fromstart

syntax case ignore

setlocal iskeyword+=-
setlocal iskeyword+=_

syntax match cssBrowserPrefix contained /\%(-webkit-\|-moz-\|-ms-\|-o-\)/ nextgroup=cssProp
syntax match cssValueNoise contained /,/

syntax match cssAtRule /@\(media\|page\|import\|charset\|namespace\)/ skipwhite skipempty nextgroup=cssAtRuleString
syntax region cssAtRuleString contained start=/"/ skip=/\\\\\|\\"/ end=/"/ contained skipwhite skipempty nextgroup=cssAtRuleNoise
syntax region cssAtRuleString contained start=/'/ skip=/\\\\\|\\'/ end=/'/ contained skipwhite skipempty nextgroup=cssAtRuleNoise
syntax match cssAtRuleNoise /;/ contained
syntax match cssPagePseudos contained /:\%(left\|right\|blank\|first\|recto\|verso\)/

syntax keyword cssTagSelector template a abbr acronym address area article aside audio b base bdo blockquote body br button canvas caption cite code col colgroup dd del details dfn div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex kbd label legend li link main map mark menu meta nav noscript object ol optgroup option p param pre progress q s samp script section select small span strong style sub summary sup svg table tbody td textarea tfoot th thead title tr u ul var video nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax match cssTagSelector /\*/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
syntax match cssSelectorSeparator contained /,/
syntax match cssSelectorOperator contained /\%(+\|\~\|>\)/ nextgroup=@cssSelectors skipwhite skipempty

syntax match cssIDSelector /#\k\+/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssIDSelectorHash
syntax match cssIDSelectorHash /#/ contained
syntax match cssClassSelector /\.\k\+/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssClassSelectorDot
syntax match cssClassSelectorDot /\./ contained

syntax match cssPseudoSelector /:\{1,2\}/ nextgroup=cssPseudoKeyword,cssPseudoFunction
syntax keyword cssPseudoKeyword contained active after before checked disabled empty first-child first-letter first-line first-of-type focus hover input-placeholder last-child last-line last-of-type left link only-child only-of-type placeholder right selection visited nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax region cssPseudoFunction     contained start=/\k\+(/ end=/)/ keepend nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssPseudoFunctionNot,cssPseudoFunctionDir,cssPseudoFunctionLang,cssPseudoFunctionType
syntax region cssPseudoFunctionNot  contained matchgroup=cssFunctionDelimiters start=/not(/ end=/)/ contains=@cssSelectors
syntax region cssPseudoFunctionDir  contained matchgroup=cssFunctionDelimiters start=/dir(/ end=/)/ contains=cssPseudoDirKeywords
syntax region cssPseudoFunctionLang contained matchgroup=cssFunctionDelimiters start=/lang(/ end=/)/
syntax region cssPseudoFunctionType contained matchgroup=cssFunctionDelimiters start=/nth-\%(child\|last-child\|last-of-type\|of-type\)(/ end=/)/ contains=cssPseudoFunctionTypeNumbers,cssPseudoFunctionTypeOperators

syntax keyword cssPseudoDirKeywords           contained ltr rtl auto
syntax keyword cssPseudoFunctionTypeNumbers   contained odd even
syntax match   cssPseudoFunctionTypeNumbers   contained /\d/
syntax match   cssPseudoFunctionTypeOperators contained /\%(+\|-\|n\)/

syntax match cssPseudoKeyword contained /\%(-webkit-\|-moz-\|-ms-\|-o-\)\%(input-placeholder\|search-cancel-button\|search-decoration\|focus-inner\|placeholder\|inner-spin-button\|outer-spin-button\|expand\)/ contains=cssBrowserPrefix nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax region cssAttributeSelector matchgroup=cssAttributeSelectorBraces start=/\[/ end=/\]/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax region cssDefinitionBlock matchgroup=cssDefinitionBraces start=/{/ end=/}/ extend contains=cssPropDefinition keepend

syntax match  cssKeyframesDefinition /@\%(-webkit-\|-moz-\|-ms-\|-o-\)\=keyframes \k\+/ contains=cssBrowserPrefix nextgroup=cssKeyframesBlock skipwhite skipempty
syntax region cssKeyframesBlock contained matchgroup=cssAnimationBraces start=/{/ end=/}/ contains=cssKeyframe extend
syntax keyword  cssKeyframe     contained from to skipwhite skipempty nextgroup=cssDefinitionBlock,cssKeyframeComma
syntax match    cssKeyframe     contained /\d\+\%(\.\d*\)\=%/ skipwhite skipempty nextgroup=cssDefinitionBlock,cssKeyframeComma contains=cssNumber
syntax match    cssKeyframeComma contained /,/ skipwhite skipempty nextgroup=cssKeyframe

syntax match  cssFontFaceDefinition /@font-face/ nextgroup=cssFontFaceBlock skipwhite skipempty
syntax region cssFontFaceBlock contained matchgroup=cssFontFaceBraces start=/{/ end=/}/ extend contains=cssPropDefinition

syntax match  cssPropDefinition       contained /[a-zA-Z-]\+\%([ \r\t\n]*:\)\@=/ nextgroup=cssValueBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix
syntax match  cssPropDefinition       contained /font\%(-family\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssFontBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix
syntax match  cssPropDefinition       contained /transition\%(-property\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssTransitionBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix
syntax match  cssPropDefinition       contained /animation\%(-name\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssAnimationBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix

syntax region cssValueBlock           contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues
syntax region cssFontBlock            contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssString,cssValueNoise,cssFontOperator
syntax match  cssFontOperator         contained /\//
syntax region cssTransitionBlock      contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssBrowserPrefix,cssProp,cssValueNoise
syntax region cssAnimationBlock       contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssValueNoise

syntax match cssProp contained /\%(zoom\|z-index\|writing-mode\|wrap-through\|wrap-inside\|wrap-flow\|wrap-before\|wrap-after\|word-wrap\|word-spacing\|word-break\|will-change\|width\|widows\|white-space\|volume\|voice-volume\|voice-stress\|voice-rate\|voice-range\|voice-pitch\|voice-family\|voice-duration\|voice-balance\|visibility\|vertical-align\|user-select\|unicode-range\|unicode-bidi\|transition-timing-function\|transition-property\|transition-duration\|transition-delay\|transition\|transform-style\|transform-origin\|transform-box\|transform\|touch-callout\|touch-action\|top\|text-wrap\|text-underline-position\|text-transform\|text-spacing\|text-space-trim\|text-space-collapse\|text-size-adjust\|text-shadow\|text-rendering\|text-overflow\|text-orientation\|text-justify\|text-indent\|text-emphasis-style\|text-emphasis-position\|text-emphasis-color\|text-emphasis\|text-decoration-style\|text-decoration-skip\|text-decoration-line\|text-decoration-color\|text-decoration\|text-combine-upright\|text-align-last\|text-align-all\|text-align\|tap-highlight-color\|table-layout\|tab-size\|stroke-width\|stroke-opacity\|stroke-miterlimit\|stroke-linejoin\|stroke-linecap\|stroke-dashoffset\|stroke-dashcorner\|stroke-dasharray\|stroke-dashadjust\|stroke-alignment\|stroke\|string-set\|string-set\|stress\|src\|speech-rate\|speak-punctuation\|speak-numeral\|speak-header\|speak-as\|speak\|size\|shape-outside\|shape-margin\|shape-inside\|shape-image-threshold\|scroll-snap-type\|scroll-snap-padding-top\|scroll-snap-padding-right\|scroll-snap-padding-left\|scroll-snap-padding-inline-start\|scroll-snap-padding-inline-end\|scroll-snap-padding-inline\|scroll-snap-padding-bottom\|scroll-snap-padding-block-start\|scroll-snap-padding-block-end\|scroll-snap-padding-block\|scroll-snap-padding\|scroll-snap-padding\|scroll-snap-margin-top\|scroll-snap-margin-right\|scroll-snap-margin-left\|scroll-snap-margin-inline-start\|scroll-snap-margin-inline-end\|scroll-snap-margin-inline\|scroll-snap-margin-bottom\|scroll-snap-margin-block-start\|scroll-snap-margin-block-end\|scroll-snap-margin-block\|scroll-snap-margin\|scroll-snap-align\|scroll-behavior\|running\|ruby-position\|ruby-merge\|ruby-align\|rotation-point\|rotation\|right\|richness\|rest-before\|rest-after\|rest\|resize\|region-fragment\|quotes\|presentation-level\|position\|polar-origin\|polar-distance\|polar-angle\|polar-anchor\|play-during\|pitch-range\|pitch\|perspective-origin\|perspective\|pause-before\|pause-after\|pause\|page-policy\|page-break-inside\|page-break-before\|page-break-after\|page\|padding-top\|padding-right\|padding-left\|padding-bottom\|padding\|overflow-y\|overflow-x\|overflow-wrap\|overflow-style\|overflow\|outline-width\|outline-style\|outline-offset\|outline-color\|outline\|osx-font-smoothing\|orphans\|order\|opacity\|offset-start\|offset-end\|offset-before\|offset-after\|object-position\|object-fit\|nav-up\|nav-right\|nav-left\|nav-down\|move-to\|motion-rotation\|motion-path\|motion-offset\|motion\|mix-blend-mode\|min-width\|min-height\|max-width\|max-lines\|max-height\|mask-type\|mask-size\|mask-repeat\|mask-position\|mask-origin\|mask-mode\|mask-image\|mask-composite\|mask-clip\|mask-border-width\|mask-border-source\|mask-border-slice\|mask-border-repeat\|mask-border-outset\|mask-border-mode\|mask-border\|mask\|marquee-style\|marquee-speed\|marquee-loop\|marquee-direction\|marker-start\|marker-side\|marker-segment\|marker-pattern\|marker-mid\|marker-knockout-right\|marker-knockout-left\|marker-end\|marker\|margin-top\|margin-right\|margin-left\|margin-bottom\|margin\|list-style-type\|list-style-position\|list-style-image\|list-style\|line-snap\|line-height\|line-grid\|line-break\|lighting-color\|letter-spacing\|left\|justify-self\|justify-items\|justify-content\|isolation\|interpolation-mode\|initial-letter-wrap\|initial-letter-align\|initial-letter\|image-resolution\|image-rendering\|image-orientation\|hyphens\|hyphenate-limit-zone\|hyphenate-limit-lines\|hyphenate-limit-last\|hyphenate-limit-chars\|hyphenate-character\|height\|hanging-punctuation\|grid-template-rows\|grid-template-columns\|grid-template-areas\|grid-template\|grid-row-start\|grid-row-gap\|grid-row-end\|grid-row\|grid-gap\|grid-column-start\|grid-column-gap\|grid-column-end\|grid-column\|grid-auto-rows\|grid-auto-flow\|grid-auto-columns\|grid-area\|grid\|glyph-orientation-vertical\|footnote-policy\|footnote-display\|font-weight\|font-variant-position\|font-variant-numeric\|font-variant-ligatures\|font-variant-east-asian\|font-variant-caps\|font-variant-alternates\|font-variant\|font-synthesis\|font-style\|font-stretch\|font-smoothing\|font-size-adjust\|font-size\|font-language-override\|font-kerning\|font-feature-settings\|font-family\|font\|flow-into\|flow-from\|flow\|flood-opacity\|flood-color\|float-reference\|float-offset\|float-defer\|float\|flex-wrap\|flex-shrink\|flex-grow\|flex-flow\|flex-direction\|flex-basis\|flex\|filter\|empty-cells\|elevation\|dominant-baseline\|display\|direction\|cursor\|cue-before\|cue-after\|cue\|crop\|counter-set\|counter-reset\|counter-increment\|content\|columns\|column-width\|column-span\|column-rule-width\|column-rule-style\|column-rule-color\|column-rule\|column-gap\|column-fill\|column-count\|color-interpolation-filters\|color\|clip-rule\|clip-path\|clip\|clear\|chains\|caret-shape\|caret-color\|caret-animation\|caret\|caption-side\|break-inside\|break-before\|break-after\|box-suppress\|box-snap\|box-sizing\|box-shadow\|box-decoration-break\|bottom\|border-width\|border-top-width\|border-top-style\|border-top-right-radius\|border-top-left-radius\|border-top-color\|border-top\|border-style\|border-spacing\|border-right-width\|border-right-style\|border-right-color\|border-right\|border-radius\|border-left-width\|border-left-style\|border-left-color\|border-left\|border-image-width\|border-image-source\|border-image-slice\|border-image-repeat\|border-image-outset\|border-image\|border-color\|border-collapse\|border-boundary\|border-bottom-width\|border-bottom-style\|border-bottom-right-radius\|border-bottom-left-radius\|border-bottom-color\|border-bottom\|border\|bookmark-state\|bookmark-level\|bookmark-label\|baseline-shift\|background-size\|background-repeat\|background-position\|background-origin\|background-image\|background-color\|background-clip\|background-blend-mode\|background-attachment\|background\|backface-visibility\|azimuth\|appearance\|animation-timing-function\|animation-play-state\|animation-name\|animation-iteration-count\|animation-fill-mode\|animation-duration\|animation-direction\|animation-delay\|animation\|all\|alignment-baseline\|align-self\|align-items\|align-content\)/
syntax match cssValueKeyword contained /\<\%(zoom-out\|zoom-in\|wait\|w-resize\|visible\|vertical-text\|uppercase\|unset\|underline\|transparent\|top\|textfield\|text-top\|text-bottom\|text\|table-row-group\|table-row\|table-header-group\|table-column\|table-cell\|table-caption\|table\|sw-resize\|super\|sub\|step-start\|step-end\|status-bar\|static\|start\|solid\|small-caption\|small-caps\|serif\|se-resize\|sans-serif\|s-resize\|running\|run-in\|ruby-text-container\|ruby-text\|ruby-base-container\|ruby-base\|ruby\|row-resize\|right\|reverse\|repeat\|relative\|progress\|pre-wrap\|pre-line\|pre\|pointer\|pixelated\|paused\|padding-box\|overflow-scrolling\|optimizeLegibility\|optimize-contrast\|oblique\|nwse-resize\|nw-resize\|ns-resize\|nowrap\|not-allowed\|normal\|none\|none\|no-repeat\|no-drop\|no-allowed\|nesw-resize\|nearest-neighbor\|ne-resize\|n-resize\|move\|monospace\|middle\|message-box\|menu\|match-parent\|manipulation\|lowercase\|list-item\|linear\|left\|justify-all\|justify\|italic\|inset\|inline-table\|inline-list-item\|inline-grid\|inline-flex\|inline-block\|inline\|initial\|inherit\|infinite\|icon\|hidden\|help\|grid\|grayscale\|grabbing\|grab\|full-width\|forwards\|flex\|end\|ellipsis\|ease-out\|ease-in-out\|ease-in\|e-resize\|dotted\|default\|dashed\|crosshair\|crisp-edges\|cover\|courier\|context-menu\|contents\|content-box\|contain\|collapse\|col-resize\|clip\|center\|cell\|caption\|capitalize\|button\|bottom\|both\|border-box\|bolder\|bold\|block\|block\|baseline\|backwards\|auto\|antialiased\|alternate-reverse\|alternate\|all-scroll\|alias\|absolute\|condensed\|cursive\)/

syntax region  cssMediaDefinition start=/@media/ end=/{\@=/ nextgroup=cssMediaBlock skipwhite skipempty contains=cssAtRule,cssNumber,cssMediaNoise,cssMediaFeatures
syntax region  cssMediaBlock contained matchgroup=cssMediaBraces start=/{/ end=/}/ contains=@cssSelectors,cssPageDefinition
syntax match   cssMediaNoise contained /\%(:\|(\|)\|,\)/
syntax keyword cssMediaFeatures contained width update-frequency transition transform-3d transform-2d scripting scan scan resolution pointer overflow-inline overflow-block orientation monochrome min-width min-resolution min-monochrome min-height min-device-width min-device-height min-device-aspect-ratio min-color-index min-color min-aspect-ratio max-width max-resolution max-monochrome max-height max-device-width max-device-height max-device-aspect-ratio max-color-index max-color max-aspect-ratio light-level inverted-colors hover height grid display-mode device-width device-pixel-ratio device-height device-aspect-ratio color-index color aspect-ratio any-pointer any-hover animation

syntax keyword cssMediaTypes contained all print screen speech

syntax region cssPageDefinition start=/@page/ end=/{\@=/ skipwhite skipempty nextgroup=cssPageBlock contains=cssAtRule,cssPagePseudos
syntax region cssPageBlock contained matchgroup=cssPageBraces start=/{/ end=/}/ contains=cssPropDefinition,cssDefinitionBlock,cssAtRulePage
syntax match  cssAtRulePage contained /@\k\+/

syntax region cssString contained start=/"/ skip=/\\\\\|\\"/ end=/"/
syntax region cssString contained start=/'/ skip=/\\\\\|\\'/ end=/'/

syntax match cssImportant /!important/ contained

syntax match cssNumber contained /[-+]\=\.\%(\d*\)\=/ nextgroup=cssUnits contains=cssNumberNoise
syntax match cssNumber contained /[-+]\=\d\+\%(\.\d*\)\=/ nextgroup=cssUnits contains=cssNumberNoise
syntax match cssNumberNoise contained /\%(-\|+\|\.\)/

syntax match cssHexColor contained "#[0-9A-Fa-f]\{3\}\>" contains=cssUnits
syntax match cssHexColor contained "#[0-9A-Fa-f]\{6\}\>" contains=cssUnits

syntax keyword cssColor contained aliceblue antiquewhite aqua aquamarine azure beige bisque black blanchedalmond blue blueviolet brown burlywood cadetblue chartreuse chocolate coral cornflowerblue cornsilk crimson cyan darkblue darkcyan darkgoldenrod darkgray darkgrey darkgreen darkkhaki darkmagenta darkolivegreen darkorange darkorchid darkred darksalmon darkseagreen darkslateblue darkslategray darkslategrey darkturquoise darkviolet deeppink deepskyblue dimgray dimgrey dodgerblue firebrick floralwhite forestgreen fuchsia gainsboro ghostwhite gold goldenrod gray grey green greenyellow honeydew hotpink indianred indigo ivory khaki lavender lavenderblush lawngreen lemonchiffon lightblue lightcoral lightcyan lightgoldenrodyellow lightgray lightgrey lightgreen lightpink lightsalmon lightseagreen lightskyblue lightslategray lightslategrey lightsteelblue lightyellow lime limegreen linen magenta maroon mediumaquamarine mediumblue mediumorchid mediumpurple mediumseagreen mediumslateblue mediumspringgreen mediumturquoise mediumvioletred midnightblue mintcream mistyrose moccasin navajowhite navy oldlace olive olivedrab orange orangered orchid palegoldenrod palegreen paleturquoise palevioletred papayawhip peachpuff peru pink plum powderblue purple red rosybrown royalblue saddlebrown salmon sandybrown seagreen seashell sienna silver skyblue slateblue slategray slategrey snow springgreen steelblue tan teal thistle tomato turquoise violet wheat white whitesmoke yellow yellowgreen

syntax match cssUnits contained /\%(#\|%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|rem\|dpi\|dppx\|dpcm\|vh\|vw\|vmin\|vmax\|deg\|grad\|rad\|ms\|s\|Hz\|kHz\)/

syntax region cssFunction        contained  start=/\k\+(/ end=/)/ keepend contains=cssFuncUrl,cssFuncAttr,cssFuncEffects,cssFuncCalc
syntax region cssFuncUrl         contained matchgroup=cssFunctionDelimiters start=/url(/ end=/)/ contains=cssString
syntax region cssFuncAttr        contained matchgroup=cssFunctionDelimiters start=/attr(/ end=/)/ contains=cssAttrProp
syntax region cssFuncEffects     contained matchgroup=cssFunctionDelimiters start=/\%(blur\|brightness\|contrast\|drop-shadow\|grayscale\|hue-rotate\|invert\|opacity\|saturate\|sepia\)(/ end=/)/ contains=cssNumber,cssColor
syntax region cssFuncCalc        contained matchgroup=cssFunctionDelimiters start=/calc(/ end=/)/ contains=cssNumber,cssOperators

syntax match  cssAttrProp     contained /\k\+/ skipwhite skipempty nextgroup=cssAttrTypes,cssAttrComma
syntax match  cssAttrTypes    contained /\%(string\|integer\|color\|url\|integer\|number\|length\|angle\|time\|frequency\|em\|ex\|px\|rem\|vw\|vh\|vmin\|vmax\|mm\|cm\|in\|pt\|pc\|deg\|grad\|rad\|ms\|s\|Hz\|kHz\|%\)/ skipwhite skipempty nextgroup=cssAttrComma
syntax match  cssAttrComma    contained /,/ skipwhite skipempty nextgroup=cssString,cssNumber
syntax match  cssOperators    contained /\%(+\|-\|*\|\/\)/

syntax cluster cssSelectors contains=cssTagSelector,cssIDSelector,cssSelectorOperator,cssSelectorSeparator,cssStarSelector,cssClassSelector,cssPseudoSelector,cssAttributeSelector,cssPseudoFunction
syntax cluster cssRules contains=cssPropDefinition
syntax cluster cssValues contains=cssFunction,cssString,cssNumber,cssHexColor,cssImportant,cssColor,cssValueKeyword,cssValueNoise

syntax region cssComment start=/\/\*/ end=/\*\// containedin=ALLBUT,cssComment keepend extend

highlight default link cssValueBlockDelimiters        Noise
highlight default link cssDefinitionBraces            Noise
highlight default link cssAnimationBraces             Noise
highlight default link cssFontFaceBraces              Noise
highlight default link cssMediaBraces                 Noise
highlight default link cssSelectorSeparator           Noise
highlight default link cssAttributeSelectorBraces     Noise
highlight default link cssAttributeSelector           String
highlight default link cssString                      String
highlight default link cssAtRuleString                String
highlight default link cssTagSelector                 Statement
highlight default link cssPseudoSelector              Noise
highlight default link cssPageBraces                  Noise
highlight default link cssComment                     Comment
highlight default link cssAtRuleNoise                 Noise
highlight default link cssAtRulePage                  PreProc
highlight default link cssKeyframesDefinition         PreProc
highlight default link cssFontFaceDefinition          PreProc
highlight default link cssAtRule                      PreProc
highlight default link cssBrowserPrefix               Comment
highlight default link cssNumber                      Number
highlight default link cssHexColor                    Number
highlight default link cssTagSelector                 Statement
highlight default link cssPseudoKeyword               Special
highlight default link cssPagePseudos                 Special
highlight default link cssValueKeyword                Constant
highlight default link cssColor                       Constant
highlight default link cssUnits                       Operator
highlight default link cssNumberNoise                 Number
highlight default link cssAttributeSelectorBraces     Special
highlight default link cssClassSelector               Function
highlight default link cssClassSelectorDot            Function
highlight default link cssIDSelector                  Function
highlight default link cssIDSelectorHash              Function
highlight default link cssImportant                   Special
highlight default link cssSelectorOperator            Operator
highlight default link cssFunctionDelimiters          Function
highlight default link cssFontBlock                   Constant
highlight default link cssFontOperator                Operator
highlight default link cssValueNoise                  Noise
highlight default link cssKeyframeComma               Noise
highlight default link cssAnimationBlock              Constant
highlight default link cssPageDefinition              Constant
highlight default link cssKeyframe                    Constant
highlight default link cssMediaDefinition             Constant
highlight default link cssMediaNoise                  Noise
highlight default link cssMediaFeatures               Special
highlight default link cssPseudoDirKeywords           Constant
highlight default link cssPseudoFunctionLang          Constant
highlight default link cssPseudoFunctionTypeOperators Operator
highlight default link cssPseudoFunctionTypeNumbers   Number
highlight default link cssFuncUrl                    Special
highlight default link cssAttrComma                   Noise
highlight default link cssAttrTypes                   Operator
highlight default link cssAttrProp                    Constant
highlight default link cssOperators                   Operator

let b:current_syntax = "css"

if main_syntax == 'css'
  unlet main_syntax
endif
