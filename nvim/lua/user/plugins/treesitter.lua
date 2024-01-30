local should_run_on_buffer = require("user.largefile").enable_except_large_or_diff

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = should_run_on_buffer,
    config = function ()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "rust", "cpp", "c", "vim", "lua", "bash", "html", "vimdoc", "java", },
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
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        }
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = should_run_on_buffer,
    init = function()
      vim.cmd[[hi TreesitterContext ctermbg=236 ctermfg=white]]
    end,
    opts = {
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
    },
  },
  { 'nvim-treesitter/playground', cond = not is_ht, },
}
