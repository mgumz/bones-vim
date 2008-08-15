"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gui - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if v:version >= 700
    set list listchars=tab:»·,trail:·,extends:¿,nbsp:¿
else
    set list listchars=tab:»·,trail:·,extends:¿
endif

set guioptions-=m
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R

set guioptions-=T
set gcr=a:blinkwait1000-blinkon1000-blinkoff250

colorscheme inkpot

if has("gui_kde")
    set guifont=Terminus/16/-1/5/50/0/0/0/0/0
elseif has("gui_gtk")
    set guifont=Terminus\ 16
elseif has("gui_running")
    set guifont=-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-1
endif

function! FoldSpellBalloon()
    let foldStart = foldclosed(v:beval_lnum )
    let foldEnd = foldclosedend(v:beval_lnum)
    let lines = []
    " Detect if we are in a fold
    if foldStart < 0
        " Detect if we are on a misspelled word
        let lines = spellsuggest( spellbadword(v:beval_text)[ 0 ], 5, 0 )
    else
        " we are in a fold
        let numLines = foldEnd - foldStart + 1
        " if we have too many lines in fold, show only the first 14
        " and the last 14 lines
        if ( numLines > 31 )
            let lines = getline( foldStart, foldStart + 14 )
            let lines += [ '-- Snipped ' . ( numLines - 30 ) . ' lines --' ]
            let lines += getline( foldEnd - 14, foldEnd )
        else
            "less than 30 lines, lets show all of them
            let lines = getline( foldStart, foldEnd )
        endif
    endif
    " return result
    return join( lines, has( "balloon_multiline" ) ? "\n" : " " )
endfunction
set balloonexpr=FoldSpellBalloon()
set noballooneval " enable it manually

