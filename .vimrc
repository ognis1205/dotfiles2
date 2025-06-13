" ────────────────────────────────
" Emacs-like Insert Mode Bindings
" ────────────────────────────────

imap <C-p> <Up>                       " Ctrl-p: Move cursor up one line
imap <C-n> <Down>                     " Ctrl-n: Move cursor down one line
imap <C-b> <Left>                     " Ctrl-b: Move cursor left one character
imap <C-f> <Right>                    " Ctrl-f: Move cursor right one character
imap <C-a> <C-o>:call <SID>home()<CR> " Ctrl-a: Move to beginning of line (custom function)
imap <C-e> <End>                      " Ctrl-e: Move to end of line
imap <C-d> <Del>                      " Ctrl-d: Delete character under cursor
imap <C-h> <BS>                       " Ctrl-h: Backspace (delete character before cursor)
imap <C-k> <C-r>=<SID>kill()<CR>      " Ctrl-k: Kill to end of line (custom function)

" Move cursor to the first non-blank character of the line;
" if already there, move to absolute beginning of the line
function! s:home()
  let start_column = col('.')
  normal! ^
  if col('.') == start_column
  ¦ normal! 0
  endif
  return ''
endfunction

" Kill (cut) text from cursor to end of line;
" if already at end, join current line with next line
function! s:kill()
  let [text_before, text_after] = s:split_line()
  if len(text_after) == 0
  ¦ normal! J
  else
  ¦ call setline(line('.'), text_before)
  endif
  return ''
endfunction

" Helper function: split current line into text before and after cursor
function! s:split_line()
  let line_text = getline(line('.'))
  let text_after  = line_text[col('.')-1 :]
  let text_before = (col('.') > 1) ? line_text[: col('.')-2] : ''
  return [text_before, text_after]
endfunction