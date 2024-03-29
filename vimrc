set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'altercation/vim-colors-solarized'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'taglist.vim'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'moll/vim-node'
Plugin 'pangloss/vim-javascript'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'janko/vim-test'
Plugin 'vim-ruby/vim-ruby'
Plugin 'HerringtonDarkholme/yats.vim'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'kamykn/spelunker.vim'
Plugin 'benmills/vimux'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let vimDir = '$HOME/.vim'

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undodir')
  " Create dirs
  call system('mkdir ' . vimDir)
  call system('mkdir ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif

set background=light
colorscheme solarized
let g:solarized_termtrans=1

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'ruby', 'sass', 'sh', 'xml', 'html']
let g:used_javascript_libs = 'react,jasmine'
let test#strategy = "vimux"
let test#javascript#reactscripts#options = "--watchAll=false"

let g:EditorConfig_exclude_patterns=['fugitive://.*', 'scp://.*']
let g:load_doxygen_syntax=1
let g:matchparen_insert_timeout=5
let g:matchparen_timeout=25
let g:syntastic_always_populate_loc_list=1
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_typescript_checkers=['tslint']
let g:syntastic_html_checkers=['']
let g:syntastic_cpp_compiler_options=' -std=c++11'
let g:syntastic_typescript_tsc_args=' --sourceMap --emitDecoratorMetadata --experimentalDecorators'
let g:enable_spelunker_vim_on_readonly=1
let g:spelunker_target_min_char_len=2
let g:vim_jsx_pretty_highlight_close_tag=1
let g:vim_jsx_pretty_colorful_config=1
syntax on

inoremap jj <ESC>
inoremap kk <ESC>
inoremap jk <ESC>

"autocmd! VimLeave * call SyntaxQuitCheck()

function! SyntaxQuitCheck()
   if !exists('b:syntastic_loclist') || empty(b:syntastic_loclist) || !b:syntastic_loclist.isEmpty()
      call inputsave()
      call input('syntax errors detected ')
      call inputrestore()
   endif
endfunction

