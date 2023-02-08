return {
	'mfussenegger/nvim-jdtls',
	'tpope/vim-repeat',
	-- {
	-- 	'rose-pine/neovim',
	-- 	name = 'rose-pine',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("rose-pine").setup()
	-- 		vim.cmd('colorscheme rose-pine')
	-- 	end
	-- },
	{
		'NMAC427/guess-indent.nvim',
		config = true
	},
	{
		'ellisonleao/gruvbox.nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd('colorscheme gruvbox')
		end
	},
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
			require("which-key").setup()
		end,
	},
	{
		'goolord/alpha-nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require 'alpha'.setup(require 'alpha.themes.startify'.config)
		end
	},
	'nvim-treesitter/playground',
	{
		'kylechui/nvim-surround',
		config = true
	},
	-- lsp, autocompletion, and snippets
	-- use('github/copilot.vim')
	{
		'simrat39/symbols-outline.nvim',
		config = function()
			require('symbols-outline').setup()

			vim.keymap.set('n', '<leader>so', vim.cmd.SymbolsOutline)
		end
	},
	{
		'akinsho/bufferline.nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = true
	},
	{
		'norcalli/nvim-colorizer.lua',
		config = true
	},
	{
		'numToStr/Comment.nvim',
		config = true
	},
	{
		'windwp/nvim-autopairs',
		config = true
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		config = true
	},

	-- dap related plugins
	{
		'theHamsta/nvim-dap-virtual-text',
		dependencies = { 'nvim-treesitter', 'nvim-dap' },
		config = true
	}
}
