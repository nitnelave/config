return {
  { 
    "github/copilot.vim", 
    ft = "rust", 
    cond = not is_ht, 
    config = function()
      vim.cmd[[
      imap <silent><script><expr> <C-l> copilot#Accept("")
      let g:copilot_no_tab_map = v:true
      augroup CopilotEnabled
        autocmd!
        autocmd BufEnter * Copilot disable
        autocmd BufEnter $HOME/projects/lldap/** Copilot enable
      augroup END
    ]]
    end
  },
}
