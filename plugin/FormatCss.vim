function! FormatCss(arg)
	"获取当前文件扩展名，&ft为当前环境变量里filetype的值
	let strSuffix=&ft
	echo strSuffix

	"不为指定扩展名的，不做任何处理，直接返回
	if strSuffix!="css" && strSuffix!="less" && strSuffix!="htm" && strSuffix!="html" && strSuffix!="xhtml"
		return
	endif

python3 << EOM
import vim,re

#取得VIM传递进来的参数
do_what=vim.eval('a:arg')

#{{{ findStartLine 查找开始边界所在行
def findStartLine():
	#获取当前窗口
	w=vim.current.window
	#获取当前缓冲区
	b=vim.current.buffer
	#获取当前坐标
	#坐标系统从1开始
	#缓冲区系统从0开始，所以要取得当前行，坐标行的值要减1
	_row,_col=w.cursor
	_row-=1

	#一个条件，目的在于当达到条件前一直循环下去
	ok=True

	#计算器，_start为'{'的统计个数，_end为'}'的统计个数
	_start=0
	_end=0

	pattern=re.compile(r'@{.*?}')

	while ok:
		#获取一行字符，去掉特定的字符串
		#_line=b[_row].replace('@{url}','')
		_line=re.sub(pattern,'',b[_row])

		#计数
		_start+=_line.count('{')
		_end+=_line.count('}')

		#在达到CSS属性起始处，返回所在行号，缓冲区行号，不是窗口坐标行，从0开始计算
		if _start!=0 and _start>=_end:
			return _row
		else:
			if _row==0:
				return None
			_row-=1
#}}}

#{{{ findEndLine 查找结束边界所在行
def findEndLine(row):
	#获取当前缓冲区
	b=vim.current.buffer

	_row=row

	#一个条件，目的在于当达到条件前一直循环下去
	ok=True

	#计算器，_start为'{'的统计个数，_end为'}'的统计个数
	_start=0
	_end=0

	while ok:
		#获取一行字符，去掉特定的字符串
		try:
			_line=b[_row].replace('@{url}','')
		except IndexError:
			#没找到闭合节点，返回假
			return None

		#计数
		_start+=_line.count('{')
		_end+=_line.count('}')

		#在达到CSS属性结束处，返回所在行号，缓冲区行号，不是窗口坐标行，从0开始计算
		if _start!=0 and _start==_end:
			return _row
		else:
			_row+=1
#}}}

#{{{ getRange 得到要处理的范围
def getRange():
	#查找第一行
	s=findStartLine()
	if s!=None:
		#查找最后一行
		e=findEndLine(s)
		if e!=None:
			#返回目标在buffer内的range
			return vim.current.buffer.range(s+1,e+1)

	return None
#}}}

#{{{ con 收缩
def con(l):
	s=''.join(l)

	#得到缩进数
	space_count=l[0].count('\t')

	#清理格式
	pattern=re.compile(r'^\s*|\s$')
	l=[re.sub(pattern,'',a) for a in l]

	pattern=re.compile(r'\s*:\s*')
	l=[re.sub(pattern,':',a) for a in l]

	pattern=re.compile(r'\s*}\s*')
	l=[re.sub(pattern,'}',a) for a in l]

	pattern=re.compile(r'\s*{\s*')
	l=[re.sub(pattern,'{',a) for a in l]

	pattern=re.compile(r'\s*;\s*')
	l=[re.sub(pattern,';',a) for a in l]

	return [space_count*'\t'+''.join(l)]
#}}}
	
