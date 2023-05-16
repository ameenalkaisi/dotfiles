return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		require("telescope").load_extension("live_grep_args")
		vim.keymap.set("n", "<leader>pa", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
	end,
}
