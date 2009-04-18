( for /R "%QTDIR%\include" %%h in (*.h) do @type %%h ) > "%TEMP%\header.lst"
"%VIMRUNTIME%"\vim.exe -u NONE -U NONE -N -s "%~dp0create_qt4_tags_win.vim" "%TEMP%\header.lst"
"%VIMRUNTIME%"\ctags.exe -L "%TEMP%\header.lst" -f qt4.tags --c++-kinds=+p --fields=+iaS --extra=+q
del "%TEMP%\header.lst"
