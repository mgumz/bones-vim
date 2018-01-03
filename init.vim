scriptencoding utf-8
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  author: mathias gumz
"    file: vimrc
"
"   thanx: a _lot_ of stuff comes from ciaranm
"
"       http://github.com/ciaranm/dotfiles-ciaranm/tree/master
"
"   more helpful information:
"
"       http://items.sjbach.com/319/configuring-vim-right
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function s:setup_encoding()
    if ($TERM == "rxvt-unicode") && (&termencoding == "")
        set termencoding=utf-8
    endif
    if &term =~ "xterm" || &term == "rxvt-unicode"
        if exists('&t_SI')
            let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
            let &t_EI = "\<Esc>]12;grey80\x7"
        endif
    endif
    set encoding=utf-8
endfunction


function s:setup_theme()
    set background=dark
    colorscheme badwolf

    if has("gui_running")
        let l:fsize = "13"
        let l:font = "Consolas"
        if has("gui_kde")
            let l:font = l:font . "/" . l:fsize . "/-1/5/50/0/0/0/0/0"
        elseif has("mac")
            let l:font = "Menlo Regular:h" . l:fsize
        elseif has("gui_gtk")
            let l:font = l:font . " " . l:fsize
        elseif has("win32") || has("win64")
            let l:font = l:font . ":h" . l:fsize
        else
            let l:font = "-xos4-terminus-medium-r-normal--".l:fsize."-140-72-72-c-80-iso8859-1"
        endif
        let &guifont = l:font
    endif

    if has('nvim')
        set termguicolors
    endif
endfunction


function s:setup_gui()
    set guioptions=afgi
    set gcr=a:blinkwait1000-blinkon1000-blinkoff250
endfunction


function s:setup_tooltip()
    if exists("+balloon_eval")
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
    endif
endfunction


function s:setup_search()
    set hlsearch

    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.4, "Visual")<cr>
    nnoremap <silent> N   N:call HLNext(0.4, "Visual")<cr>

    if !exists("autocommands_loaded")
        " http://superuser.com/questions/156248/disable-set-hlsearch-when-i-enter-insert-mode/156290#156290
        autocmd InsertEnter * :setlocal nohlsearch
        autocmd InsertLeave * :setlocal hlsearch
    endif
    set incsearch
    set ignorecase
    set smartcase
endfunction


function s:setup_ws_display()
    " Show tabs and trailing whitespace visually
    if (&termencoding == "utf-8" || has('gui_running'))
        if v:version >= 700
            set listchars=tab:»·,trail:·,extends:¿,nbsp:¿
        else
            set listchars=tab:»·,trail:·,extends:¿
        endif
    else
        if v:version >= 700
            set listchars=tab:>-,trail:.,extends:>,nbsp:_
        else
            set listchars=tab:>-,trail:.,extends:>
        endif
    endif
    set list
endfunction


function s:setup_visual_helpers()
    set showbreak=+
    set number
    set ruler
    set visualbell vb
    " if possible, try to use a narrow number column.
    if v:version >= 700 && exists('+linebreak')
       set numberwidth=3
    endif

    " colorcolumn | mark 
    if exists('+cc')
        "set colorcolumn=+1   " mark textwidth + 1 column as end

        " http://www.techtalkshub.com/instantly-better-vim/
        let s=printf('\%%%dv', &l:textwidth + 1)
        call matchadd('ColorColumn', s, 100)
    endif
    if has("syntax")
        syntax on
    endif
endfunction


function s:setup_lines()
    set textwidth=78
    set formatoptions-=t " don't wrap at textwidth, no need to set tw=0
    set nolinebreak
    set nowrap
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set expandtab
endfunction


function s:setup_completion()
    set wildignore=*.o,*.bak,*.exe,*.so
    set wildmenu                                 "menu when tabcomplete
    set wildmode=list:longest,full
    set completeopt+=longest

    if exists('+shellslash') | set shellslash | endif
endfunction


function s:setup_status_line()
    set laststatus=2
    set statusline=
    set statusline+=%-3.3n\                      " buffer number
    set statusline+=%f\                          " file name
    set statusline+=%h%m%r%w                     " flags
    set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
    set statusline+=%{&encoding},                " encoding
    set statusline+=%{&fileformat}]              " file format
    set statusline+=%=                           " right align
    set statusline+=%-b\ 0x%-8B\                 " current char
    set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset
endfunction


function s:setup_tags()
    " search upward for a 'tags' file
    let &tags="tags;./tags"
    " add some more tags (mainly for omnicompletion)
    let s:tfs=split(globpath(&rtp, "tags/*.tags"),"\n")
    for s:tf in s:tfs
        let &tags.=",".expand(escape(escape(s:tf, " "), " "))
    endfor
endfunction


function s:setup_modeline()
    " Enable modelines only on secure vim versions
    if (v:version == 603 && has("patch045")) || (v:version > 603)
        set modeline
    else
        set nomodeline
    endif
endfunction


function s:setup_indentation()
    set cindent
    set cpoptions+=$
    autocmd BufRead,BufNewFile *.txt setlocal nocindent
    autocmd BufRead,BufNewFile * if &ft == 'changelog' | setlocal nocindent | endif
endfunction


