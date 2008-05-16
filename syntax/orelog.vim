syntax match orelogTitle    +\(\%^\|\_^--\n\)\@<=.*+ contains=orelogTags
syntax match orelogSep      +^--$+
syntax match orelogCode     +^\t.*$+
syntax match orelogQuote    +^> .*+ contains=orelogQuotePre
syntax match orelogList     +^ \+\*+

syntax match orelogTitle        +\(\%^\|--\n\)\@<=hatena:.*$+ contains=orelogTags nextgroup=orelogHatena skipnl

syntax match orelogTags         + - .*$+ contains=orelogTagsSep contained
syntax match orelogTagsSep      + - + contained

syntax match orelogQuotePre     +^> + contained

syntax match orelogURL ,https\=:\/\/[a-zA-Z0-9%/._?&:;#=~+-]\+,

syntax include @Hatena syntax/hatena.vim

syntax region orelogHatena start=+^+ end=+\ze--+ contains=@Hatena contained

syntax region orelogSync matchgroup=orelogSyncSep start=+^{\(sync\|pull\|push\):.*}$+ end=+^{/\(sync\|pull\|push\)}$+ contains=TOP
syntax region orelogSync matchgroup=orelogSyncSep start=+^{\(sync\|pull\|push\):hatena.*}$+ end=+^{/\(sync\|pull\|push\)}$+ contains=@Hatena

highlight link orelogTitle      Directory
highlight link orelogSep        Ignore
highlight link orelogCode       Character
highlight link orelogQuote      String
highlight link orelogList       Number

highlight link orelogTags       Type
highlight link orelogTagsSep    Ignore

highlight link orelogQuotePre   Ignore

highlight link orelogURL        Underlined

highlight link orelogSyncSep    Special
