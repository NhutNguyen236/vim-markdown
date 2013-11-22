if exists("b:did_ftplugin")
  finish
endif

setlocal textwidth=0
setlocal ts=2 sw=2 expandtab smarttab
setlocal comments=b:*,b:-,b:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcrqon formatoptions-=wa
setlocal formatlistpat="^\s*\d\.\s\+"

execute 'setlocal dictionary+=' . expand('<sfile>:p:h:h') . '/dict/emoticons.dict'
setlocal iskeyword+=:,+,-
setlocal complete+=k

iabbr :-) :smile:
iabbr :-D :laughing:
iabbr :-( :disappointed:

function! s:MarkdownJumpToHeader(forward, visual)
  let pattern = '\v^#{1,6}.*$|^.+\n%(\-+|\=+)$'
  if a:visual
    normal! gv
  endif
  if a:forward
    let direction = '/'
  else
    let direction = '?'
  endif
  execute 'silent normal! ' . direction . pattern . "\n"
endfunction

function! s:MarkdownIndent(indent)
  let line = getline('.')
  if line =~ '\v^\s*%([-*+]|\d\.)\s*$'
    if a:indent
      normal >>
    else
      normal <<
    endif
    call setline('.', substitute(getline('.'), '\*\s*$', '* ', ''))
  elseif line =~ '\v^\s*(\s|\>)+\s*$'
    if a:indent
      call setline('.', substitute(getline('.'), '>\s*$', '> > ', ''))
    else
      call setline('.', substitute(getline('.'), '\s*>\s*$', ' ', ''))
      call setline('.', substitute(getline('.'), '^\s\+$', '', ''))
    endif
  else 
    call setline('.', substitute(line, '$', "\t", ''))
  endif
endfunction

function! s:RemoveEmptyListItem()
  if getline('.') =~ '\v^\s*%([-*+]|\d\.)\s*$'
    normal! 0D
  else
    call feedkeys("\<CR>", "n")
  endif
endfunction

noremap <silent> <buffer> <script> ]] :call <SID>MarkdownJumpToHeader(1, 0)<CR>
noremap <silent> <buffer> <script> [[ :call <SID>MarkdownJumpToHeader(0, 0)<CR>
vnoremap <silent> <buffer> <script> ]] :<C-u>call <SID>MarkdownJumpToHeader(1, 1)<CR>
vnoremap <silent> <buffer> <script> [[ :<C-u>call <SID>MarkdownJumpToHeader(0, 1)<CR>

noremap <silent> <buffer> <script> ][ <nop>
noremap <silent> <buffer> <script> [] <nop>

inoremap <silent> <buffer> <script> <Tab> <Esc>:call <SID>MarkdownIndent(1)<CR>A
inoremap <silent> <buffer> <script> <S-Tab> <Esc>:call <SID>MarkdownIndent(0)<CR>A

inoremap <silent> <buffer> <script> <CR> <Esc>:call <SID>RemoveEmptyListItem()<CR>A

let b:did_ftplugin = 1
