" ocrypt.vim
" version 2
" 2007 Mathias Gumz <akira@fluxbox.org>
"
" based on des3.vim
" version 1
" 2007 Noah Spurrier <noah@noah.org>
"
" I release all copyright claims. This code is in the public domain.
" Permission is granted to use, copy modify, distribute, and sell this software
" for any purpose. I make no guarantee about the suitability of this software
" for any purpose and I am not liable for any damages resulting from its use.
" Further, I am under no obligation to maintain or extend this software.
" It is provided on an "as is" basis without any expressed or implied warranty.
"
" == Edit aes encrypted files ==
"
" This will allow editing of aes encrypted files.
" The file must have .aes extension
" The openssl command line tool must be in the path.
" This will turn off the swap file and .viminfo log.
"
" == Install ==
"
" Put this in your plugin directory. For example:
"    /usr/share/vim/vim70/plugin/ocrypt.vim
" You can also source it directly from your .vimrc file:
"    source ~/.vim/ocrypt.vim
"
" You can start by editing an empty unencrypted file with a .aes extension.
" When you first write the file you will be asked to give it a password.
"


" pick what you want
let s:ocrypt_cipher= '-aes-256-cbc'
let s:ocrypt_suffix= '*.aes'

"let s:ocrypt_sh=( has("win32") || has("win64") ) ? 'cmd.exe' : '/bin/sh'
"let s:ocrypt_sh_save = &shell
let s:ocrypt_enc="0,$!openssl enc -e -salt " . s:ocrypt_cipher
let s:ocrypt_dec="0,$!openssl enc -d " . s:ocrypt_cipher

augroup ocrypt_crypt
autocmd!

" don't use swap file or ~/.viminfo while editing
exe 'autocmd BufReadPre,FileReadPre '     . s:ocrypt_suffix . ' set viminfo='
exe 'autocmd BufReadPre,FileReadPre '     . s:ocrypt_suffix . ' set noswapfile'
" filter the encrypted file through openssl after reading
exe 'autocmd BufReadPre,FileReadPre '     . s:ocrypt_suffix . ' set bin'
exe 'autocmd BufReadPre,FileReadPre '     . s:ocrypt_suffix . ' set cmdheight=2'
exe 'autocmd BufReadPost,FileReadPost '   . s:ocrypt_suffix . ' ' . s:ocrypt_dec
" switch back to nobin mode for editing
exe 'autocmd BufReadPost,FileReadPost '   . s:ocrypt_suffix . ' set nobin'
exe 'autocmd BufReadPost,FileReadPost '   . s:ocrypt_suffix . ' set cmdheight&'
exe 'autocmd BufReadPost,FileReadPost '   . s:ocrypt_suffix . ' execute ":doautocmd BufReadPost ".expand("%:r")'
" filter plain text through openssl before writing 
exe 'autocmd BufWritePre,FileWritePre '   . s:ocrypt_suffix . ' set bin'
exe 'autocmd BufWritePre,FileWritePre '   . s:ocrypt_suffix . ' set cmdheight=2'
exe 'autocmd BufWritePre,FileWritePre '   . s:ocrypt_suffix . ' ' . s:ocrypt_enc
" undo the encrypt step so we can continue editing after writing
exe 'autocmd BufWritePost,FileWritePost ' . s:ocrypt_suffix . ' silent u'
exe 'autocmd BufWritePost,FileWritePost ' . s:ocrypt_suffix . ' set nobin'
exe 'autocmd BufWritePost,FileWritePost ' . s:ocrypt_suffix . ' set cmdheight&'

augroup END

