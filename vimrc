filetype plugin on
filetype plugin indent on
let g:load_doxygen_syntax=1
let g:matchparen_insert_timeout=5
let g:matchparen_timeout=25
syntax on

autocmd! BufRead,BufNewFile *.sass setfiletype sass

set ofu=syntaxcomplete#Complete
set wildmenu wildmode=longest,list
set laststatus=2 statusline=%<%f\ %h%m%r%w\ %n/%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}\ %=%v,\ %l/%L\ %P
set tabline=%!MyTabLine()
set formatoptions=tcroqb
set hlsearch incsearch ignorecase smartcase
set showcmd showmode
set ruler
set magic
set spell
set errorfile=make_output.txt
set errorformat^=%-G%f:%l:\ TARG\ not\ defined\ as\ one\ of:\ %m
set errorformat^=%-GCreated:%m
set errorformat^=%-G%m\ RuntimeWarning:\ Python\ C\ API\ version\ mismatch\ for\ module\ mcrypt:\ This\ Python\ has\ API\ version\ 1013\\,\ module\ mcrypt\ has\ version\ 1012.
set pastetoggle=<leader>p

noremap <leader>d       :call SDiff('') <CR><CR>
noremap <leader>g       :Grep <CR>
noremap <leader>x       :%!xxd <CR>
noremap <leader>X       :%!xxd -r <CR>
noremap <leader>w       :w !sudo tee % > /dev/null <CR>
noremap <leader>c       :redraw! <bar> cf <bar> copen <CR><CR>
noremap <leader>s       :call Code_Style() <CR>
noremap <leader>S       :call Not_Code_Style() <CR>
noremap <leader>0       :let string=Shenry_Build(""    ,"" ,"y") <CR><CR> :echo string <CR>
noremap <leader>1       :let string=Shenry_Build("pp"  ,"" ,"" ) <CR><CR> :echo string <CR>
noremap <leader>2       :let string=Shenry_Build("swdl","" ,"" ) <CR><CR> :echo string <CR>
noremap <leader>3       :let string=Shenry_Build("pp"  ,"x","" ) <CR><CR> :echo string <CR>
noremap <leader>4       :let string=Shenry_Build("swdl","x","" ) <CR><CR> :echo string <CR>
noremap <leader><space> :noh <CR>
noremap <F1> <nop>

"usage: ':R ls -l' would open a new window listing all files in the current directory
command! -nargs=* -complete=shellcmd R vnew | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

hi clear BadFormat
hi       BadFormat    ctermfg=black ctermbg=gray
hi clear SpellBad
hi       SpellBad     ctermfg=red                  cterm=undercurl
hi clear SpellLocal
hi       SpellLocal   ctermfg=red                  cterm=undercurl
hi clear SpellCap
hi       SpellCap     ctermfg=blue                 cterm=undercurl
hi clear DiffAdd
hi       DiffAdd      ctermfg=black ctermbg=yellow cterm=none
hi clear DiffText
hi       DiffText     ctermfg=black ctermbg=yellow cterm=none
hi clear DiffChange
hi       DiffChange                 ctermbg=none   cterm=none
hi clear DiffDelete
hi       DiffDelete                 ctermbg=none
hi clear StatusLineNC
hi       StatusLineNC ctermfg=black ctermbg=gray   cterm=none
hi clear StatusLine
hi       StatusLine   ctermfg=white ctermbg=black  cterm=none
hi clear TabLine
hi       TabLine      ctermfg=black ctermbg=gray   cterm=none
hi clear TabLineFill
hi       TabLineFill  ctermfg=black ctermbg=gray   cterm=none
hi clear TabLineSel
hi       TabLineSel   ctermfg=white ctermbg=black  cterm=bold
hi clear TabNum
hi       TabNum       ctermfg=blue  ctermbg=gray   cterm=none
hi clear TabNumSel
hi       TabNumSel    ctermfg=cyan  ctermbg=black  cterm=bold
hi clear TabBufNum
hi       TabBufNum    ctermfg=red   ctermbg=gray   cterm=none
hi clear TabBufNumSel
hi       TabBufNumSel ctermfg=red   ctermbg=black  cterm=bold

if 1 == executable( 'p4' )
   source $HOME/.vim/perforce.vimrc
endif

function MyTabLine()
   let s = ''
   let i = 1
   while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let name = fnamemodify(bufname(buflist[winnr - 1]), ":t")
      let name = substitute(name, "@.*$", "", "") " Get rid of an '@' and anything after
      let s .= '%#TabLine#|'
      let s .= (i == tabpagenr() ? '%#TabNumSel#' : '%#TabNum#')
      let s .= i - 1 . ':'          " Start tab numbers at 0, so tabm works with the index (and is not off by one)
      let s .= (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
      let s .= (name == '' ? '[No Name]' : name)
      let s .= (i == tabpagenr() ? '%#TabBufNumSel#' : '%#TabBufNum#')
      let s .= '('
      let s .= tabpagewinnr(i, '$' ) " Number of buffers within tab
      let s .= ')'
      let i = i + 1
   endwhile
   let s .= '%#TabLine#|%#TabLineFill#' " after the last tab fill with TabLineFill and reset tab page nr
   return s
endfunction

function! Code_Style()
   source $HOME/.vim/after/ftplugin/c.vim
endfunction

function! Not_Code_Style()
   set tabstop=8
   set shiftwidth=8
   set noexpandtab
   set nosmarttab
   set tw=0
   set nocindent
   set cinoptions=
   autocmd! BufWinEnter *
   autocmd! InsertEnter *
   autocmd! InsertLeave *
endfunction

function! Shenry_Build(target, model, input)
   if a:input == 'y'
      call inputsave()
      let params = input('model, clean, target, window: ')
      call inputrestore()
      exe '!sh smake '.params.' &'
      return 'make '.params
   else
      exe '!sh smake '.a:model.' '.a:target.' &'
      return 'make '.a:model.' '.a:target
   endif
endfunction

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

function! SDiff(...)
   if '' != FindProjectRoot( '.git' )
      Gdiff
   elseif '' != FindProjectRoot( '.svn' )
      call call( "SvnDiff", a:000  )
   else
      call call( "P4Diff", a:000 )
   endif
endfunction

function! FindProjectRoot(target_dir)
   let root='%:p'
   while( len( expand( root ) ) > len( expand( root.':h' ) ) )
      let root=root.':h'
      let file=expand( root ).'/'.a:target_dir
      if filereadable( file ) || isdirectory( file )
         return expand( root )
      endif
   endwhile
   return ''
endfunction
