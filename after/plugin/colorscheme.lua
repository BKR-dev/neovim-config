function SetTheme(theme)
    theme = "palenightfall"
    vim.cmd.colorscheme(theme)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetTheme()
