local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


vim.api.nvim_create_user_command("FindFilesInDir", function()
    local dir = vim.env.NVIM_CWD
    require 'telescope'.find_files({ cwd = dir })
end, {})
