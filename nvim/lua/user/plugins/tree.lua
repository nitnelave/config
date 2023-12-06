local function tree_on_attach(bufnr)
  local api = require('nvim-tree.api')
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  vim.keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
  vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
end

return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeFindFileToggle",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      on_attach = tree_on_attach,
      view = {
        centralize_selection = true,
        width = function() return math.floor(vim.o.columns / table.getn(vim.api.nvim_tabpage_list_wins(0))) end,
      },
      renderer = {
        root_folder_label = false,
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false
          },
        },
      },
    }
  },
}
