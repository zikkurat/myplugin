"{{{ s:openWin()
function! s:openWin()
	exe 'silent keepalt ' . g:jskey_openPos . g:jskey_width . 'split ' . g:jskey_title
	call s:InitWindow()
endfunction
"}}}

"{{{ s:closeWin()
function! s:closeWin() abort
	let jsbar = bufwinnr(g:jskey_title)

	if jsbar == -1
		pclose
	endif
endfunction
"}}}

"{{{ s:InitWindow()
function! s:InitWindow() abort
    setlocal filetype=jskey

    setlocal noreadonly " in case the "view" mode is used
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nospell
	setlocal nonumber
    setlocal nofoldenable
    setlocal foldcolumn=0
    " Reset fold settings in case a plugin set them globally to something
    " expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
    " off, and then for every appended line (like with :put).
    setlocal foldmethod&
    setlocal foldexpr&

    set cpoptions&vim

	call s:mapkeys()
	call s:update()

endfunction
"}}}

"{{{ JSKey#openWin()
function! JSKey#openWin()
	let jsbar = bufwinnr(g:jskey_title)

	if jsbar != -1
		call s:goto_win(jsbar)
		return
	endif

	let jsbar = bufnr(g:jskey_title)

	if jsbar !=-1
		call s:goto_buf(jsbar)
		return
	endif

	call s:openWin()
endfunction
"}}}

"{{{ goto_buf()
function! s:goto_buf(winnr, ...) abort
	" exe 'silent keepalt ' . g:jskey_openPos . g:jskey_width . 'split ' . g:jskey_title
	noautocmd execute 'silent keepalt ' . g:jskey_openPos . g:jskey_width . 'split'
	noautocmd execute 'buf ' . a:winnr
endfunction
"}}}

"{{{ goto_win()
function! s:goto_win(winnr, ...) abort
    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
                                     \ : 'wincmd ' . a:winnr
    let noauto = a:0 > 0 ? a:1 : 0

    if noauto
        noautocmd execute cmd
    else
        execute cmd
    endif
endfunction
"}}}

function! s:jump()
	let l = winline()
	let at = g:jskey_lines[l - 1][1]
	let w = bufwinnr(g:jskey_jsBuf)
	call s:goto_win(w)
	normal at.'gg'
endfunction

"{{{ s:mapkeys()
function! s:mapkeys()
    nnoremap <script> <silent> <buffer> u :call <SID>update()<CR>
    nnoremap <script> <silent> <buffer> <Enter> :call <SID>jump()<CR>
endfunction
"}}}

function! s:update()
	if g:jskey_jsBuf != ''
    setlocal modifiable
python << EOM
import vim, re
file_name = vim.eval('g:jskey_jsFile')
buf_idx = int(vim.eval('g:jskey_jsBuf'))
win_idx = int(vim.eval('g:jskey_jsWin'))
buf = vim.buffers[buf_idx]

re_var = re.compile(r'\s*var\s([a-zA-Z_]+)\s*=')
re_pro = re.compile(r'\s*([a-zA-Z_]+)\.prototype\s*=')
comment = re.compile(r'{{{|}}}')

lines = []
indent = 0
for i in range(len(buf)):
	line = []
	re = re_var.match(buf[i])
	if re:
		if indent == 0:
			line.append(indent * '\t' + re.group(1))
			line.append(i)
			lines.append(line)

	re = re_pro.match(buf[i])
	if re:
		if indent == 0:
			line.append(indent * '\t' + re.group(1) + '......prototype')
			line.append(i)
			lines.append(line)
	
	re = comment.search(buf[i])
	if not re:
		s = buf[i].count('{')
		e = buf[i].count('}')
		indent = indent + (s - e)

vim.current.buffer[:] = [a for a,b in lines]

vim.vars['jskey_lines'] = lines

EOM
    setlocal nomodifiable
	endif
endfunction

function! JSKey#mark()
	let g:jskey_jsBuf = bufnr('%')
	let g:jskey_jsWin = bufwinnr('%')
	let g:jskey_jsFile = bufname('%')
endfunction
