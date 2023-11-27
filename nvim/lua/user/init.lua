clang_version = "17-0-1"
function is_ht_fn()
   local f=io.open("/usr/local/ht-clang-" .. clang_version .. "/bin/clangd","r")
   if f~=nil then
     io.close(f)
     return true
   end
   return false
end
is_ht = is_ht_fn()

vim.api.nvim_clear_autocmds({})
-- Needs to be set early.
vim.g.mapleader = ","

dvorak_mappings = dvorak_mappings or false

require "user.options"
require "user.largefile"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ import = "user.plugins" })
require "user.autocmd"
require "user.mappings"
