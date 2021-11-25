" Clear autocmds
autocmd!

" Install automatically Plug, if not already there.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
  " QOL plugins.

  " Better delimiters.
  Plug 'tpope/vim-surround'
  " Better dot repetition
  Plug 'tpope/vim-repeat'
  " Load per-project vimrc
  Plug 'embear/vim-localvimrc'
  " Toggle paste mode automatically.
  Plug 'roxma/vim-paste-easy'
  " Open vim at a specific line.
  Plug 'bogado/file-line'
  " Diffed lines in vim.
  Plug 'mhinz/vim-signify'
  " Swap function arguments with <, and >,
  " New text objects a, and i,
  Plug 'PeterRincker/vim-argumentative'
  " Replace with case.
  Plug 'tpope/vim-abolish'
  " Spellcheck with CamlCase support.
  Plug 'kamykn/spelunker.vim'

  " Language-specific support.

  "Plug 'rust-lang/rust.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'jceb/vim-orgmode'
  Plug 'cespare/vim-toml'

  " Tools

  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'FelikZ/ctrlp-py-matcher'

  Plug 'lifepillar/vim-cheat40'

  " LSP & completion
  " Collection of common configurations for the Nvim LSP client
  Plug 'neovim/nvim-lspconfig'
  " Nicer UI.
  Plug 'tami5/lspsaga.nvim', { 'branch': 'nvim51' }

  " Completion framework
  Plug 'hrsh7th/nvim-cmp'

  " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'

  " Snippet completion source for nvim-cmp
  Plug 'hrsh7th/cmp-vsnip'

  " Other usefull completion sources
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-git'

  " To enable more of the features of rust-analyzer, such as inlay hints and more!
  Plug 'simrat39/rust-tools.nvim'

  " Snippet engine
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'rafamadriz/friendly-snippets'


  " Fuzzy finder
  " Optional
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  " Tree sitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" General vim settings

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

" Allow mouse use in vim
set mouse=a

" Briefly show matching braces, parens, etc
set showmatch

" Enable line wrapping
set wrap

" Preview window on completion
set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Ignore case on search
set ignorecase

" Ignore case unless there is an uppercase letter in the pattern
set smartcase

" Move cursor to the matched string
set incsearch

" Show the live results of a :s command
set inccommand=nosplit

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
set cinoptions=(0,W4,u0,U0,t0,g1,h1,N-s,>s

" In diff mode, open the buffers vertically, and ignore whitespace changes.
set diffopt=iwhite,vertical

" Highlight merge conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set nofoldenable

set comments=s0:/*,mb:**,ex:*/,:// " Comments

set list
set listchars=tab:>-,trail:.

set number
set signcolumn=yes

set breakindent showbreak=..
set linebreak

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

let g:netrw_banner = 0
let g:netrw_liststyle = 3
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nunmap <buffer> Th
  nunmap <buffer> Tb
  nnoremap <buffer> t j
  nnoremap <buffer> n k
  nnoremap <buffer> T 8j
  nnoremap <buffer> N 8k
  nnoremap <buffer> l n
  nnoremap <buffer> L N
  nnoremap <buffer> - $
  nnoremap <buffer> _ ^
  nnoremap <buffer> S <C-w>w
  nnoremap <buffer> H <C-w>r
endfunction

color desert

" Spellcheck highlighting
augroup my_colors
  autocmd!
  autocmd ColorScheme desert hi clear SpellBad
  autocmd ColorScheme desert hi SpellBad cterm=underline ctermfg=red
  autocmd ColorScheme desert hi SpelunkerSpellBad cterm=underline ctermfg=red
  autocmd ColorScheme desert hi SpelunkerComplexOrCompoundWord cterm=underline ctermfg=NONE
augroup END

" Autocmd, per language

autocmd Filetype c,cpp set comments^=:///\ ,://\ ,fb:-

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

function! s:insert_python()
  execute "normal! i#! /usr/bin/env python\n\n"
  set softtabstop=4
  set shiftwidth=4
endfunction
autocmd BufNewFile *.py call <SID>insert_python()


" Mappings & commands

" Set "," as map leader
let mapleader = ","

" 'very magic' regexp searches
nnoremap / /\v
nnoremap ? ?\v

nnoremap U <C-R>

" Ctrl-Backspace deletes a word.
inoremap <C-H> <C-W>


" 'very magic' regexp substitutions
cnoremap %s %s/\v

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
" Fast move up/down
no T 8<Down>
no N 8<Up>
" Switch between splits
no S <C-w>w
no H <C-w>r

" For extra capital letter
command! W w
command! Q q
command! Qa qa
command! Wq wq
command! WQ wq

" Yank from cursor to end of line, to be consistent with C and D
nnoremap Y y$
" Yank relative file path.
nnoremap <silent> yf :let @"=@%<CR>


" map ; to :
noremap ; :

cab reload source ~/.vimrc

" tab settings
nnoremap <silent> <C-H> :tabprevious<CR>
nnoremap <silent> <C-S> :tabnext<CR>
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
noremap <C-T> :silent call MoveToPrevTab()<CR>
noremap <C-N> :silent call MoveToNextTab()<CR>

nnoremap <Space> i<Space><Esc>

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

" Plugin configs

" Localvimrc

let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0

" Ctrl-P

let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'raw'
let g:ctrlp_root_markers = ['.vimrc', 'google3', '.git', '.hg']
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_switch_buffer = 'EV'
let g:ctrlp_clear_cache_on_exit = 0


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
      \ 'PrtDeleteWord()':      ['<c-H>'],
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

" LSP

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
require'lspconfig'.clangd.setup{}
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_prev_item(),
    ['<C-t>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-c>'] = cmp.mapping.scroll_docs(-4),
    ['<C-w>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = "cmp_git" },
    { name = "cmdline" },
  },
})

