XPTemplate priority=personal

let s:f = g:XPTfuncs()

fun! s:f._strftime(fmt) dict
    return strftime(a:fmt)
endfunction

XPTemplateDef

" - using 'strftime' directly would only get the value 
"   on the first call of it. to avoid this: _strftime

XPT YMD hint=date\ 'YYYYMMDD'
`_strftime("%Y%m%d")^

XPT YMDs hint=date\ 'YYMMDD'
`_strftime("%y%m%d")^

XPT YMDt hint=date\ 'YYYY-MM-DD\ HH:MM:SS'
`_strftime("%Y-%m-%d %T")^

XPT YMDb hint=date\ 'YYYY-MM-DD'
`_strftime("%Y-%m-%d")^



" TODO snippets
XPT nt hint=new\ task
- [ ] `description^

