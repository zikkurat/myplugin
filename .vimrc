"===========================================================
"=                            备忘                         =
"===========================================================
"{{{
"             保存会话
"             :mksession session.vim
"             :mks session.vim
"             载入会话
"             :source session.vim
"             :so session.vim
"
"             设置文件编码utf-8+BOM，一些特殊软件可能会用到，如foobar读取cue文件时，编辑必须设置为utf-8+BOM
"             set bomb
"             set nobomb
"
"
"             加密文件：
"             :set key=code
"             下次编辑时需要输入密码，密码错误会显示乱码
"             加密后，如果密码输入错误，VIM不会强制保护文档，使用w!可强制写入文档
"             解密直接设置key为空：
"             :set key=
"
"
"}}}


"===========================================================
"=                        插件说明                         =
"===========================================================
"{{{ 插件说明
"	说明：
"	分布：
"	地址：
"	使用方法：
"bufexplorer.vim
"	说明：缓冲区浏览
"	分布：单文件
"	地址：http://www.vim.org/scripts/script.php?script_id=42
"	使用方法：
"		\be(标准，整个窗口)
"		\bs(横向分割窗口)
"		\bv(竖向分割窗口)
"--------------------------------------------------------------
"csExplorer.vim
"	说明：配色方案浏览
"	分布：plugin,doc
"	地址：http://www.vim.org/scripts/script.php?script_id=1298
"	使用方法：
"-------------------------------------------------------------
"colorizer.vim
"	说明：预览16进制颜色
"	分布：plugin,autoload
"	地址：http://www.vim.org/scripts/script.php?script_id=3567
"	使用方法：
"		ColorHighlight(开始显示/更新 高亮颜色)
"		ColorClear(清除高亮)
"		ColorToggle(切换)
"		默认快捷方式：\tc
"-------------------------------------------------------------
"jsbeautify.vim
"	说明：美化JS文件
"	分布：单文件
"	地址：http://www.vim.org/scripts/script.php?script_id=2727
"	使用方法：
"-------------------------------------------------------------
"mark.vim
"	说明：用不同颜色高亮指定关键字
"	分布：
"		autoload/mark.vim
"		autoload/mark/palettes.vim
"		mark.vim
"		doc/mark.txt
"	地址：http://www.vim.org/scripts/script.php?script_id=2666
"	使用方法：
"		<leader>m 标记光标下的词
"		<leader>r 输入一个正则表达式标记
"		<leader>n 清除光标下的词，第二次清除全部
"
"		命令模式：
"		:Mark{表达式}
"		:Mark 切换隐藏/显示高亮标记
"		:MarkClear 清除全部标记
"
"		搜索模板：
"		[数字]<leader>* 跳到本颜色组的下一个标记
"		[数字]<leader># 跳到本颜色组的上一个标记
"		[数字]<leader>/ 跳到下一个颜色组
"		[数字]<leader>? 跳到上一个颜色组
"-------------------------------------------------------------
"matchit.vim
"	说明：快速跳转到配对的符号或标签
"	分布：单文件
"	地址：http://www.vim.org/script.php?script_id=39
"	使用方法：使用%即可跳转
"-------------------------------------------------------------
"move.vim
"	说明：移动行插件
"	分布：plugin,doc
"	地址：http://www.vim.org/scripts/script.php?script_id=4687
"	使用方法：
		"alt+j 整行向下移动
		"alt+k 整行向上移动
		"选中多行亦可
"-------------------------------------------------------------
"statusline.vim
"	说明：状态栏样式
"	分布：单文件
"	地址：http://www.vim.org/scripts/script.php?script_id=3734
"	使用方法：
"-------------------------------------------------------------
"UltiSnips.vim
"	说明：
"	分布：
"	地址：http://www.vim.org/scripts/script.php?script_id=2715
"	使用方法：
"	版本：3.0(2014-03-22)
"
"-------------------------------------------------------------
"terryma/vim-multiple-cursors
"	说明：多行文本编辑
"	分布：
"	地址：
"	使用方法：c-n 选择光标下单词，非单词要先选中，连续按c-n选择，按c修改
"	支持表达式使用，命令为：MultipleCursorsFind [表达式]
"
"}}}

