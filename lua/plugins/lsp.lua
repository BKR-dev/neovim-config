return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = false,
        config = false,
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
            { 'williamboman/mason.nvim' },
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { "gopls", "lua_ls", "jsonls" },
            })
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-calc' },
            { 'ray-x/cmp-treesitter' },
            { 'petertriho/cmp-git' },
            { 'saadparwaiz1/cmp_luasnip' },
        },
        config = function()
            local cmp = require('cmp')

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })

            cmp.setup({
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    { name = 'path' },
                }, {
                    { name = 'buffer',    keyword_length = 3 },
                    { name = 'nvim_lua' },
                    { name = 'calc' },
                    { name = 'treesitter' },
                    { name = 'git' },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        }
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snip]",
                            buffer = "[Buf]",
                            path = "[Path]",
                            nvim_lua = "[Lua]",
                            calc = "[Calc]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = {
                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                    ["<CR>"] = cmp.mapping.confirm({
                        select = true,
                        behavior = cmp.ConfirmBehavior.Replace
                    }),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
            -- Setup git source
            require("cmp_git").setup()
        end
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'VonHeikemen/lsp-zero.nvim' },
        },
        config = function()
            -- HOTFIX: Neovim 0.11+ E216 error workaround
            pcall(vim.api.nvim_create_augroup, "nvim.lsp.enable", { clear = false })

            local lsp = require('lsp-zero')
            lsp.extend_lspconfig()

            -- Set up keymaps and autoformat on attach
            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })

                -- Enable format on save
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end)

            -- Configure Lua LSP using vim.lsp.config (Neovim 0.11+ API)
            vim.lsp.config.lua_ls = {
                cmd = { 'lua-language-server' },
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            }

            -- Configure gopls with full settings
            vim.lsp.config.gopls = {
                cmd = { 'gopls' },
                settings = {
                    gopls = {
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                            unusedvars = true,
                            shadowedvars = true,
                            deadcode = true,
                            nilness = true,
                            useany = true,
                            unusedwrite = true,
                            undeclaredname = true,
                        },
                        gofumpt = true,
                        staticcheck = true,
                        codelenses = {
                            gc_details = true,
                            generate = true,
                            regenerate_cgo = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                            run_govulncheck = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        semanticTokens = true,
                        directoryFilters = { "-node_modules", "-vendor" },
                        symbolMatcher = "fuzzy",
                        symbolStyle = "dynamic",
                        hoverKind = "FullDocumentation",
                        linkTarget = "pkg.go.dev",
                        linksInHover = true,
                        importShortcut = "Definition",
                    },
                },
                on_attach = function(client, bufnr)
                    -- Apply default keymaps
                    lsp.default_keymaps({ buffer = bufnr })

                    -- Ensure imports are organized on save
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = "*.go",
                        callback = function()
                            local current_buf = vim.api.nvim_get_current_buf()

                            -- Organize imports before saving
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }
                            local result = vim.lsp.buf_request_sync(current_buf, "textDocument/codeAction", params, 3000)

                            if result and result[1] then
                                local actions = result[1].result

                                if actions and actions[1] then
                                    vim.lsp.buf.code_action({
                                        filter = function(action)
                                            return action.title == "Organize Imports"
                                        end,
                                        apply = true
                                    })
                                end
                            end

                            -- Format the buffer
                            vim.lsp.buf.format({ async = false })
                        end,
                        group = vim.api.nvim_create_augroup("GoImports", { clear = true }),
                    })
                end
            }

            -- Add templ files to lsp
            vim.filetype.add({
                extension = {
                    templ = "templ"
                },
            })

            -- Setup terraform lsp
            vim.lsp.config.terraformls = {
                cmd = { 'terraform-ls', 'serve' },
            }

            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.tf", "*.tfvars" },
                callback = function()
                    vim.lsp.buf.format()
                end,
            })

            -- Add keymap to see full diagnostics
            vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })

            -- Configure diagnostics display
            vim.diagnostic.config({
                virtual_text = {
                    prefix = '● ',
                    spacing = 4,
                    format = function(diagnostic)
                        if #diagnostic.message > 80 then
                            return "See details... [Press <leader>ld]"
                        end
                        return diagnostic.message
                    end,
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "✘",
                        [vim.diagnostic.severity.WARN] = "▲",
                        [vim.diagnostic.severity.HINT] = "⚑",
                        [vim.diagnostic.severity.INFO] = "»",
                    },
                },
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = false,
                    style = 'minimal',
                    border = 'rounded',
                    source = 'always',
                    header = '',
                    prefix = '',
                },
            })

            -- Setup lsp-zero
            lsp.setup()
        end
    }
}