function s:setup_window() " {{{1
    set scrolloff=3
    set hidden
    set lazyredraw
    set splitbelow
    set splitright
    set virtualedit=block
endfunction             " }}}


set nocompatible
set popt+=syntax:y                           "syntax when printing

"set dictionary=/usr/share/dict/words

if has("eval")
    filetype on
    filetype plugin on
    filetype indent on
endif

if has("digraphs")
    digraph ., 8230  " ellipsis (¿)
endif


set dir=$TEMP,~/tmp,/tmp


let g:pathogen_disabled=[]

execute("silent! source ".globpath(split(&rtp, ",")[0], "vimrc.local"))
execute("silent! source ".globpath(split(&rtp, ",")[0], "init.local.vim"))

if !executable('git') 
    let g:pathogen_disabled += [ 'vim-gitgutter', 'nerdtree-git-plugin' ]
end
if !executable('ctags')
    let g:pathogen_disabled += [ 'tagbar', 'taglist-46' ]
endif

call pathogen#infect('3rd/{}')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call s:setup_encoding()
call s:setup_theme()
call s:setup_status_line()
call s:setup_modeline()
call s:setup_window()
call s:setup_lines()

call s:setup_completion()
call s:setup_search()

call s:setup_visual_helpers()
call s:setup_ws_display()
call s:setup_indentation()

if has("gui_running")
    call s:setup_gui()
    call s:setup_tooltip()
endif

call s:setup_tags()

"settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" HTML
let g:html_tag_case = 'lowercase'
let g:no_html_toolbar = 'yes'
let g:no_html_tab_mapping = 'yes'

" scrollfix.vim
let g:scrollfix=-1 "disabled for normal work

" pydoc.vim
if has('win32') || has('win64')
    let g:pydoc_cmd = 'python -m pydoc'
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" own stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" http://www.techtalkshub.com/instantly-better-vim/
function! HLNext (blinktime, hlgroup)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#'.@/
        let ring = matchadd(a:hlgroup, target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction


" add a block
func! AddBlock(style, nr)
  let s:save_co = &comments
  setlocal comments=
  if     ( a:style == "c" && a:nr > 0 )
    let l:pre1="normal i/*-\<ESC>"
    let l:post1="a-\<ESC>a-*\\\<CR>\<ESC>"
    let l:pre2="normal i\\*-\<ESC>"
    let l:post2="a-\<ESC>a-*/\<ESC>ko "
  elseif ( a:style == "file" && a:nr > 0 )
    let l:pre1="normal i-+-\<ESC>"
    let l:post1="a-\<ESC>a-+-\<CR>\<ESC>"
    let l:pre2="normal i-+-\<ESC>"
    let l:post2="a-\<ESC>a-+-\<ESC>ko "
  elseif ( a:style == "shell" && a:nr > 0 )
    let l:pre1="normal i#--\<ESC>"
    let l:post1="a-\<ESC>a#--\<CR>\<ESC>"
    let l:pre2="normal i#--\<ESC>"
    let l:post2="a-\<ESC>a#--\<ESC>ko#  "
  elseif ( a:style == "tex" && a:nr > 0 )
    let l:pre1="normal i%%%\<ESC>"
    let l:post1="a%\<ESC>a%%%\<CR>\<ESC>"
    let l:pre2="normal i%%%\<ESC>"
    let l:post2="a%\<ESC>a%%%\<ESC>ko% "
  endif
  execute l:pre1 . a:nr . l:post1
  execute l:pre2 . a:nr . l:post2
  let &comments = s:save_co
endfunc

map <unique> ,bcb :call AddBlock("c", 74)<CR>
map <unique> ,bcn :call AddBlock("c", 64)<CR>
map <unique> ,bcs :call AddBlock("c", 54)<CR>
map <unique> ,bbb :call AddBlock("file", 74)<CR>
map <unique> ,bbn :call AddBlock("file", 64)<CR>
map <unique> ,bbs :call AddBlock("file", 54)<CR>
map <unique> ,bsb :call AddBlock("shell", 74)<CR>
map <unique> ,bsn :call AddBlock("shell", 64)<CR>
map <unique> ,bss :call AddBlock("shell", 54)<CR>
map <unique> ,btb :call AddBlock("tex", 74)<CR>
map <unique> ,btn :call AddBlock("tex", 64)<CR>
map <unique> ,bts :call AddBlock("tex", 54)<CR>


" create asciidoc style underlines
func! UnderLine(char)
    execute "normal YYpVr" . a:char . "o"
endfunc

map <unique> ,u1 :call UnderLine("=")<CR>
map <unique> ,u2 :call UnderLine("-")<CR>
map <unique> ,u3 :call UnderLine("~")<CR>
map <unique> ,u4 :call UnderLine("^")<CR>
map <unique> ,u5 :call UnderLine("+")<CR>

" last used path
if has("unix")
  map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
  map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

" beautify text
map <unique> ,4 :%s/[[:space:]]\+$//g<CR> :%s/<C-V><CR>$//g<CR>:%retab<CR>

" enter in commandmode will insert an enter (604)
nmap <CR> :call append(line('.')-1, '')<CR><ESC>

map <unique> <C-F1> :set number!<ESC>

" Make <space> in normal mode go down a page rather than insert a
" character
noremap <space> <C-f>
nnoremap ,cd :cd %:p:h<CR>

