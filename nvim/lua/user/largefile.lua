local M = {}
M.max_filesize = 10 * 1024 * 1024 -- 10 MB

function M.is_large_file(name)
  local ok, stats = pcall(vim.loop.fs_stat, name)
  if ok and stats and stats.size > M.max_filesize then
      return true
  end
  return false
end

function M.is_large_buffer(bufnr)
  local wc = vim.api.nvim_eval("wordcount()")
  return wc["bytes"] > M.max_filesize
end

function M.enable_except_large_or_diff(lang, bufnr)
  return not M.is_large_buffer(bufnr) and not vim.wo.diff
end

function disable_features_for_large_files()
  vim.cmd[[syntax clear]]
  vim.cmd[[syntax off]]
  vim.cmd[[filetype off]]
  vim.b.undofile = false
  vim.b.swapfile = false
  vim.b.foldmethod = "manual"
  -- Disable spelunker
  vim.b.enable_spelunker_vim = false
end

vim.api.nvim_create_augroup("LargeFiles", {})
vim.api.nvim_create_autocmd({"BufRead", "FileReadPre"}, {
  pattern = "*",
  group = "LargeFiles",
  callback = function(args)
    if M.is_large_file(args.file) or M.is_large_buffer(args.buf) then
      disable_features_for_large_files()
    end
  end,
})
vim.api.nvim_create_autocmd({"StdinReadPre"}, {
  pattern = "*",
  group = "LargeFiles",
  callback = function(args)
    disable_features_for_large_files()
  end,
})

return M
