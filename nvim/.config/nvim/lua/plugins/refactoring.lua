return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim"
	},
	config = function()
		require("refactoring").setup()

		vim.keymap.set("x", "<leader>re", function() require('refactoring').refactor('Extract Function') end, {desc='Extract Function'})
		vim.keymap.set("x", "<leader>rf", function() require('refactoring').refactor('Extract Function To File') end, {desc='Extract Function To File'})
		-- Extract function supports only visual mode
		vim.keymap.set("x", "<leader>rv", function() require('refactoring').refactor('Extract Variable') end, {desc='Extract Variable'})
		-- Extract variable supports only visual mode
		vim.keymap.set("n", "<leader>rI", function() require('refactoring').refactor('Inline Function') end, {desc='Inline Function'})
		-- Inline func supports only normal
		vim.keymap.set({ "n", "x" }, "<leader>ri", function() require('refactoring').refactor('Inline Variable') end, {desc='Inline Variable'})
		-- Inline var supports both normal and visual mode

		vim.keymap.set("n", "<leader>rb", function() require('refactoring').refactor('Extract Block') end, {desc='Extract Block'})
		vim.keymap.set("n", "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end, {desc='Extract Block To File'})
		-- Extract block supports only normal mode

		-- load refactoring Telescope extension
		require("telescope").load_extension("refactoring")

		vim.keymap.set(
			{ "n", "x" },
			"<leader>rr",
			function() require('telescope').extensions.refactoring.refactors() end, {desc="Refactor select"}
		)

		-- You can also use below = true here to to change the position of the printf
		-- statement (or set two remaps for either one). This remap must be made in normal mode.
		vim.keymap.set(
			"n",
			"<leader>rdp",
			function() require('refactoring').debug.printf({ below = false }) end,
			{desc="Debug printf"}
		)

		-- Print var

		vim.keymap.set({ "x", "n" }, "<leader>rdv", function() require('refactoring').debug.print_var() end, {desc="Debug print variable"})
		-- Supports both visual and normal mode

		vim.keymap.set("n", "<leader>rdc", function() require('refactoring').debug.cleanup({}) end, {desc="Debug cleanup"})
		-- Supports only normal mode
	end,
}
