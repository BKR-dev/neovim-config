-- vim.opt.termguicolors = true
function SetTheme(theme)
    theme = "palenightfall"
    vim.cmd.colorscheme(theme)
    -- keep verything nice and transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- make braces. parenthesis and brackets better visible which doesnt work sadly
    -- vim.api.nvim_set_hl(0, "TSBraces", { fg = "#FF00FF", bg = "#FFFFFF", bold = true })
    -- vim.api.nvim_set_hl(0, "TSParenthesis", { fg = "#00FFFF", bg = "#FFFFFF", bold = true })
    -- vim.api.nvim_set_hl(0, "TSBracket", { fg = "#FFFF00", bg = "#FFFFFF", bold = true })
    vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
end

SetTheme()
