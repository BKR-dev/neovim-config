vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
vim.keymap.set("v", "<Up>", ":m '>-2<CR>gv=gv")
vim.keymap.set("v", "<Down>", ":m '>+1<CR>gv=gv")
