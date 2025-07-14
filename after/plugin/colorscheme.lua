-- vim.opt.termguicolors = true
function SetTheme(theme)
    theme = "palenightfall"
    vim.cmd.colorscheme(theme)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
end

SetTheme()
