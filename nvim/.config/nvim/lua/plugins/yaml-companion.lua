return {
	"someone-stole-my-name/yaml-companion.nvim",
	ft = { "yml", "yaml" },
	dependencies= {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		local telescope = require("telescope")
		telescope.load_extension("yaml_schema")
		vim.keymap.set("n", "<leader>py", telescope.extensions.yaml_schema.yaml_schema)
	end,
}
