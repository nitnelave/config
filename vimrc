" Clear autocmds
autocmd!

" Disable NetRW.
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

lua <<EOF
function is_ht()
   local f=io.open('/usr/local/ht-clang-17-0-1/bin/clangd',"r")
   if f~=nil then
     io.close(f)
     return true
   end
   return false
end
EOF

" Install automatically Plug, if not already there.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if luaeval("is_ht()") && empty(glob('~/.config/nvim/jdtls/1.15.0'))
  silent !curl -fLo '/tmp/jdt-language-server-1.15.0-202208220516.tar.gz' --create-dirs
    \ 'https://download.eclipse.org/jdtls/snapshots/jdt-language-server-1.15.0-202208220516.tar.gz'
  silent !mkdir -p ~/.config/nvim/jdtls/1.15.0
  silent !tar xvzf /tmp/jdt-language-server-1.15.0-202208220516.tar.gz --directory ~/.config/nvim/jdtls/1.15.0
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
  " Unix commands on the current file, :Move and :Mkdir
  Plug 'tpope/vim-eunuch'

  " Language-specific support.

  "Plug 'rust-lang/rust.vim'
  Plug 'leafgarland/typescript-vim'
  Plug 'jceb/vim-orgmode'
  Plug 'cespare/vim-toml'

  " Tools

  Plug 'lifepillar/vim-cheat40'

  " for icons
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'

  " LSP & completion
  " Collection of common configurations for the Nvim LSP client
  Plug 'neovim/nvim-lspconfig'
  if luaeval("is_ht()")
    " Java support
    Plug 'mfussenegger/nvim-jdtls'
  endif
  " Nicer UI
  Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
  Plug 'ray-x/navigator.lua'
  Plug 'ray-x/lsp_signature.nvim'
  " LSP status
  Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }
   " Clangd inlay hints and more.
  Plug 'p00f/clangd_extensions.nvim'

  " Completion framework
  Plug 'hrsh7th/nvim-cmp'

  " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'

  " Snippet completion source for nvim-cmp
  Plug 'hrsh7th/cmp-vsnip'

  " Other useful completion sources
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-git'

  " Dependency for refactoring and null-ls.
  Plug 'nvim-lua/plenary.nvim'
  " Refactoring
  Plug 'ThePrimeagen/refactoring.nvim'

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
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'nvim-telescope/telescope-live-grep-args.nvim'

  " Tree sitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-context'

  " Bulk rename files
  Plug 'qpkorr/vim-renamer'

  " Git sessions
  Plug 'wting/gitsessions.vim'

  " Git sessions
  Plug 'tpope/vim-fugitive'

  " Close hidden buffers
  Plug 'kazhala/close-buffers.nvim'

  " Theme
  Plug 'sonph/onehalf', { 'rtp': 'vim' }

  " Leap
  Plug 'ggandor/leap.nvim'

  " null-ls
  Plug 'jose-elias-alvarez/null-ls.nvim'

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

" Ignore case unless there is an uppercase letter in the pattern
set ignorecase
set smartcase

" Move cursor to the matched string
set incsearch

" Show the live results of a :s command
set inccommand=nosplit

" Don't highlight matched strings
set nohlsearch

" Toggle g option by default on substitution
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
" Hide the "." directory in explore mode
let g:netrw_list_hide = '^\./$'
let g:netrw_hide = 1
augroup netrw_mapping
  autocmd!
  autocmd BufNewFile,BufEnter netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  unmap! <buffer> Th
  unmap! <buffer> Tb
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

color onehalfdark

" Autocmd, per language

autocmd Filetype c,cpp set comments^=:///\ ,://\ ,fb:-

autocmd BufWritePre * if &ft!="markdown" && &ft!="diff"|:%s/\v\s+$//e|endif
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
command! Ex NvimTreeFindFileToggle
command! Vex NvimTreeFindFileToggle
command! VEX NvimTreeFindFileToggle
command! VEx NvimTreeFindFileToggle
cabbrev vex <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'NvimTreeFindFileToggle' : 'vex')<CR>
cabbrev ex <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'NvimTreeFindFileToggle' : 'ex')<CR>

