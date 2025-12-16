return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
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
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    }
}
