" vimrc by Chunjun Li
" Last Update: 2020-01-17

"------------------------------------------------------
" 插件列表
"------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'clones/vim-genutils'  " 通用函数
Plug 'Yggdroot/indentLine'  " 缩进线
Plug 'scrooloose/nerdtree'  " 右边目录树
Plug 'scrooloose/nerdcommenter'  " 注释
Plug 'jlanzarotta/bufexplorer'   " 缓冲区浏览器
Plug 'neoclide/coc.nvim', {'branch': 'release'}	"  自动补全插件
Plug 'luochen1990/rainbow'  " 彩色括号
Plug 'vim-scripts/taglist.vim'  " 左边标签列表
Plug 'mhinz/vim-signify', { 'branch': 'legacy' }  "Git,Svn管理
Plug 'itchyny/lightline.vim'  " 状态栏
Plug 'vim-scripts/a.vim'  " .h/.c 切换

call plug#end()

"------------------------------------------------------
" 配置项
"------------------------------------------------------
let mapleader = ";"    " 比较习惯用;作为命令前缀，右手小拇指直接能按到
" 把空格键映射成:
nmap <space> :
" 快捷打开编辑vimrc文件的键盘绑定
map <silent> <leader>ee :e $HOME/.vimrc<cr>
autocmd! bufwritepost *.vimrc source $HOME/.vimrc
" ^z快速进入shell
nmap <C-Z> :shell<cr>
" 判断操作系统
if (has("win32") || has("win64") || has("win32unix"))
    let g:isWin = 1
else
    let g:isWin = 0
endif
" 判断是终端还是gvim
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
set nocompatible    " 关闭兼容模式
syntax enable       " 语法高亮
filetype plugin on  " 文件类型插件
filetype indent on
set autoindent
autocmd BufEnter * :syntax sync fromstart
set nu              " 显示行号
set showcmd         " 显示命令
set lz              " 当运行宏时，在命令执行完成之前，不重绘屏幕
set hid             " 可以在没有保存的情况下切换buffer
set backspace=eol,start,indent
set whichwrap+=<,>,h,l " 退格键和方向键可以换行
set incsearch       " 增量式搜索
set hlsearch        " 高亮搜索
" set ignorecase      " 搜索时忽略大小写
set magic           " 额，自己:h magic吧，一行很难解释
set showmatch       " 显示匹配的括号
set nobackup        " 关闭备份
set nowb
set noswapfile      " 不使用swp文件，注意，错误退出后无法恢复
set lbr             " 在breakat字符处而不是最后一个字符处断行
set ai              " 自动缩进
set si              " 智能缩进
set cindent         " C/C++风格缩进
set wildmenu
set nofen
set fdl=10
" tab转化为4个字符
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
" 不使用beep或flash
set vb t_vb=
set background=dark
colorscheme desert
set t_Co=256
set history=20   " vim记住的历史操作的数量，默认的是20
set autoread     " 当文件在外部被修改时，自动重新读取
set mouse=a      " 在所有模式下都允许使用鼠标，还可以是n,v,i,c等
"在gvim中高亮当前行
if (g:isGUI)
    set cursorline
    hi cursorline guibg=#333333
    hi CursorColumn guibg=#333333
    set guifont=Consolas\ 14
    set guifontwide=Consolas\ 14
endif
" 设置字符集编码，默认使用utf8
if (g:isWin)
    let &termencoding=&encoding " 通常win下的encoding为cp936
    set fileencodings=utf8,cp936,ucs-bom,latin1
else
    set encoding=utf8
    set fileencodings=utf8,gb2312,gb18030,ucs-bom,latin1
endif
" 状态栏
set laststatus=2      " 总是显示状态栏
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 代码折叠
set foldmethod=manual

" 第100列往后加下划线
"au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 120 . 'v.\+', -1)

" 根据给定方向搜索当前光标下的单词，结合下面两个绑定使用
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n{1}quot;, "", "")
    if a:direction == 'b'
        execute "normal ?" . l:pattern . "<cr>"
    else
        execute "normal /" . l:pattern . "<cr>"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" 用 */# 向 前/后 搜索光标下的单词
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" 在文件名上按gf时，在新的tab中打开

" 用c-j,k在buffer之间切换
nn <C-J> :bn<cr>
nn <C-K> :bp<cr>
nn <C-H> :b1<cr>

