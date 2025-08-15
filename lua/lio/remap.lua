-- Create a command that calls the goimports Lua function
-- vim.api.nvim_create_user_command('GoImports', goimports, {})
-- Define the leader key to be space
vim.g.mapleader = " "
-- use sapce-f-t to open the standard vim file navigation
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
-- toggle Copilot on/off - disabled on start
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ToggleCopilot()<CR>', { noremap = true, silent = true })
-- Capslock is mapped to F13 - always escapes modes and saves file
vim.api.nvim_set_keymap('i', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
-- Capslock aka F13 for when inside of tmux
vim.api.nvim_set_keymap('i', '<S-F1>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-F1>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-F1>', '<Esc>:w<CR>', { noremap = true, silent = true })
-- Capslock aka F13 for when not inside of tmux
vim.api.nvim_set_keymap('i', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<F13>', ':GoImports<CR>', { noremap = true, silent = true })
-- toggle undotree on leader-u
vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR><C-w>h', { noremap = true, silent = true })
-- move between tmux windows
-- Function to send a tmux command
local function tmux_command(cmd)
    vim.fn.system("tmux " .. cmd)
end

-- Use asynchronous job for faster tmux navigation
local function tmux_command_async(cmd)
    vim.fn.jobstart("tmux " .. cmd, {
        detach = true,
        on_exit = function(_, _, _) end
    })
end

-- Map <Leader>t<number> to switch to a specific tmux window
for i = 1, 9 do
    vim.keymap.set("n", "<Leader>t" .. i, function()
        tmux_command_async("select-window -t " .. i)
    end, { desc = "Switch to tmux window " .. i })
end

-- Map <Leader>n to switch to the next tmux window
vim.keymap.set("n", "<Leader>n", function()
    tmux_command_async("next-window")
end, { desc = "Switch to the next tmux window" })

-- Map <Leader>p to switch to the previous tmux window
vim.keymap.set("n", "<Leader>p", function()
    tmux_command_async("previous-window")
end, { desc = "Switch to the previous tmux window" })

-- Alternative direct window selection for better performance
vim.keymap.set("n", "<Leader>tn", function()
    tmux_command_async("select-window -n")
end, { desc = "Select next tmux window (faster)" })

vim.keymap.set("n", "<Leader>tp", function()
    tmux_command_async("select-window -p")
end, { desc = "Select previous tmux window (faster)" })
