-- 'very magic' regexp searches and substitutions
vim.api.nvim_set_keymap("n", "/", [[/\v]], { noremap = true })
vim.api.nvim_set_keymap("n", "?", [[?\v]], { noremap = true })
vim.api.nvim_set_keymap("c", "%s", [[%s/\v]], { noremap = true })
-- Redo
vim.api.nvim_set_keymap("n", "U", "<C-R>", { noremap = true })
-- Ctrl-Backspace deletes a word.
vim.api.nvim_set_keymap("l", "<C-H>", "<C-W>", { noremap = true })

-- Yank from cursor to end of line, to be consistent with C and D
vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })
-- Yank relative file path.
vim.api.nvim_set_keymap("n", "yf", [[:let @"=@%<CR>]], { noremap = true })

if dvorak_mappings then
  vim.api.nvim_set_keymap("", "t", "gj", { noremap = true })
  vim.api.nvim_set_keymap("", "n", "gk", { noremap = true })
  vim.api.nvim_set_keymap("", "s", "l", { noremap = true })
  vim.api.nvim_set_keymap("", "l", "n", { noremap = true })
  vim.api.nvim_set_keymap("", "L", "N", { noremap = true })
  -- Fast movements.
  vim.api.nvim_set_keymap("", "T", "8<Down>", { noremap = true })
  vim.api.nvim_set_keymap("", "N", "8<Up>", { noremap = true })

  -- Switch between splits.
  vim.api.nvim_set_keymap("", "S", "<C-w>w", { noremap = true })
  vim.api.nvim_set_keymap("", "H", "<C-w>r", { noremap = true })
else
  vim.api.nvim_set_keymap("", "j", "gj", { noremap = true })
  vim.api.nvim_set_keymap("", "k", "gk", { noremap = true })
  -- Fast movements.
  vim.api.nvim_set_keymap("", "J", "8<Down>", { noremap = true })
  vim.api.nvim_set_keymap("", "K", "8<Up>", { noremap = true })

  -- Switch between splits.
  vim.api.nvim_set_keymap("", "L", "<C-w>w", { noremap = true })
  vim.api.nvim_set_keymap("", "H", "<C-w>r", { noremap = true })
end

vim.api.nvim_set_keymap("", "-", "$", { noremap = true })
vim.api.nvim_set_keymap("", "_", "^", { noremap = true })

-- For fat fingers, with extra capital letter
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qa", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
vim.api.nvim_create_user_command("Vs", "vs", {})
vim.api.nvim_create_user_command("VS", "vs", {})
vim.api.nvim_create_user_command("Ex", "NvimTreeFindFileToggle", {})
vim.api.nvim_create_user_command("EX", "NvimTreeFindFileToggle", {})
vim.api.nvim_create_user_command("Vex", "NvimTreeFindFileToggle", {})
vim.api.nvim_create_user_command("VEx", "NvimTreeFindFileToggle", {})
vim.api.nvim_create_user_command("VEX", "NvimTreeFindFileToggle", {})
vim.cmd([[cabbrev vex <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'NvimTreeFindFileToggle' : 'vex')<CR>]])
vim.cmd([[cabbrev ex <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'NvimTreeFindFileToggle' : 'ex')<CR>]])

vim.api.nvim_set_keymap("", ";", ":", { noremap = true })
vim.api.nvim_set_keymap("n", "<Space>", "i<Space><Esc>", { noremap = true })

-- tab settings
vim.api.nvim_exec([[
function! MoveToPrevTab()
  " there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  " preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() != 1
    close!
    if l:tab_nr == tabpagenr('$')
      tabprev
    endif
    vsp
  else
    close!
    exe "0tabnew"
  endif
  " opening current buffer in new window
  exe "b".l:cur_buf
endfunc

function! MoveToNextTab()
  " there is only one window
  if tabpagenr('$') == 1 && winnr('$') == 1
    return
  endif
  " preparing new window
  let l:tab_nr = tabpagenr('$')
  let l:cur_buf = bufnr('%')
  if tabpagenr() < tab_nr
    close!
    if l:tab_nr == tabpagenr('$')
      tabnext
    endif
    vsp
  else
    close!
    tabnew
  endif
  " opening current buffer in new window
  exe "b".l:cur_buf
endfunc
]], {})
if dvorak_mappings then
  vim.api.nvim_set_keymap("n", "<C-H>", ":tabprevious<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-S>", ":tabnext<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-T>", ":call MoveToPrevTab()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-N>", ":call MoveToNextTab()<CR>", { noremap = true, silent = true })
else
  vim.api.nvim_set_keymap("n", "<C-H>", ":tabprevious<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-L>", ":tabnext<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-J>", ":call MoveToPrevTab()<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-K>", ":call MoveToNextTab()<CR>", { noremap = true, silent = true })
end