"--------------------------------------------------------
" 恢复上次文件打开位置
"--------------------------------------------------------
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost if line("'\"") > 0|if line("'\"") <= line("{1}quot;)|exe("norm '\"")|else|exe "norm {1}quot;|endif|endif
" 删除buffer时不关闭窗口
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")
    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif
    if bufnr("%") == l:currentBufNum
        new
    endif
    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

highlight PMenu ctermfg=40 ctermbg=0
highlight PMenuSel ctermfg=0 ctermbg=4

"--------------------------------------------------------
" 显示优化
"--------------------------------------------------------
"如果行尾有多余的空格(包括 Tab 键),该配置将让这些空格显示成可见的小方块
set listchars=tab:»■,trail:■
set list

"出错时，发出视觉提示，通常是屏幕闪烁
set visualbell

"保留撤销历史
"set undofile

" 光标所在的当前行高亮
set cursorline
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
highlight CocHighlightText cterm=NONE ctermbg=yellow ctermfg=black guibg=NONE guifg=NONE

"--------------------------------------------------------
" 缩写
"--------------------------------------------------------
iab idate <c-r>=strftime("%Y-%m-%d")<CR>
iab itime <c-r>=strftime("%H:%M")<CR>
iab idatetime <c-r>=strftime("%Y-%m-%d %H:%M")<CR>
iab iname Chunjun Li
iab imail chunjun.li@aqara.com
iab iauth Chunjun Li <chunjun.li@aqara.com>
iab ifile <C-R>=expand("%:t")<CR>

let s:PlugWinSize = 30

"--------------------------------------------------------
" Taglist.vim
"--------------------------------------------------------
nmap <silent> <leader>t :TlistToggle<cr>
" let g:showfuncctagsbin = '/home/lichunjun/bin/ctags'
let Tlist_Show_One_File = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 0
let Tlist_File_Fold_Auto_Close = 1
let Tlist_GainFocus_On_ToggleOpen = 0
let Tlist_WinWidth = s:PlugWinSize
let Tlist_Auto_Open = 0
let Tlist_Display_Prototype = 0
"let Tlist_Close_On_Select = 1

"--------------------------------------------------------
" NERD_commenter.vim
"--------------------------------------------------------
" http://www.vim.org/scripts/script.php?script_id=1218
" Toggle单行注释/“性感”注释/注释到行尾/取消注释
map <leader>cc ,c<space>
map <leader>cs ,cs
map <leader>c$ ,c$

"--------------------------------------------------------
" NERD tree
"--------------------------------------------------------
let NERDTreeShowHidden = 1
let NERDTreeWinPos = "right"
let NERDTreeWinSize = s:PlugWinSize
nmap <leader>n :NERDTreeToggle<cr>

"--------------------------------------------------------
" 更新ctags和cscope索引
"--------------------------------------------------------
map <c-\> :call ReflashTagsAndCscope()<cr>
function! ReflashTagsAndCscope()
    let dir = getcwd()
    silent! execute "!rm -f ./tags ./cscope.*"
    if(executable('ctags'))
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:isWin)
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        else
            silent! execute "!find . -iname '*.[ch]' -o -name '*.cpp' > cscope.files"
        endif
        silent! execute "!cscope -bkq"
        silent! execute "!rm cscope.files"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
    " 刷新屏幕
    execute "redr!"
endfunction

"--------------------------------------------------------
" cscope 绑定
"--------------------------------------------------------
if has("cscope")
    set csto=1
    set cst
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    set csverb
    nmap <leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fe :cs find e <C-R>=expand("<cword>")<CR>
    nmap <leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>fi :cs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>fz :cs find i <C-R>=expand("%:t")<CR><CR>
    nmap <leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>
    " split horizontally, with search result displayed in
    " the new window.
    nmap <leader>fhs :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fhg :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fhc :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fht :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fhe :scs find e <C-R>=expand("<cword>")<CR>
    nmap <leader>fhf :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>fhi :scs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>fhz :scs find i <C-R>=expand("%:t")<CR><CR>
    nmap <leader>fhd :scs find d <C-R>=expand("<cword>")<CR><CR>
    " split instead of a horizontal one
    nmap <leader>fvs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fvg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fvc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fvt :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>fve :vert scs find e <C-R>=expand("<cword>")<CR>
    nmap <leader>fvi :vert scs find i <C-R>=expand("<cfile>")<CR><CR>
    nmap <leader>fvz :vert scs find i <C-R>=expand("%:t")<CR><CR>
    nmap <leader>fvd :vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif

"--------------------------------------------------------
" Buffers Explorer （需要genutils.vim）
"--------------------------------------------------------
" http://vim.sourceforge.net/scripts/script.php?script_id=42
" http://www.vim.org/scripts/script.php?script_id=197
let g:bufExplorerDefaultHelp=0       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = s:PlugWinSize  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
autocmd BufWinEnter \[Buf\ List\] setl nonumber
nmap <silent> <leader>b :BufExplorer<CR>

"--------------------------------------------------------
" Ctags
"--------------------------------------------------------
nmap <leader>; :tag <C-R>=expand("<cword>")<CR><CR>
nmap <leader>[ :tp<CR>
nmap <leader>] :tn<CR>
nmap <silent> <leader>f :let @f=expand("%")<CR>

"--------------------------------------------------------
" multi language
"--------------------------------------------------------
set termencoding=utf-8
set encoding=utf-8

"----------------------------------------------------
" indentLine
"----------------------------------------------------
let g:indentLine_enabled = 1
let g:indent_guides_guide_size = 1  " 指定对齐线的尺寸
let g:indent_guides_start_level = 2  " 从第二层开始可视化显示缩进

"----------------------------------------------------
" Rainbow
"----------------------------------------------------
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\   'ctermfgs': ['lightyellow', 'lightcyan','lightblue', 'lightmagenta'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['darkorange3', 'seagreen3', 'royalblue3', 'firebrick'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\   }
\}

"--------------------------------------------------------
" lightline.vim; 
"--------------------------------------------------------
let g:lightline = { 'colorscheme': 'wombat' }

"--------------------------------------------------------
" coc.nvim; 补全器的配置
"--------------------------------------------------------

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"--------------------------------------------------------
" END
"--------------------------------------------------------
