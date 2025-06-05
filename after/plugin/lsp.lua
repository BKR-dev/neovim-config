local lsp = require('lsp-zero')

-- use reasonable preset
lsp.preset('recommended')

-- fix undefined "vim" global
lsp.nvim_workspace()

-- make sure these LS are installed
lsp.ensure_installed({
    'gopls',
    'eslint',
    'lua_ls',
    'html',
    'yamlls',
})

-- always use active LS to fromat on save
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

require('lspconfig').gopls.setup({
    usePlaceholders = true,
})

require('lspconfig').yamlls.setup {

    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = "*.yaml",
            },
        },
    },
}

-- Add a keymap to see full diagnostics
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })

-- fix the tab issue
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
        { name = 'emoji' },                         -- Emoji completion
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

-- Enable gopls settings
local lsp_settings = {
    usePlaceholders = true,
    analyses = {
        unusedparams = true,
        unusedvars = true,
        shadowedvars = true,
        deadcode = true,
    },
}

-- Setup gopls
require('lspconfig').gopls.setup({
    settings = lsp_settings,
})

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
require 'lspconfig'.vls.setup {
    on_attach = function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()
    end
}

-- setup typescript ls
require 'lspconfig'.ts_ls.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
}

-- cssls
require 'lspconfig'.cssls.setup {}

-- tailwindcss lsp
require 'lspconfig'.tailwindcss.setup {}

-- sets up configuration
lsp.setup()
