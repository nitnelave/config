vim.api.nvim_create_augroup("ClearTrailingSpaces", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = "ClearTrailingSpaces",
  callback = function()
    if vim.bo.filetype ~= "markdown" and vim.bo.filetype ~= "diff" then
      return
    end
    vim.cmd[[%s/\v\s+$//e]]
  end,
})

vim.api.nvim_create_augroup("CppPragmaOnce", {})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.h,*.hh,*.hpp",
  group = "CppPragmaOnce",
  command = [[normal! i#pragma once \n\n]],
})

vim.api.nvim_create_augroup("SheBang", {})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.sh",
  group = "SheBang",
  command = [[normal! i#! /bin/sh\n\n]],
})
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.py",
  group = "SheBang",
  command = [[normal! i#! /usr/bin/env python\n\n]],
})
