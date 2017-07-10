source $HOME/.vim/after/ftplugin/ruby.vim

function! HtmlAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '.html$'
    let l:alt_file = substitute( l:current_file, '\(.*\).html', '\1.ts', '' )
  endif

  let l:dir = fnamemodify( alt_file, ':h' )
  if !isdirectory( dir )
    call mkdir( dir, 'p' ) 
  endif

  return a:cmd . ' ' . fnameescape( alt_file )
endfunction

command! -buffer -bar A  :exe HtmlAlternate( 'edit<bang>' )
command! -buffer -bar AV :exe HtmlAlternate( 'vsplit' )
command! -buffer -bar AS :exe HtmlAlternate( 'split' )
