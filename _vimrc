set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

filetype  plugin  on

""""""""""""encoding settings""""""""""
set  encoding=utf-8
set  langmenu=zh_CN.UTF-8
language  message  zh_CN.UTF-8
set  fileencoding=utf-8
set  fileencodings=utf-8,chinese
""""""""""""encoding settings""""""""""


""""""""""""common settings""""""""""""
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
language messages zh_CN.utf-8
"设置窗口大小
set lines=40 columns=120
syntax on
set cul "高亮光标所在行
set cuc
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
"color desert     " 设置背景主题  
"color solarized  " 设置背景主题  
"color torte     " 设置背景主题  
set guifont=Courier_New:h12:cANSI   " 设置字体  
"autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些  
"set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  
"set foldenable      " 允许折叠  
""set foldmethod=manual   " 手动折叠  
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 自动缩进
set autoindent
set cindent
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
"搜索逐字符高亮
set hlsearch
set incsearch
" 总是显示状态行
set cmdheight=2

""""""""""""common settings""""""""""""

""""""""""""NEEDTree opened by default""""""""""""
" autocmd VimEnter * NERDTree
""""""""""""NEEDTree ctrl+w to change windows""""""""""""
" wincmd w
" au VimEnter * wincmd w
""""""""""""NEEDTree settings""""""""""""
" let NERDTreeWinSize = 25
" let NERDTreeIgnore = ['\aux$','\log$','\pdf$','\syn$']

" NERD tree
let NERDChristmasTree=0
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
" let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
let NERDTreeIgnore = ['\aux$','\log$','\pdf$','\gz$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos="left"
" Automatically open a NERDTree if no files where specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open a NERDTree
nmap <F5> :NERDTreeToggle<cr>


" Tagbar
let g:tagbar_width=35
let g:tagbar_autofocus=1
nmap <F6> :TagbarToggle<CR>

"ctag tag dir
"首先要用ctag生成tag，一般固定放在这个文件夹，用cmd进入vimfiles/tags文件夹，然后
"输入ctags -R --c-kinds=+p --fields=+iaS --extra=+q E:\想要生成tag的code目录
"然后tags文件将放置在\tags文件夹下
" set tags+=d:\Vim\vimfiles\tags\tags
" set tags+=$VIM/vimfiles/tags/stm32_tags 
set tags+=$VIM/vimfiles/tags/latex_tags 


"omnicppcomplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1 
let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表 
let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全 
let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全 
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" 自动关闭补全窗口 
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif 
set completeopt=menuone,menu,longest
"omnicppcomplete




""""""""""""vundle settings""""""""""""
filetype on  

" 此处规定Vundle的路径  

set rtp+=$VIM/vimfiles/bundle/vundle/  

call vundle#rc('$VIM/vimfiles/bundle/')  


colorscheme molokai
Bundle 'gmarik/vundle'  
Bundle 'Vincent4307/vimlatex_win32'  

" filetype plugin indent on  

" original repos on github  

"Bundle 'mattn/zencoding-vim'  

"Bundle 'drmingdrmer/xptemplate'  

" vim-scripts repos  

"Bundle 'vim-markdown'  
"Bundle 'christoomey/vim-run-interactive'
"Bundle 'croaky/vim-colors-github'
"Bundle 'danro/rename.vim'
"Bundle 'kchmck/vim-coffee-script'
Plugin 'kien/ctrlp.vim'
"Bundle 'pbrisbin/vim-mkdir'
"Bundle 'scrooloose/syntastic'
"Bundle 'slim-template/vim-slim'
"Bundle 'thoughtbot/vim-rspec'
"Bundle 'tpope/vim-bundler'
"Bundle 'tpope/vim-endwise'
"Bundle 'tpope/vim-fugitive'
"Bundle 'tpope/vim-rails'
"Bundle 'tpope/vim-surround'
"Bundle 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/ctags.vim'
"Bundle 'vim-scripts/matchit.zip'
Bundle 'vim-scripts/tComment'
"Bundle 'mattn/emmet-vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'Lokaltog/vim-powerline'
"Bundle 'godlygeek/tabular'
"Bundle 'msanders/snipmate.vim'
"Bundle 'jelera/vim-javascript-syntax'
"Bundle 'altercation/vim-colors-solarized'
"Bundle 'othree/html5.vim'
"Bundle 'xsbeats/vim-blade'
"Bundle 'Raimondi/delimitMate'
"Bundle 'groenewege/vim-less'
"Bundle 'evanmiller/nginx-vim-syntax'
"Bundle 'Lokaltog/vim-easymotion'
Bundle 'tomasr/molokai'
" Bundle 'Vincent4307/Vimlatex_suit'
Bundle 'vim-scripts/OmniCppComplete'
" Bundle 'Valloric/YouCompleteMe'
Bundle 'ervandew/supertab'

filetype plugin indent on " required!
 
"source $VIMRUNTIME/ruby-macros.vim
""""""""""""vundle settings""""""""""""




