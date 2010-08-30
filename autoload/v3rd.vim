" v3rd.vim - v3rd party plugin management
" Author:    Mathias Gumz <mathias gumz at gmail com>
" Version:   1.0
" Inspiration: pathogen.vim by Tim Pope
" 
"-----------------------------------------------------"

if exists('g:loaded_v3rd') || &cp | finish | endif
let g:loaded_v3rd = 1

"-----------------------------------------------------"

let s:v3rd_disabled = 'disabled'

"-----------------------------------------------------"

fun! s:for_each_do(dir, act)
    let dirs=split(globpath(&rtp, a:dir.'/*'),'\n')
    for d in dirs
        call {a:act}(expand(escape(escape(d, ' \'), ' \')))
    endfor
endf

fun! s:add_2_rtp(path)
    if !filereadable(a:path.s:v3rd_disabled)
        let &rtp.=','.a:path
    endif
endf

fun! s:update_docs(path)
    echo 'creating docs for '.a:path
    if isdirectory(a:path.'/doc') | exec 'helptags '.a:path.'/doc' | endif
endf

"-----------------------------------------------------"

" a:1 - name of subfolder, default: '3rd'
" a:2 - name of the file that disables loading a plugin, default: 'disabled'
fun! v3rd#load_3rd_plugins(...)
    if a:0 > 1 | let s:v3rd_disabled = a:2 | endif
    call s:for_each_do(a:0 ? a:1 : '3rd', 's:add_2_rtp')
endf

fun! v3rd#update_docs(...)
    call s:for_each_do(a:0 ? a:1 : '3rd', 's:update_docs')
endf

