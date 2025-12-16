return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = false,
        config = false,
        init = function()
            -- Disable automatic setup, we will do it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        dependencies = {
            {'williamboman/mason.nvim'},
            {'VonHeikemen/lsp-zero.nvim'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            
            require('mason-lspconfig').setup({
                ensure_installed = {"gopls", "lua_ls"},
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls()
                        require('lspconfig').lua_ls.setup(lua_opts)
                    end,
                    gopls = function()
                        require('lspconfig').gopls.setup({
                            settings = {
                                gopls = {
                                    usePlaceholders = true,
                                    analyses = { unusedparams = true },
                                    gofumpt = true,
                                    staticcheck = true,
                                    directoryFilters = { "-node_modules", "-vendor" },
                                },
                            },
                        })
                    end,
                },
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'rafamadriz/friendly-snippets'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            local cmp = require('cmp')
            local cmp_action = lsp_zero.cmp_action()

            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                sources = {
                    {name = 'path'},
                    {name = 'nvim_lsp'},
                    {name = 'luasnip', keyword_length = 2},
                    {name = 'buffer', keyword_length = 3},
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({select = true}),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<Tab>'] = cmp_action.luasnip_supertab(),
                    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason-lspconfig.nvim'},
            {'VonHeikemen/lsp-zero.nvim'},
        },
        config = function()
            -- HOTFIX: Neovim 0.11+ E216 error workaround
            pcall(vim.api.nvim_create_augroup, "nvim.lsp.enable", { clear = false })

            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function() vim.lsp.buf.format({bufnr = bufnr}) end
                    })
                end
            end)
        end
    }
}
