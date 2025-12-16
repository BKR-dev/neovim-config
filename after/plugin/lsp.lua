-- Check if new API is available
if not vim.lsp.config then
    vim.notify("Neovim 0.11+ required for vim.lsp.config", vim.log.levels.WARN)
    return
end

-- Default keymaps function (replaces lsp.default_keymaps)
local function setup_keymaps(bufnr)
    local opts = { buffer = bufnr, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
        vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Find references' }))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code actions' }))
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end,
        vim.tbl_extend('force', opts, { desc = 'Format buffer' }))

    -- Diagnostics
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- Common on_attach function (replaces lsp.on_attach)
local function on_attach(client, bufnr)
    -- Set up keymaps
    setup_keymaps(bufnr)

    -- Enable format on save
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end
end

-- Configure LSP servers using vim.lsp.config (new API)
vim.lsp.config.lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', '.git' },
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = on_attach,
}

vim.lsp.config.yamlls = {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yml' },
    root_markers = { '.git', 'kustomization.yaml', 'kustomization.yml' },
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = {
                    "*.yaml",
                    "*.yaml.j2"
                },
            },
            validate = true,
            completion = true,
        },
    },
    on_attach = on_attach,
}

-- gopls setup with your exact configuration
vim.lsp.config.gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.mod', 'go.work', '.git' },
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
        -- Apply default keymaps and format on save
        on_attach(client, bufnr)

        -- Go-specific: organize imports on save
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
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

-- setup terraform lsp
vim.lsp.config.terraformls = {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'tf' },
    root_markers = { '.terraform', '.git' },
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Terraform format on save (in addition to the general format on save)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            pattern = { "*.tf", "*.tfvars" },
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end,
}

-- add templ files to lsp
vim.filetype.add({
    extension = {
        templ = "templ"
    },
})

-- Auto-enable LSP servers based on filetype
local filetype_to_server = {
    lua = 'lua_ls',
    yaml = 'yamlls',
    yml = 'yamlls',
    go = 'gopls',
    gomod = 'gopls',
    gowork = 'gopls',
    gotmpl = 'gopls',
    terraform = 'terraformls',
    tf = 'terraformls',
    templ = 'gopls', -- if you want gopls for templ files
}

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local server = filetype_to_server[args.match]
        if server then
            vim.lsp.enable(server)
        end
    end,
})

-- Add a keymap to see full diagnostics (your existing config)
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })

-- Diagnostic configuration (your existing config)
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

-- Your existing completion setup (unchanged)
local cmp = require('cmp')
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })

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