" Yank from cursor to end of line, to be consistent with C and D
nnoremap Y y$
" Yank relative file path.
nnoremap <silent> yf :let @"=@%<CR>

au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=false}

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

" LSP

nnoremap <c-f> :lua vim.lsp.buf.format { async = true }<CR>

lua <<EOF
local util = require 'lspconfig.util'
function get_capabilities()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return capabilities
end
local clangd_capabilities = get_capabilities()
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = { "utf-16" }
local rust_capabilities = get_capabilities()
rust_capabilities.document_formatting = true

function clang_options()
   if is_ht() then
     return {'/usr/local/ht-clang-17-0-1/bin/clangd', '-j=40',
     '--compile-commands-dir=./build/ub-18.04-clang-17.0.1-generic.debug',
     "--background-index", "--clang-tidy", "--header-insertion=iwyu",
     "--all-scopes-completion", "--completion-style=bundled"}
   else
     return {"clangd", "--background-index", "--clang-tidy",
     "--header-insertion=iwyu", "--all-scopes-completion",
     "--completion-style=bundled"}
   end
end

require'navigator'.setup({
  default_mapping = false,  -- set to false if you will remap every key
  keymaps = {
    { key = '<c-k>', func = vim.lsp.signature_help, desc = 'signature_help' },
    { mode = 'i', key = '<c-k>', func = vim.lsp.signature_help, desc = 'signature_help' },
    { key = 'K', func = function () vim.lsp.buf.hover({ popup_opts = { border = single, max_width = 80 }}) end, desc = 'hover_doc' },
    { key = 'ga', mode = 'n', func = require('navigator.codeAction').code_action, desc = 'code_actions' },
    { key = 'ga', mode = 'v', func = vim.lsp.buf.code_action, desc = 'visual_code_actions' },
    { key = '<c-r>', func = require('navigator.rename').rename, desc = 'rename'},
    { key = 'g]', func = function () vim.diagnostic.goto_next({ border = 'rounded', max_width = 80}) end, desc = 'next diagnostic' },
    { key = 'g[', func = function () vim.diagnostic.goto_prev({ border = 'rounded', max_width = 80}) end, desc = 'prev diagnostic' },
    { key = 'gE', func = vim.diagnostic.setloclist, desc = 'diagnostics set loclist' },
    { key = 'ge', func = require('navigator.diagnostics').show_diagnostics, desc = 'show_diagnostics' },
  },
  lsp = {
    format_on_save = true,
    disable_lsp = {'bashls', 'ccls', 'clangd', 'closure_lsp', 'cssls', 'dartls',
    'denols', 'dockerls', 'dotls', 'graphql', 'intelephense',
    'kotlin_language_server', 'nimls', 'pylsp', 'sqlls',
    'sumneko_lua', 'vimls', 'vim-language-server', 'yamlls'},
    rust_analyzer = {
      root_dir = function(fname)
        return util.root_pattern("Cargo.toml", "rust-project.json", ".git")(fname)
                   or util.path.dirname(fname)
      end,
      filetypes = {"rust"},
      message_level = vim.lsp.protocol.MessageType.error,
      capabilities = rust_capabilities,
      settings = {
        ["rust-analyzer"] = {
          assist = {importMergeBehavior = "last", importPrefix = "by_self"},
          cargo = {loadOutDirsFromCheck = true},
          procMacro = {enable = true},
          checkOnSave = {
            command = "clippy",
            extraArgs = {"--target-dir", "target/rust-analyzer"},
          },
        },
      },
      flags = {allow_incremental_sync = true, debounce_text_changes = 500},
    },
    pyright = {},
  }
})

require("clangd_extensions").setup({
  inlay_hints = {
    only_current_line = false,
    show_parameter_hints = false,
    other_hints_prefix = "-> ",
  }
})

