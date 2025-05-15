require 'colorizer'.setup({
    '*',
}, {
    RGB = true,          -- Enable RGB color codes
    RRGGBB = true,       -- Enable RRGGBB color codes
    names = true,        -- Disable color names like "red"
    RRGGBBAA = true,     -- Enable RRGGBBAA color codes
    rgb_fn = true,       -- Enable CSS rgb() and rgba() functions
    hsl_fn = true,       -- Enable CSS hsl() and hsla() functions
    css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
    mode = 'background', -- Set the display mode to background (other options: 'foreground', 'virtualtext')
})
