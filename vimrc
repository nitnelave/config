autocmd!

if !exists('g:pathogen_disabled')
  let g:pathogen_disabled = []
endif

execute pathogen#infect()

" Disable vi compatibility mode
set nocompatible

" Enable filetype detection for plugins and indentation options
filetype plugin indent on

" Reload a file when it is changed from the outside
set autoread

" Write the file when we leave the buffer
set autowrite

set nobackup

" Don't hide buffers instead of closing them
set nohidden

" Set the time (in milliseconds) spent idle until various actions occur
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
set statusline=%f\ %l\|%c\ %m\ %#warningmsg#%*%=%p%%\ (%Y%R)

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
set cinoptions=(0,u0,U0,t0,g1,h1,N-s,>s

set comments=s0:/*,mb:**,ex:*/,://	" Comments
" Set "," as map leader
let mapleader = ","

" 'very magic' regexp searches
nnoremap / /\v
nnoremap ? ?\v

nnoremap U <C-R>

" 'very magic' regexp substitutions
cnoremap %s %s/\v

" Toggle paste mode
noremap <leader>pp :setlocal paste!<cr>

xnoremap p "_dP

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

" For extra capital letter
command! W w
command! Q q
command! Qa qa
command! Wq wq
command! WQ wq


" Yank from cursor to end of line, to be consistent with C and D
nnoremap Y y$


" map ; to :
noremap ; :

cab reload source ~/.vimrc

no Z z=1<CR>]s