#{{{ expand 展开一层
def expand(l):

	#清理格式
	s=''.join(l)

	#转换特殊标记
	pattern=re.compile(r'@{(.*?)}')
	s=re.sub(pattern,r'&&\1&&',s)

	pattern=re.compile(r'\s*}\s*')
	s=pattern.sub('}',s)

	pattern=re.compile(r'\s*:\s*')
	s=pattern.sub(':',s)

	pattern=re.compile(r'\s*;\s*')
	s=pattern.sub(';',s)

	pattern=re.compile(r'([^;{}])}')
	s=pattern.sub(r'\1;}',s)

	#开始标记
	start_tag=0

	#逐个字符分析
	l=[]
	for a in s:
		if a=='{':
			if start_tag==0:
				l.append('{\n')
			else:
				l.append('{')
			start_tag+=1
		elif a=='}':
			start_tag-=1
			if start_tag<=1:
				l.append('}\n')
			else:
				l.append('}')
		elif a==';':
			if start_tag==1:
				l.append(';\n')
			else:
				l.append(';')
		else:
			l.append(a)
	

	#恢复特殊标记
	pattern=re.compile(r'&&(.*?)&&')
	s=re.sub(pattern,r'@{\1}',''.join(l))

	#生成列表
	l=s.split('\n')
	l.pop()

	#美化
	l=beautifulLeft(l)

	#得到缩进
	space_count=l[0].count('\t')
	for i in range(len(l)):
		#第一行不处理
		if i!=0:
			if l[i]!='}':
				l[i]=(space_count+1)*'\t'+l[i]
			elif l[i]=='}':
				l[i]=space_count*'\t'+l[i]

	return l
#}}}

#{{{ expandX 展开所有
def expandX(l):

	#转成字符串
	s=''.join(l)

	#转换特殊标记
	pattern=re.compile(r'@{(.*?)}')
	s=re.sub(pattern,r'&&\1&&',s)

	#清理格式
	pattern=re.compile(r'\s*}\s*')
	s=pattern.sub('}',s)

	pattern=re.compile(r'\s*:\s*')
	s=pattern.sub(':',s)

	pattern=re.compile(r'\s*;\s*')
	s=pattern.sub(';',s)

	pattern=re.compile(r'([^;}])}')
	s=pattern.sub(r'\1;}',s)

	pattern=re.compile(r'({|}|;)')
	s=re.sub(pattern,r'\1\n',s)

	#逐个字符分析
	#for a in s:
	#	if a=='{':
	#		l.append('{\n')
	#	elif a=='}':
	#		l.append('}\n')
	#	elif a==';':
	#		l.append(';\n')
	#	else:
	#		l.append(a)

	#恢复特殊标记
	pattern=re.compile(r'&&(.*?)&&')
	#s=re.sub(pattern,r'@{\1}',''.join(l))
	s=re.sub(pattern,r'@{\1}',s)

	l=s.split('\n')
	#去掉最后空行
	l.pop()
	l=beautifulLeft(l)

	#得到缩进
	space_count=l[0].count('\t')
	#开始标记
	start_tag=1
	for i in range(len(l)):
		if i!=0:
			if l[i].count('{')==l[i].count('}'):
				l[i]=(space_count+start_tag)*'\t'+l[i]
			elif l[i].count('{')>l[i].count('}'):
				l[i]=(space_count+start_tag)*'\t'+l[i]
				start_tag+=1
			elif l[i].count('{')<l[i].count('}'):
				l[i]=(space_count+start_tag-1)*'\t'+l[i]
				start_tag-=1


	return l
#}}}

# beautifulLeft 对齐CSS{{{
def beautifulLeft(l):
	max_len=-1
	for i in range(len(l)):
		s=l[i]
		m=s.find(':')
		if s[-1]==';' and m!=-1:
			if m>max_len:
				max_len=m

	max_len+=1
	for i in range(len(l)):
		s=l[i]
		m=s.find(':')
		if s[-1]==';' and m!=-1:
			#左对齐
			l[i]=l[i][:m]+' '*(max_len-m)+': '+l[i][m+1:]

			#居中对齐
			#l[i]=(max_len-m)*' '+l[i][:m]+' : '+l[i][m+1:]


	return l
#}}}

#{{{ writeBuffer 写入缓冲区
def writeBuffer(start,end,strList):
	b=vim.current.buffer
	b[start:end+1]=strList
#}}}

r=getRange()

if r!=None:
	if len(r)!=1:
		writeBuffer(r.start,r.end,con(list(r)))
	else:
		if do_what=='all':
			writeBuffer(r.start,r.end,expandX(list(r)))
		else:
			writeBuffer(r.start,r.end,expand(list(r)))


EOM

endfunction