"设置是否兼容vi模式
"此设置必须放在靠前位置
"neovim不再支持此设置
set nocompatible

"设置一些变量
if(has("win32"))
	let $VIMFILES=$VIM."/vimfiles"
else
	let $VIMFILES=$HOME."/.vim"
endif

"===========================================================
"=                     vundle 插件管理                     =
"===========================================================
"{{{
"安装说明：
"https://github.com/VundleVim/Vundle.vim

filetype off
if(has("win32"))
	set rtp+=$VIMFILES/bundle/vundle.vim
	call vundle#begin('$VIMFILES/bundle/vundle.vim/')
else
	set rtp+=~/.vim/bundle/vundle.vim
	call vundle#begin('~/.vim/bundle/vundle.vim/')
endif

"Plugins
Plugin 'VundleVim/Vundle.vim'						"插件管理依赖

Plugin 'majutsushi/tagbar'							"tarbar没什么好说的
Plugin 'vim-scripts/matchit.zip'					"快速跳转到配对的符号或标签
Plugin 'jlanzarotta/bufexplorer'					"缓冲区管理
Plugin 'lilydjwg/colorizer'							"在文件内查看代码表示的颜色
Plugin 'kien/ctrlp.vim'								"文件查找
Plugin 'lunaru/vim-less'							"less文件支持
Plugin 'sjas/csExplorer'							"颜色方案预览
Plugin 'easymotion/vim-easymotion'					"快速跳转
Plugin 'vim-airline/vim-airline'					"状态条
Plugin 'vim-airline/vim-airline-themes'				"状态条配色方案
Plugin 'matze/vim-move'								"移动行
Plugin 'sirver/ultisnips'							"自动完成
Plugin 'honza/vim-snippets'							"自动完成方案大全
Plugin 'scrooloose/nerdcommenter'					"注释插件
Plugin 'zikkurat/myplugin'							"自写插件
Plugin 'marijnh/tern_for_vim'						"JS补全引擎
Plugin 'othree/javascript-libraries-syntax.vim'		"javascript系列框架语法高亮
Plugin 'vim-scripts/Mark'							"高度指定关键字
Plugin 'terryma/vim-multiple-cursors'				"多行文本编辑
Plugin 'rkulla/pydiction'							"python自动完成

"颜色方案
Plugin 'jonathanfilip/vim-lucius'
Plugin 'ajh17/Spacegray.vim'
Plugin 'yuratomo/neon.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'morhetz/gruvbox'
"Plugin 'tomasr/molokai'
Plugin 'vim-scripts/Wombat'

"中文帮助
Plugin 'zikkurat/vimdoc'
Plugin 'vimcn/ctrlp.cnx'
Plugin 'vimcn/NERD_commenter.cnx'
Plugin 'vimcn/bufexplorer.vim.cnx'

call vundle#end()
filetype plugin on

"安装插件":BundleInstall"
"更新插件":BundleUpdate"
"清除不再使用的插件":BundleClean"
"列出所有插件":BundleList"
"查找插件":BundleSearch"

"安装插件":PluginInstall"
"更新插件":PluginUpdate"
"清除不再使用的插件":PluginClean"
"列出所有插件":PluginList"
"查找插件":PluginSearch"

"}}}

"===========================================================
"=                        公共部分                         =
"===========================================================
"{{{
let mapleader=" " "设置VIM快捷符号

"语言，编码相关{{{

set enc=utf-8 "设置显示编码
set fenc=utf-8 "设置文件编码
set fileformat=unix
language messages zh_cn.utf-8 "解决console输出乱码，就是控制台乱码
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 "设置文件编码检测类型及支持格式

"以下为指定菜单语言
set langmenu=zh_CN.UTF-8
"删除现有菜单
source $VIMRUNTIME/delmenu.vim
"重建菜单
source $VIMRUNTIME/menu.vim

"以下字符将被视为单词的一部分 (ASCII)：
"set iskeyword=@,48-57,_,192-255,- "设置关键字
"set iskeyword+=33-47,58-64,91-96,123-128,-

"}}}

"{{{ 常规设置

set number "显示行号简写nu
set rnu "动态行号

set nobackup "备份文档，不备分
set nowritebackup "在写入档案前先备份一份，不备份

