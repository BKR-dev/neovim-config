return {
    {
        "olimorris/codecompanion.nvim",
        version = "^18.0.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        sources = {
            per_filetype = {
                codecompanion = { "codecompanion" },
            }
        },
        opts = {
            interactions = {
                chat = {
                    adapter = {
                        name = "copilot",
                        model = "claude-sonnet-4.5",
                    },
                },
            },
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "DEBUG", -- or "TRACE"
            },
        },
    }
}
