-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    -- Install Palenightfall colorscheme
    use('JoosepAlviste/palenightfall.nvim')

    -- install telescope for neat file finds
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    -- sintalling dap for debugging
    use('mfussenegger/nvim-dap')

    -- easy to use comments
    use('numToStr/Comment.nvim')

    -- install treesitter GOAT syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- install harpoon for quickmenu file storage and switch
    use('theprimeagen/harpoon')

    -- install fugitive for insane git integration
    use('tpope/vim-fugitive')

    -- use nvim surround for easy surroundings
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    })

    -- center a buffer for no neck pain
    use { "shortcuts/no-neck-pain.nvim", tag = "*" }

    -- install undotree for changes in files
    use('mbbill/undotree')

    -- install copilot
    use
    {'zbirenbaum/copilot.lua',
    config = function()
        vim.g.copilot_no_tab_map = false
        end
    }

    -- install debugging plugins
    use { "leoluz/nvim-dap-go" }
    use { "nvim-neotest/nvim-nio" }
    use { "rcarriga/nvim-dap-ui" }

    -- cute little icons
    use('nvim-tree/nvim-web-devicons')

    -- install all nvim-java packages
    -- use('nvim-java/nvim-java')
    -- use('nvim-java/nvim-java-refactor')
    -- use('nvim-java/nvim-java-core')
    -- use('nvim-java/lua-async-await')
    -- use('nvim-java/nvim-java-test')
    -- use('nvim-java/nvim-java-dap')
    -- use('JavaHello/spring-boot.nvim')
    -- use('mfussenegger/nvim-dap')
    use('MunifTanjim/nui.nvim')

    -- diagnostics in virtual lines
    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    })
    -- TODO-comments
    use {
        'folke/todo-comments.nvim',
        requires = "nvim-lua/plenary.nvim",
    }

    -- install lsp-zero for lsp support
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                run = ':MasonUpdate',
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }
end)
