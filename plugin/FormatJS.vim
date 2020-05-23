function! FormatJS() range
python3 << EOM
import vim,jsbeautifier

#取得VIM传递进来的参数
first=int(vim.eval('a:firstline'));
end=int(vim.eval('a:lastline'));

b=vim.current.buffer.range(first,end)

opts = jsbeautifier.default_options()
opts.indent_with_tabs=True

res = jsbeautifier.beautify('\n'.join(list(b)), opts)
l=res.split('\n')

b[:]=l

EOM
endfunction
