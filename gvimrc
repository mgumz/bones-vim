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

