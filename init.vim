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

func s:setup_encoding()
    if ($TERM == 'rxvt-unicode') && (&termencoding == '')
        set termencoding=utf-8
    endif
    if &term =~ 'xterm' || &term == 'rxvt-unicode'
        if exists('&t_SI')
            let &t_SI = '\<Esc>]12;lightgoldenrod\x7'
            let &t_EI = '\<Esc>]12;grey80\x7'
        endif
    endif
    set encoding=utf-8
endf


func s:setup_theme()
    set background=dark
    colorscheme badwolf

    if has('gui_running')
        let l:fsize = '13'
        let l:font = 'Consolas'
        if has('gui_kde')
            let l:font = l:font . '/' . l:fsize . '/-1/5/50/0/0/0/0/0'
        elseif has('mac')
            let l:font = 'Menlo Regular:h' . l:fsize
        elseif has('gui_gtk')
            let l:font = l:font . ' ' . l:fsize
        elseif has('win32') || has('win64')
            let l:font = l:font . ':h' . l:fsize
        else
            let l:font = '-xos4-terminus-medium-r-normal--'.l:fsize.'-140-72-72-c-80-iso8859-1'
        endif
        let &guifont = l:font
    endif

    if has('nvim')
        set termguicolors
    endif
endf


func s:setup_gui()
    set guioptions=afgi
    set gcr=a:blinkwait1000-blinkon1000-blinkoff250
endf


func s:setup_tooltip()
    if exists('+balloon_eval')
        func! FoldSpellBalloon()
            let foldStart = foldclosed(v:beval_lnum)
            let foldEnd = foldclosedend(v:beval_lnum)
            let lines = []
            " Detect if we are in a fold
            if foldStart < 0
                " Detect if we are on a misspelled word
                let lines = spellsuggest(spellbadword(v:beval_text)[ 0 ], 5, 0)
            else
                " we are in a fold
                let numLines = foldEnd - foldStart + 1
                " if we have too many lines in fold, show only the first 14
                " and the last 14 lines
                if (numLines > 31)
                    let lines = getline(foldStart, foldStart + 14)
                    let lines += ['-- Snipped ' . (numLines - 30) . ' lines --']
                    let lines += getline(foldEnd - 14, foldEnd)
                else
                    "less than 30 lines, lets show all of them
                    let lines = getline(foldStart, foldEnd)
                endif
            endif
            return join(lines, has('balloon_multiline') ? '\n' : ' ')
        endf
        set balloonexpr=FoldSpellBalloon()
        set noballooneval " enable it manually
    endif
endfunc


func s:setup_search()
    set hlsearch

    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.4, 'Visual')<cr>
    nnoremap <silent> N   N:call HLNext(0.4, 'Visual')<cr>

    if !exists('autocommands_loaded')
        " http://superuser.com/questions/156248/disable-set-hlsearch-when-i-enter-insert-mode/156290#156290
        autocmd InsertEnter * :setlocal nohlsearch
        autocmd InsertLeave * :setlocal hlsearch
    endif
    set incsearch
    set ignorecase
    set smartcase
endf


func s:setup_ws_display()
    " Show tabs and trailing whitespace visually
    if (&termencoding == 'utf-8' || has('gui_running'))
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
endf


func s:setup_visual_helpers()
    set showbreak=+
    set number
    set ruler
    set visualbell vb
    " if possible, try to use a narrow number column.
    if v:version >= 700 && exists('+linebreak')
       set numberwidth=3
    endif

    if (has('gui_running') && v:version >= 700) || (has('nvim'))
        set cursorline
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
endf


func s:setup_lines()
    set textwidth=78
    set formatoptions-=t " don't wrap at textwidth, no need to set tw=0
    set nolinebreak
    set nowrap
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set expandtab
endf


func s:setup_completion()
    set wildignore=*.o,*.bak,*.exe,*.so
    set wildmenu                                 "menu when tabcomplete
    set wildmode=list:longest,full
    set completeopt+=longest

    if exists('+shellslash') | set shellslash | endif
