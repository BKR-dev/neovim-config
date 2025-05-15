require('tokyonight').setup({
    style = 'storm',        -- 'storm', 'moon', 'night' (default is 'storm')
    transparent = false,    -- Remove background color
    terminal_colors = true, -- Use theme colors for Neovim terminal
    onedark = true,         -- Enable OneDark-style color palette
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
    },
    cache = true,
    lualine_bold = true,
})
vim.cmd('colorscheme tokyonight')
