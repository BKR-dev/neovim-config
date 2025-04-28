-- Get the config directory (where this file resides)
local config_path = vim.fn.stdpath('config')
local packer_path = config_path .. '/pack/packer/start/packer.nvim'
local install_path = packer_path

-- Auto-install packer if not installed
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print('Installing packer...')
    vim.fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    vim.cmd [[packadd packer.nvim]]
    print('Packer installed!')
end

-- Configure Packer to use the custom path inside your config directory
require('packer').init({
    package_root = config_path .. '/pack',
    compile_path = config_path .. '/plugin/packer_compiled.lua',
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end
    }
})

-- Make sure Packer is loaded from the custom path
vim.opt.packpath:prepend(config_path)

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

    -- add autopairs
    use { 'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup({
                check_ts = true,        -- Use treesitter if available
                ts_config = {
                    lua = { 'string' }, -- Don't add pairs in lua string treesitter nodes
                    javascript = { 'template_string' },
                    java = false,       -- Don't check treesitter on java
                }
            })
        end }

    use {
        'fj0rd/kubernets.nvim', -- K8s specific features and integrations
        requires = {
            'nvim-lua/plenary.nvim',
        }
    }
    use {
        'b0o/schemastore.nvim',
        requires = { 'neovim/nvim-lspconfig' }
    }

    -- easy to use comments
    use('numToStr/Comment.nvim')

    -- install treesitter GOAT syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- install harpoon for quickmenu file storage and switch
    use('theprimeagen/harpoon')

    -- install fugitive for insane git integration
    use('tpope/vim-fugitive')

    -- center a buffer for no neck pain
    use { "shortcuts/no-neck-pain.nvim", tag = "*" }

    -- install undotree for changes in files
    use('mbbill/undotree')

    -- install copilot
    use
    { 'zbirenbaum/copilot.lua',
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

    use {
        'hrsh7th/cmp-nvim-lsp-signature-help', -- Signature help
        'hrsh7th/cmp-buffer',                  -- Buffer words
        'hrsh7th/cmp-path',                    -- File paths
        'hrsh7th/cmp-nvim-lua',                -- Lua API
        'hrsh7th/cmp-calc',                    -- Calculator
        'hrsh7th/cmp-emoji',                   -- Emoji
        'ray-x/cmp-treesitter',                -- Treesitter
        'petertriho/cmp-git',                  -- Git completions
        'saadparwaiz1/cmp_luasnip',            -- Snippet integration
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

