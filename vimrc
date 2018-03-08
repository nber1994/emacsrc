set nocompatible                 "去掉有关vi一致性模式，避免以前版本的bug和局限
set nu                                    "显示行号
filetype on                              "检测文件的类型
set history=1000                  "记录历史的行数
set background=dark          "背景使用黑色
syntax on                                "语法高亮度显示
set autoindent                       "vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进）
set smartindent                    "依据上面的对齐格式，智能的选择对齐方式，对于类似C语言编写上有用
set tabstop=4                        "设置tab键为4个空格，
set shiftwidth =4                   "设置当行之间交错时使用4个空格
set ai!                                      " 设置自动缩进
set showmatch                     "设置匹配模式，类似当输入一个左括号时会匹配相应的右括号
set guioptions-=T                 "去除vim的GUI版本中得toolbar
set vb t_vb=                            "当vim进行编辑时，如果命令错误，会发出警报，该设置去掉警报
set ruler                                  "在编辑过程中，在右下角显示光标位置的状态行
set incsearch                        "在程序中查询一单词，自动匹配单词的位置；
set expandtab
set relativenumber
set cursorcolumn
set cursorline
set ignorecase
"set list listchars=tab:>-,trail:-
"command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>
"execute pathogen#infect()
set laststatus=2
set hlsearch
set statusline=%t\ %y\ format:\ %{&ff};\ [%c,%l]
""inoremap ' ''<ESC>i
""inoremap " ""<ESC>i
""inoremap ( ()<ESC>i
""inoremap [ []<ESC>i
""inoremap { {<CR>}<ESC>O
"set statusline+=%4*\ %F\ %* 
"hi User4 cterm=bold ctermfg=169 ctermbg=239 
set t_Co=256
"colorscheme base16-atelierdune
"colorscheme happy_hacking
"colorscheme Chasing_Logic
"colorscheme base16-ateliercave
"colorscheme ron
"colorscheme my
"
"colorscheme redblack
"colorscheme 256_noir
"colorscheme 256-jungle
"colorscheme onedark
"colorscheme badwolf
"colorscheme greenvision
"colorscheme darkblue
"colorscheme random
"colorscheme farout
"colorscheme solarized8_dark_high
map <F5> :!ctags -R<CR>
"cmap E Explore
"inoremap jk <esc>
cabbrev E Explore
set backspace=indent,eol,start
autocmd BufWritePost *.php call PHPSyntaxCheck()
"autocmd BufWritePost *.php call Removess()
if !exists('g:PHP_SYNTAX_CHECK_BIN')
    let g:PHP_SYNTAX_CHECK_BIN = 'php'
endif

function! PHPSyntaxCheck()
    let result = system(g:PHP_SYNTAX_CHECK_BIN.' -l -n '.expand('%'))
    if (stridx(result, 'No syntax errors detected') == -1)
        echohl WarningMsg | echo result | echohl None
    endif
endfunction
""php代码的检查与格式化工具
""实现以下功能:
""  1 :F
""      php代码的语法检查
""      格式化代码
""      去除行尾的空格,tab与^M
""      将文件中的tab改为4个空格
""  2 <F12> 生成方法注释
""  3 <F4> 生成作者信息
""2017/4/22
""author jingtianyou
let Copyright = ' * Copyright © 链家网（北京）科技有限公司 '
let str = nr2char(10)  " 不可打印字符
let str = strtrans(str)
let User      = ' * User: ' . get(split(system('who'), ' '), 0)
if !exists('g:PHP_SYNTAX_CHECK_BIN')
    let g:PHP_SYNTAX_CHECK_BIN = 'php'
endif
command! F call Formatcheck()
nmap <F4> :call Addhead()<CR>:10<CR>o
nmap <F12> :call Funchead()<CR>:.+5<CR>o
nmap <F6> :call Funcdebug1()<CR>i
nmap <F7> :call Funcdebug2()<CR>i
nmap <F8> :call Funcdebug3()<CR>i
nmap <F2> :source ~/.vimrc_crt<CR>
if !exists("*Funcmove")
func! Funcmove(line, clom)
    let pos = getpos(".")
    let pos[1] = pos[1] + a:line
    let pos[2] = a:clom
    call setpos('.', pos)
endfunc
endif
if !exists("*Formatcheck")
func! Formatcheck()
    let n = line('.')
    silent! w
    call Format()
    execute n
    echom "FCheck: Code Format Done!"
    if (expand('%:e') == 'php')
        let result = system(g:PHP_SYNTAX_CHECK_BIN.' -l -n '.expand('%'))
        if (stridx(result, 'No syntax errors detected') == -1)
            echohl WarningMsg | echo result | echohl None
        endif
    endif
endfunc
endif
if !exists("*Format")
function! Format()
    call Removess()
    try
        execute "normal = \<Esc>"
        execute 'set ts=4'
        execute 'set expandtab'
        execute '%retab!'
    catch
    endtry
endfunction
endif
if !exists("*Removess")
func! Removess()
    try
        execute '%s/\s\+$'
        execute '%s/^M$//g'
    catch
    endtry
endfunc
endif
if !exists("*Addhead")
func! Addhead()
    let n = 3
    let line = getline(n)
    let str = '^ \* Copyright © 链家网（北京）科技有限公司 $'
        if line =~ str
            return
        endif
    call Setfilehead()
endfunc
endif
if !exists("*Setfilehead")
func! Setfilehead()
    call append(0, '<?php')
    call append(1, '/**')
    call append(2, g:Copyright)
""    call append(3, g:User)
    call append(3, ' * User: jingtianyou@lianjia.com')
    call append(4, ' * Date: '.strftime("%Y/%m/%d %H:%M:%S"))
    call append(5, ' * Desc: ')
    call append(6, ' */')
endfunc
endif
if !exists("*Funchead")
func! Funchead()
    call append(line(".")+0, '    /**')
    call append(line(".")+1, '     * @param')
    call append(line(".")+2, '     * @return')
    call append(line(".")+3, '     * Desc')
    call append(line(".")+4, '     */')
endfunc
endif
if !exists("*Funcdebug1")
func! Funcdebug1()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, '$var = var_export(, true);')
    call append(line(".")+4, "file_put_contents('/tmp/log', $var);")
    call append(line(".")+5, 'die;')
    call append(line(".")+6, '}')
    call append(line(".")+7, '//********debug 断点，后续请删除*********')
    call append(line(".")+8, '')
    call Funcmove(4, 19)
endfunc
endif
if !exists("*Funcdebug2")
func! Funcdebug2()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, 'var_dump();')
    call append(line(".")+4, 'die;')
    call append(line(".")+5, '}')
    call append(line(".")+6, '//********debug 断点，后续请删除*********')
    call append(line(".")+7, '')
    call Funcmove(4, 10)
endfunc
endif
if !exists("*Funcdebug3")
func! Funcdebug3()
    call append(line(".")+0, '')
    call append(line(".")+1, '//********debug 断点，后续请删除*********')
    call append(line(".")+2, 'if (true) {')
    call append(line(".")+3, 'print_r();')
    call append(line(".")+4, 'die;')
    call append(line(".")+5, '}')
    call append(line(".")+6, '//********debug 断点，后续请删除*********')
    call append(line(".")+7, '')
    call Funcmove(4, 9)
endfunc
endif
function! RunPhpcs()
    let l:filename=@%
    let l:phpcs_output=system('/usr/local/matrix/bin/php /home/jty/github/PHP_CodeSniffer/bin/phpcs --report=csv --standard=PSR2 '.l:filename)
    let l:phpcs_list=split(l:phpcs_output, "\n")
    unlet l:phpcs_list[0]
    cexpr l:phpcs_list
    cwindow
endfunction
set errorformat+="%f"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,"%m"
command! Phpcs execute RunPhpcs()

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Bundle 'scrooloose/syntastic'
"let g:syntastic_enable_signs = 1
"let g:syntastic_check_on_open=1
"let g:syntastic_check_on_wq=0
"let g:syntastic_enable_highlighting=0
"let g:syntastic_python_checkers=['pyflakes'] " 使用pyflakes,速度比pylint快
"let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
"let g:syntastic_javascript_checkers = ['jsl', 'jshint']
"let g:syntastic_html_checkers=['tidy', 'jshint']
"" 修改高亮的背景色, 适应主题
"highlight SyntasticErrorSign ctermbg=Red cterm=none ctermfg=Red
"highlight SyntasticWarningSign ctermbg=Black cterm=none ctermfg=Black

 " to see error location list
 function! ToggleErrors()
     let old_last_winnr = winnr('$')
     lclose
     if old_last_winnr == winnr('$')
         " Nothing was closed, open syntastic error location
         panel
         Errors
     endif
 endfunction
 nnoremap <Leader>s :call ToggleErrors()<cr>

 Bundle 'mileszs/ack.vim'
"Bundle 'liuchengxu/eleline.vim'
Bundle 'ctrlpvim/ctrlp.vim'

Bundle 'ianva/vim-youdao-translater'
vnoremap <silent> <C-Y> :<C-u>Ydv<CR>
nnoremap <silent> <C-Y> :<C-u>Ydc<CR>
noremap <leader>yd :<C-u>Yde<CR>

Bundle 'majutsushi/tagbar'
"let g:tagbar_ctags_bin='/usr/local/bin/ctags'            "ctags程序的路径
let g:tagbar_ctags_bin='/usr/bin/ctags'            "ctags程序的路径
let g:tagbar_width=50                    "窗口宽度的设置
let g:tagbar_autofocus = 1
let g:tagbar_left=1 
nmap <F3> :TagbarToggle<CR>

filetype plugin indent on     " required!
