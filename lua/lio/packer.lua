-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function(use)
    -- Packer can manage itself
    use('wbthomason/packer.nvim')
    --tmux plugin
    use {
        "christoomey/vim-tmux-navigator",
        config = function()
            dofile(vim.fn.stdpath("config") .. "/after/plugin/tmux-navigator.lua")
        end,
    }
    -- Install Palenightfall colorscheme
    use('JoosepAlviste/palenightfall.nvim')
    -- Tokyonight
    use {
        'folke/tokyonight.nvim',
        branch = 'main',
        requires = 'nvim-treesitter/nvim-treesitter' -- Optional for syntax highlighting
    }
    -- install telescope for neat file finds
    -- relies on ripgrep (brew install ripgrep) for example
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.2',
        -- or , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
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
    -- easy to use comments
    use('numToStr/Comment.nvim')
    -- lualines
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    -- install treesitter GOAT syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    -- install harpoon for quickmenu file storage and switch
    use('theprimeagen/harpoon')
    -- install fugitive for insane git integration
    use('tpope/vim-fugitive')
    -- center a buffer for no neck pain
    -- use { "shortcuts/no-neck-pain.nvim", tag = "*" }
    -- install undotree for changes in files
    use('mbbill/undotree')
    -- install debugging plugins
    use { "leoluz/nvim-dap-go" }
    use { "nvim-neotest/nvim-nio" }
    use { "rcarriga/nvim-dap-ui" }
    -- cute little icons
    use('nvim-tree/nvim-web-devicons')
    -- UI component
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
    -- LSP and completion setup (no more lsp-zero)
-- Mason for LSP server installation
use {
  'williamboman/mason.nvim',
  config = function()
    require('mason').setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
  end
}

-- Mason LSP config (bridges mason with native LSP)
use {
  'williamboman/mason-lspconfig.nvim',
  after = 'mason.nvim',
  config = function()
    require('mason-lspconfig').setup({
      -- Automatically install these LSP servers
      ensure_installed = {
        'lua_ls',
        'gopls', 
        'yamlls',
        'terraformls',
      },
      automatic_installation = true,
    })
  end
}

-- Core completion engine
use {
  'hrsh7th/nvim-cmp',
  config = function()
    -- Your cmp config will be loaded from after/plugin/lsp.lua
  end
}

-- LSP completion source
use 'hrsh7th/cmp-nvim-lsp'

-- Snippet engine
use {
  'L3MON4D3/LuaSnip',
  tag = "v2.*",
  run = "make install_jsregexp"
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
end)
