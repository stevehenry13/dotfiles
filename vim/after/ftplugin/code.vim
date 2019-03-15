setlocal fo+=t fo-=l
setlocal expandtab
setlocal smarttab
setlocal tw=100
autocmd BufWinEnter * match BadFormat /\%>100v.\+\|\t\|\s\+$/
autocmd InsertEnter * match BadFormat /\%>100v.\+\|\t\|\s\+\%#\@<!$/
autocmd InsertLeave * match BadFormat /\%>100v.\+\|\t\|\s\+$/
