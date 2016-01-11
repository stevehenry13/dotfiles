source $HOME/.vim/after/ftplugin/ruby.vim

setlocal cinoptions=g0,(0

function! NgAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '_spec.js$'
    let l:alt_file = substitute( l:current_file, 'test/spec/\(.*\)_spec.js', 'app/\1.js', '' )
  else
    let l:alt_file = substitute( l:current_file, 'app/\(.*\).js', 'test/spec/\1_spec.js', '' )
  endif

  if filereadable( alt_file )
    return a:cmd . ' ' . fnameescape( alt_file )
  endif
endfunction

command! -buffer -bar A  :exe NgAlternate( 'edit<bang>' )
command! -buffer -bar AV :exe NgAlternate( 'vsplit' )
command! -buffer -bar AS :exe NgAlternate( 'split' )
