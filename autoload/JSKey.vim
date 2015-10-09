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
    " setlocal nolist
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
    "setlocal foldmethod&
    setlocal foldmethod=indent
    setlocal foldtext=substitute(getline(v:foldstart),'^.+:\s*','','g')

    setlocal foldexpr&

    " set cpoptions&vim

	call s:mapkeys()
	call s:update()

endfunction
"}}}

"{{{ JSKey#openWin()
function! JSKey#openWin()
	if g:jskey_jsBuf == ''
		return
	endif

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

function! s:jump(how)
	let l = line('.')
	let at = g:jskey_lines[l - 1][1]
	let w = bufwinnr(g:jskey_jsBuf)
	call s:goto_win(w)
	execute 'normal '.(at + 1).'Gzvz.'
	if a:how
		call s:goto_win(bufwinnr(g:jskey_title))
	endif
endfunction

"{{{ s:mapkeys()
function! s:mapkeys()
    nnoremap <script> <silent> <buffer> u :call <SID>update()<CR>
    nnoremap <script> <silent> <buffer> <Enter> :call <SID>jump(0)<CR>
    nnoremap <script> <silent> <buffer> <2-LeftMouse> :call <SID>jump(0)<CR>
    nnoremap <script> <silent> <buffer> p :call <SID>jump(1)<CR>
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

re_var = re.compile(r'\s*var\s([a-z_][a-zA-Z_]*)\s*=.+{\s*$')
re_class = re.compile(r'\s*var\s([A-Z][a-zA-Z_]*)\s*=.+{\s*$')
re_pro = re.compile(r'\s*([A-Z][a-zA-Z_]*)\.prototype\s*=')
re_obj = re.compile(r'\s*([a-zA-Z_]+)\s*:\s*{\s*')
re_methods = re.compile(r'\s*([a-zA-Z_]+)\s*:\s*function\s*')
re_comment = re.compile(r'{{{|}}}')
re_exclude = re.compile(r'success|error|complete|data')


#{{{findRange
def findRange(start):
	_end = start
	_indent = 0
	_break = False

	s = buf[_end].count('{')
	e = buf[_end].count('}')

	if s == e:
		return [start, start]

	while _break == False:
		s = buf[_end].count('{')
		e = buf[_end].count('}')
		_indent = _indent + (s - e)
		if _indent != 0:
			_end = _end + 1
		else:
			_break = True

	return [start, _end]
#}}}

#{{{ getKey
def getKey(start):
	_lines = []
	_line = []
	_indent = 0
	_len = len(buf)
	_next = start

	while _next < _len:
		print _lines
		_re = comment.search(buf[_next])
		_s = _e = 0
		if not _re:
			_s = buf[_next].count('{')
			_e = buf[_next].count('}')
			_indent = _indent + (_s - _e)

		_line = []
		_re = re_var.match(buf[_next])
		if _re:
			_line.append(_indent * '\t' + _re.group(1))
			_line.append(_next)
			_lines.append(_line)

		if _s == _e:
			_next += 1
			continue
		else:
			if _indent == 0:
				return _lines

			_lines.extend(getKey(_next + 1))
			_next = _lines[-1][1] + 1
			continue

		_next += 1

	return _lines

#}}}


lines = []
line_local = 0
buf_len = len(buf)
indent = 0
cur_line = ''
while line_local < buf_len:
	cur_line = buf[line_local]

	_re = re_comment.search(cur_line)
	if _re:
		line_local += 1
		continue

	s = cur_line.count('{')
	e = cur_line.count('}')

	_re = re_var.match(cur_line)
	if _re:
		lines.append([indent * '\t' + _re.group(1), line_local])
		indent = indent + (s - e)
		line_local += 1
		continue

	_re = re_class.match(cur_line)
	if _re:
		lines.append([indent * '\t' + _re.group(1) + '---Class', line_local])
		indent = indent + (s - e)
		line_local += 1
		continue

	_re = re_pro.match(cur_line)
	if _re:
		lines.append([indent * '\t' + _re.group(1) + '---Prototype', line_local])
		indent = indent + (s - e)
		line_local += 1
		continue

	_re = re_obj.match(cur_line)
	if _re:
		__re = re_exclude.search(cur_line)
		if not __re:
			lines.append([indent * '\t' + _re.group(1) + '---Object', line_local])
			indent = indent + (s - e)
			line_local += 1
			continue

	_re = re_methods.match(cur_line)
	if _re:
		__re = re_exclude.search(cur_line)
		if not __re:
			lines.append([indent * '\t' + _re.group(1) + '---Methods', line_local])
			indent = indent + (s - e)
			line_local += 1
			continue
			

	indent = indent + (s - e)
	line_local += 1




vim.current.buffer[:] = [a for a,b in lines]
vim.command('match WarningMsg /.*---Class/')
vim.command('2match Question /.*---Prototype/')
vim.command('3match Conceal /.*---Object/')
vim.command('normal zM')

#全局变量赋值，供跳转使用
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
