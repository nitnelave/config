" Disable vi compatibility mode
set nocompatible

" Enable filetype detection for plugins and indentation options
filetype plugin indent on

" Reload a file when it is changed from the outside
set autoread

" Write the file when we leave the buffer
set autowrite

set nobackup

" Hide buffers instead of closing them
set hidden

" Set the time (in milliseconds) spent idle until various actions occur
" In this configuration, it is particularly useful for the tagbar plugin
set updatetime=500

" Make backspace behave as expected
set backspace=eol,indent,start

" Set the minimal amount of lignes under and above the cursor
" Useful for keeping context when moving with j/k
set scrolloff=5

" Show current mode
set showmode

" Show command being executed
set showcmd

" Show line number
set number

" Always show status line
set laststatus=2

" Format the status line
set statusline=%f\ %l\|%c\ %m%=%p%%\ (%Y%R)

" Enhance command line completion
set wildmenu

" Set completion behavior, see :help wildmode for details
set wildmode=list:longest:full

" Disable bell completely
set visualbell
set t_vb=

" Enables syntax highlighting
syntax on

" Enable Doxygen highlighting
let g:load_doxygen_syntax=1

" Use a slightly darker background color to differentiate with the status line
let g:jellybeans_background_color_256='232'

" Feel free to switch to another colorscheme
colorscheme desert

" Allow mouse use in vim
set mouse=a

" Briefly show matching braces, parens, etc
set showmatch

" Enable line wrapping
set wrap

" Wrap on column 80
set textwidth=79

" Preview window on completion
set completeopt=menu,longest

" Ignore case on search
set ignorecase

" Ignore case unless there is an uppercase letter in the pattern
set smartcase

" Move cursor to the matched string
set incsearch

" Don't highlight matched strings
set nohlsearch

" Toggle g option by default on substition
set gdefault

" The length of a tab
set tabstop=8

" The number of spaces inserted when you press tab
set softtabstop=2

" The number of spaces inserted/removed when using < or >
set shiftwidth=2

" Insert spaces instead of tabs
set expandtab

" When tabbing manually, use shiftwidth instead of tabstop and softtabstop
set smarttab

" Set basic indenting (i.e. copy the indentation of the previous line)
" When filetype detection didn't find a fancy indentation scheme
set autoindent

" This one is complicated. See :help cinoptions-values for details
set cinoptions=(0,u0,U0,t0,g0,N-s,>s

" Set "," as map leader
let mapleader = ","

" 'very magic' regexp searches
nnoremap / /\v
nnoremap ? ?\v

" 'very magic' regexp substitutions
cnoremap %s %s/\v

" Toggle paste mode
noremap <leader>pp :setlocal paste!<cr>

" Dvorak mappings
" Move between rows in wrapped lines
no t gj
no n gk
no s l
no l n
no L N
" end of line
no - $
no _ ^
" change window
no S <C-w><C-w>
" Fast move up/down
no T 8<Down>
no N 8<Up>
" Move window
no H <C-w><C-r>

imap <C-Space> <C-n>

nmap <F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
  \:!cscope -b -i cscope.files -f cscope.out<CR>
  \:cs reset<CR>

" Yank from cursor to end of line, to be consistent with C and D
nnoremap Y y$


" map ; to :
noremap ; :

" tab settings
noremap <silent> <C-H> :tabprevious<CR>
noremap <silent> <C-S> :tabnext<CR>
inoremap <silent> <C-H> <Esc>:tabprevious<CR>
inoremap <silent> <C-S> <Esc>:tabnext<CR>
function! MoveToPrevTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    vsp
  else
    close!
    exe "0tabnew"
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! MoveToNextTab()
  "there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  "preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  "opening current buffer in new window
  exe "b".l:cur_buf
endfunc
noremap <C-T> :call MoveToPrevTab()<CR>
noremap <C-N> :call MoveToNextTab()<CR>
inoremap <C-T> <Esc>:call MoveToPrevTab()<CR>
inoremap <C-N> <Esc>:call MoveToNextTab()<CR>
cab tn tabnew

" Enter remap
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>
nnoremap <CR> o<Esc>

autocmd BufWritePre * :%s/\v\s+$//e
autocmd BufWritePre .article :%s/\v^--$/-- /e

highlight over80 ctermbg=red
match over80 '\%>80v.*'

function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g") . "_"
  execute "normal! i#ifndef " . gatename
  execute "normal! o# define " . gatename . "\n\n\n"
  execute "normal! Go#endif /* !" . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

function! s:insert_shebang()
  execute "normal! i#! /bin/sh\n\n"
endfunction
autocmd BufNewFile *.sh call <SID>insert_shebang()

function! s:insert_include()
  execute "normal! i#include \"" . substitute(expand("%:t"), "\\.c$", ".h", "") . "\"\n\n"
endfunction
autocmd BufNewFile *.c call <SID>insert_include()

set list
set listchars=tab:\ \ ,trail:.

function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-l> :call NumberToggle()<cr>

set relativenumber

autocmd BufLeave * : set norelativenumber
autocmd BufLeave * : set number
autocmd BufEnter * : set relativenumber

autocmd InsertEnter * : set norelativenumber
autocmd InsertEnter * : set number
autocmd InsertLeave * : set relativenumber

function! s:insert_python()
  execute "normal! i#! env python\n\n"
  set softtabstop=4
  set shiftwidth=4
endfunction
autocmd BufNewFile *.py call <SID>insert_python()

function! s:format_text()
  execute "%s/\|-\>/└─>/ge"
  execute "%s/\\v( *)  - /\\1└─> /ge"
  execute "%s/-\>/=>/ge"
endfunction
autocmd BufWritePre *.fr call <SID>format_text()
autocmd BufWritePre *.en call <SID>format_text()




let g:languagetool_jar='$HOME/.vim/LanguageTool/languagetool-commandline.jar'

autocmd BufEnter *.en : set spell spelllang=en_us
autocmd BufEnter *.fr : set spell spelllang=fr
autocmd BufLeave *.en : set nospell
autocmd BufLeave *.fr : set nospell
