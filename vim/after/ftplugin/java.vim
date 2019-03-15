source $HOME/.vim/after/ftplugin/code.vim
setlocal tabstop=4
setlocal shiftwidth=4

setlocal cinoptions=g0,(0

function! JavaAlternate( cmd )
  let l:current_file = expand( '%' )
  let l:test_suffix = 'Test.java'
  let l:test_prefix = 'src/test'
  let l:app_prefix = 'src/main'
  if l:current_file =~ l:test_suffix . '$'
    let l:alt_file = substitute( l:current_file, l:test_prefix . '\(.*\)' . l:test_suffix, l:app_prefix . '\1.java', '' )
  else
    let l:alt_file = substitute( l:current_file, l:app_prefix . '\(.*\).java', l:test_prefix . '\1' . l:test_suffix, '' )
  endif

  let l:dir = fnamemodify( alt_file, ':h' )
  if !isdirectory( dir )
    call mkdir( dir, 'p' ) 
  endif

  return a:cmd . ' ' . fnameescape( alt_file )
endfunction

command! -buffer -bar A  :exe JavaAlternate( 'edit<bang>' )
command! -buffer -bar AV :exe JavaAlternate( 'vsplit' )
command! -buffer -bar AS :exe JavaAlternate( 'split' )

set path+=src/main/java
set path+=*/src/main/java