"临时文件存放目录，swap文件
if(has('win32'))
	if isdirectory('z:/temp')
		set directory=z:\temp\
	elseif isdirectory('c:/temp')
		set directory=c:\temp\
	endif
else
	set directory=~/tmp/
endif

set nowrap "设置文本不自动换行
set ic "查找时不考虑大小写


"au GUIEnter * simalt ~x "启动gVIM时最大化
set autoindent "自动缩进autoindent简写ai
syntax on "开启语法加亮
set syn=html
filetype on

"设置自动完成不打开预览窗口，默认为：menu,preview
set completeopt=menu

"}}}

"折叠{{{
set foldenable	"允许折叠
set foldcolumn=0 "显示折行标识
set foldlevel=0 "设置折行深度，自动折行时设定
"set foldclose=all	"设置为自动关闭折叠
"set foldmethod=manual "设定折叠方式(手工)
"set foldmethod=indent "相同缩进距离的行构成折叠
"set foldmethod=expr "设定折叠方式(表达式)
"set foldmethod=syntax "设定折叠方式(语法高亮)
"set foldmethod=diff "设定折叠方式(手工)
set foldmethod=marker "设定折叠方式(对文中的标志折叠)
"}}}

"{{{ 颜色方案

"两种风格：'dark','light'
"let g:lucius_style='dark'
"三种文本亮度：'low','normal','high'
"let g:lucius_contrast='low'
"两种背景对比度：'normal','high'
"let g:lucius_contrast_bg='normal'
"colorscheme lucius "配色风格

set background=dark
colorscheme solarized "配色风格

"hi Pmenu		guifg=#DDDDDD	guibg=#447744	gui=none
"hi PmenuSel		guifg=#FFFFFF	guibg=#993333	gui=none
"hi CursorLine	guibg=#293d29

"set background=dark
"colorscheme yowish "配色风格

"
"}}}

"{{{ 其他

if(has('win32'))
	"windows下用directX渲染文字
	"set renderoptions=type:directx,renmode:5,taamode:1
	set renderoptions=type:directx,
		\gamma:1.5,contrast:0.5,geom:1,
		\renmode:5,taamode:1,level:0.5
endif

set linespace=2 "设定行高，GUI界面中生效

"设置彩色列
"set colorcolumn=51,101,151
"highlight colorcolumn guibg=#293d29
"set cc=101

"设定GUI选项
"set guioptions-=m "m:菜单 T:工具栏 r:滚动条
"set guioptions-=T
set guioptions-=r

set cursorline "设置当前行高亮
"set cursorcolumn "设置当前列高亮

" 进入插入模式时改变状态栏颜色（仅限于Vim 7）
set laststatus=2 "总是显示状态栏
"au InsertEnter * hi StatusLine guibg=#ffa200 guifg=#000000 gui=none
"au InsertLeave * hi StatusLine guibg=#478536 guifg=#ffffff gui=none

set list	"显示制表符
"制表符显示样式
set listchars=tab:\|\ ,trail:°
"set listchars=tab:\|\ ,trail:-

set tabstop=4 "设定Tab键缩进的空格数
set shiftwidth=4 "设定编辑器将多少空格视为一个缩进

"autocmd BufEnter * lcd %:p:h "自动设置当前路径为当前激活的缓冲区文件路径

"光标离窗口上下边界5行时自动滚动
"set scrolloff=5

"}}}

"{{{ 快捷键设置
"==================================================================================================================================
"下面为快捷键设置
"==================================================================================================================================
	"标签
	nmap <F2> :tabnew<cr>
	nmap <C-S-j> :tabp<cr>
	nmap <C-S-k> :tabn<cr>
	nmap <C-j> :bprevious<cr>
	nmap <C-k> :bnext<cr>

