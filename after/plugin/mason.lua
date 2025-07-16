require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
    },
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "awk_ls",         -- awk-language-server
        "bashls",         -- bash-language-server
        "cmake",          -- cmake-language-server
        "dockerls",       -- dockerfile-language-server
        "gopls",          -- gopls
        "helm_ls",        -- helm-ls
        "html",           -- html-lsp
        "lua_ls",         -- lua-language-server
        "terraformls",    -- terraform-ls
        "tsserver",       -- typescript-language-server
        "yamlls",         -- yaml-language-server
    },
    automatic_installation = true,
})
