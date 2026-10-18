" NOTE: Syntax highlighting for SnipMate .snippets files (LuaSnip from_snipmate).

if exists("b:current_syntax")
  finish
endif

" Comments: a line starting with #
syntax match snipComment /^#.*$/

" Header line: `snippet <trigger> <description>`
syntax match snipKeyword /^snippet\>/ nextgroup=snipTrigger skipwhite
syntax match snipTrigger /\S\+/ contained nextgroup=snipDescription skipwhite
syntax match snipDescription /.*$/ contained

" Tab stops and placeholders anywhere in the body
syntax match snipTabStop /\$\d\+/
syntax match snipPlaceholder /\${\d\+\%(:[^}]*\)\?}/
syntax match snipEscape /\\[$`]/

highlight default link snipComment     Comment
highlight default link snipKeyword     Keyword
highlight default link snipTrigger     Identifier
highlight default link snipDescription String
highlight default link snipTabStop     Special
highlight default link snipPlaceholder Special
highlight default link snipEscape      SpecialChar

let b:current_syntax = "snippets"