"	nmap <F5> :new<cr>
"	nmap <F6> :vnew<cr>
"	nmap <F7> :bnext!<cr>
"	nmap <F8> :bprevious!<cr>

	"缓冲区窗口
	nmap <leader>wl <C-w>l
	nmap <leader>wk <C-w>k
	nmap <leader>wh <C-w>h
	nmap <leader>wj <C-w>j

	"设置文件类型
	nmap <leader>ht :setf html<cr>
	nmap <leader>css :setf css<cr>
	nmap <leader>js :setf javascript<cr>
	nmap <leader>py :setf python<cr>

	"位置跳转
	map <leader>a ^
	map <leader>; $
	map <leader>d V%

	map <F12> :sp<cr>:edit $MYVIMRC<cr>:on!<cr>
	"nmap J Jx
	nmap <leader>color :ColorSchemeExplorer<cr> "选择颜色方案

	map <leader>y "*y
	map <leader>p "*p

	imap jj <Esc>

"}}}

"}}}

"===========================================================
"=                        插件                             =
"===========================================================
"{{{

"===========================================================
"=                      taglist                            =
"===========================================================
"{{{
	" set tags=tags;
	" set autochdir

	" let Tlist_Ctags_Cmd=$VIM . '\ctags\ctags.exe'
	" let Tlist_Show_One_File=1 "不同时显示多个文件的tag，只显示当前文件的
	" let Tlist_Exit_OnlyWindow=1 "如果taglist窗口是最后一个窗口，则退出vim
	" let Tlist_Auto_Open=0 "启动VIM后，自动打开taglist窗口
	" let Tlist_Use_Right_Window=1 "显示在右边
	" let Tlist_WinWidth=30 "宽度
	" let Tlist_Auto_Update=1
	" let Tlist_Show_Menu=1 "显示taglist菜单
	" "let tlist_javascript_settings = 'javascript;c:Class;o:Object;f:Function;a:Array;m:Method;v:variable'
	" "let tlist_html_settings = 'html;i:HTML-ID;c:HTML-Class;d:CSS-ID;s:CSS-Class'
	" "let tlist_xhtml_settings = 'html;i:HTML-ID'
	" let g:tlist_javascript_settings = 'javascript;s:string;a:array;o:object;f:function;m:member'

	" nmap <silent><F7> :Tlist<cr>
	" "let tlist_html_settings = 'html;a:anchor;o:javascript object'
	" "let tlist_html_settings = 'c:javascript Class;o:javascript Object;f:javascript Function;a:javascript Array;m:javascript Method;v:javascript variable'
	
	
"}}}


"===========================================================
"=                      pydiction                          =
"===========================================================
"{{{
	filetype plugin on
	if(has('win32'))
		let g:pydiction_location = 'd:/Vim/vimfiles/bundle/Vundle.vim/pydiction/complete-dict'
	else
		let g:pydiction_location = '/Users/ziggurat/.vim/bundle/Vundle.vim/pydiction/complete-dict'
	endif
	let g:pydiction_menu_height = 10
"}}}


"===========================================================
"=                        UltiSnips                        =
"===========================================================
"{{{

"let g:UltiSnipsExpandTrigger = '<C-l>'
"let g:UltiSnipsListSnippets = '<C-Tab>'
"let g:UltiSnipsJumpForwardTrigger = '<C-l>'

"}}}


"===========================================================
"=                        NerdTree                         =
"===========================================================
"{{{
	"let NERDTreeWinPos="right"	"右边显示窗口
	"let NERDTreeWinSize=50		"窗口大小
	"let NERDTreeIgnore=['.\+\.\(html\)\@!']		"文件过滤
	"let NERDTreeMapToggleFilters='f'		"打开文件过滤
	"map <leader>f :NERDTreeToggle<cr>
	"map <leader>ft :NERDTree z:/<cr>
	"map <leader>fw :NERDTree g:/workcollect/<cr>
	"map <leader>fs :NERDTree e:/Vim/vimfiles/snippets/<cr>
	"map <leader>fh :let NERDTreeIgnore=['.\+\.\(html\)\@!']<cr>r
	"map <leader>fc :let NERDTreeIgnore=['.\+\.\(css\)\@!']<cr>r
	"map <leader>fj :let NERDTreeIgnore=['.\+\.\(js\)\@!']<cr>r
"}}}


"===========================================================
"=                        tagbar                           =
"===========================================================
"{{{

	if(has("win32"))
		let g:tagbar_ctags_bin=$VIM.'\ctags\ctags.exe'
	endif
	nmap <leader>t :TagbarToggle<cr>
	let g:tagbar_width = 30

"}}}


