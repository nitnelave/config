return {
  {
    "sonph/onehalf",
    lazy = false,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
      vim.cmd [[ colorscheme onehalfdark ]]
    end,
  },
}