endf


func s:setup_status_line()
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

    " lightline configuration
    let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
          \   'right': [ [ 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
          \ },
          \ 'component_function': {
          \   'fugitive': 'LightlineFugitive',
          \   'filename': 'LightlineFilename',
          \   'fileformat': 'LightlineFileformat',
          \   'filetype': 'LightlineFiletype',
          \   'fileencoding': 'LightlineFileencoding',
          \   'mode': 'LightlineMode'
          \ },
          \ 'subseparator': { 'left': '|', 'right': '|' }
          \ }

    func! LightlineModified()
      return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
    endfunc

    func! LightlineReadonly()
      return &ft !~? 'help' && &readonly ? 'RO' : ''
    endfunc

    func! LightlineFilename()
      let fname = expand('%:t')
      return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
            \ fname == '__Tagbar__' ? g:lightline.fname :
            \ fname =~ '__Gundo\|NERD_tree' ? '' :
            \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
            \ &ft == 'unite' ? unite#get_status_string() :
            \ &ft == 'vimshell' ? vimshell#get_status_string() :
            \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
            \ ('' != fname ? fname : '[No Name]') .
            \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
    endfunc

    func! LightlineFugitive()
      try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
          let mark = ''  " edit here for cool mark
          let branch = fugitive#head()
          return branch !=# '' ? mark.branch : ''
        endif
      catch
      endtry
      return ''
    endfunc

    func! LightlineFileformat()
      let icon = ''
      if exists('g:loaded_webdevicons')
          let icon = ' ' . WebDevIconsGetFileFormatSymbol()
      endif
      return winwidth(0) > 70 ? &fileformat . icon : ''
    endfunc

    func! LightlineFiletype()
      let icon = ''
      if exists('g:loaded_webdevicons')
          let icon = ' ' . WebDevIconsGetFileTypeSymbol()
      endif
      return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype . icon : 'no ft') : ''
    endfunc

    func! LightlineFileencoding()
      return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
    endfunc

    func! LightlineMode()
      let fname = expand('%:t')
      return fname == '__Tagbar__' ? 'Tagbar' :
            \ fname == 'ControlP' ? 'CtrlP' :
            \ fname == '__Gundo__' ? 'Gundo' :
            \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
            \ fname =~ 'NERD_tree' ? 'NERDTree' :
            \ &ft == 'unite' ? 'Unite' :
            \ &ft == 'vimfiler' ? 'VimFiler' :
            \ &ft == 'vimshell' ? 'VimShell' :
            \ winwidth(0) > 60 ? lightline#mode() : ''
    endfunc

    let g:unite_force_overwrite_statusline = 0
    let g:vimfiler_force_overwrite_statusline = 0
    let g:vimshell_force_overwrite_statusline = 0

endf


func s:setup_tags()
    " search upward for a 'tags' file
    let &tags='tags;./tags'
    " add some more tags (mainly for omnicompletion)
    let s:tfs=split(globpath(&rtp, 'tags/*.tags'), '\n')
    for s:tf in s:tfs
        let &tags.=','.expand(escape(escape(s:tf, ' '), ' '))
    endfor
endf


func s:setup_modeline()
    " Enable modelines only on secure vim versions
    if (v:version == 603 && has('patch045')) || (v:version > 603)
        set modeline
    else
        set nomodeline
    endif
endf


func s:setup_indentation()
    set cindent
    set cpoptions+=$
    autocmd BufRead,BufNewFile *.txt setlocal nocindent
    autocmd BufRead,BufNewFile * if &ft == 'changelog' | setlocal nocindent | endif
endf


func s:setup_window()
    set scrolloff=3
    set hidden
    set lazyredraw
    set splitbelow
    set splitright
    set virtualedit=block
    set mouse=a
endf


func s:setup_filehandling()
    "set dir=$TEMP,~/tmp,/tmp
endf


set nocompatible
if has('printer')
    set popt+=syntax:y    "syntax when printing
endif

"set dictionary=/usr/share/dict/words

