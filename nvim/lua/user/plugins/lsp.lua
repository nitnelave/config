function get_capabilities()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return capabilities
end

function find_related_test_file(path)
  local telescope_builtin = require("telescope.builtin")
  local Path = require("plenary.path")
  local current_file = vim.api.nvim_buf_get_name(0)
  local filename = string.gsub(string.gsub(current_file, "^.*/", ""), ".h$", ".cpp")
  local dir = Path:new(current_file):parent()
  local parent_path, is_test = string.gsub(dir:normalize(), "/tests?$", "", 1)
  if is_test == 0 then
    for _, test_dir_name in ipairs({ "test", "tests" }) do
      local test_dir = dir / test_dir_name
      if test_dir:exists() then
        local test_file = test_dir / filename
        if test_file:exists() then
          return vim.cmd.edit(test_file:normalize())
        end
        return telescope_builtin.git_files({ default_text = test_dir:normalize()})
      end
    end
    return telescope_builtin.git_files({ default_text = dir:normalize() .. "/test"})
  else
    local parent_dir = dir:parent()
    local impl_file = parent_dir / filename
    if impl_file:exists() then
      return vim.cmd.edit(impl_file:normalize())
    end
    return telescope_builtin.git_files({ default_text = parent_dir:normalize() })
  end
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    cond = is_ht,
    init = function()
      local utils = require "user.utils"
      if not utils.is_dir(vim.fn.expand("~/.config/nvim/jdtls/1.42.0")) then
        function execute_silent(command)
          local handle = require("io").popen(command)
          handle:read("*a")
          handle:close()
        end
        execute_silent("curl -fLo '/tmp/jdt-language-server-1.42.0.tar.gz' --create-dirs 'https://www.eclipse.org/downloads/download.php?file=/jdtls/milestones/1.42.0/jdt-language-server-1.42.0-202411281516.tar.gz'")
        execute_silent("mkdir -p ~/.config/nvim/jdtls/1.42.0")
        execute_silent("tar xvzf /tmp/jdt-language-server-1.42.0.tar.gz --directory ~/.config/nvim/jdtls/1.42.0")
      end
    end,
  },
  { "leafgarland/typescript-vim", ft = "ts", cond = not is_ht, },
  { "jceb/vim-orgmode", ft = "org", cond = not is_ht, },
  { "cespare/vim-toml", ft = "toml", cond = not is_ht, },

  -- Clangd inlay hints and more
  {
    "p00f/clangd_extensions.nvim",
    ft = {"cpp", "c"},
    config = function()
      require("clangd_extensions").setup({
        inlay_hints = {
          only_current_line = false,
          show_parameter_hints = false,
          other_hints_prefix = "-> ",
        }
      })
      vim.api.nvim_set_keymap("n", "<leader>rh", ":ClangdSwitchSourceHeader<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>rt", find_related_test_file, { noremap = true, silent = true })
    end,
  },

  -- Rust inlay hints and more
  { "simrat39/rust-tools.nvim", ft = "rust", cond = not is_ht, },

  -- Local checks
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = "cpp",
    config = function()
      if vim.g.enable_null_lints == nil then
        vim.g.enable_null_lints = is_ht
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
                  type: (_) @type (#not-match? @type "^Optional\\<const .*\\>$")
                  declarator: (identifier) @id)))) @decl
      ]]
      local const_arg_parsed_query = vim.treesitter.query.parse("cpp", const_arg_query)

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
                            message = "Argument \"" .. vim.treesitter.get_node_text(id, params.bufnr) .. "\" should be const",
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

      local decl_no_name_query = [[
          (_
            declarator: (function_declarator
              (parameter_list
                (_
                  type: (_) @type
                  declarator: (_) @id)))) @decl
      ]]
      local decl_no_name_parsed_query = vim.treesitter.query.parse("cpp", decl_no_name_query)

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
                      local id_text = vim.treesitter.get_node_text(id, params.bufnr)
                      if id_text:len() <= 3 then
                        return
                      end
                      local type_text = vim.treesitter.get_node_text(arg_type, params.bufnr)
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
      local decl_no_const_parsed_query = vim.treesitter.query.parse("cpp", decl_no_const_query)

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
                      local type_text = vim.treesitter.get_node_text(match[2], params.bufnr)
                      if match[3] ~= nil then
                        local id_text = vim.treesitter.get_node_text(match[3], params.bufnr)
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
        {pattern = "\\(include <\\)\\@<!\\(ht_base/\\)\\@<!\\(std::\\)\\@<!\\(\\.\\)\\@<!\\(_\\)\\@<!\\(->\\)\\@<!string_view", message = "Use std::string_view"},
        {pattern = "include .gmock/gmock.h.", message = "Include \"ht_test_helpers/gmock.h\""},
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
    end,
  },

  -- UI
  {
    "ray-x/guihua.lua",
    build = "cd lua/fzy && make",
    lazy = true,
    init = function()
      vim.cmd([[hi default GuihuaTextViewDark ctermfg=white ctermbg=236 cterm=NONE]])
      vim.cmd([[hi default GuihuaListDark ctermfg=white ctermbg=236 cterm=NONE]])
      vim.cmd([[hi default GuihuaListHl ctermfg=white ctermbg=cyan]])
    end
  },
  {
    "ray-x/navigator.lua",
    config = function()
      local lsp_config = {
        format_on_save = true,
        disable_lsp = {'bashls', 'ccls', 'clangd', 'closure_lsp', 'cssls', 'dartls',
        'denols', 'dockerls', 'dotls', 'graphql', 'intelephense',
        'kotlin_language_server', 'nimls', 'pylsp', 'ruff_lsp', 'ruff', 'sqlls',
        'sumneko_lua', 'vimls', 'vim-language-server', 'yamlls'},
        pyright = {},
      }

      if not is_ht then
        local rust_capabilities = get_capabilities()
        rust_capabilities.document_formatting = true
        lsp_config.rust_analyzer = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
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
        }
      end
      require("navigator").setup {
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
          { key = '<c-f>', func = function() vim.lsp.buf.format { async = true } end, desc = 'format' },
        },
        lsp = lsp_config,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local util = require 'lspconfig.util'
      local clang_options
       if is_ht then
         clang_options = {'/usr/local/ht-clang-17-0-1/bin/clangd', '-j=40',
         '--compile-commands-dir=./build/ub-18.04-clang-17.0.1-generic.debug',
         "--background-index", "--clang-tidy", "--header-insertion=iwyu",
         "--all-scopes-completion", "--completion-style=bundled", "--malloc-trim", 
         "--pch-storage=memory"}
       else
         clang_options = {"clangd", "--background-index", "--clang-tidy",
         "--header-insertion=iwyu", "--all-scopes-completion",
         "--completion-style=bundled", "--malloc-trim",
         "--pch-storage=memory"}
       end



      local clangd_capabilities = get_capabilities()
      clangd_capabilities.textDocument.semanticHighlighting = true
      clangd_capabilities.offsetEncoding = { "utf-16" }
      require('lspconfig').clangd.setup({
        root_dir = util.root_pattern('.git'),
        flags = {allow_incremental_sync = true, debounce_text_changes = 500},
        cmd = clang_options,
        filetypes = {"c", "cpp", "objc", "objcpp"},
        init_options = {
          clangdFileStatus = true
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.document_formatting = true
          require('navigator.lspclient.mapping').setup({client=client, bufnr=bufnr}) -- setup navigator keymaps here,
          require("navigator.dochighlight").documentHighlight(bufnr)
          require("clangd_extensions.inlay_hints").setup_autocmd()
          require("clangd_extensions.inlay_hints").set_inlay_hints()
          if on_attach ~= nil then
            on_attach(client, bufnr)
          end
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
        }
      )
      vim.cmd[[hi clear LspReferenceRead]]
      vim.cmd[[hi clear LspReferenceText]]
      vim.cmd[[hi clear LspReferenceWrite]]
      vim.cmd[[hi LspReferenceRead gui=underline cterm=underline]]
      vim.cmd[[hi LspReferenceText gui=underline cterm=underline]]
      vim.cmd[[hi LspReferenceWrite gui=underline cterm=underline]]
    end
  },
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }
  },

  -- LSP status
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = true,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function ()
      require("luasnip.loaders.from_snipmate").load()
    end
  },

  { 'saadparwaiz1/cmp_luasnip' },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    init = function()
      -- TODO: Probably not what we need. autocmd?
      if vim.o.ft == 'clap_input' or vim.o.ft == 'guihua' or vim.o.ft == 'guihua_rust' then
        require'cmp'.setup.buffer { completion = {enable = false} }
      end
    end,
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

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
      cmp.setup({
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end
        },
        mapping = {
          [dvorak_mappings and '<C-n>' or '<C-k>'] = cmp.mapping.select_prev_item(),
          [dvorak_mappings and '<C-t>' or '<C-j>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          [dvorak_mappings and '<C-c>' or '<C-i>'] = cmp.mapping.scroll_docs(-4),
          [dvorak_mappings and '<C-w>' or '<C-,>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
          })
        },

        -- Installed sources
        sources = {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
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
                Variable = 11,
                Constant = 10,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                Class = 10,
                File = 8,
                Folder = 8,
                Module = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Color = 0,
                Snippet = 0,
                Text = 0,
                TypeParameter = 0,
                Unit = 0,
                Value = 0,
              },
            }),
            --cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'cmp_git' },
        }, {
          { name = 'buffer' },
        })
      })

      cmp.setup.filetype('lua', {
        sources = cmp.config.sources({
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
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
    end
  },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  {
    "petertriho/cmp-git",
    cond = not is_ht,
    opts = {
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
    }
  },
}
