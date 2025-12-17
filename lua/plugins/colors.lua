return {
    {
        'JoosepAlviste/palenightfall.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- Define the SetTheme function
            function SetTheme(theme)
                theme = theme or "palenightfall"
                vim.cmd.colorscheme(theme)
                -- Custom Highlights
                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })                                       -- make stuff transparent
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })                                  -- make stuff transparent
                vim.api.nvim_set_hl(0, "LineNr", { fg = "#789cac", bg = "#44475a" })                    -- blueish-grey foreground
                vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e4dbc2", bg = "#44475a", bold = true }) -- Highlight current line
                vim.api.nvim_set_hl(0, "Comment", { fg = "#789cac", bg = "#2e3440", italic = true })    -- comments look like linenumbers
                vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#ff79c6", bold = true })   -- bracket pairs
            end
            
            SetTheme()
        end
    }
}
