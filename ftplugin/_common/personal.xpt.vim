XPTemplate priority=personal

XPTemplateDef

" - using 'strftime' directly would only get the value 
"   on the first call of it. to avoid this: XSET
" - `^ after `ymd^ allows to press <tab> to keep
"   the created time

XPT YMD hint=date\ 'YYYYMMDD'
XSET ymd=strftime("%Y%m%d")
`ymd^`^

XPT YMDs hint=date\ 'YYMMDD'
XSET ymds=strftime("%y%m%d")
`ymds^`^

XPT YMDt hint=date\ 'YYYY-MM-DD\ HH:MM:SS'
XSET ymdt=strftime("%Y-%m-%d %T")
`ymdt^`^

XPT YMDb hint=date\ 'YYYY-MM-DD'
XSET ymdb=strftime("%Y-%m-%d")
`ymdb^`^

