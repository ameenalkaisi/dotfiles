return {
	'zaldih/themery.nvim',
	dependencies = {
		"rose-pine/neovim",
		"ellisonleao/gruvbox.nvim",
		"EdenEast/nightfox.nvim",
		"rebelot/kanagawa.nvim",
		"catppuccin/nvim",
	},
	lazy = false,
	priority = 1000,
	config = function()
		require("rose-pine").setup()

		require("themery").setup({
			themes = { "gruvbox", "dayfox", "kanagawa", "catppuccin", "carbonfox", "duskfox", "rose-pine", "slate" },
		})
	end,
}