set encoding=utf-8
set hidden
set path+=**
set tags+=./tags
set ofu=syntaxcomplete#Complete
set wildmenu wildmode=longest,list
set wildignore+=*node_modules/**
set laststatus=2 statusline=%<%f\ %h%m%r%w\ %n/%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}\ %=%v,\ %l/%L\ %P
set tabline=%!MyTabLine()
set formatoptions=tcroqb
set hlsearch incsearch ignorecase smartcase
set showcmd showmode
set relativenumber
set number
set ruler
set magic
set nospell
set nocscopeverbose
set clipboard^=unnamed
set pastetoggle=<leader>p
set cmdheight=2
set updatetime=300
set shortmess+=c

let awkAlignColumns  = "'{"
let awkAlignColumns .= "  gsub(/ +$/, \"\", $1);"
let awkAlignColumns .= "  gsub(/^ +/, \"\",$2);"
let awkAlignColumns .= "  before_data[NR] = $1;"
let awkAlignColumns .= "  after_data[NR] = $2;"
let awkAlignColumns .= "  for (i = 3; i <= NF; i++ ) {"
let awkAlignColumns .= "    after_data[NR] = after_data[NR]FS$i"
let awkAlignColumns .= "  }"
let awkAlignColumns .= "  width[NR] = length($1);"
let awkAlignColumns .= "  if (length($1) > max) max = length($1)"
let awkAlignColumns .= "}"
let awkAlignColumns .= "END {"
let awkAlignColumns .= "  for (i = 1; i <= NR; ++i) {"
let awkAlignColumns .= "    w = max - width[i];"
let awkAlignColumns .= "    printf \"%s\", before_data[i];"
let awkAlignColumns .= "    if (after_data[i] != null) {"
let awkAlignColumns .= "      if (space == \"before\" || space == \"both\") printf \" \";"
let awkAlignColumns .= "      if (alignFS != \"true\") printf FS;"
let awkAlignColumns .= "      if (w > 0) printf \"%*s\", w, \" \";"
let awkAlignColumns .= "      if (alignFS == \"true\") printf FS;"
let awkAlignColumns .= "      if (space == \"after\" || space == \"both\") printf \" \";"
let awkAlignColumns .= "      printf \"%s\\n\", after_data[i]"
let awkAlignColumns .= "    }"
let awkAlignColumns .= "  }"
let awkAlignColumns .= "}'"

noremap <leader>=       :!awk -v alignFS='true'  -v space='both'  -F= <C-r>=escape( awkAlignColumns, '%!' ) <CR><CR> gv_=
noremap <leader>:       :!awk -v alignFS='false' -v space='after' -F: <C-r>=escape( awkAlignColumns, '%!' ) <CR><CR> gv_=

noremap <leader>a       :call SAddEdit() <CR><CR>
noremap <leader>e       :call SAddEdit() <CR><CR>
noremap <leader>b       :call SBlame() <CR><CR>
noremap <leader>r       :call SCheckoutRevert() <CR><CR>
noremap <leader>d       :call SDiff('') <CR><CR>
noremap <leader>g       :Grep <CR>
noremap <leader>j       :lnext <CR>
noremap <leader>k       :lprev <CR>
noremap <leader>n       :set nu! <CR> :set relativenumber! <CR>
noremap <leader>x       :%!xxd <CR>
noremap <leader>X       :%!xxd -r <CR>
noremap <leader>w       :w !sudo tee % > /dev/null <CR>
noremap <leader>c       :redraw! <bar> cf <bar> copen <CR><CR>
noremap <leader>l       :call Linux_Style() <CR>
noremap <leader>s       :call Code_Style() <CR>
noremap <leader>S       :call Not_Code_Style() <CR>
noremap <leader>t       :w <CR> :TestNearest <CR>
noremap <leader>#       :set foldmethod=expr <CR> :set foldexpr=getline(v:lnum)=~'^\\s*#' <CR> zM <CR>
noremap <leader>/       :set foldmethod=syntax <CR> zM <CR>
noremap <leader>*       :<C-r><C-w> :0 <CR> $hhgfn
noremap <leader>\       :hi clear BadFormat <CR>
noremap <leader><space> :noh <CR>
noremap <F1> <nop>

function SetHighlight( name, fg, bg, term )
   exe 'hi clear '.a:name
   exe 'hi '.a:name.' ctermfg='.a:fg.' ctermbg='.a:bg.' cterm='.a:term
endfunction

call SetHighlight( 'BadFormat',    'red',   'none',      'undercurl' )
call SetHighlight( 'SpellBad',     'red',   'none',      'undercurl' )
call SetHighlight( 'SpellLocal',   'red',   'none',      'undercurl' )
call SetHighlight( 'SpellCap',     'blue',  'none',      'undercurl' )
call SetHighlight( 'DiffAdd',      'green', 'none',      'none'      )
call SetHighlight( 'DiffText',     'cyan',  'none',      'none'      )
call SetHighlight( 'DiffChange',   'none',  'none',      'undercurl' )
call SetHighlight( 'DiffDelete',   'red',   'none',      'none'      )
call SetHighlight( 'StatusLineNC', 'black', 'gray',      'none'      )
call SetHighlight( 'StatusLine',   'white', 'black',     'none'      )
call SetHighlight( 'TabLine',      'black', 'gray',      'none'      )
call SetHighlight( 'TabLineFill',  'black', 'gray',      'none'      )
call SetHighlight( 'TabLineSel',   'white', 'black',     'bold'      )
call SetHighlight( 'TabNum',       'blue',  'gray',      'none'      )
call SetHighlight( 'TabNumSel',    'cyan',  'black',     'bold'      )
call SetHighlight( 'TabBufNum',    'red',   'gray',      'none'      )
call SetHighlight( 'TabBufNumSel', 'red',   'black',     'bold'      )
call SetHighlight( 'CursorLineNR', 'red',   'black',     'none'      )
call SetHighlight( 'LineNr',       'gray',  'black',     'none'      )
call SetHighlight( 'ColorColumn',  'none',  'none',      'none'      )
call SetHighlight( 'MatchParen',   'black', 'green',     'none'      )

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

function! Linux_Style()
   set tabstop=8
   set softtabstop=8
   set shiftwidth=8
   set noexpandtab
   set cindent
   set formatoptions=tcqlron
   set cinoptions=:0,l1,t0,g0

   syn keyword cOperator likely unlikely
   syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
   autocmd BufWinEnter * match BadFormat /\%>80v.\+\|\s\+\t|\s\+$/
   autocmd InsertEnter * match BadFormat /\%>80v.\+\|\s\+\t|\s\+\%#\@<!$/
   autocmd InsertLeave * match BadFormat /\%>80v.\+\|\s\+\t|\s\+$/
endfunction

function! Not_Code_Style()
   set tabstop=8
   set shiftwidth=8
   set noexpandtab
   set nosmarttab
   set textwidth=80
   set nocindent
   set cinoptions=
   autocmd! BufWinEnter *
   autocmd! InsertEnter *
   autocmd! InsertLeave *
endfunction
