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

		local theme_config_file = vim.fn.stdpath("config") .. "/lua/settings/theme.lua"

		require("global.utils").touch_file(theme_config_file,
			[[
-- Themery block
-- This block will be replaced by Themery.
-- end themery block]])

		require("themery").setup({
			themes = { "gruvbox", "dayfox", "kanagawa", "catppuccin", "carbonfox", "duskfox", "rose-pine", "slate" },
			themeConfigFile = theme_config_file,
		})
	end,
}