require("cmp_git").setup({
    -- defaults
    filetypes = { "gitcommit" },
    github = {
        issues = {
            filter = "all", -- assigned, created, mentioned, subscribed, all, repos
            limit = 100,
            state = "open", -- open, closed, all
        },
        mentions = {
            limit = 100,
        },
    },
    gitlab = {
        issues = {
            limit = 100,
            state = "opened", -- opened, closed, all
        },
        mentions = {
            limit = 100,
        },
        merge_requests = {
            limit = 100,
            state = "opened", -- opened, closed, locked, merged
        },
    },
})
EOF

" LSP saga config
lua <<EOF
local saga = require 'lspsaga'
saga.init_lsp_saga {
  finder_action_keys = {
    open = '<CR>',
    vsplit = 's',
    quit = 'q',
    scroll_down = '<c-w>',
    scroll_up = '<c-c>'
  },
  code_action_prompt = {
    enable = false,
  },
}
EOF

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-w> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(4)<CR>
" scroll up hover doc
nnoremap <silent> <C-c> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-4)<CR>
nnoremap <silent> <c-k> <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
"nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gh    <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent><leader>a    <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>a :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent><c-r> <cmd>lua require('lspsaga.rename').rename()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * :Lspsaga show_line_diagnostics

nnoremap <silent><leader>d <cmd>Lspsaga show_line_diagnostics<CR>
" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> g] <cmd>Lspsaga diagnostic_jump_prev<CR>

" Show/hide float terminal
nnoremap <silent> <leader>g <cmd>lua require('lspsaga.floaterm').open_float_terminal('lazygit')<CR>
tnoremap <silent> <leader>g <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>

autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)


" VSnip

imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" vim-cheat40
let g:cheat40_use_default = 0


" Treesitter

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "rust", "cpp", "c" },
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "g]",
      node_decremental = "g[",
    },
  },
}
EOF

" Spelunker

" Only check words currently displayed
let g:spelunker_check_type = 1
" Highlight only SpellBad
let g:spelunker_highlight_type = 2
let g:spelunker_disable_uri_checking = 1
let g:spelunker_disable_backquoted_checking = 1
let g:spelunker_white_list_for_user = ['args', 'kwargs']
" Disable email-like words checking. (default: 0)
let g:spelunker_disable_email_checking = 1
" Disable account name checking. (default: 0)
let g:spelunker_disable_account_name_checking = 1
let g:spelunker_disable_acronym_checking = 1

autocmd TermOpen * :let b:enable_spelunker_vim = 0
