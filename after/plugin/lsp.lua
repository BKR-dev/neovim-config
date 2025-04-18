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


-- fix the tab issue 
--


local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local copilot = require("copilot.suggestion") -- Ensure Copilot is properly set up

cmp.setup({
    mapping = {
        ["<Tab>"] = function(fallback)
            if copilot.is_visible() then
                copilot.accept()
            elseif cmp.visible() then
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
