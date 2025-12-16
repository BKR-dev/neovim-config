return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        ensure_installed = { "go", "gomod", "gosum", "gowork", "templ", "c", "lua", "vim", "vimdoc", "query", "javascript" },
        sync_install = false,
        highlight = {
            enable = true
        },
        auto_install = true,
    },
    config = function(_, opts)
        local status_ok, configs = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            return
        end

        configs.setup(opts)

        local status_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
        if status_parsers then
             local treesitter_parser_config = parsers.get_parser_configs()
             treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
        end

        vim.treesitter.language.register('templ', 'templ')
        vim.filetype.add({
            extension = {
                templ = "templ",
            },
        })
        vim.filetype.add({
            extension = {
                ["yml.tmpl"] = "yaml",
            },
        })
        vim.treesitter.language.register('yaml', 'yml.tmpl')

        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = "*.yml.tmpl",
            callback = function()
                vim.bo.filetype = "yaml" -- Force filetype to yaml
            end,
        })
    end
}
