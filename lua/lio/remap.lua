-- Define a Lua function to run goimports and preserve cursor position
local function goimports()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Run goimports on the entire buffer
  vim.api.nvim_command('%!goimports')
  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  -- Save the File
  vim.api.nvim_command('w')
end

-- Create a command that calls the goimports Lua function
vim.api.nvim_create_user_command('GoImports', goimports, {})


vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
vim.keymap.set("v", "<Up>", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "<Down>", ":m '>+1<CR>gv=gv")
vim.api.nvim_set_keymap('i','<F13>','<Esc>:w<CR>',{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n','<F13>',':GoImports<CR>',{ noremap = true, silent = true })


