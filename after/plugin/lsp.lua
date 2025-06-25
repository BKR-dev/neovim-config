local lsp = require('lsp-zero')

-- use reasonable preset
lsp.preset('manual')

-- always use active LS to fromat on save
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)


lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

require('lspconfig').yamlls.setup {
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = { "*.yaml", "*.yaml.j2" },
            },
        },
    },
}

-- Add a keymap to see full diagnostics
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })
vim.diagnostic.config({
    virtual_text = {
        prefix = '● ',
        spacing = 4,
        format = function(diagnostic)
            -- For long messages, just show an indicator
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

local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },                      -- LSP
        { name = 'nvim_lsp_signature_help' },       -- Function signatures
        { name = 'luasnip' },                       -- Snippets
        { name = 'path' },                          -- File paths
    }, {
        { name = 'buffer',    keyword_length = 3 }, -- Buffer text (min 3 chars)
        { name = 'nvim_lua' },                      -- Neovim Lua API
        { name = 'calc' },                          -- Math calculations
        { name = 'treesitter' },                    -- Treesitter-based completion
        { name = 'git' },                           -- Git completion (commit hashes, branches)
    }),
    formatting = {
        format = function(entry, vim_item)
            -- Fancy icons for different types
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
            -- Show source name
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
        -- Add Enter mapping to confirm selection
        ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
        }),
    },
    -- Add snippet support explicitly
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})


------------ gopls setup -----------------------
-- Setup gopls
lsp.configure('gopls', {
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
            -- Add these settings for better import handling
            gofumpt = true,
            staticcheck = true,
            -- Enable import organization
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
    -- Ensure imports are organized on save
    on_attach = function(bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                -- Organize imports before saving
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }

                local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
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
    end,
})

------------ gopls setup -----------------------

-- add templ files to lsp
vim.filetype.add({
    extension = {
        templ = "templ"
    },
})

-- setup terraform lsp
require 'lspconfig'.terraformls.setup {}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        vim.lsp.buf.format()
    end,
})


-- setup vtsls lsp
-- require 'lspconfig'.vls.setup {
--     on_attach = function(bufnr)
--         lsp.default_keymaps({ buffer = bufnr })
--         lsp.buffer_autoformat()
--     end
-- }

-- sets up configuration
lsp.setup()
