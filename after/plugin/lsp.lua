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
<<<<<<< HEAD
=======
    'tsserver',
    'html',
    'tailwindcss',
>>>>>>> a3efbae (no idea whats going on i forgot)
})

-- always use active LS to fromat on save
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

require('lspconfig').gopls.setup({
    usePlaceholders = true,
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
<<<<<<< HEAD
})

-- add templ files to lsp
vim.filetype.add({
    extension = {
        templ = "templ"
    },
=======
>>>>>>> a3efbae (no idea whats going on i forgot)
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
