" 让配置变更立即生效
" autocmd BufWritePost $MYVIMRC source $MYVIMRC
" autocmd BufWritePost $MYVIMRC 
" basic setup
set modelines=0                          " 禁用模式行（安全措施）
syntax on                                " 语法高亮
filetype on                              " 开启文件类型检测
filetype plugin on
" 主题
set background=dark
colorscheme solarized
" colorscheme molokai
" colorscheme phd
" colorscheme desert

set encoding=utf-8                       " 编码设置
set number                               " 显示行号
" set relativenumber                       " 显示相对行号
set smartindent                          " 智能缩进
set autoindent                           " 自动对齐

set smarttab
set tabstop=2                            " tab缩进
set shiftwidth=2                         " 设定自动缩进为2个字符
set expandtab                            " 用space替代tab的输入
set splitright                           " 设置左右分割窗口时，新窗口出现在右侧
set splitbelow                           " 设置水平分割窗口时，新窗口出现在底部

set nobackup                             " 不需要备份
set noswapfile                           " 禁止生成临时文件
set autoread                             " 文件自动检测外部更改
set clipboard=unnamed                    " 共享剪切板

set nocompatible                         " 去除vi一致性
set ambiwidth=double                     " 解决中文标点显示的问题
set nowrap                               " 不自动折行
set mouse=a                              " 使用鼠标
set mousehide                            " 输入时隐藏鼠标
" set sidescroll=10                        " 移动到看不见的字符时，自动向右滚动是个字符

set sm!                                  " 高亮显示匹配括号
set incsearch                            " 搜索高亮
set hlsearch                             " 高亮查找匹配
set cursorline                           " 高亮显示当前行
" hi cursorline guibg=#00ff00
" hi CursorColumn guibg=#00ff00
set termguicolors                        " 启用终端真色

set showmatch                            " 显示匹配
set ruler                                " 显示标尺，在右下角显示光标位置
set novisualbell                         " 不要闪烁
set showcmd                              " 显示输入的命令

set laststatus=2                         " always show statusline
set showtabline=2                        " always show tabline
set confirm
set completeopt=preview,menu

inoremap jj <esc> 
nnoremap <space>l $
nnoremap <space>h ^
nnoremap <space>j <c-f>
nnoremap <space>k <c-b>

