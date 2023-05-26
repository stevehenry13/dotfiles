source $HOME/.vim/after/ftplugin/code.vim
setlocal tabstop=2
setlocal shiftwidth=2

inoremap <C-f> () => {<CR>}
inoremap <C-d> describe('', () => {<CR>})
inoremap <C-t> it('should ', () => {<CR>})
inoremap <C-b> beforeEach(() => {<CR>})

setlocal cinoptions=g0,(0

function! ReactTestAlternate( cmd )
  let l:current_file = expand( '%' )
  if l:current_file =~ '.test.tsx\?$'
    let l:alt_file = substitute( l:current_file, '\(.*\).test.ts', '\1.ts', '' )
   else
    let l:alt_file = substitute( l:current_file, '\(.*\).ts', '\1.test.ts', '' )
   endif
 
   let l:dir = fnamemodify( alt_file, ':h' )
   return a:cmd . ' ' . fnameescape( alt_file )
 endfunction
 
function! ReactScssAlternate( cmd )
   let l:current_file = expand( '%' )
  if l:current_file =~ 'Component.tsx$'
    let l:alt_file = substitute( l:current_file, '\(.*\)Component.tsx', '\1.module.scss', '' )
  else
    let l:alt_file = substitute( l:current_file, '\(.*\).module.scss', '\1Component.tsx', '' )
  endif

  let l:dir = fnamemodify( alt_file, ':h' )
  return a:cmd . ' ' . fnameescape( alt_file )
endfunction

function! OpenFileInDir( cmd, file )
  let l:current_file = expand( '%' )
  let l:dir = fnamemodify( current_file, ':h' )
  let l:file = fnameescape( dir ) . '/' . a:file

  return a:cmd . ' ' . fnameescape( file )
endfunction

command! -buffer -bar A  :exe ReactTestAlternate( 'edit<bang>' )
command! -buffer -bar AV :exe ReactTestAlternate( 'vsplit' )
command! -buffer -bar AS :exe ReactTestAlternate( 'split' )

command! -buffer -bar C  :exe ReactScssAlternate( 'edit<bang>' )
command! -buffer -bar CV :exe ReactScssAlternate( 'vsplit' )
command! -buffer -bar CS :exe ReactScssAlternate( 'split' )

command! -buffer -bar R  :exe OpenFileInDir( 'edit<bang>', 'reducer.ts' )
command! -buffer -bar RV :exe OpenFileInDir( 'vsplit', 'reducer.ts' )
command! -buffer -bar RS :exe OpenFileInDir( 'split', 'reducer.ts' )

command! -buffer -bar S  :exe OpenFileInDir( 'edit<bang>', 'selectors.ts' )
command! -buffer -bar SV :exe OpenFileInDir( 'vsplit', 'selectors.ts' )
command! -buffer -bar SS :exe OpenFileInDir( 'split', 'selectors.ts' )
