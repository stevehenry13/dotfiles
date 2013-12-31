noremap <leader>b       :call P4login() <CR> :call P4Blame() <CR><CR>
noremap <leader>e       :call P4login() <CR> :!p4 edit % <CR><CR>
noremap <leader>r       :call P4login() <CR> :!p4 revert % <CR><CR>

function! P4login()
   let login_string = system( "p4 login -s 2>/dev/null | grep User" )
   if empty( login_string )
      :!echo "Perforce login ($LOGNAME)"
      :!p4 login
   endif
endfunction

function! P4DiffPrint(fileRev)
   let file_syntax=&syntax
   vnew
   setlocal buftype=nofile bufhidden=hide noswapfile
   exe 'read !p4 print -q '.a:fileRev
   exe 'set syntax='.file_syntax
   exe 'file '.a:fileRev
   diffthis
   0,0g/^$/d
   wincmd p
endfunction

function! P4Diff(...)
   let filename = system('echo -n '.expand('%'))
   if empty( a:2 )
      let filename .= ('' == a:1 ? '\#head' : a:1)
      diffthis
   else
      call P4DiffPrint(filename.a:2.a:1)
      bd
      let filename .= ('@=' == a:2 ? '\#head' : a:2.(a:1 - 1))
   endif
   call P4DiffPrint(filename)
endfunction

function! P4Blame()
   let filename = system('echo -n '.expand('%'))
   let file_syntax=&syntax
   let awk_blame = "awk -F'[ @:]' "                        "'@' and ':' needed to parse out user name and CL numbers
   let awk_blame .= "'BEGIN {"
   let awk_blame .=    "ORS=\"\";"                         "default to no newline
   let awk_blame .=    "empty_prefix=\" \";"
   let awk_blame .=    "while (\"p4 changes -i ".filename."\" | getline result)"
   let awk_blame .=    "{"
   let awk_blame .=       "split( result, field );"
   let awk_blame .=       "cl=field[2];"
   let awk_blame .=       "pad_cl=cl;"
   let awk_blame .=       "name=field[6];"
   let awk_blame .=       "while (length( pad_cl ) < 6)"   "pad to 6 (left justified)
   let awk_blame .=          "pad_cl=pad_cl\" \";"
   let awk_blame .=       "while (length( name ) < 8)"     "pad to 8 (right justified)
   let awk_blame .=          "name=\" \"name;"
   let awk_blame .=       "while (length( empty_prefix ) < 15)" "keep code in line
   let awk_blame .=          "empty_prefix=\" \"empty_prefix;"
   let awk_blame .=       "user_name[cl]=name;"
   let awk_blame .=       "cl_display[cl]=pad_cl;"
   let awk_blame .=    "}"
   let awk_blame .= "}"
   let awk_blame .= "{"                                    "Start 'for each line' section
   let awk_blame .=    "cl=$1;"
   let awk_blame .=    "$1=\"\";"
   let awk_blame .=    "if (last_cl==cl)"
   let awk_blame .=       "print empty_prefix;"            "print empty spaces if same change as prev line
   let awk_blame .=    "else"
   let awk_blame .=    "{"
   let awk_blame .=       "last_cl=cl;"                    "new change print CL and name
   let awk_blame .=       "print cl_display[cl] \" \" substr( user_name[cl], 0, 8 );"
   let awk_blame .=    "}"
   let awk_blame .=    "print \"|\" substr( $0, 3 ) \"\\n\";" "print the actual code, without leading spaces
   let awk_blame .= "}'"
   setlocal scrollbind
   set scrollopt=ver
   vnew
   setlocal buftype=nofile bufhidden=hide noswapfile
   setlocal scrollbind
   exe "read !p4 annotate -I -i -q ".filename." | ".awk_blame
   exe 'set syntax='.file_syntax
   exe 'file '.filename.'\#head'
   0,0g/^$/d
endfunction
