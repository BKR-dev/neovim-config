
-- Hotfix for Neovim 0.11+ / lspconfig interaction
-- See vim E216: No such group or event: nvim.lsp.enable
pcall(vim.api.nvim_create_augroup, "nvim.lsp.enable", { clear = false })

require("lio.remap")
require("lio.set")

require("lio.floatterminal")
