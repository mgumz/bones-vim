( for /R %QTDIR%\include %%h in (*.h) do @type %%h ) > header.lst
%VIMRUNTIME%\vim.exe -u NONE -U NONE -N -s create_qt4_tags.vim header.lst
%VIMRUNTIME%\ctags.exe -L header.lst -f qt4.tags --c++-kinds=+p --fields=+iaS --extra=+q
del header.lst
