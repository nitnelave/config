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
      }
    }
  },
}
