-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use('wbthomason/packer.nvim')
	-- Install Palenightfall colorscheme
	use('JoosepAlviste/palenightfall.nvim')
	-- install telescope for neat file finds
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		-- or , branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}
	-- install treesitter GOAT syntax highlighting
	use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

	-- install harpoon for quickmenu file storage and switch
	use('theprimeagen/harpoon')

	-- install fugitive for insane git integration
	use('tpope/vim-fugitive')

	-- install undotree for changes in files
	use('mbbill/undotree')

	-- install lsp-zero for lsp support
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		requires = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{       -- Optional
				'williamboman/mason.nvim',
				run = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' }, -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' }, -- Required
		}
	}
end)
