"{{{ init param
function! s:init_var(var, value) abort
    if !exists('g:jskey_' . a:var)
        execute 'let g:jskey_' . a:var . ' = ' . string(a:value)
    endif
endfunction

let s:options = [
	\ ['title', '__JSKEY__'],
	\ ['openPos', 'topleft vertical '],
	\ ['width', 40],
	\ ['curFile', ''],
	\ ['curLine', 0],
\ ]

for [opt, val] in s:options
    call s:init_var(opt, val)
endfor
unlet s:options
"}}}

"{{{ openWin()
function! s:openWin()
	if g:jskey_curFile == ''
		let g:jskey_curFile = fnamemodify(bufname('%'), ':p')
		let g:jskey_curLine = line('.')
	endif

	exe 'silent keepalt ' . g:jskey_openPos . g:jskey_width . 'split ' . g:jskey_title
	call s:InitWindow()
endfunction
"}}}

"{{{ closeWin()
function! s:closeWin() abort
	let jsbar = bufwinnr('__JSKEY__')

	if jsbar == -1
		pclose
	endif
endfunction
"}}}

"{{{ InitWindow()
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
endfunction
"}}}

"{{{ jskey$JSKey#openWin()
function! JSKey#openWin()
	let jsbar = bufwinnr('__JSKEY__')

	if jsbar != -1
		if winnr() != jsbar
			call s:goto_win(jsbar)
			return
		endif
	endif

	call s:openWin()
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
