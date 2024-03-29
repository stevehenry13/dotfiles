source $HOME/.vim/after/ftplugin/code.vim
setlocal tabstop=4
setlocal shiftwidth=4

setlocal cinoptions=g0,(0,j4,J4

function! NgAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '_spec.js$'
    let l:alt_file = substitute( l:current_file, 'test/spec/\(.*\)_spec.js', 'app/\1.js', '' )
  else
    let l:alt_file = substitute( l:current_file, 'app/\(.*\).js', 'test/spec/\1_spec.js', '' )
  endif

  let l:dir = fnamemodify( alt_file, ':h' )
  if !isdirectory( dir )
    call mkdir( dir, 'p' ) 
  endif

  return a:cmd . ' ' . fnameescape( alt_file )
endfunction

command! -buffer -bar A  :exe NgAlternate( 'edit<bang>' )
command! -buffer -bar AV :exe NgAlternate( 'vsplit' )
command! -buffer -bar AS :exe NgAlternate( 'split' )
