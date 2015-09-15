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
	\ ['jsFile', ''],
	\ ['jsBuf', ''],
	\ ['jsWin', ''],
	\ ['curBuf', ''],
	\ ['curLine', 0],
\ ]

for [opt, val] in s:options
    call s:init_var(opt, val)
endfor
unlet s:options
"}}}

au BufEnter *.js :call JSKey#mark()