"===========================================================
"=                    tern for vim                         =
"===========================================================
"{{{
	imap <C-o> <C-x><C-o>
	let g:tern_map_keys=1
	let g:tern_show_argument_hints='on_hold'

"}}}


"===========================================================
"=                      bufferhint                         =
"===========================================================
"{{{
"nnoremap <C-I> :call bufferhint#Popup()<CR>
"nnoremap \ :call bufferhint#LoadPrevious()<CR>
"}}}


"===========================================================
"=           javascript系列框架语法高亮                    =
"===========================================================
"{{{
"支持很多JS库，具体到github看
autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_react = 1
"}}}


"===========================================================
"=                         ctrl-p                          =
"===========================================================
"{{{

"let g:ctrlp_cmd = 'CtrlPBuffer'

let g:ctrlp_working_path_mode = 'raw'
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(psd|exe|so|dll|gif|jpg|png|avi|rm|rmvb|mkv|db)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }
"}}}


"===========================================================
"=                        airline                          =
"===========================================================
"{{{
"状态栏插件
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1


"颜色方案
let g:airline_theme='alduin'

"let g:airline_theme='solarized'
"let g:airline_solarized_bg='light'

"乱七八糟的定制文字颜色
"function! AccentDemo()
	"let keys = ['a','b','c','d','e','f','g','h']
	"for k in keys
		"call airline#parts#define_text(k, k)
	"endfor
	"call airline#parts#define_accent('a', 'red')
	"call airline#parts#define_accent('b', 'green')
	"call airline#parts#define_accent('c', 'blue')
	"call airline#parts#define_accent('d', 'yellow')
	"call airline#parts#define_accent('e', 'orange')
	"call airline#parts#define_accent('f', 'purple')
	"call airline#parts#define_accent('g', 'bold')
	"call airline#parts#define_accent('h', 'italic')
	"let g:airline_section_a = airline#section#create(keys)
"endfunction
"autocmd VimEnter * call AccentDemo()




"}}}


"===========================================================
"=                        自写插件                         =
"===========================================================
"{{{
	"
	"自写插件地址:   vimfiles/plugin/MyPlugins.vim
	"
	"
	"map <leader>o :call JoinHTML()<cr>
	map <leader>o :call JSKey#openWin()<cr>
	"map <leader>q :source $VIM\vimfiles\bundle\Vundle.vim\myplugin\plugin\JSKey.vim<cr>
	map <leader>1 :call FormatCss('all')<cr>
	map <leader>e :call FormatCss('one')<cr>
	map <leader>v :call FormatHTML()<cr>
	"nmap <Space> :call FindAttribute("")<cr>
	vmap <Space> <Esc>:call FindAttribute("")<cr>
	nmap <S-Space> :call FindAttribute("b")<cr>
	vmap <S-Space> <Esc>:call FindAttribute("b")<cr>
	map <leader>x :call FormatJS()<cr>
"}}}

"}}}

"===========================================================
"=                           GUI                           =
"===========================================================
"{{{ GUI设置

set guifont=Source_Code_Pro_for_Powerline:h16
set guifontwide=Yahei_Mono:h16

"if(has('gui_running'))
"
"	if(has('win32'))
"		set guifont=Source_Code_Pro_for_Powerline:h12
"		"set guifont=Noto_Mono_for_Powerline:h12
"		set guifontwide=Yahei_Mono:h12
"	else
"		set guifont=mononoki:h16
"		set guifontwide=Yahei_Mono:h16
"	endif
	

	"字体{{{
	"设置字体
	"set guifont=source_code_pro_Semibold:h11
	"set guifont=Monaco:h11
	"set guifont=Yahei_Mono:h12
	"set guifont=consolas:h11

	"set guifont=Source_Code_Pro:h11
	"set guifont=Bitstream_Vera_Sans_Mono:h11

	"set guifontwide=GulimChe:h11
	"set guifont=Courier\ New:h16

	"set guifont=Megatops_ProCoder_1.0:h11
	"set guifontwide=Yahei_Mono:h12
	"}}}

endif
"}}}

"===========================================================
"=                           终端                         =
"===========================================================
"{{{
if(has('gui_running')==0)

	"set background=dark
	"colorscheme yowish "配色风格

endif
