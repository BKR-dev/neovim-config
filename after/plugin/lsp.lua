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

----------- JAVA Setuo ---------------
--
-- require('java').setup({
-- })
--
-- require('lspconfig').jdtls.setup({
--     settings = {
--         root_markers = {
--             '.git',
--             'pom.xml',
--
--         }
--     }
-- })
--
----------- JAVA Setuo ---------------

local cmp = require('cmp')
local copilot = require('copilot.suggestion')

local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<Tab>'] = function(fallback)
        if copilot.is_visible() then
            copilot.accept()
        elseif cmp.visible() then
            cmp.select_next_item()
        else
            fallback()
        end
    end,
    ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})


lsp.setup_nvim_cmp({
    mapping = cmp_mappings
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

-- vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })]]

-- vim.api.nvim_create_autocmd('BufWritePre', { pattern = '*.go', callback = function() vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true }) end })

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
require 'lspconfig'.vls.setup {
    on_attach = function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()
    end
}



-- sets up configuration
lsp.setup()
