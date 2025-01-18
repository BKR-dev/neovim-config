-- Define a Lua function to run goimports and preserve cursor position
local function goimports()
    -- check if buffer is a go file
    if vim.bo.filetype == 'go' then
        vim.api.nvim_command('w')
        -- Save the current cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        -- Run goimports on the entire buffer
        vim.api.nvim_command('%!goimports')
        local exit_code = vim.api.nvim_get_vvar('shell_error')
        -- If Exit code is NOT Zero do:
        if exit_code ~= 0 then
            print('Undoing due to gofmt error\n')
            -- Undo Changes
            -- vim.api.nvim_command('undo')
            vim.api.nvim_command('undo')
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
            return
        end
        -- Save the File
        vim.api.nvim_command('w')
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
        -- Restore the cursor position
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
    -- Save the File
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', true)
    vim.api.nvim_command('w')
end

-- this isnt really working but i thought hey, why not? and the answer is : pluginslocal
local function addSingleComment()
    if vim.bo.filetype == 'go' then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_command('I//<Esc>')
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
    if vim.bo.filetype == 'lua' then
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_command('I--<Esc>')
        vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
end

vim.g.copilot_enabled = false
function ToggleCopilot()
    if vim.g.copilot_enabled then
        vim.cmd('Copilot disable')
        vim.g.copilot_enabled = false
    else
        vim.cmd('Copilot enable')
        vim.g.copilot_enabled = true
    end
end

-- Create a command that calls the goimports Lua function
-- vim.api.nvim_create_user_command('GoImports', goimports, {})
-- Define the leader key to be space
vim.g.mapleader = " "
-- use sapce-f-t to open the standard vim file navigation
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
-- toggle Copilot on/off - disabled on start
vim.api.nvim_set_keymap('n', '<leader>cc', ':lua ToggleCopilot()<CR>', { noremap = true, silent = true })
-- toggle between colorschemes
-- vim.api.nvim_set_keymap('n', '<leader>tt', ':lua ToggleTheme()<CR>', { noremap = true, silent = true })
-- Capslock is mapped to F13 - always escapes modes and saves file
vim.api.nvim_set_keymap('i', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F20>', '<Esc>:%!goimports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<F13>', ':GoImports<CR>', { noremap = true, silent = true })
-- toggle undotree on leader-u
vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR><C-w>h', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<leader>co', ':CommentOut<CR>', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('v', '<Up>', ':m \'<-2<CR>gv=gv', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('v', '<Down>', ':m \'>+1<CR>gv=gv', { noremap = true, silent = true })
