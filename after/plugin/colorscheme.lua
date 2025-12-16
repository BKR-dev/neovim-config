function SetTheme(theme)
    vim.cmd.colorscheme(theme)
    -- Custom Highlihgts
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })                                       -- make stuff transparent because thats nice
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })                                  -- make stuff transparent because thats nice
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#789cac", bg = "#44475a" })                    -- blueish-grey foreground, dark gray background
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e4dbc2", bg = "#44475a", bold = true }) -- Highlight current line number
    vim.api.nvim_set_hl(0, "Comment", { fg = "#789cac", bg = "#2e3440", italic = true })    -- give comments the same look as linenumbers
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#ff79c6", bold = true })   -- make bracket pairs easier to see
end

SetTheme()
