setlocal fo+=t fo-=l
setlocal tabstop=3
setlocal shiftwidth=3
setlocal expandtab
setlocal smarttab
setlocal tw=80
setlocal cindent
setlocal cinoptions=g0,(0,J1
autocmd BufWinEnter * match BadFormat /\%>80v.\+\|\t\|\s\+$/
autocmd InsertEnter * match BadFormat /\%>80v.\+\|\t\|\s\+\%#\@<!$/
autocmd InsertLeave * match BadFormat /\%>80v.\+\|\t\|\s\+$/