require('lspconfig').clangd.setup({
  root_dir = util.root_pattern('.git'),
  flags = {allow_incremental_sync = true, debounce_text_changes = 500},
  cmd = clang_options(),
  filetypes = {"c", "cpp", "objc", "objcpp"},
  init_options = {
    clangdFileStatus = true
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.document_formatting = true
    require('navigator.lspclient.mapping').setup({client=client, bufnr=bufnr}) -- setup navigator keymaps here,
    require("navigator.dochighlight").documentHighlight(bufnr)
    require('navigator.codeAction').code_action_prompt(bufnr)
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
    on_attach(client, bufnr)
  end,
  capabilities = clangd_capabilities
})

-- Don't open the loclist on compilation failure.
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup('delete_nvim_nv_event_autos', {}),
    desc = 'delete diagnostic update',
    callback = function()
      vim.api.nvim_create_augroup("nvim_nv_event_autos", {
          clear = true
      })
    end,
  })

if vim.o.ft == 'clap_input' or vim.o.ft == 'guihua' or vim.o.ft == 'guihua_rust' then
  require'cmp'.setup.buffer { completion = {enable = false} }
end

require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})
EOF

hi default GuihuaTextViewDark ctermfg=white ctermbg=236 cterm=NONE
hi default GuihuaListDark ctermfg=white ctermbg=236 cterm=NONE
hi default GuihuaListHl ctermfg=white ctermbg=cyan

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF

local lspkind_comparator = function(conf)
  local lsp_types = require('cmp.types').lsp
  return function(entry1, entry2)
    if entry1.source.name ~= 'nvim_lsp' then
      if entry2.source.name == 'nvim_lsp' then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end
local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

local no_text_kind = function(entry1, entry2)
  if entry1.source.name ~= 'nvim_lsp' then
    if entry2.source.name == 'nvim_lsp' then
      return false
    else
      return nil
    end
  end
  local lsp_types = require('cmp.types').lsp
  local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
  local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
  if kind1 == Text and kind2 ~= Text then
    return false
  elseif kind2 == Text and kind1 ~= Text then
    return true
  else
    return nil
  end
end

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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
    ['<C-c>'] = cmp.mapping.scroll_docs(-4),
    ['<C-w>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'buffer' },
  },
  sorting = {
    comparators = {
      no_text_kind,
      cmp.config.compare.scopes,
      cmp.config.compare.locality,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      require("clangd_extensions.cmp_scores"),
      lspkind_comparator({
        kind_priority = {
          Field = 11,
          Property = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Method = 10,
          Operator = 10,
          Reference = 10,
          Struct = 10,
          Variable = 9,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Function = 4,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Snippet = 0,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
        },
      }),
      label_comparator,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})


-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
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


hi clear LspReferenceRead
hi clear LspReferenceText
hi clear LspReferenceWrite
hi LspReferenceRead gui=underline cterm=underline
hi LspReferenceText gui=underline cterm=underline
hi LspReferenceWrite gui=underline cterm=underline

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

set nospell

" Only check words currently displayed
let g:spelunker_check_type = 2
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

" Telescope
lua <<EOF
local telescope = require "telescope"
local actions = require "telescope.actions"
local lga_actions = require("telescope-live-grep-args.actions")
local fzf_opts = {
  fuzzy = true,                    -- false will only do exact matching
  override_generic_sorter = true,  -- override the generic sorter
  override_file_sorter = true,     -- override the file sorter
  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                   -- the default case_mode is "smart_case"
}
telescope.setup {
  defaults = {
    path_display = {
      shorten = 3
    },
    cache_picker = {
      num_pickers = 10,
    },
    mappings = {
      i = {
        ["<C-t>"] = actions.move_selection_next,
        ["<C-n>"] = actions.move_selection_previous,
      },
      n = {
        ["t"] = actions.move_selection_next,
        ["n"] = actions.move_selection_previous,
        ["T"] = actions.move_to_top,
        ["N"] = actions.move_to_bottom,
        ["<C-v>"] = actions.select_vertical,
      }
    },
  },
  pickers = {
    -- Manually set sorter, for some reason not picked up automatically
    lsp_dynamic_workspace_symbols = {
      sorter = telescope.extensions.fzf.native_fzf_sorter(fzf_opts)
    },
  },
  extensions = {
    fzf = fzf_opts,
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- override default mappings
      -- default_mappings = {},
      default_mappings = {},
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          ["<C-f>"] = lga_actions.quote_prompt({ postfix = " -t " }),
        },
      },
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')
telescope.load_extension("live_grep_args")
vim.keymap.set({ "n", "v" }, "<c-g>", function()
  telescope.extensions.live_grep_args.live_grep_args({ vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--glob",
    "!test",
    "--glob",
    "!tests"} })
