function! SvnDiffPrint(file, rev)
   let file_syntax=&syntax
   vnew
   setlocal buftype=nofile bufhidden=hide noswapfile
   exe 'read !svn cat -r '.a:rev.' '.a:file.' 2>/dev/null'
   exe 'set syntax='.file_syntax
   exe 'file '.a:file.a:rev
   diffthis
   0,0g/^$/d
   wincmd p
endfunction

function! SvnDiff(...)
   let filename = system('echo -n '.expand('%'))
   let rev = 'HEAD'
   if a:0 >= 1 && a:1 != ''
      let rev = a:1
   endif
   diffthis
   call SvnDiffPrint(filename, rev)
endfunction

function! SvnBlame()
   let filename = system('echo -n '.expand('%'))
   let file_syntax=&syntax
   setlocal scrollbind
   set scrollopt=ver
   vnew
   setlocal buftype=nofile bufhidden=hide noswapfile
   setlocal scrollbind
   exe "read !svn blame ".filename
   exe 'set syntax='.file_syntax
   exe 'file '.filename.'\#head'
   0,0g/^$/d
endfunction
