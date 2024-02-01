-- Define a Lua function to run goimports and preserve cursor position
local function goimports()
    -- Save the File
    vim.api.nvim_command('w')
    -- check if buffer is a go file
    if vim.bo.filetype == 'go' then
        -- Save the File
        vim.api.nvim_command('w')
        -- Run gofmt to see if there are errors
        vim.api.nvim_command('!gofmt %')
        -- Get exit code of gofmt
        local exit_code = vim.api.nvim_get_vvar('shell_error')
        -- If Exit code is NOT Zero do:
        if exit_code ~= 0 then
            -- Undo Changes
            vim.api.nvim_command('undo')
            return
        end
        -- Save the current cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        -- Run goimports on the entire buffer
        vim.api.nvim_command('%!goimports')
        -- Restore the cursor position
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        -- Save the File
        vim.api.nvim_command('w')
    end
end

-- Create a command that calls the goimports Lua function
vim.api.nvim_create_user_command('GoImports', goimports, {})


vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ft", vim.cmd.Ex)
vim.api.nvim_set_keymap('i', '<F13>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F13>', ':GoImports<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR><C-w>h', { noremap = true, silent = true })
