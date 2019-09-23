" Vim syntax file
" Language:     CSS
" Maintainer:   Amadeus Demarzi, http://github.com/amadeus
" URL:          https://github.com/amadeus/vim-css

if !exists('main_syntax')
  let main_syntax = 'css'
endif

if exists('b:current_syntax') && b:current_syntax ==# 'css'
  finish
endif

if !exists('b:embedded_rules') && main_syntax !=# 'css'
  syntax clear
endif

let s:cpo_save = &cpoptions
set cpoptions&vim

syntax sync fromstart

syntax case ignore

setlocal iskeyword+=_

" This is here simply to fix misc issues where external plugins attempt to
" load this CSS plugin - I need to research more why the bug exists - perhaps
" this is a better workaround
syntax match cssAttr /\<cssAttrPolyfill\>/ contained
syntax match cssBracketError /}\|]/ containedin=ALLBUT,cssComment
syntax match cssBrowserPrefix contained /\%(-webkit-\|-moz-\|-ms-\|-o-\)/ nextgroup=cssProp
syntax match cssValueNoise contained /,/

syntax match cssAtRule /@\(media\|page\|import\|charset\|namespace\)/ skipwhite skipempty nextgroup=cssAtRuleString
syntax region cssAtRuleString contained start=/"/ skip=/\\\\\|\\"/ end=/"/ contained skipwhite skipempty oneline nextgroup=cssAtRuleNoise
syntax region cssAtRuleString contained start=/'/ skip=/\\\\\|\\'/ end=/'/ contained skipwhite skipempty oneline nextgroup=cssAtRuleNoise
syntax match cssAtRuleNoise /;/ contained
syntax match cssPagePseudos contained /:\%(left\|right\|blank\|first\|recto\|verso\)/

syntax keyword cssTagSelector a abbr acronym address applet area article aside audio b base bdo big blockquote body br button canvas caption circle cite code col colgroup dd del details dfn div dl dt em embed fieldset figcaption figure footer form g h1 h2 h3 h4 h5 h6 head header hgroup hr html i iframe img input ins isindex kbd label legend li link main map mark menu meta nav noscript  ol optgroup option p param path pre progress q rect s samp script section select small span strike strong style sub summary sup svg table tbody td template textarea tfoot th thead title tr tt u ul var video nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
" object has to be pulled out and made a match or else it overrides object-fit property
syntax match cssTagSelector /object/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax match cssTagSelector /\*/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty
syntax match cssSelectorSeparator contained /,/
syntax match cssSelectorOperator contained /\%(+\|\~\|>\)/ nextgroup=@cssSelectors skipwhite skipempty

syntax match cssIDSelector /#[_a-zA-Z]\+[_a-zA-Z0-9-]*/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssIDSelectorHash
syntax match cssIDSelectorHash /#/ contained
syntax match cssClassSelector /\.[_a-zA-Z]\+[_a-zA-Z0-9-]*/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssClassSelectorDot
syntax match cssClassSelectorDot /\./ contained

syntax match cssPseudoSelector /:\{1,2\}/ nextgroup=cssPseudoKeyword,cssPseudoFunction,cssPseudoFunctionType
syntax match cssPseudoKeyword contained /\<active\|after\|before\|checked\|disabled\|empty\|first-child\|first-letter\|first-line\|first-of-type\|focus-within\|focus\|hover\|input-placeholder\|last-child\|last-line\|last-of-type\|left\|link\|only-child\|only-of-type\|placeholder\|right\|selection\|visited\|scrollbar-track-piece\|scrollbar-button\|scrollbar-corner\|scrollbar\>/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax region cssPseudoFunction     contained start=/[a-zA-Z0-9-_]\+(/ end=/)/ keepend extend nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty contains=cssPseudoFunctionNot,cssPseudoFunctionDir,cssPseudoFunctionLang,cssPseudoFunctionType
syntax region cssPseudoFunctionNot  contained matchgroup=cssFunctionDelimiters start=/not(/ end=/)/ contains=@cssSelectors
syntax region cssPseudoFunctionDir  contained matchgroup=cssFunctionDelimiters start=/dir(/ end=/)/ contains=cssPseudoDirKeywords
syntax region cssPseudoFunctionLang contained matchgroup=cssFunctionDelimiters start=/lang(/ end=/)/
syntax region cssPseudoFunctionType contained matchgroup=cssFunctionDelimiters start=/nth-\%(child\|last-child\|last-of-type\|of-type\)(/ end=/)/ keepend contains=cssPseudoFunctionTypeNumbers,cssPseudoFunctionTypeOperators skipwhite skipempty nextgroup=cssSelectorSeparator,cssDefinitionBlock,cssDefinitionBraces