if has('eval')
    filetype on
    filetype plugin on
    filetype indent on
endif

if has('digraphs')
    digraph ., 8230  " ellipsis (¿)
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter complaints if "git" is not available. so, disable it
" here and check later on, if its there
let g:gitgutter_git_executable = exepath("cat") " 'cat' works on *nix|win

execute("silent! source ".globpath(split(&rtp, ",")[0], "vimrc.local"))
execute("silent! source ".globpath(split(&rtp, ",")[0], "init.local.vim"))

" with vim8 came support for native vim packages. vim8 loads
" all the plugins into pack/*/start/ folder(s). pathogen
" is fully aware of this and 'does the right thing'
if !has('packages')
    call pathogen#infect()
endif

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

if has('gui_running')
    call s:setup_gui()
    call s:setup_tooltip()
endif

call s:setup_filehandling()
call s:setup_tags()

"settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" plugin - settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" vim8 situation: the plugins are loaded after vim/neovim has parsed
" vimrc/init.vim. the VimEnter event is used to signal vim/neovim is
" done loading all the plugins and ready for use. so, at that point
" its useful to check if certain plugins are actually there.
func s:setup_after_vim_enter()

    if exists("g:scrollfix_plugin")
        let g:scrollfix=-1 "disabled for normal work
    endif

    if exists("g:loaded_gitgutter")
        if !executable('git')
            let g:gitgutter_enabled = 0
        else
            let g:gitgutter_git_executable = exepath("git")
            exec 'GitGutterEnable'
        end
    endif

    if exists("g:loaded_fzf")
        " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
        command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
          \   <bang>0 ? fzf#vim#with_preview('up:60%')
          \           : fzf#vim#with_preview('right:50%:hidden', '?'),
          \   <bang>0)


        imap <c-x><c-k> <plug>(fzf-complete-word)
        imap <c-x><c-f> <plug>(fzf-complete-path)
        imap <c-x><c-j> <plug>(fzf-complete-file-ag)
        imap <c-x><c-l> <plug>(fzf-complete-line)

        autocmd! FileType fzf
        autocmd  FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    endif
endfunc

autocmd VimEnter * call s:setup_after_vim_enter()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" own stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" http://www.techtalkshub.com/instantly-better-vim/
funct! HLNext (blinktime, hlgroup)
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let target_pat = '\c\%#'.@/
        let ring = matchadd(a:hlgroup, target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
endfunc

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

map <unique> ,bcb :call AddBlock('c', 74)<CR>
map <unique> ,bcn :call AddBlock('c', 64)<CR>
map <unique> ,bcs :call AddBlock('c', 54)<CR>
map <unique> ,bbb :call AddBlock('file', 74)<CR>
map <unique> ,bbn :call AddBlock('file', 64)<CR>
map <unique> ,bbs :call AddBlock('file', 54)<CR>
map <unique> ,bsb :call AddBlock('shell', 74)<CR>
map <unique> ,bsn :call AddBlock('shell', 64)<CR>
map <unique> ,bss :call AddBlock('shell', 54)<CR>
map <unique> ,btb :call AddBlock('tex', 74)<CR>
map <unique> ,btn :call AddBlock('tex', 64)<CR>
map <unique> ,bts :call AddBlock('tex', 54)<CR>


" create asciidoc style underlines
func! UnderLine(char)
    execute 'normal YYpVr' . a:char . 'o'
endfunc

map <unique> ,u1 :call UnderLine('=')<CR>
map <unique> ,u2 :call UnderLine('-')<CR>
map <unique> ,u3 :call UnderLine('~')<CR>
map <unique> ,u4 :call UnderLine('^')<CR>
map <unique> ,u5 :call UnderLine('+')<CR>

" last used path
if has('unix')
  map ,e :e <C-R>=expand('%:p:h') . '/' <CR>
else
  map ,e :e <C-R>=expand('%:p:h') . '\' <CR>
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
nnoremap ,lcd :lcd %:p:h<CR>

