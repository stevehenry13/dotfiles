setlocal formatoptions=cqt
setlocal ts=3
setlocal sw=3
setlocal expandtab
setlocal tw=79
setlocal autoindent
setlocal smartindent
hi Col80Limit term=reverse ctermfg=black ctermbg=yellow
match Col80Limit /\%>81v.\+/
