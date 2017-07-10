source $HOME/.vim/after/ftplugin/ruby.vim

setlocal cinoptions=g0,(0

function! NgAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '.spec.ts$'
    let l:alt_file = substitute( l:current_file, '\(.*\).spec.ts', '\1.ts', '' )
  else
    let l:alt_file = substitute( l:current_file, '\(.*\).ts', '\1.spec.ts', '' )
  endif

  let l:dir = fnamemodify( alt_file, ':h' )
  if !isdirectory( dir )
    call mkdir( dir, 'p' ) 
  endif

  return a:cmd . ' ' . fnameescape( alt_file )
endfunction

function! NgHtml( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '.spec.ts$'
    let l:alt_file = substitute( l:current_file, '\(.*\).spec.ts', '\1.html', '' )
  elseif l:current_file =~ '.ts$'
    let l:alt_file = substitute( l:current_file, '\(.*\).ts', '\1.html', '' )
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
command! -buffer -bar AH :exe NgHtml( 'edit<bang>' )
command! -buffer -bar AVH :exe NgHtml( 'vsplit' )
command! -buffer -bar ASH :exe NgHtml( 'split' )
