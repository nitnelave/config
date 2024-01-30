return {
  {
    "sonph/onehalf",
    lazy = false,
    priority = 1000,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
      vim.cmd [[
        colorscheme onehalfdark
        hi clear NormalFloat
        hi link NormalFloat Normal
        hi clear FloatBorder
        hi FloatBorder ctermfg=188 ctermbg=237 guifg=#dcdfe4 guibg=#313640
        hi clear Pmenu
        hi link Pmenu Visual
        hi clear PmenuSel
        hi link PmenuSel Cursor
      ]]
    end,
  },
}
