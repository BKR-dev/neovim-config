require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = { "go", "gomod", "gosum", "gowork", "c", "lua", "vim", "vimdoc", "query", "javascript" },

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,
	highlight = {
		enable = true
	},
	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

}
local treesitter_parser_config = require "nvim-treesitter.parsers".get_parser_configs()
treesitter_parser_config.templ = {
  install_info = {
    url = "https://github.com/vrischmann/tree-sitter-templ.git",
    files = {"src/parser.c", "src/scanner.c"},
    branch = "master",
  },
}

vim.treesitter.language.register('templ', 'templ')
