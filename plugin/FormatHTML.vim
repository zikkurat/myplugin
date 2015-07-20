"当一个函数定义时给出了range" 关键字时，表示它会自行处理该范围。
"Vim 在调用这样一个函数时给它传递两个参数: "a:firstline" 和 "a:lastline"，
"用来表示该范围所包括的第一行和最后一行。

function! JoinHTML() range
	let a=confirm(a:firstline)
endfunction

function! FormatHTML() range
	"获取当前文件扩展名，&ft为当前环境变量里filetype的值
	let strSuffix=&ft
	"不为指定扩展名的，不做任何处理，直接返回
	if strSuffix!="htm" && strSuffix!="html" && strSuffix!="xhtml"
		return
	endif

	"取得当前行缩进，&ts为当前环境变量里tabstop的值
	let strSpace=substitute(getline(a:firstline),"^\\(\\s*\\).*$","\\1","g")

	"获取选择行
	let lineSelected=getline(a:firstline,a:lastline)
	let strTemp=""
	for line in lineSelected
		let strTemp=strTemp . line
	endfor
	"所有字符串变量中的字符都被VIM视为一行，也就是说，就算是变量为多行的文本，也仅有一个^和$，你妈的，搞了一天才搞明白！
	let strTemp=substitute(strTemp,"<[^>]\\{-}>","\\n\\0\\n","g")	"按标签分割行
	let strTemp=substitute(strTemp,"\\n\\s*\\n","\\n","g")	"删除空行
	let strTemp=substitute(strTemp,"^\\s*\\n\\|^\\s*","","g")	"如果第一行为空行则删除，基本都是空行！
	let strList=split(strTemp,"\\n")
	"表达式含义：re=["判断是否为标签","取得标签","判断是否为结束标签","取得结束标签"]
	let re=["<[^>]\\{-}>","<\\<\\(\\w\\+\\)\\>[^>]\\{-}>","<\/\\<\\w\\+\\>>","<\/\\<\\(\\w\\+\\)\\>>"]
	let i=0
	let arr=[]
	let tags=["input","img","hr","link","meta","br","base"]	"不增加缩进的标签
	let tag=""
	let l=0
	for line in strList
		if match(line,re[0])!=-1	"如果当前行是标签
			if match(line,re[2])==-1	"如果当前行不是结束标签
				let strList[i]=strSpace . strList[i]
				let tag=substitute(line,re[1],"\\1","")
				if match(tags,"\\<" . tag . "\\>")==-1
					let strSpace.="\t"	"缩进増加一级
					let arr=add(arr,tag)
				endif
			elseif match(line,re[2])!=-1	"如果当前行是结束标签
				if len(arr)!=0	"当TAG堆栈不为0时
					if substitute(line,re[3],"\\1","")==arr[-1]	"判断当前结束的TAG与堆栈中的TAG是否相符
						let strSpace=substitute(strSpace,"\\t","","")	"如果相符，缩进减一级
						call remove(arr,-1)	"堆栈去掉相应TAG
					endif
				endif
				let strList[i]=strSpace . strList[i]
			endif
		else	"不是标签的行，直接缩进
			let strList[i]=strSpace . strList[i]
		endif
		let i+=1
	endfor

	let strTemp=join(strList,"\n")
	call setreg("t",strTemp,"l")
	exe "normal V" . ( a:lastline - a:firstline == 0 ? "" : a:lastline - a:firstline . "j" ) . "\"tp"
endfunction
