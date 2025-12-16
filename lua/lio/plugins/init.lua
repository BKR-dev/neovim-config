return {
    -- Tmux integration
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
        config = function()
            dofile(vim.fn.stdpath("config") .. "/after/plugin/tmux-navigator.lua")
        end,
    },

    -- Colorschemes
    {
        "folke/tokyonight.nvim",
        name = "tokyonight", -- Important: explicit name
        lazy = false,
        priority = 1000,     -- Load before other plugins
        lazy = false,        -- Don't lazy load colorschemes
        config = function()
            -- Load tokyonight first
            require("tokyonight").setup({
                style = "night", -- storm, moon, night, day
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                },
            })

            -- Set colorscheme immediately
            vim.cmd.colorscheme("tokyonight")

            -- Then load your colorscheme config if you have additional settings
            local colorscheme_config = vim.fn.stdpath("config") .. "/after/plugin/colorscheme.lua"
            if vim.fn.filereadable(colorscheme_config) == 1 then
                dofile(colorscheme_config)
            end
        end,
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.2",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        dependencies = { "telescope.nvim",
            "nvim-treesitter/nvim-treesitter" },
    },

    -- LSP and Mason
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "gopls",
                "yamlls",
                "terraformls",
            },
            automatic_installation = true,
        },
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-calc",
            "hrsh7th/cmp-emoji",
            "ray-x/cmp-treesitter",
            "petertriho/cmp-git",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        event = "InsertEnter",
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = { "lua", "go", "yaml", "terraform", "markdown" },
            highlight = { enable = true },
            indent = { enable = true },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
                java = false,
            }
        },
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n",          desc = "Comment toggle current line" },
            { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
            { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
        },
        config = true,
    },

    -- Lualine
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons",
            "folke/tokyonight.nvim" },
    },

    -- Navigation and Git
    {
        "theprimeagen/harpoon",
        keys = {
            { "<leader>ha", function() require("harpoon.mark").add_file() end,        desc = "Harpoon Add" },
            { "<leader>hm", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon Menu" },
        },
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
    },
    {
        "mbbill/undotree",
        keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
    },

    -- DAP (Debugging)
    { "mfussenegger/nvim-dap",       lazy = true },
    { "leoluz/nvim-dap-go",          ft = "go" },
    { "nvim-neotest/nvim-nio",       lazy = true },
    { "rcarriga/nvim-dap-ui",        lazy = true },

    -- UI and Diagnostics
    { "nvim-tree/nvim-web-devicons", lazy = true },
    { "MunifTanjim/nui.nvim",        lazy = true },
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_lines").setup()
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "BufReadPost", "BufNewFile" },
        config = true,
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function() 
            require('nvim-treesitter.configs').setup({
                -- A list of parser names, or "all" (the five listed parsers should always be installed)
                ensure_installed = {
                    "go", "gomod", "gosum", "gowork", "templ",
                    "c", "lua", "vim", "vimdoc", "query", "javascript",
                    "yaml", "json", "bash", "dockerfile", "terraform" -- Added some useful ones
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = true,

                -- Enable incremental selection
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },

                -- Enable indentation
                indent = {
                    enable = true,
                },
            })

            -- Custom parser configurations
            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()

            -- Templ parser configuration
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }

            -- Register templ language
            vim.treesitter.language.register('templ', 'templ')

            -- Filetype associations
            vim.filetype.add({
                extension = {
                    templ = "templ",
                    ["yml.tmpl"] = "yaml",
                },
            })

            -- Register yaml for yml.tmpl files
            vim.treesitter.language.register('yaml', 'yml.tmpl')

            -- Autocmd for yml.tmpl files
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.yml.tmpl",
                callback = function()
                    vim.bo.filetype = "yaml" -- Force filetype to yaml
                end,
            })
        end,
    },
}
