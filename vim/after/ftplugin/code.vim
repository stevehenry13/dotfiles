setlocal fo+=t fo-=l
setlocal expandtab
setlocal smarttab
setlocal tw=120
autocmd BufWinEnter * match BadFormat /\%>120v.\+\|\t\|\s\+$/
autocmd InsertEnter * match BadFormat /\%>120v.\+\|\t\|\s\+\%#\@<!$/
autocmd InsertLeave * match BadFormat /\%>120v.\+\|\t\|\s\+$/