end)
vim.keymap.set({ "n", "v" }, "<c-a-g>", function()
  telescope.extensions.live_grep_args.live_grep_args({ vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case"} })
end)
vim.keymap.set({ "n", "v" }, "<c-x>", function()
  require("telescope.builtin").pickers()
end)
EOF
nnoremap <c-p> <cmd>Telescope git_files<cr>
"nnoremap <c-b> <cmd>Telescope buffers<cr>
nnoremap gr <cmd>Telescope lsp_references<cr>
nnoremap gi <cmd>Telescope lsp_incoming_calls<cr>
nnoremap go <cmd>Telescope lsp_outgoing_calls<cr>
nnoremap gd <cmd>Telescope lsp_definitions<cr>
nnoremap gD <cmd>Telescope lsp_implementations<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})<cr>
nnoremap <leader>fS <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})<cr>

lua <<EOF
function pickTab()
  local builtin = require("telescope.builtin")
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  builtin.buffers({
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        local bufnr = action_state.get_selected_entry().bufnr
        -- pick first window that comprises relevant buffer
        local winid = vim.tbl_filter(function(w)
          return vim.api.nvim_win_get_buf(w) == bufnr
        end, vim.api.nvim_list_wins())[1]
        local tabpage = vim.api.nvim_win_get_tabpage(winid)
        actions.close(prompt_bufnr)
        vim.api.nvim_set_current_win(winid)
      end)
      return true
    end,
  })
end
vim.api.nvim_set_keymap("n", "<c-b>", ":lua pickTab()<CR>", { noremap = true, silent = true })
EOF

" Switch source and header
nnoremap ,rh :ClangdSwitchSourceHeader<CR>
nnoremap ,rc :execute 'e' expand("%:p:h")."/CMakeLists.txt"<CR>

" Tree-sitter context
lua <<EOF
require'treesitter-context'.setup{
    enable = true,
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        rust = {
            'impl_item',
        },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
EOF
hi TreesitterContext ctermbg=236 ctermfg=white

" Leap
nnoremap f <Plug>(leap-forward)
vnoremap f <Plug>(leap-forward)
nnoremap F <Plug>(leap-backward)
vnoremap F <Plug>(leap-backward)

" Refactoring
lua <<EOF
require('refactoring').setup({
  extract_var_statements = {
    cpp = "const auto %s = %s;\n"
  }
})
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- load refactoring Telescope extension
require("telescope").load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
  "v",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { noremap = true }
)
EOF

" Nvim tree
lua <<EOF
require("nvim-tree").setup {
  view = {
    centralize_selection = true,
    hide_root_folder = true,
    width = function() return math.floor(vim.o.columns / table.getn(vim.api.nvim_tabpage_list_wins(0))) end,
    mappings = {
      custom_only = true,
      list = {
        { key = "<CR>", action = "edit_in_place" },
        { key = "<BS>", action = "close_node" },
        { key = "<C-v>", action = "vsplit" },
        { key = "<C-t>", action = "tabnew" },
        { key = "a", action = "create" },
        { key = "d", action = "remove" },
        { key = "r", action = "rename" },
        { key = "y", action = "copy_name" },
        { key = "Y", action = "copy_path" },
        { key = "-", action = "dir_up" },
        { key = "f", action = "live_filter" },
        { key = "F", action = "clear_live_filter" },
        { key = "q", action = "close" },
      },
    },
  }
}
EOF

lua require"fidget".setup{}

lua <<EOF
if vim.g.enable_null_lints == nil then
  vim.g.enable_null_lints = is_ht()
