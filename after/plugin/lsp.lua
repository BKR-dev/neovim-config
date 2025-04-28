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


-- Enhanced hover handler for better formatting
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  -- Format Go documentation more nicely
  if syntax == "go" or syntax == "gomod" then
    -- Process contents for better readability
    local formatted_contents = {}
    for _, line in ipairs(contents) do
      -- Split long lines at meaningful breaks
      if #line > 80 then
        line = line:gsub("(%S)%.(%S)", "%1.\n%2")  -- Break after periods
      end
      table.insert(formatted_contents, line)
    end
    contents = formatted_contents
  end
  
  -- Configure the floating window
  opts = opts or {}
  opts.border = opts.border or "rounded"
  opts.max_width = opts.max_width or 100
  opts.max_height = opts.max_height or 30
  
  -- Return the floating window using the original function
  return orig_util_open_floating_preview(contents, syntax, opts)
end

-- Set hover handler with improved formatting and wrapping
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    width = 100,
    border = "rounded",
    wrap = true,
    max_height = 30,
    max_width = 100,
  }
)

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
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
  
  -- Define diagnostic signs
  local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

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
