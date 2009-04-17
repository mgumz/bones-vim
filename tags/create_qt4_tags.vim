:set ul=-1
:argdo %s@^#include "[\./]*@\="".substitute(expand("$QTDIR"), "\\", "/", "g")."/"@ | %s@"$*@@ | %s@/@\\@g
:wq
