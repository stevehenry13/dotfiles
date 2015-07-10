source $HOME/.vim/after/ftplugin/code.vim
setlocal tabstop=2
setlocal shiftwidth=2

function! RubyLibAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '_spec.rb$'
    let l:alt_file = substitute( l:current_file, 'spec\(.*\)_spec.rb', 'lib\1.rb', '' )
  else
    let l:alt_file = substitute( l:current_file, 'lib\(.*\).rb', 'spec\1_spec.rb', '' )
  endif

  if filereadable( alt_file )
    return a:cmd . ' ' . fnameescape( alt_file )
  endif
endfunction
  
if !exists( 'A' )
  command! -buffer -bar A  :exe RubyLibAlternate( 'edit<bang>' )
endif

if !exists( 'AV' )
  command! -buffer -bar AV :exe RubyLibAlternate( 'vsplit' )
endif

if !exists( 'AS' )
  command! -buffer -bar AS :exe RubyLibAlternate( 'split' )
endif
