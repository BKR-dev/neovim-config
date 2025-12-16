local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
    spec = {
        -- Import your plugin specs
        { import = "lio.plugins" },
    },
    git = {
        -- Use SSH instead of HTTPS
        url_format = "git@github.com:%s.git",
        -- Or force HTTPS with credentials
        -- url_format = "https://github.com/%s.git",
    },
    defaults = {
        lazy = false,    -- should plugins be lazy-loaded?
        version = false, -- always use the latest git commit
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = true }, -- automatically check for plugin updates
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
