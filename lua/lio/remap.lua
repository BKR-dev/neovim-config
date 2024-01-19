vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
vim.keymap.set("v", "<Up>", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "<Down>", ":m '>+1<CR>gv=gv")
vim.api.nvim_set_keymap('i','<leader><leader>w','<C-o>:w<CR>',{ noremap = true, silent = true })