end
-- Toggle the lints. Still need to save to refresh them.
vim.api.nvim_set_keymap("n", "<leader>l", ":lua vim.g.enable_null_lints = not vim.g.enable_null_lints<CR>", {noremap = true, silent = true})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.code_actions.refactoring,
    -- pip3 install --user cmakelang
    null_ls.builtins.diagnostics.cmake_lint.with({
      extra_args = {
        "--local-var-pattern", "[A-Z][A-Z0-9_]+",
        "--argument-var-pattern", "[A-Z][A-Z0-9_]+",
        "--macro-pattern", "ht_[a-z0-9_]+",
        "--function-pattern", "ht_[a-z0-9_]+",
        "--disabled-codes", "C0113",
      },
    }),
    -- null_ls.builtins.formatting.cmake_format,
    -- cppcheck?
  }
})

local ts = vim.treesitter
local ts_utils = require 'nvim-treesitter.ts_utils'

local const_arg_query = [[
    (_
      declarator: (_
        (parameter_list
          (_
            .
            type: (_) @type
            declarator: (identifier) @id)))) @decl
]]
local const_arg_parsed_query = vim.treesitter.query.parse_query("cpp", const_arg_query)

local const_arg = {
    name = "const_arg",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "cpp" },
    generator = {
        fn = function(params)
            if not vim.g.enable_null_lints then return end
            local diagnostics = {}
            tsparser = ts.get_parser(params.bufnr, params.filetype)
            tstree = tsparser:parse()
            local root = tstree[1]:root()

            for pattern, match in const_arg_parsed_query:iter_matches(root, params.bufnr) do
              (function()
                local decl = match[3]
                if decl:type() ~= "function_definition" and decl:type() ~= "lambda_expression" then
                  return
                end
                local arg_type = match[1]
                local id = match[2]
                if not has_const then
                  local row1, col1, row2, col2 = arg_type:range()
                  table.insert(diagnostics, {
                      row = row1 + 1,
                      end_row = row2 + 1,
                      col = col1 + 1,
                      end_col = col2 + 1,
                      source = "const_arg",
                      message = "Argument \"" .. vim.treesitter.query.get_node_text(id, params.bufnr) .. "\" should be const",
                      severity = vim.diagnostic.severity.WARN,
                  })
                end
              end)()
            end
            return diagnostics
        end,
    },
}
null_ls.register(const_arg)

local boost_main_query = [[
    (_
      (preproc_include)
      (preproc_def
        .
        (identifier) @id
        (#eq? @id "BOOST_TEST_MAIN")
        .
      )
    )
]]
local boost_main_parsed_query = vim.treesitter.query.parse_query("cpp", boost_main_query)

local boost_main = {
    name = "boost_main",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "cpp" },
    generator = {
        fn = function(params)
            if not vim.g.enable_null_lints then return end
            local diagnostics = {}
            tsparser = ts.get_parser(params.bufnr, params.filetype)
            tstree = tsparser:parse()
            local root = tstree[1]:root()

            for pattern, match in boost_main_parsed_query:iter_matches(root, params.bufnr) do
                local id = match[1]
                local row1, col1, row2, col2 = id:range()
                table.insert(diagnostics, {
                    row = row1 + 1,
                    end_row = row2 + 1,
                    col = col1 + 1,
                    end_col = col2 + 1,
                    source = "boost_main",
                    message = "#define BOOST_TEST_MAIN should appear before any includes",
                    severity = vim.diagnostic.severity.WARN,
                })
            end
            return diagnostics
        end,
    },
}

null_ls.register(boost_main)

local decl_no_name_query = [[
    (_
      declarator: (function_declarator
        (parameter_list
          (_
            type: (_) @type
            declarator: (_) @id)))) @decl
]]
local decl_no_name_parsed_query = vim.treesitter.query.parse_query("cpp", decl_no_name_query)