let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir
if has('persistent_undo')
  let myUndoDir = expand(vimDir . '/undo')
  silent call system('mkdir -p ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
  set undolevels=1000
  set undoreload=100000
endif

autocmd BufNewFile,BufRead *.{c,cc,h,hh,hxx,hpp,cpp,md,fr,en,txt} : set tw=79
autocmd BufNewFile,BufRead *.{java} : set tw=119

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
cab tn tabnew

nnoremap <Space> i<Space><Esc>


autocmd BufWritePre * if &ft!="markdown"|:%s/\v\s+$//e|endif
autocmd BufWritePre .{article,letter,followup} :%s/\v^--$/-- /e
autocmd BufWritePre /tmp/mutt-* :%s/\v^--$/-- /e


augroup Guards
autocmd BufNewFile *.{h,hh,hpp} execute "normal! i#pragma once \n\n"
augroup END

function! s:insert_shebang()
  execute "normal! i#! /bin/sh\n\n"
endfunction
autocmd BufNewFile *.sh call <SID>insert_shebang()

set list
set listchars=tab:>-,trail:.

set number

function! s:insert_python()
  execute "normal! i#! /usr/bin/env python\n\n"
  set softtabstop=4
  set shiftwidth=4
endfunction
autocmd BufNewFile *.py call <SID>insert_python()

function! s:format_text()
  execute "%s/\|-\>/└─>/ge"
  execute "%s/\\v( *)  - /\\1└─> /ge"
  execute "%s/-\>/=>/ge"
  syntax off
endfunction
autocmd BufWritePre *.{fr,en} call <SID>format_text()
autocmd BufEnter *.{fr,en} call <SID>format_text()


function! g:FromPDF()
  execute "%s/ ::/::/ge"
  execute "%s/:: /::/ge"
  execute "%s/ ;/;/ge"
  execute "%s/ (/(/ge"
  execute "%s/( /(/ge"
  execute "%s/ )/)/ge"
  execute "%s/) /)/ge"
  execute "%s/< /</ge"
  execute "%s/ >/>/ge"
  execute "%s/> />/ge"
  execute "%s/ ,/,/ge"
  execute "%s/ :/:/ge"
  execute "%s/operator /operator/ge"
  execute "%s/)const/) const/ge"
  execute "%s/\\\v \\\&/\\\&/ge"
  execute "g/\\\v\\\s*[0-9]+$/d"
  normal! gg=G
endfunction

cab fpdf call g:FromPDF()

set nofoldenable

autocmd BufNewFile,BufRead *.en : set spell spelllang=en_us
autocmd BufNewFile,BufRead *.fr : set spell spelllang=fr
autocmd BufNewFile,BufRead *tolmer.fr : set nospell

if filereadable("~/.vim/plugin/RainbowParenthesis.vim")
  source ~/.vim/plugin/RainbowParenthesis.vim
endif

function! g:AccentsToLatex()
  execute "'<,'>s/é/\\\\'e/e"
  execute "'<,'>s/è/\\\\`e/e"
  execute "'<,'>s/ê/\\\\^e/e"
  execute "'<,'>s/î/\\\\^i/e"
  execute "'<,'>s/à/\\\\`a/e"
  execute "'<,'>s/â/\\\\^a/e"
  execute "'<,'>s/û/\\\\^u/e"
  execute "'<,'>s/ä/\\\\\"a/e"
  execute "'<,'>s/ü/\\\\\"u/e"
  execute "'<,'>s/ë/\\\\\"e/e"
  execute "'<,'>s/ï/\\\\\"i/e"
  execute "'<,'>s/ç/\\\\c{c}/e"
  execute "'<,'>s/\%/\\\\%/e"
endfunction

cab accents call g:AccentsToLatex()

" LatexBox

let g:LatexBox_latexmk_options = "-pvc -pdfps"
au FileType * exec("setlocal dictionary+=".$HOME."/.vim/dictionaries/".expand('<amatch>'))
set complete+=k

" Localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" YouCompleteMe

let g:ycm_confirm_extra_conf = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>', '<C-PageUp>']
let g:ycm_rust_src_path = '~/.vim/bundle/YouCompleteMe/rust'
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
if !exists('g:ycm_global_ycm_extra_conf')
  let g:ycm_global_ycm_extra_conf = '/home/nitnelave/.vim/.ycm_extra_conf.py'
endif
if has("patch-7.4.314")
    set shortmess+=c
endif

nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <C-f> :YcmCompleter FixIt<CR>
nnoremap <C-y>f :YcmCompleter FixIt<CR>
nnoremap <C-y>h :YcmCompleter GoToInclude<CR>
nnoremap <C-y>g :YcmCompleter GoTo<CR>
nnoremap <C-y>i :YcmCompleter GoToDefinition<CR>
nnoremap <C-y>d :YcmCompleter GoToDeclaration<CR>
nnoremap <C-y>t :YcmCompleter GetType<CR>
nnoremap <C-y>n :YcmCompleter RefactorRename<CR>

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Ctrl-P
nnoremap ,b :CtrlPBuffer<CR>
let g:ctrlp_working_path_mode = 'raw'
let g:ctrlp_default_input = 1
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_root_markers = ['.vimrc', 'google3', '.git']
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = 'vj'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_switch_buffer = 'EV'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_default_input = ''



let g:ctrlp_prompt_mappings = {
      \ 'PrtSelectMove("j")':   ['<c-t>', '<down>'],
      \ 'PrtSelectMove("k")':   ['<c-n>', '<up>'],
      \ 'PrtCurStart()':        ['<c-a>', '<Home>', '<kHome>'],
      \ 'PrtCurEnd()':          ['<c-e>', '<End>', '<kEnd>'],
      \ 'PrtHistory(-1)':       ['<c-c>'],
      \ 'PrtHistory(1)':        ['<c-w>'],
      \ 'PrtCurLeft()':         ['<left>', '<c-^>'],
      \ 'AcceptSelection("h")': ['<c-x>', '<c-cr>'],
      \ 'AcceptSelection("t")': [],
      \ 'PrtDeleteWord()':      ['<c-g>'],
      \ 'PrtExit()':            ['<esc>'],
      \ }


if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
        \ --ignore .git
        \ --ignore .svn
        \ --ignore .hg
        \ --ignore .DS_Store
        \ --ignore "**/*.pyc"
        \ --ignore .git5_specs
        \ --ignore review
        \ -g ""'
endif
