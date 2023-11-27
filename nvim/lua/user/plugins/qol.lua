-- Quality of life plugins

return {
  -- Better delimiters
  { "tpope/vim-surround", },
  -- Better dot repetition
  { "tpope/vim-repeat", },
  -- Load per-project vimrc
  {
    "embear/vim-localvimrc",
    init = function()
      vim.g.localvimrc_sandbox = 0
      vim.g.localvimrc_ask = 0
    end,
  },
  -- Toggle paste mode automatically.
  { "roxma/vim-paste-easy", },
  -- Open vim at a specific line.
  { "bogado/file-line", },
  -- Diffed lines in vim.
  { "mhinz/vim-signify", },
  -- Swap function arguments with <, and >,
  -- New text objects a, and i,
  { "PeterRincker/vim-argumentative", },
  -- Replace with case.
  { "tpope/vim-abolish", },
  -- Spellcheck with CamlCase support.
  {
    "kamykn/spelunker.vim",
    config = function()
      vim.cmd[[set nospell]]
      -- Only check words currently displayed
      vim.g.spelunker_check_type = 2
      -- Highlight only SpellBad
      vim.g.spelunker_highlight_type = 2
      vim.g.spelunker_disable_uri_checking = 1
      vim.g.spelunker_disable_backquoted_checking = 1
      vim.g.spelunker_white_list_for_user = {'args', 'kwargs'}
      -- Disable email-like words checking. (default: 0)
      vim.g.spelunker_disable_email_checking = 1
      -- Disable account name checking. (default: 0)
      vim.g.spelunker_disable_account_name_checking = 1
      vim.g.spelunker_disable_acronym_checking = 1

      vim.api.nvim_create_augroup("SpelunkerDisable", {})
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        group = "SpelunkerDisable",
        callback = function()
          vim.b.enable_spelunker_vim = 0
        end,
      })
    end
  },
  -- Unix commands on the current file, :Move and :Mkdir
  { "tpope/vim-eunuch", },
  -- Bulk rename files
  { "qpkorr/vim-renamer", cmd = {"Renamer", "RenamerStart"}, },
  -- Git commands
  { "tpope/vim-fugitive", },
  -- Close hidden buffers
  { "kazhala/close-buffers.nvim" },
  -- Leap: jump to bigram with 'f'
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")
      vim.keymap.set({ "n", "v" }, "f", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "v" }, "F", "<Plug>(leap-backward)")
      if dvorak_mappings then
        leap.opts.safe_labels = {
          "o", "e", "g", "j", "k", "l", "m", "p", "q", "u", "z", "f",
          "O", "E", "G", "J", "K", "L", "M", "P", "Q", "U", "Z", "F",
        }
        leap.opts.labels = {}
      else
        leap.opts.safe_labels = {
          "o", "e", "g", "t", "n", "s", "m", "p", "q", "u", "z", "f",
          "O", "E", "G", "T", "N", "S", "M", "P", "Q", "U", "Z", "F",
        }
        leap.opts.labels = {}
      end
    end
  },
  -- Cheatsheet
  {
    "lifepillar/vim-cheat40",
    cmd = "Cheat40",
    keys = {
      { "<leader>?", nil, desc = "CheatSheet" },
    },
    init = function()
      vim.g.cheat40_use_default = 0
    end,
  },
}
