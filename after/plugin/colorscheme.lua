vim.api.nvim_set_hl(0, "LineNr", { fg = "#ffffff" })                     -- Farbe für Zeilennummern ohne Cursor
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c8c8c8", ctermfg = 12 }) -- Farbe für Zeilennummer mit Cursor
require('tokyonight').setup({
    style = 'storm',
    transparent = true,
    terminal_colors = true,
    onedark = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
    },
    cache = true,
    lualine_bold = true,
})
