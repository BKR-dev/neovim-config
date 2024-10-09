function SetTheme(theme)
    theme = theme or current_theme
    vim.cmd.colorscheme(theme)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ToggleTheme()
    if current_theme == "palenightfall" then
        current_theme = "catppuccin"
    else
        current_theme = "palenightfall"
    end
    SetTheme(current_theme)
end

SetTheme()
