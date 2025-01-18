-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt}
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here

        -- Install Palenightfall colorscheme
        { 'JoosepAlviste/palenightfall.nvim' },

        -- install telescope for neat file finds
        {
            'nvim-telescope/telescope.nvim',
            version = '0.1.2',
            -- or , branch = '0.1.x',
            requires = { 'nvim-lua/plenary.nvim' }
        },

        -- easy to use comments
        { 'numToStr/Comment.nvim' },

        -- install treesitter GOAT syntax highlighting
        { 'nvim-treesitter/nvim-treesitter', { build = ':TSUpdate' } },

        -- install harpoon for quickmenu file storage and switch
        { 'theprimeagen/harpoon' },


        -- center a buffer for no neck pain
        { "shortcuts/no-neck-pain.nvim" },

        -- install undotree for changes in files
        { 'mbbill/undotree' },

        -- install debugging plugins
        { 'mfussenegger/nvim-dap' },
        { "leoluz/nvim-dap-go" },
        { "nvim-neotest/nvim-nio" },
        { "rcarriga/nvim-dap-ui" },
        {
            'folke/todo-comments.nvim',
            requires = "nvim-lua/plenary.nvim",
        },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "palenightfall" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