syntax keyword cssPseudoDirKeywords           contained ltr rtl auto
syntax keyword cssPseudoFunctionTypeNumbers   contained odd even
syntax match   cssPseudoFunctionTypeNumbers   contained /\d/
syntax match   cssPseudoFunctionTypeOperators contained /\%(+\|-\|n\)/

syntax match cssPseudoKeyword contained /\%(-webkit-\|-moz-\|-ms-\|-o-\)\%(input-placeholder\|search-cancel-button\|search-decoration\|focus-inner\|resizer\|placeholder\|inner-spin-button\|outer-spin-button\|expand\|scrollbar-track-piece\|scrollbar-track\|scrollbar-thumb\|scrollbar-button\|scrollbar-corner\|scrollbar\|full-screen\|media-controls-enclosure\)/ contains=cssBrowserPrefix nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

syntax region cssAttributeSelector matchgroup=cssAttributeSelectorBraces start=/\[/ end=/\]/ nextgroup=@cssSelectors,cssDefinitionBlock skipwhite skipempty

if exists('b:embedded_rules')
  syntax region cssDefinitionBlock matchgroup=cssDefinitionBraces start=/{/ end=/}/ extend contains=cssPropDefinition,@cssSelectors,cssMediaDefinition keepend extend fold
else
  syntax region cssDefinitionBlock matchgroup=cssDefinitionBraces start=/{/ end=/}/ extend contains=cssPropDefinition keepend fold
endif

syntax match  cssKeyframesDefinition /@\%(-webkit-\|-moz-\|-ms-\|-o-\)\=keyframes [a-zA-Z0-9-_]\+/ contains=cssBrowserPrefix nextgroup=cssKeyframesBlock skipwhite skipempty
syntax region cssKeyframesBlock contained matchgroup=cssAnimationBraces start=/{/ end=/}/ contains=cssKeyframe extend fold
syntax keyword  cssKeyframe     contained from to skipwhite skipempty nextgroup=cssDefinitionBlock,cssKeyframeComma
syntax match    cssKeyframe     contained /\d\+\%(\.\d*\)\=%/ skipwhite skipempty nextgroup=cssDefinitionBlock,cssKeyframeComma contains=cssNumber
syntax match    cssKeyframeComma contained /,/ skipwhite skipempty nextgroup=cssKeyframe

syntax match  cssFontFaceDefinition /@font-face/ nextgroup=cssFontFaceBlock skipwhite skipempty
syntax region cssFontFaceBlock contained matchgroup=cssFontFaceBraces start=/{/ end=/}/ extend contains=cssPropDefinition fold

