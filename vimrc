"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  author: mathias gumz
"    file: vimrc
"
"   thanx: a _lot_ of stuff comes from ciaranm
"
"   more helpful information:
"
"       http://items.sjbach.com/319/configuring-vim-right
"
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

set background=dark
set nocompatible
set cpoptions+=$
set cindent

" disable cindet for all .txt files
autocmd BufRead *.txt set nocindent

set expandtab

set hidden
set hlsearch
set incsearch
set ignorecase
set smartcase

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8")
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
set scrolloff=3
set visualbell vb
set wildignore=*.o,*.bak,*.exe,*.so
set wildmenu                                 "menu when tabcomplete
set wildmode=list:longest
set popt+=syntax:y                           "syntax when printing
set lazyredraw
set autochdir
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

"set dictionary=/usr/share/dict/words

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
" plugin - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist.vim

map <unique> ,<F2> :TlistSync<CR>
map <unique> <F2>  :Tlist<CR>
let Tlist_Inc_Winwidth = 0
"let Tlist_Use_Horiz_Window = 1

" minibufexpl
map <unique> <F5>  :TMiniBufExplorer<cr>

" vtreeexplor.vim
map <unique> <F3>  :VSTreeExplore<CR>

" showmark.vim
map <unique> <F4>  :ShowMarksToggle<CR>
let g:showmarks_enable = 0

" HTML
let g:html_tag_case = 'lowercase'
let g:no_html_toolbar = 'yes'

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

func! Indent()
  "execute '%!indent -nsaf -npcs -cli4 -i4 -lp -nprs -nsaw -nut -cbi4 -bl -bli0 -bls -nbad -npsl'
  execute "%!indent -nsaf -npcs -cli4 -i4 -lp -nprs -nsaw -nut -cbi4 -bli0 -bls -nbad -npsl -bl -bad -brz -cez -cdwz -brs"
endfunc

" insert date
iab YMD <C-R>=strftime("%y%m%d %T")<CR>
iab YMDb <C-R>=strftime("%Y-%m-%d")<CR>

" enter in commandmode will insert an enter (604)
nmap <CR> _i<CR><ESC>

" Make <space> in normal mode go down a page rather than left a
" character
noremap <space> <C-f>

" create various c/c++ stuff on the fly
iab gcm_ int main(int argc, char* argv[]) {<cr>xxx;<cr>return 0;<cr>}<cr><Esc>?xxx<cr>c$
iab gcf_ int xxx( edit_parameters ) {<cr>}<Esc>?xxx<cr>cw
iab gci_ if ( xxx ) {<cr><cr>}<Esc>?xxx<cr>cw
iab gce_ else {<cr>}<cr><Esc>kO

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" local stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
silent! source ~/.vim/vimrc.local
