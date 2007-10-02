"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  author: mathias gumz
"    file: vimrc
"
"   thanx: a _lot_ of stuff comes from ciaranm
"
"     $Id: vimrc,v 1.22 2004/02/05 14:59:23 mathias Exp $
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
scriptencoding utf-8

if ($TERM == "rxvt-unicode") && (&termencoding == "")
    set termencoding=utf-8
endif

if &term =~ "xterm" || &term == "rxvt-unicode"
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
        let &t_EI = "\<Esc>]12;grey80\x7"
    endif
endif

set nocompatible
set cindent
set expandtab
set guioptions=afgimrT
set incsearch
" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=tab:»·,trail:·,extends:¿,nbsp:¿
    else
        set list listchars=tab:»·,trail:·,extends:¿
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif
set nowrap
set number
set ruler
set shiftwidth=4
set softtabstop=4
set tabstop=4
set textwidth=78
set visualbell vb
set wildignore=*.o,*.bak,*.exe,*.so
set wildmenu                                 "menu when tabcomplete
set popt+=syntax:y                           "syntax when printing
set lazyredraw

set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          " vim buddy
endif
set statusline+=%=                           " right align
set statusline+=0x%-8B\                      " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

set dictionary=/usr/share/dict/words

" If possible, try to use a narrow number column.
if v:version >= 700
    try
        setlocal numberwidth=3
    catch
    endtry
endif

if has("syntax")
    syntax on
endif

if has("eval")
    filetype on
    filetype plugin on
    filetype indent on
endif

" Enable modelines only on secure vim versions
if (v:version == 603 && has("patch045")) || (v:version > 603)
    set modeline
else
    set nomodeline
endif

" runtime ftplugin/man.vim
" runtime macros/matchit.vim
" runtime plugin/a.vim
let g:alternateExtensions_cc = "hh,HH"
let g:alternateExtensions_hh = "cc,CC"

"settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gui - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
end

if has("gui_running")
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
else
  colorscheme koehler
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist.vim

map <unique> ,<F2> :TlistSync<CR>
map <unique> <F2>  :Tlist<CR>
let Tlist_Ctags_Cmd = 'exuberant-ctags'
let Tlist_Inc_Winwidth = 0
"let Tlist_Use_Horiz_Window = 1

" minibufexpl
map <unique> <F5>  :TMiniBufExplorer<cr>

" spell.vim
let mapleader="\\"
let spell_executable="aspell"
let spell_auto_type   = ''
let spell_insert_mode = 0

" calendar.vim
map <unique> <F3>  :Calendar<CR>
let g:calendar_diary = "~/.diary"

" showmark.vim
map <unique> <F4>  :ShowMarksToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" own stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

map <unique> ,x xp  " swap 2 chars
map <unique> ,y ddp " swap 2 lines

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


" 
" number lines (yeah, another one)
func! NumberLines(style) range
  execute (a:firstline) . "," . a:lastline . '!cat -n'
  if ( a:style == "c" )
    execute (a:firstline) . "," . a:lastline . 's/^[[:space:]]*\([[:digit:]]\+\)*[[:space:]]*/\/* \1 *\//'
  endif
endfunc 

" last used path
if has("unix")
  map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
  map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

" beautify text
map <unique> ,4 :%s/[[:space:]]\+$//g<CR> :%s/<C-V><CR>$//g<CR>:%retab<CR>

func! Indent()
  "execute '%!indent -nsaf -npcs -cli4 -i4 -lp -nprs -nsaw -nut -cbi4 -bl -bli0 -bls -nbad -npsl'
  execute "%!indent -nsaf -npcs -cli4 -i4 -lp -nprs -nsaw -nut -cbi4 -bli0 -bls -nbad -npsl -bl -bad -brz -cez -cdwz -brs"
endfunc

map <unique> ,f  !!fortune<CR>
map <unique> ,fa !!fortune hitchhiker<CR>
map <unique> ,fh !!fortune homer<CR>
map <unique> ,ff !!fortune futurama<CR>
map <unique> ,fl !!fortune law<CR>
map <unique> ,fs !!fortune starwars<CR>

" insert date
iab YMD <C-R>=strftime("%y%m%d %T")<CR>
iab YMDb <C-R>=strftime("%Y-%m-%d")<CR>

" enter in commandmode will insert an enter (604)
nmap <CR> _i<CR><ESC>

" map meta-left/right to  next/previos word
map <unique> <M-Left> b
imap <unique> <M-Left> <ESC>bi
map <unique> <M-Right> e
imap <unique> <M-Right> <ESC>ea

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent! source ~/.vim/vimrc.local