syntax match  cssPropDefinition       contained /[a-zA-Z0-9-_]\+\%([ \r\t\n]*:\)\@=/ nextgroup=cssValueBlock skipwhite skipempty contains=cssProp,cssVariableDefinition,cssBrowserPrefix
syntax match  cssPropDefinition       contained /font\%(-family\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssFontBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix
syntax match  cssPropDefinition       contained /transition\%(-property\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssTransitionBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix
syntax match  cssPropDefinition       contained /animation\%(-name\)\=\%([ \r\t\n]*:\)\@=/ nextgroup=cssAnimationBlock skipwhite skipempty contains=cssProp,cssBrowserPrefix

syntax region cssValueBlock           contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues
syntax region cssFontBlock            contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssString,cssValueNoise,cssFontOperator
syntax match  cssFontOperator         contained /\//
syntax region cssTransitionBlock      contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssBrowserPrefix,cssProp,cssValueNoise
syntax region cssAnimationBlock       contained matchgroup=cssValueBlockDelimiters start=/:/ end=/;/ contains=@cssValues,cssValueNoise

syntax match cssVariableDefinition    contained /--[a-zA-Z0-9-_]\+/
syntax match cssProp contained /\<\%(zoom\|z-index\|writing-mode\|word-wrap\|word-spacing\|word-break\|will-change\|width\)\>/
syntax match cssProp contained /\<\%(widows\|white-space\|volume\|voice-volume\|top\|text-wrap\|text-underline-position\|visibility\|vertical-align\|user-select\)\>/
syntax match cssProp contained /\<\%(voice-stress\|voice-rate\|voice-range\|voice-pitch\|voice-family\|voice-duration\|voice-balance\|quotes\|presentation-level\)\>/
syntax match cssProp contained /\<\%(unicode-range\|unicode-bidi\|tap-highlight-color\|table-layout\|tab-size\|string-set\|string-set\|stress\|src\)\>/
syntax match cssProp contained /\<\%(transition-timing-function\|transition-property\|transition-duration\|transition-delay\|transition\)\>/
syntax match cssProp contained /\<\%(transform-style\|transform-origin\|transform-box\|transform\)\>/
syntax match cssProp contained /\<\%(text-rendering\|text-overflow\|text-orientation\|text-justify\|text-indent\|text-combine-upright\)\>/
syntax match cssProp contained /\<\%(text-emphasis-style\|text-emphasis-position\|text-emphasis-color\|text-emphasis\)\>/
syntax match cssProp contained /\<\%(text-decoration-style\|text-decoration-skip\|text-decoration-line\|text-decoration-color\|text-decoration\)\>/
syntax match cssProp contained /\<\%(text-align-last\|text-align-all\|text-align\|touch-callout\|touch-action\|wrap-through\|wrap-inside\|wrap-flow\|wrap-before\|wrap-after\)\>/
syntax match cssProp contained /\<\%(stroke-width\|stroke-opacity\|stroke-miterlimit\|stroke-linejoin\|stroke-linecap\|stroke-dashoffset\|stroke-dashcorner\|stroke-dasharray\|stroke-dashadjust\|stroke-alignment\|stroke\)\>/
syntax match cssProp contained /\<\%(speech-rate\|size\|running\|ruby-position\|ruby-merge\|ruby-align\|right\|richness\|rest-before\|rest-after\|rest\|resize\)\>/
syntax match cssProp contained /\<\%(speak-punctuation\|speak-numeral\|speak-header\|speak-as\|speak\)\>/
syntax match cssProp contained /\<\%(scroll-snap-padding-top\|scroll-snap-padding-right\|scroll-snap-padding-left\|scroll-snap-padding-inline-start\|scroll-snap-padding-inline-end\|scroll-snap-padding-inline\|scroll-snap-padding-bottom\|scroll-snap-padding-block-start\|scroll-snap-padding-block-end\|scroll-snap-padding-block\|scroll-snap-padding\|scroll-snap-padding\)\>/
syntax match cssProp contained /\<\%(scroll-snap-margin-top\|scroll-snap-margin-right\|scroll-snap-margin-left\|scroll-snap-margin-inline-start\|scroll-snap-margin-inline-end\|scroll-snap-margin-inline\|scroll-snap-margin-bottom\|scroll-snap-margin-block-start\|scroll-snap-margin-block-end\|scroll-snap-margin-block\|scroll-snap-margin\)\>/
syntax match cssProp contained /\<\%(scroll-behavior\|text-transform\|text-spacing\|text-space-trim\|text-space-collapse\|text-size-adjust\|text-shadow\)\>/
syntax match cssProp contained /\<\%(rotation-point\|rotation\|scrollbar-width\|scrollbar-color\)\>/
syntax match cssProp contained /\<\%(region-fragment\|shape-outside\|shape-margin\|shape-inside\|shape-image-threshold\|scroll-snap-type\|scroll-snap-align\)\>/
syntax match cssProp contained /\<\%(position\|polar-origin\|polar-distance\|polar-angle\|polar-anchor\|pointer-events\|play-during\|osx-font-smoothing\|orphans\)\>/
syntax match cssProp contained /\<\%(pitch-range\|pitch\)\>/
syntax match cssProp contained /\<\%(perspective-origin\|perspective\)\>/
syntax match cssProp contained /\<\%(pause-before\|pause-after\|pause\)\>/
syntax match cssProp contained /\<\%(page-policy\|page-break-inside\|page-break-before\|page-break-after\|page\)\>/
syntax match cssProp contained /\<\%(padding-top\|padding-right\|padding-left\|padding-bottom\|padding\)\>/
syntax match cssProp contained /\<\%(overflow-y\|overflow-x\|overflow-wrap\|overflow-style\|overflow\)\>/
syntax match cssProp contained /\<\%(outline-width\|outline-style\|outline-offset\|outline-color\|outline\)\>/
syntax match cssProp contained /\<\%(order\|opacity\|offset-start\|offset-end\|offset-before\|offset-after\|object-position\|object-fit\|nav-up\|nav-right\|nav-left\)\>/
syntax match cssProp contained /\<\%(nav-down\|move-to\|mix-blend-mode\|min-width\|min-height\|max-width\|max-lines\|max-height\|marquee-style\|marquee-speed\)\>/
syntax match cssProp contained /\<\%(motion-rotation\|motion-path\|motion-offset\|motion\)\>/
syntax match cssProp contained /\<\%(mask-type\|mask-size\|mask-repeat\|mask-position\|mask-origin\|mask-mode\|mask-image\|mask-composite\|mask-clip\|mask-border-width\|mask-border-source\|mask-border-slice\|mask-border-repeat\|mask-border-outset\|mask-border-mode\|mask-border\|mask\)\>/
syntax match cssProp contained /\<\%(marquee-loop\|marquee-direction\)\>/
syntax match cssProp contained /\<\%(marker-start\|marker-side\|marker-segment\|marker-pattern\|marker-mid\|marker-knockout-right\|marker-knockout-left\|marker-end\|marker\)\>/
syntax match cssProp contained /\<\%(line-snap\|line-height\|line-grid\|line-break\|lighting-color\|letter-spacing\|left\)\>/
syntax match cssProp contained /\<\%(margin-top\|margin-right\|margin-left\|margin-bottom\|margin\)\>/
syntax match cssProp contained /\<\%(list-style-type\|list-style-position\|list-style-image\|list-style\)\>/
syntax match cssProp contained /\<\%(justify-self\|justify-items\|justify-content\|isolation\|interpolation-mode\|image-resolution\|image-rendering\|image-orientation\)\>/
syntax match cssProp contained /\<\%(initial-letter-wrap\|initial-letter-align\|initial-letter\)\>/
syntax match cssProp contained /\<\%(hyphens\|hyphenate-limit-zone\|hyphenate-limit-lines\|hyphenate-limit-last\|hyphenate-limit-chars\|hyphenate-character\)\>/
syntax match cssProp contained /\<\%(height\|hanging-punctuation\|glyph-orientation-vertical\|footnote-policy\|footnote-display\|flood-opacity\|flood-color\|filter\)\>/
syntax match cssProp contained /\<\%(grid-template-rows\|grid-template-columns\|grid-template-areas\|grid-template\|grid-row-start\|grid-row-gap\|grid-row-end\|grid-row\|grid-column-start\|grid-column-gap\|grid-column-end\|grid-column\|grid-gap\|grid-auto-rows\|grid-auto-flow\|grid-auto-columns\|grid-area\|grid\)\>/
syntax match cssProp contained /\<\%(font-weight\|font-variant-position\|font-variant-numeric\|font-variant-ligatures\|font-variant-east-asian\|font-variant-caps\|font-variant-alternates\|font-variant\|font-synthesis\|font-style\|font-stretch\|font-smoothing\|font-size-adjust\|font-size\|font-language-override\|font-kerning\|font-feature-settings\|font-family\|font-display\|font\)\>/
syntax match cssProp contained /\<\%(flow-into\|flow-from\|flow\)\>/
syntax match cssProp contained /\<\%(float-reference\|float-offset\|float-defer\|float\)\>/
syntax match cssProp contained /\<\%(flex-wrap\|flex-shrink\|flex-grow\|flex-flow\|flex-direction\|flex-basis\|flex\)\>/
syntax match cssProp contained /\<\%(fill\|empty-cells\|elevation\|dominant-baseline\|display\|direction\|d\|cursor\|cue-before\|cue-after\|cue\|crop\|counter-set\)\>/
syntax match cssProp contained /\<\%(counter-reset\|counter-increment\|content\|columns\|clear\|chains\|caption-side\|break-inside\|break-before\|break-after\)\>/
syntax match cssProp contained /\<\%(column-width\|column-span\|column-rule-width\|column-rule-style\|column-rule-color\|column-rule\|column-gap\|column-fill\|column-count\)\>/
syntax match cssProp contained /\<\%(color-interpolation-filters\|color\|contain\)\>/
syntax match cssProp contained /\<\%(clip-rule\|clip-path\|clip\)\>/
syntax match cssProp contained /\<\%(caret-shape\|caret-color\|caret-animation\|caret\)\>/
syntax match cssProp contained /\<\%(box-suppress\|box-snap\|box-sizing\|box-shadow\|box-decoration-break\|bottom\|bookmark-state\|bookmark-level\|bookmark-label\)\>/
syntax match cssProp contained /\<\%(border-width\|border-top-width\|border-top-style\|border-top-right-radius\|border-top-left-radius\|border-top-color\|border-top\|border-style\|border-spacing\|border-right-width\|border-right-style\|border-right-color\|border-right\|border-radius\|border-left-width\|border-left-style\|border-left-color\|border-left\|border-image-width\|border-image-source\|border-image-slice\|border-image-repeat\|border-image-outset\|border-image\|border-color\|border-collapse\|border-boundary\|border-bottom-width\|border-bottom-style\|border-bottom-right-radius\|border-bottom-left-radius\|border-bottom-color\|border-bottom\|border\)\>/
syntax match cssProp contained /\<\%(baseline-shift\|backface-visibility\|azimuth\|appearance\|all\|alignment-baseline\|align-self\|align-items\|align-content\)\>/
syntax match cssProp contained /\<\%(background-size\|background-repeat\|background-position\|background-origin\|background-image\|background-color\|background-clip\|background-blend-mode\|background-attachment\|background\)\>/
syntax match cssProp contained /\<\%(animation-timing-function\|animation-play-state\|animation-name\|animation-iteration-count\|animation-fill-mode\|animation-duration\|animation-direction\|animation-delay\|animation\)\>/

syntax match cssValueKeyword contained /\<\%(zoom-out\|zoom-in\|wrap\|wait\|w-resize\|visible\|vertical-text\)\>/
syntax match cssValueKeyword contained /\<\%(uppercase\|unset\|underline\|transparent\|top\|thin\|textfield\|text-top\|text-bottom\|text\)\>/
syntax match cssValueKeyword contained /\<\%(table-row-group\|table-row\|table-header-group\|table-column\|table-cell\|table-caption\|table\)\>/
syntax match cssValueKeyword contained /\<\%(swap\|sw-resize\|super\|sub\|style\|strict\|stretch\|step-start\|step-end\)\>/
syntax match cssValueKeyword contained /\<\%(status-bar\|static\|start\|space-between\|space-around\|solid\|small-caption\)\>/
syntax match cssValueKeyword contained /\<\%(small-caps\|size\|serif\|se-resize\|scroll\|scale-down\|sans-serif\|s-resize\)\>/
syntax match cssValueKeyword contained /\<\%(running\|run-in\|ruby-text-container\|ruby-text\|ruby-base-container\|ruby-base\)\>/
syntax match cssValueKeyword contained /\<\%(ruby\|row-resize\|row\|right\|reverse\|repeat\|relative\|progress\)\>/
syntax match cssValueKeyword contained /\<\%(pre-wrap\|pre-line\|pre\|pointer\|pixelated\|paused\|paint\)\>/
syntax match cssValueKeyword contained /\<\%(padding-box\|overflow-scrolling\|optional\|optimizeLegibility\)\>/
syntax match cssValueKeyword contained /\<\%(optimize-contrast\|oblique\|nwse-resize\|nw-resize\|ns-resize\|nowrap\|not-allowed\)\>/
syntax match cssValueKeyword contained /\<\%(normal\|none\|no-repeat\|no-drop\|no-allowed\|nesw-resize\|nearest-neighbor\)\>/
syntax match cssValueKeyword contained /\<\%(ne-resize\|n-resize\|move\|monospace\|middle\|message-box\|menu\|match-parent\)\>/
syntax match cssValueKeyword contained /\<\%(manipulation\|lowercase\|list-item\|linear\|left\|layout\|justify-all\|justify\)\>/
syntax match cssValueKeyword contained /\<\%(italic\|inset\|inline-table\|inline-list-item\|inline-grid\)\>/
syntax match cssValueKeyword contained /\<\%(inline-flex\|inline-block\|inline\|initial\|inherit\|infinite\|icon\)\>/
syntax match cssValueKeyword contained /\<\%(hidden\|help\|grid\|grayscale\|grabbing\|grab\|full-width\|forwards\)\>/
syntax match cssValueKeyword contained /\<\%(flex-start\|flex-end\|flex\|fixed\|fill\|fallback\|end\|ellipsis\)\>/
syntax match cssValueKeyword contained /\<\%(ease-out\|ease-in-out\|ease-in\|e-resize\|dotted\|default\|dashed\)\>/
syntax match cssValueKeyword contained /\<\%(cursive\|crosshair\|crisp-edges\|cover\|courier\|context-menu\|contents\)\>/
syntax match cssValueKeyword contained /\<\%(content-box\|content\|contain\|condensed\|column\|collapse\|col-resize\)\>/
syntax match cssValueKeyword contained /\<\%(clip\|center\|cell\|caption\|capitalize\|button\|break-word\|bottom\)\>/
syntax match cssValueKeyword contained /\<\%(both\|border-box\|bolder\|bold\|block\|baseline\|backwards\)\>/
syntax match cssValueKeyword contained /\<\%(auto\|antialiased\|alternate-reverse\|alternate\|all-scroll\|alias\|absolute\)\>/

syntax region  cssMediaDefinition start=/@media/ end=/{\@=/ nextgroup=cssMediaBlock skipwhite skipempty contains=cssAtRule,cssNumber,cssMediaNoise,cssMediaFeature,cssMediaFeatureAnd
syntax region  cssMediaBlock contained matchgroup=cssMediaBraces start=/{/ end=/}/ contains=@cssSelectors,cssPageDefinition fold extend
syntax match cssMediaNoise contained /\%(:\|(\|)\|,\)/
syntax match cssMediaFeature contained /\<\%(width\|update-frequency\|transition\|transform-3d\|transform-2d\|scripting\|scan\|scan\|resolution\|pointer\|overflow-inline\|overflow-block\|orientation\|monochrome\|min-width\|min-resolution\|min-monochrome\|min-height\|min-device-width\|min-device-height\|min-device-aspect-ratio\|min-color-index\|min-color\|min-aspect-ratio\|max-width\|max-resolution\|max-monochrome\|max-height\|max-device-width\|max-device-height\|max-device-aspect-ratio\|max-color-index\|max-color\|max-aspect-ratio\|light-level\|inverted-colors\|hover\|height\|grid\|display-mode\|device-width\|device-pixel-ratio\|device-height\|device-aspect-ratio\|color-index\|color\|aspect-ratio\|any-pointer\|any-hover\|animation\|handheld\|tv\)\>/
syntax keyword cssMediaFeatureAnd contained and

syntax keyword cssMediaTypes contained all print screen speech

syntax region cssPageDefinition start=/@page/ end=/{\@=/ skipwhite skipempty nextgroup=cssPageBlock contains=cssAtRule,cssPagePseudos
syntax region cssPageBlock contained matchgroup=cssPageBraces start=/{/ end=/}/ contains=cssPropDefinition,cssDefinitionBlock,cssAtRulePage fold
syntax match  cssAtRulePage contained /@[a-zA-Z0-9-_]\+/

syntax region cssString contained start=/"/ skip=/\\\\\|\\"/ end=/"/ oneline
syntax region cssString contained start=/'/ skip=/\\\\\|\\'/ end=/'/ oneline

syntax match cssImportant /!important/ contained

syntax match cssNumber contained /\k\@<![-+]\=\.\%(\d*\)\=/ nextgroup=cssUnits contains=cssNumberNoise
syntax match cssNumber contained /\k\@<![-+]\=\d\+\%(\.\d*\)\=/ nextgroup=cssUnits contains=cssNumberNoise
syntax match cssNumberNoise contained /\%(-\|+\|\.\)/

syntax match cssHexColor contained "#[0-9A-Fa-f]\{3\}\>" contains=cssUnits
syntax match cssHexColor contained "#[0-9A-Fa-f]\{6\}\>" contains=cssUnits

syntax keyword cssColor contained aliceblue antiquewhite aqua aquamarine azure beige bisque black blanchedalmond blue blueviolet brown burlywood cadetblue chartreuse chocolate coral cornflowerblue cornsilk crimson cyan darkblue darkcyan darkgoldenrod darkgray darkgrey darkgreen darkkhaki darkmagenta darkolivegreen darkorange darkorchid darkred darksalmon darkseagreen darkslateblue darkslategray darkslategrey darkturquoise darkviolet deeppink deepskyblue dimgray dimgrey dodgerblue firebrick floralwhite forestgreen fuchsia gainsboro ghostwhite gold goldenrod gray grey green greenyellow honeydew hotpink indianred indigo ivory khaki lavender lavenderblush lawngreen lemonchiffon lightblue lightcoral lightcyan lightgoldenrodyellow lightgray lightgrey lightgreen lightpink lightsalmon lightseagreen lightskyblue lightslategray lightslategrey lightsteelblue lightyellow lime limegreen linen magenta maroon mediumaquamarine mediumblue mediumorchid mediumpurple mediumseagreen mediumslateblue mediumspringgreen mediumturquoise mediumvioletred midnightblue mintcream mistyrose moccasin navajowhite navy oldlace olive olivedrab orange orangered orchid palegoldenrod palegreen paleturquoise palevioletred papayawhip peachpuff peru pink plum powderblue purple red rosybrown royalblue saddlebrown salmon sandybrown seagreen seashell sienna silver skyblue slateblue slategray slategrey snow springgreen steelblue tan teal thistle tomato turquoise violet wheat white whitesmoke yellow yellowgreen

syntax match cssUnits contained /\%(#\|%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\|rem\|dpi\|dppx\|dpcm\|vh\|vw\|vmin\|vmax\|deg\|grad\|rad\|ms\|s\|Hz\|kHz\|fr\)/

syntax match cssVariable contained /--[a-zA-Z0-9-_]\+/

syntax region cssFunction        contained  start=/\<[a-zA-Z0-9-]\+\>\+(/ end=/)/ contains=cssFuncName extend keepend
syntax match cssFuncName         contained  /\<[a-zA-Z0-9-]\+\>(\@=/ nextgroup=cssFuncArgs,cssFuncUrlArgs,cssFuncVar,cssFuncAttrArgs,cssFuncEffectArgs,cssFuncCalcArgs
syntax region cssFuncArgs        contained matchgroup=cssFuncDelimiters start=/(/ end=/)/ contains=cssFunction,cssString,cssNumber,cssHexColor,cssColor,cssOperators,cssValueNoise
syntax region cssFuncUrlArgs     contained matchgroup=cssFuncDelimiters start=/\%(url\)\@<=(/ end=/)/ contains=cssString
syntax region cssFuncAttrArgs    contained matchgroup=cssFuncDelimiters start=/\%(attr\)\@<=(/ end=/)/ contains=cssAttrProp
syntax region cssFuncEffectArgs  contained matchgroup=cssFuncDelimiters start=/\%(blur\|brightness\|contrast\|drop-shadow\|grayscale\|hue-rotate\|invert\|opacity\|saturate\|sepia\)\@<=(/ end=/)/ contains=cssNumber,cssColor
syntax region cssFuncCalcArgs    contained matchgroup=cssFuncDelimiters start=/\%(calc\)\@<=(/ end=/)/ contains=cssNumber,cssOperators
syntax region cssFuncVar         contained matchgroup=cssFuncDelimiters start=/\%(var\)\@<=(/ end=/)/ contains=cssVariable,@cssValues,cssValueNoise

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
highlight default link cssMediaFeature                Special
highlight default link cssMediaFeatureAnd             Special
highlight default link cssPseudoDirKeywords           Constant
highlight default link cssPseudoFunctionLang          Constant
highlight default link cssPseudoFunctionTypeOperators Operator
highlight default link cssPseudoFunctionTypeNumbers   Number
highlight default link cssFuncUrlArgs                 Special
highlight default link cssAttrComma                   Noise
highlight default link cssAttrTypes                   Operator
highlight default link cssAttrProp                    Constant
highlight default link cssOperators                   Operator
highlight default link cssBracketError                Error
highlight default link cssFuncName                    Function
highlight default link cssFuncDelimiters              Operator
highlight default link cssVariableDefinition          Special
highlight default link cssVariable                    Special

let b:current_syntax = 'css'

if main_syntax ==# 'css'
  unlet main_syntax
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