" 设置状态行显示常用信息
" %F 完整文件路径名
" %m 当前缓冲被修改标记
" %m 当前缓冲只读标记
" %h 帮助缓冲标记
" %w 预览缓冲标记
" %Y 文件类型
" %b ASCII值
" %B 十六进制值
" %l 行数
" %v 列数
" %p 当前行数占总行数的的百分比
" %L 总行数
" %{...} 评估表达式的值，并用值代替
" %{"[fenc=".(&fenc==""?&enc:&fenc).((exists("+bomb") && &bomb)?"+":"")."]"} 显示文件编码
" %{&ff} 显示文件类型
set statusline=%1*%F%m%r%h%w%=\ 
set statusline+=%2*\ %Y\ \|\  
set statusline+=%3*%{\"\".(\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\").\"\"}\ 
set statusline+=%4*[%l:%v]\ 
set statusline+=%5*%p%%\ \|\ 
set statusline+=%6*%LL\ 

hi User1 cterm=none ctermfg=gray ctermbg=darkgray
hi User2 cterm=none ctermfg=darkgrey ctermbg=gray
hi User3 cterm=bold ctermfg=darkgrey ctermbg=gray
hi User4 cterm=bold ctermfg=yellow ctermbg=gray
hi User5 cterm=none ctermfg=darkgrey ctermbg=gray
hi User6 cterm=none ctermfg=darkgrey ctermbg=gray

" 设置tab栏-------------------------------------------------
" 选中的tab颜色
hi SelectTabLine term=Bold cterm=Bold ctermfg=DarkYellow ctermbg=LightGray
hi SelectPageNum cterm=None ctermfg=DarkRed ctermbg=LightGray
hi SelectWindowsNum cterm=None ctermfg=DarkCyan ctermbg=LightGray
" 未选中状态的tab
hi NormalTabLine cterm=None ctermfg=Gray ctermbg=DarkGray
hi NormalPageNum cterm=None ctermfg=Gray ctermbg=DarkGray
hi NormalWindowsNum cterm=None ctermfg=Gray ctermbg=DarkGray
" tab栏背景色
hi TabLineFill term=reverse ctermfg=5 ctermbg=7 guibg=#6c6c6c

function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        let hlTab = ''
        let select = 0
        if i + 1 == tabpagenr()
            let hlTab = '%#SelectTabLine#'
            let s ..= hlTab . '⎡%#SelectPageNum#%T' . (i + 1) . hlTab
            let select = 1
        else
            let hlTab = '%#NormalTabLine#'
            let s ..= hlTab . "⎡%#NormalTabLine#%T" . (i + 1) . hlTab
        endif

        " the label is made by MyTabLabel()
        let s .= ' %<%{MyTabLabel(' . (i + 1) . ', ' . select . ')} '
        "追加窗口数量
        let wincount = tabpagewinnr(i + 1, '$')
        if wincount > 1
            if select == 1
                let s .= "%#SelectWindowsNum#" . wincount
            else
                let s .= "%#NormalWindowsNum#" . wincount
            endif
        endif
        let s .= hlTab . "⎦"
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s ..= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      let s ..= '%=%#TabLine#%999X░❨X❩'
    endif

    return s
endfunction

" Now the MyTabLabel() function is called for each tab page to get its label. >
function MyTabLabel(n, select)
    let label = ''
    let buflist = tabpagebuflist(a:n)

    for bufnr in buflist
        if getbufvar(bufnr, "&modified")
            let label = '+'
            break
        endif
    endfor

    let winnr = tabpagewinnr(a:n)
    let name = bufname(buflist[winnr - 1])

    if name == ''
        if &buftype == 'quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[No Name]'
        endif
    else
        let name = fnamemodify(name, ':t')
    endif

    let label .= name
    return label
endfunction

set tabline=%!MyTabLine()

" 设置netrw-------------------------------------
let g:netrw_banner = 0         " 设置是否显示横幅
let g:netrw_liststyle = 3      " 设置目录列表样式：树形
let g:netrw_browse_split = 4   " 在之前的窗口编辑文件
let g:netrw_altv = 1           " 水平分割时，文件浏览器始终显示在左边
let g:netrw_winsize = 20       " 设置文件浏览器窗口宽度为25%
let g:netrw_list_hide= '^\..*' " 不显示隐藏文件 用 a 键就可以显示所有文件、 隐藏匹配文件或只显示匹配文件
" 自动打开文件浏览器
" augroup ProjectDrawer
"     autocmd!
"     autocmd VimEnter * :Vexplore
" augroup END

" 快捷键绑定
let mapleader='\'
" 窗口移动快捷键
noremap <TAB>w <C-w>w 
noremap <TAB>c <C-w>c
noremap <TAB>h <C-w><left>
noremap <TAB>l <C-w><right>
noremap <TAB>k <C-w><up>
noremap <TAB>j <C-w><down>
" 使用方向键切换buffer
noremap <space><left> :bp<CR>
noremap <space><right> :bn<CR>
" 使用方括号切换tab
noremap <TAB>] :tabnext<CR>
noremap <TAB>[ :tabprevious<CR>
" 使用 \ + s 保存, \ + q 退出
noremap <space>s :w<CR>
noremap <space>q :q<CR>
" 设置快捷键将选中文本块复制至系统剪贴板
vnoremap <Leader>y "+y
" 设置快捷键将系统剪贴板内容粘贴至 vim
nmap <Leader>p "+p
" 打开或关闭目录树
nnoremap <SPACE>t :Lexplore<CR>    

" 文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\#    File Name: ".expand("%"))
        call append(line(".")+1, "\#    Author: Alpraline")
        call append(line(".")+2, "\#    Mail: 1776882398@qq.com ")
        call append(line(".")+3, "\#    Created Time: ".strftime("%c"))
        call append(line(".")+4, "\#########################################################################")
        call append(line(".")+5, "\#!/usr/bin/bash")
        call append(line(".")+9, "")
    endif
endfunc
" 创建文件时自动生成文件头
autocmd BufNewFile * call SetTitle()
