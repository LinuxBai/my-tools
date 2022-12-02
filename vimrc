set nu
set ruler
set autoindent
set showmatch
set incsearch
set hlsearch
set showcmd

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,gbk,cp936,gb2312,big5,euc-jp,euc-kr,latin1
let &termencoding=&encoding
language messages zh_CN.utf-8

set ignorecase
set tabstop=4
set bg=light
set softtabstop=4
set shiftwidth=4
set expandtab
set list
set listchars=tab:>-,trail:-

set autochdir
set tags=tags;

set t_Co=256
syntax enable
set background=dark
"set background=light
colorscheme solarized

"if has('gui_running')
"	set background=light
"else
"	set background=dark
"endif


set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'vim-scripts/taglist.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


" majutsushi/tagbar
let g:tagbar_ctags_bin='/usr/bin/ctags' 
let g:tagbar_left=1
let g:tagbar_width=24
nmap <c-i> :TagbarToggle<CR>

"rking/ag.vim
let g:ag_prg="<custom-ag-path-goes-here> --vimgrep"
let g:ag_working_path_mode="r"

"kien/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
"let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

"nerdtree
let NERDTreeQuitOnOpen=1 "打开文件时，关闭树
nmap <c-n> :NERDTreeToggle<CR>
"nnoremap <silent> <F2> :NERDTree<CR>
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeBookmarksFile=$VIM.'\Data\NerdBookmarks.txt'
let NERDTreeMouseMode=2
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='right'
let NERDTreeWinSize=28

"taglist
let Tlist_Ctags_Cmd='ctags'
let Tlist_Show_One_File=1               "不同时显示多个文件的tag，只显示当前文件的
let Tlist_WinWidt=28                   "设置taglist的宽度
let Tlist_Exit_OnlyWindow=1             "如果taglist窗口是最后一个窗口，则退出vim
"let Tlist_Use_Right_Window=1           "在右侧窗口中显示taglist窗口
let Tlist_Use_Left_Windo=1             "在左侧窗口中显示taglist窗口
let Tlist_Auto_Open=0
"nmap <c-t> :TaglistToggle<CR>

"cscope
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=1
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	set csverb
endif

nmap <C-/>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-/>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-/>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-/>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-/>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-/>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-/>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-/>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"air line
"This is disabled by default; add the following to your vimrc to enable the extension:
let g:airline#extensions#tabline#enabled = 1
"Separators can be configured independently for the tabline, so here is how you can define "straight" tabs:
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"In addition, you can also choose which path formatter airline uses. 
"This affects how file paths are displayed in each individual tab as well as the current buffer indicator in the upper right. 
"To do so, set the formatter field with:
let g:airline#extensions#tabline#formatter = 'default'
"air line theme
let g:airline_theme='bubblegum'

"设置切换Buffer快捷键"
let g:airline#extensions#tabline#buffer_nr_show = 1
nmap <S-tab> :bp<CR>
