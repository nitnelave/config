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
set softtabstop=4

" The number of spaces inserted/removed when using < or >
set shiftwidth=4

" Insert spaces instead of tabs
set expandtab

" When tabbing manually, use shiftwidth instead of tabstop and softtabstop
set smarttab

" Set basic indenting (i.e. copy the indentation of the previous line)
" When filetype detection didn't find a fancy indentation scheme
set autoindent

" This one is complicated. See :help cinoptions-values for details
set cinoptions=(0,u0,U0,t0,g0,N-s,>s

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
command W w
command Q q
command Qa qa
command Wq wq
command WQ wq

nmap <F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files<CR>
  \:!cscope -b -i cscope.files -f cscope.out<CR>
  \:cs reset<CR>

noremap cs cl

" VCSN

map <c-y> 0df:dwi* <Esc>A: Here.<Esc>t0
vmap <c-y> :normal <c-y><CR>

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

" Enter remap
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>
nnoremap <CR> o<Esc>
nnoremap <Space> i<Space><Esc>


nnoremap <C-R> "_diwP

autocmd BufWritePre * if &ft!="markdown"|:%s/\v\s+$//e|endif
autocmd BufWritePre .{article,letter,followup} :%s/\v^--$/-- /e
autocmd BufWritePre /tmp/mutt-* :%s/\v^--$/-- /e

"highlight over80 ctermbg=red
"autocmd BufReadPre *.{c,cc,h,hh,cpp,hxx} match over80 /\%80v.\+/


augroup Guards
autocmd BufNewFile *.{h,hh,hpp} execute "normal! i#pragma once \n\n"
augroup END

function! s:insert_shebang()
  execute "normal! i#! /bin/sh\n\n"
endfunction
autocmd BufNewFile *.sh call <SID>insert_shebang()

function! s:insert_include()
  if expand("%:t") != "test.cc" && expand("%:t") != "main.cc"
      execute "normal! i#include \"" . substitute(substitute(expand("%:t"), "\\.cc$", ".hh", ""), "\\.c$", ".h", "") . "\"\n\n"
  endif
endfunction
autocmd BufNewFile *.{c,cc} call <SID>insert_include()

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

let g:languagetool_jar='$HOME/.vim/LanguageTool/languagetool-commandline.jar'

autocmd BufNewFile,BufRead *.en : set spell spelllang=en_us
autocmd BufNewFile,BufRead *.fr : set spell spelllang=fr
autocmd BufNewFile,BufRead *tolmer.fr : set nospell

" Syntastic

highlight SyntasticErrorSign guifg=white ctermbg=black
highlight SyntasticError gui=underline ctermbg=black
highlight SyntasticErrorLine gui=underline ctermbg=black
let g:syntastic_check_on_open = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_loc_list = 1
" let g:syntastic_stl_format = '[%E{Err(%e): %fe}%B{, }%W{Warn(%w): %fw}]'
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': [] }


let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_remove_include_errors = 0
let g:syntastic_cpp_config_file = ".syntastic_config"
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_cpp_checkers = [ 'gcc', 'moulinette' ]

let g:syntastic_c_check_header = 1
let g:syntastic_c_remove_include_errors = 1
let g:syntastic_c_config_file = ".syntastic_config"
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_checkers = [ 'gcc', 'moulinette' ]

noremap <C-W> :lnext<CR>
noremap <C-C> :lprev<CR>

command! Moulinette let b:moulinette_ignore=0
command! NoMoulinette let b:moulinette_ignore=1
cab mou Moulinette
cab nomou NoMoulinette
let b:moulinette_ignore=1

command! Complete let b:complete_ignore=0
command! NoComplete let b:complete_ignore=1
cab comp Complete
cab nocomp NoComplete


" Project

let g:proj_flags = "cgist"

let g:proj_window_width = 40

" Fugitive

cab gci Gcommit
cab gdi Gdiff
cab gbl Gblame
cab grm Gremove
cab git Git
cab ged Gedit
cab gsp Gsplit
cab gvs Gvsplit

" Doxygen toolkit

let g:DoxygenToolkit_startCommentTag	= "/**"
let g:DoxygenToolkit_interCommentTag	= "** "
let g:DoxygenToolkit_briefTag_pre	= "@brief "
let g:DoxygenToolkit_paramTag_pre	= "@param "
let g:DoxygenToolkit_returnTag	= "@return "
let g:DoxygenToolkit_fileTag		= "@file "
let g:DoxygenToolkit_authorTag	= "@author "
let g:DoxygenToolkit_dateTag		= "@date "
let g:DoxygenToolkit_blockTag		= "@name "
let g:DoxygenToolkit_classTag		= "@class "
let g:DoxygenToolkit_cinoptions	= "c0,C1"

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

au BufRead /tmp/mutt-* set tw=72

" LatexBox

let g:LatexBox_latexmk_options = "-pvc -pdfps"
au FileType * exec("setlocal dictionary+=".$HOME."/.vim/dictionaries/".expand('<amatch>'))
set complete+=k

" Ctrl-P

let g:ctrlp_tabpage_position = 'ca'
let g:ctrlp_root_markers = ['.vimrc']
let g:ctrlp_max_depth = 10
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = 'vj'

noremap <C-e> <C-p>

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" YouCompleteMe

let g:ycm_confirm_extra_conf = 0
let g:ycm_server_keep_logfiles = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_filepath_completion_use_working_dir = 1
if !exists('g:ycm_global_ycm_extra_conf')
  let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
endif
if has("patch-7.4.314")
    set shortmess+=c
endif

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
