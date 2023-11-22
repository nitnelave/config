
return {
  { "nvim-lua/popup.nvim", lazy = true, },
  { "nvim-lua/plenary.nvim", lazy = true, },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      local refactoring = require('refactoring')
      refactoring.setup({
        extract_var_statements = {
          cpp = "const auto %s = %s;\n"
        }
      })
      -- Remaps for the refactoring operations currently offered by the plugin
      vim.keymap.set("v", "<leader>re", function() refactoring.refactor('Extract Function') end, { noremap = true })
      vim.keymap.set("v", "<leader>rv", function() refactoring.refactor('Extract Variable') end, { noremap = true })
      vim.keymap.set("v", "<leader>ri", function() refactoring.refactor('Inline Variable') end, { noremap = true })

      -- Extract block doesn't need visual mode
      vim.keymap.set("n", "<leader>rb", function() refactoring.refactor('Extract Block') end, { noremap = true })

      -- Inline variable can also pick up the identifier currently under the cursor without visual mode
      vim.keymap.set("n", "<leader>ri", function() refactoring.refactor('Inline Variable') end, { noremap = true })

      -- load refactoring Telescope extension
      require("telescope").load_extension("refactoring")

      -- remap to open the Telescope refactoring menu
      local telescope = require "telescope"
      vim.keymap.set({"n", "v"}, "<leader>rr", telescope.extensions.refactoring.refactors)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local lga_actions = require("telescope-live-grep-args.actions")
      local builtin = require("telescope.builtin")
      local action_state = require("telescope.actions.state")
      local finders = require "telescope.finders"
      local make_entry = require "telescope.make_entry"
      local pickers = require "telescope.pickers"
      local previewers = require "telescope.previewers"
      local utils = require "telescope.utils"
      local putils = require "telescope.previewers.utils"

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
            shorten = {
              len = 1,
              exclude = {-1, -2, 4, 5, 6, 7, 8}
            }
          },
          cache_picker = {
            num_pickers = 10,
          },
          mappings = {
            i = {
              [dvorak_mappings and "<C-t>" or "<C-j>"] = actions.move_selection_next,
              [dvorak_mappings and "<C-n>" or "<C-k>"] = actions.move_selection_previous,
            },
            n = {
              [dvorak_mappings and "t" or "j"] = actions.move_selection_next,
              [dvorak_mappings and "n" or "k"] = actions.move_selection_previous,
              [dvorak_mappings and "T" or "J"] = actions.move_to_top,
              [dvorak_mappings and "N" or "K"] = actions.move_to_bottom,
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
      function pickTab()
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

      local git_modified_previewer = function(base)
        return previewers.new_buffer_previewer {
          title = "Diff Preview with master",
          get_buffer_by_name = function(_, entry)
            return entry.value
          end,

          define_preview = function(self, entry, status)
            putils.job_maker({ "git", "diff", base, "--", entry.value }, self.state.bufnr, {
              value = entry.value,
              bufname = self.state.bufname,
              callback = function(bufnr)
                if vim.api.nvim_buf_is_valid(bufnr) then
                  putils.regex_highlighter(bufnr, "diff")
                end
              end,
            })
          end,
        }
      end

      function git_modified_picker(conf)
        local git_merge_base_cmd = { "git", "merge-base", "HEAD", "origin/master" }
        local merge_base = utils.get_os_command_output(git_merge_base_cmd)[1]
        local git_cmd = { "git", "diff", "--name-only", merge_base }

        local output = utils.get_os_command_output(git_cmd)

        if #output == 0 then
          print "No changes found"
          utils.notify("git_modified", {
            msg = "No changes found",
            level = "WARN",
          })
          return
        end

        local finder = finders.new_table {
          results = output,
          entry_maker = make_entry.gen_from_file(),
        }

        pickers
          .new(opts, {
            prompt_title = "Git Modified Files",
            finder = finder,
            previewer = git_modified_previewer(merge_base),
            sorter = conf.file_sorter(),
          })
          :find()
      end


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
      vim.keymap.set("n", "<c-x>", builtin.pickers)
      vim.keymap.set("n", "<c-p>", builtin.git_files)
      vim.keymap.set("n", "gr", builtin.lsp_references)
      vim.keymap.set("n", "gi", builtin.lsp_incoming_calls)
      vim.keymap.set("n", "go", builtin.lsp_outgoing_calls)
      vim.keymap.set("n", "gd", builtin.lsp_definitions)
      vim.keymap.set("n", "gD", builtin.lsp_implementations)
      vim.keymap.set("n", "<leader>fs", function()
        builtin.lsp_document_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})
      end)
      vim.keymap.set("n", "<leader>fS", function()
        builtin.lsp_dynamic_workspace_symbols({symbol_width = 60, ignore_symbols = {"namespace"}})
      end)
      vim.keymap.set({"n"}, "<c-b>", pickTab, { noremap = true, silent = true })
      vim.keymap.set({"n"}, "<c-m>", function() git_modified_picker(require("telescope.config").values) end, { noremap = true, silent = true })
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope-live-grep-args.nvim", },
}
