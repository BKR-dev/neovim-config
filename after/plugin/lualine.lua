require('lualine').setup {
    options = {
        theme = 'auto',
        section_separators = { '', '' },
        component_separators = { '', '' },
    },
    sections = {
        lualine_a = {
            {
                'mode',
                color = function()
                    local mode_color = {
                        n = '#1d1f21',     -- Normal
                        i = '#282a36',     -- Insert
                        v = '#44475a',     -- Visual
                        V = '#44475a',     -- Visual Line
                        [''] = '#44475a', -- Visual Block
                        c = '#8be9fd',     -- Command
                        t = '#ffb86c',     -- Terminal
                    }
                    return { fg = mode_color[vim.fn.mode()] }
                end
            }
        },
        lualine_b = { 'branch' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}
vim.o.showmode = false
vim.api.nvim_set_hl(0, 'Cmdline', { bg = '#1c1f2b', fg = '#f8f8f2' })
