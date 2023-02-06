" Clear autocmds
autocmd!

" Disable NetRW.
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

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

  Plug 'lifepillar/vim-cheat40'

  " for icons
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'

  " LSP & completion
  " Collection of common configurations for the Nvim LSP client
  Plug 'neovim/nvim-lspconfig'
  " Nicer UI
  Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
  Plug 'ray-x/navigator.lua'
  Plug 'ray-x/lsp_signature.nvim'
  " LSP status in status line.
  Plug 'nvim-lua/lsp-status.nvim'

  " Completion framework
  Plug 'hrsh7th/nvim-cmp'

  " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp', {'commit': 'affe808a5c56b71630f17aa7c38e15c59fd648a8'}

  " Snippet completion source for nvim-cmp
  Plug 'hrsh7th/cmp-vsnip'

  " Other useful completion sources
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-git'

  " Dependency for refactoring.
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
" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
  return ''
endfunction
set statusline=%f\ %l\|%c\ %m\ %#warningmsg#%*%=%{LspStatus()}%p%%\ (%Y%R)

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

nnoremap <c-f> :lua vim.lsp.buf.formatting()<CR>

lua <<EOF
local lsp_status = require('lsp-status')
lsp_status.config {
  show_filename = false,
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'i',
  indicator_hint = '?',
  indicator_ok = 'Ok',
}
lsp_status.register_progress()

local util = require 'lspconfig.util'
local capabilities = vim.lsp.protocol.make_client_capabilities()
for k,v in pairs(lsp_status.capabilities) do capabilities[k] = v end
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
local clangd_capabilities  = require("cmp_nvim_lsp").update_capabilities(capabilities)
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = {"utf-8"}
local rust_capabilities = capabilities
rust_capabilities.document_formatting = true

function clang_options()
   local f=io.open('/usr/local/ht-clang-15-0-0/bin/clangd',"r")
   if f~=nil then
     io.close(f)
     return {'/usr/local/ht-clang-15-0-0/bin/clangd', '-j=40',
     '--compile-commands-dir=./build/ub-18.04-clang-15.0.0-generic.debug',
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
    { key = 'gd', func = require('navigator.definition').definition, desc = 'definition' },
    { key = 'gD', func = function () vim.lsp.buf.declaration({ border = 'rounded', max_width = 80 }) end, desc = 'declaration' },
    { key = '<c-k>', func = vim.lsp.signature_help, desc = 'signature_help' },
    { mode = 'i', key = '<c-k>', func = vim.lsp.signature_help, desc = 'signature_help' },
    { key = 'K', func = function () vim.lsp.buf.hover({ popup_opts = { border = single, max_width = 80 }}) end, desc = 'hover_doc' },
    { key = 'ga', mode = 'n', func = require('navigator.codeAction').code_action, desc = 'code_actions' },
    { key = '<c-r>', func = require('navigator.rename').rename, desc = 'rename'},
    { key = 'gi', func = vim.lsp.buf.incoming_calls, desc = 'incoming calls' },
    { key = 'go', func = vim.lsp.buf.outgoing_calls, desc = 'outgoing calls' },
    { key = 'g]', func = function () vim.diagnostic.goto_next({ border = 'rounded', max_width = 80}) end, desc = 'next diagnostic' },
    { key = 'g[', func = function () vim.diagnostic.goto_prev({ border = 'rounded', max_width = 80}) end, desc = 'prev diagnostic' },
    { key = 'gE', func = vim.diagnostic.setloclist, desc = 'diagnostics set loclist' },
    { key = 'ge', func = require('navigator.diagnostics').show_diagnostics, desc = 'show_diagnostics' },
  },
  lsp = {
    format_on_save = true,
    disable_lsp = {'bashls', 'ccls', 'closure_lsp', 'cssls', 'dartls',
    'denols', 'dockerls', 'dotls', 'graphql', 'intelephense',
    'kotlin_language_server', 'nimls', 'pylsp', 'pyright', 'sqlls',
    'sumneko_lua', 'vimls', 'vim-language-server', 'yamlls'},
    clangd = {
      handlers = lsp_status.extensions.clangd.setup(),
      root_dir = util.root_pattern('build/compile_commands.json', '.git'),
      flags = {allow_incremental_sync = true, debounce_text_changes = 500},
      cmd = clang_options(),
      filetypes = {"c", "cpp", "objc", "objcpp"},
      init_options = {
        clangdFileStatus = true
      },
      on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
        lsp_status.on_attach(client)
      end,
      capabilities = clangd_capabilities
    },
    rust_analyzer = {
      root_dir = function(fname)
        return util.root_pattern("Cargo.toml", "rust-project.json", ".git")(fname)
                   or util.path.dirname(fname)
      end,
      filetypes = {"rust"},
      message_level = vim.lsp.protocol.MessageType.error,
      capabilities = rust_capabilities,
      on_attach = lsp_status.on_attach,
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
  }
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

if vim.o.ft == 'clap_input' and vim.o.ft == 'guihua' and vim.o.ft == 'guihua_rust' then
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
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
    },
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
nnoremap ,fs <cmd>lua require('telescope.builtin').lsp_document_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})<cr>
nnoremap ,fS <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})<cr>

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
require('refactoring').setup({})
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
    width = 80,
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
