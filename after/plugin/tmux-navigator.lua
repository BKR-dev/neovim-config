-- Keybindings for vim-tmux-navigator
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "Navigate left to tmux pane" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true, desc = "Navigate down to tmux pane" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true, desc = "Navigate up to tmux pane" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>",
    { silent = true, desc = "Navigate right to tmux pane" })
vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>",
    { silent = true, desc = "Navigate to previous tmux pane" })

-- Optional: Disable tmux navigator when zoomed in a tmux pane
vim.g.tmux_navigator_disable_when_zoomed = 1
