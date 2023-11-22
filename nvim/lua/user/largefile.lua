function is_large_file(name)
  local max_filesize = 10 * 1024 * 1024 -- 10 MB
  local ok, stats = pcall(vim.loop.fs_stat, name)
  if ok and stats and stats.size > max_filesize then
      return true
  end
  return false
end

vim.api.nvim_create_augroup("LargeFiles", {})
vim.api.nvim_create_autocmd({"BufReadPre", "FileReadPre"}, {
  pattern = "*",
  group = "LargeFiles",
  callback = function(args)
    if is_large_file(args.file) then
      vim.cmd[[syntax clear]]
      vim.cmd[[syntax off]]
      vim.cmd[[filetype off]]
      vim.b.undofile = false
      vim.b.swapfile = false
      vim.b.foldmethod = "manual"
      -- DIsable TreeSitter?
    end
  end,
})
