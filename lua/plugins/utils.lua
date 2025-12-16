return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<CR>", mode = {"n", "t"}, desc = "Navigate left to tmux pane" },
            { "<C-j>", "<cmd>TmuxNavigateDown<CR>", mode = {"n", "t"}, desc = "Navigate down to tmux pane" },
            { "<C-k>", "<cmd>TmuxNavigateUp<CR>", mode = {"n", "t"}, desc = "Navigate up to tmux pane" },
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", mode = {"n", "t"}, desc = "Navigate right to tmux pane" },
            { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", mode = {"n", "t"}, desc = "Navigate to previous tmux pane" },
        },
        config = function()
             vim.g.tmux_navigator_disable_when_zoomed = 1
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            local status_ok, autopairs = pcall(require, "nvim-autopairs")
            if not status_ok then return end

            autopairs.setup({
                check_ts = true,
                ts_config = {
                    lua = {'string'},
                    javascript = {'template_string'},
                    java = false,
                },
                fast_wrap = {
                    map = '<M-e>',
                    chars = { '{', '[', '(', '"', "'" },
                    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
                    end_key = '$',
                    keys = 'qwertyuiopzxcvbnmasdfghjkl',
                    check_comma = true,
                    highlight = 'Search',
                    highlight_grey = 'Comment'
                },
                disable_filetype = { "TelescopePrompt", "vim" },
            })
            
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
            end
        end
    },
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup({
                sticky = true,
                mappings = { basic = true, extra = true },
            })
        end
    },
    {
        'folke/todo-comments.nvim',
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup()
        end
    },
    { "shortcuts/no-neck-pain.nvim", version = "*", 
        config = function()
            require("no-neck-pain").setup({
                width = 120,
                minSideBufferWidth = 10,
                autocmds = { enableOnVimEnter = false },
                mappings = { enabled = true },
                buffers = {
                    scratchPad = { enabled = true, location = "~/Git/ScratchPadFiles/" },
                    bo = { filetype = "md" },
                    colors = {
                        backgroundColor = "#525252",
                        right = { backgroundColor = "tokyonight-moon" },
                        left = { backgroundColor = "tokyonight-moon" },
                    },
                    wo = { fillchars = "eob: " }
                }
            })
        end
    },
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'MunifTanjim/nui.nvim',
}
