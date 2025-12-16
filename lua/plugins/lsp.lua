return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
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
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({buffer = bufnr})
                
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = bufnr })
                        end,
                    })
                end
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {
                    "awk_ls", "bashls", "cmake", "dockerls", "gopls", 
                    "helm_ls", "html", "lua_ls", "terraformls", "yamlls",
                },
                automatic_installation = true,
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
                                    analyses = { unusedparams = true, unusedvars = true, shadowedvars = true, deadcode = true, nilness = true, useany = true, unusedwrite = true, undeclaredname = true },
                                    gofumpt = true,
                                    staticcheck = true,
                                    codelenses = { gc_details = true, generate = true, regenerate_cgo = true, test = true, tidy = true, upgrade_dependency = true, vendor = true, run_govulncheck = true },
                                    hints = { assignVariableTypes = true, compositeLiteralFields = true, compositeLiteralTypes = true, constantValues = true, functionTypeParameters = true, parameterNames = true, rangeVariableTypes = true },
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
                                lsp_zero.default_keymaps({ buffer = bufnr })
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    pattern = "*.go",
                                    callback = function()
                                        local current_buf = vim.api.nvim_get_current_buf()
                                        local params = vim.lsp.util.make_range_params()
                                        params.context = { only = { "source.organizeImports" } }
                                        local result = vim.lsp.buf_request_sync(current_buf, "textDocument/codeAction", params, 3000)
                                        if result and result[1] then
                                            local actions = result[1].result
                                            if actions and actions[1] then
                                                vim.lsp.buf.code_action({
                                                    filter = function(action) return action.title == "Organize Imports" end,
                                                    apply = true
                                                })
                                            end
                                        end
                                        vim.lsp.buf.format({ async = false })
                                    end,
                                    group = vim.api.nvim_create_augroup("GoImports", { clear = true }),
                                })
                            end
                       })
                    end,
                    yamlls = function()
                         require('lspconfig').yamlls.setup({
                            settings = {
                                yaml = {
                                    schemas = {
                                        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = { "*.yaml", "*.yaml.j2" },
                                    },
                                },
                            },
                        })
                    end,
                    terraformls = function()
                         require('lspconfig').terraformls.setup({
                             cmd = { 'terraform-ls', 'serve' },
                         })
                    end
                }
            })
            
            vim.filetype.add({ extension = { templ = "templ" }, })
            
            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                pattern = { "*.tf", "*.tfvars" },
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
            
             vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })

            vim.diagnostic.config({
                virtual_text = {
                    prefix = '● ',
                    spacing = 4,
                    format = function(diagnostic)
                        if #diagnostic.message > 80 then return "See details... [Press <leader>ld]" end
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
        end
    },
    {
        'hrsh7th/nvim-cmp',
         dependencies = {
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-calc',
            'hrsh7th/cmp-emoji',
            'ray-x/cmp-treesitter',
            'petertriho/cmp-git',
            'saadparwaiz1/cmp_luasnip',
            'L3MON4D3/LuaSnip',
         },
         config = function()
            local cmp = require('cmp')
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
                            Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "", Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "", Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠", Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘", File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "", Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕", TypeParameter = "",
                        }
                        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]", path = "[Path]", nvim_lua = "[Lua]", calc = "[Calc]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                mapping = {
                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then cmp.select_next_item() elseif has_words_before() then cmp.complete() else fallback() end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then cmp.select_prev_item() else fallback() end
                    end,
                    ["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })
         end
    }, 
    {
         "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
         config = function()
             require("lsp_lines").setup()
         end,
    }
}