local decl_no_name = {
    name = "decl_no_name",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "cpp" },
    generator = {
        fn = function(params)
            if not vim.g.enable_null_lints then return end
            local diagnostics = {}
            tsparser = ts.get_parser(params.bufnr, params.filetype)
            tstree = tsparser:parse()
            local root = tstree[1]:root()

            for pattern, match in decl_no_name_parsed_query:iter_matches(root, params.bufnr) do
              (function()
                local decl = match[3]
                if decl:type() ~= "declaration" and decl:type() ~= "field_declaration" then
                  return
                end
                local arg_type = match[1]
                local id = match[2]
                local row, _, _, _ = id:range()
                if id:type() ~= "identifier" then
                  for node in id:iter_children() do
                    if node:type() == "identifier" then
                      id = node
                      break
                    elseif node:type() == "parameter_list" then
                      -- Variable declaration parsed as function, most vexing parse.
                      return
                    end
                  end
                end
                local id_text = vim.treesitter.query.get_node_text(id, params.bufnr)
                if id_text:len() <= 3 then
                  return
                end
                local type_text = vim.treesitter.query.get_node_text(arg_type, params.bufnr)
                local lower_type = string.lower(type_text)
                local short_arg = string.gsub(id_text, "_", "")
                if lower_type:find(short_arg, 1, true) ~= nil then
                  local row1, col1, row2, col2 = id:range()
                  table.insert(diagnostics, {
                      row = row1 + 1,
                      end_row = row2 + 1,
                      col = col1 + 1,
                      end_col = col2 + 1,
                      source = "decl_no_name",
                      message = "Argument name \"" .. id_text .. "\" can be omitted",
                      severity = vim.diagnostic.severity.WARN,
                  })
                end
              end)()
            end
            return diagnostics
        end,
    },
}
null_ls.register(decl_no_name)

local decl_no_const_query = [[
    (_
      declarator: (function_declarator
        (parameter_list
          (_
            (type_qualifier) @const
            (#eq? @const "const")
            type: (_) @type
            declarator: (_)? @id)))) @decl
]]
local decl_no_const_parsed_query = vim.treesitter.query.parse_query("cpp", decl_no_const_query)

local decl_no_const = {
    name = "decl_no_const",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "cpp" },
    generator = {
        fn = function(params)
            if not vim.g.enable_null_lints then return end
            local diagnostics = {}
            tsparser = ts.get_parser(params.bufnr, params.filetype)
            tstree = tsparser:parse()
            local root = tstree[1]:root()

            for pattern, match in decl_no_const_parsed_query:iter_matches(root, params.bufnr) do
              (function()
                local decl = match[4]
                if decl:type() ~= "declaration" and decl:type() ~= "field_declaration" then
                  return
                end
                local type_text = vim.treesitter.query.get_node_text(match[2], params.bufnr)
                if match[3] ~= nil then
                  local id_text = vim.treesitter.query.get_node_text(match[3], params.bufnr)
                  if id_text:find("&") ~= nil or id_text:find("*") ~= nil then
                    return
                  end
                end
                local row1, col1, row2, col2 = match[1]:range()
                table.insert(diagnostics, {
                    row = row1 + 1,
                    end_row = row2 + 1,
                    col = col1 + 1,
                    end_col = col2 + 1,
                    source = "decl_no_const",
                    message = "\"const\" in declaration is not necessary",
                    severity = vim.diagnostic.severity.WARN,
                })
              end)()
            end
            return diagnostics
        end,
    },
}
null_ls.register(decl_no_const)

local forbidden_patterns_list = {
  {pattern = "\bBOOST_TEST\b", message = "Use BOOST_CHECK"},
  {pattern = "\\(ht_base/\\)\\@<!\\(std::\\)\\@<!string_view", message = "Use std::string_view"},
};

for _, pattern in pairs(forbidden_patterns_list) do
  pattern.regex = vim.regex(pattern.pattern)
end

local forbidden_words = {
    name = "forbidden_words",
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    filetypes = { "cpp" },
    generator = {
        fn = function(params)
            if not vim.g.enable_null_lints then return end
            local diagnostics = {}
            for line_number, line in pairs(params.content) do
              for _, pattern in pairs(forbidden_patterns_list) do
                local match_start, match_end = pattern.regex:match_str(line)
                if match_start ~= nil then
                  table.insert(diagnostics, {
                      row = line_number,
                      end_row = line_number,
                      col = match_start,
                      end_col = match_end,
                      source = "forbidden_words",
                      message = "\"" .. line:sub(match_start, match_end) .. "\" is forbidden. " .. pattern.message,
                      severity = vim.diagnostic.severity.WARN,
                  })
                end
              end
            end
            return diagnostics
        end,
    },
}
null_ls.register(forbidden_words)
EOF
