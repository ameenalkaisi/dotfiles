return {
	"someone-stole-my-name/yaml-companion.nvim",
	ft = { "yml", "yaml" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",

		"neovim/nvim-lspconfig",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- setup telescope
		local telescope = require("telescope")
		telescope.load_extension("yaml_schema")
		vim.keymap.set("n", "<leader>py", telescope.extensions.yaml_schema.yaml_schema, {desc="Select yaml schema"})

		-- setup lsp similar to lsp.lua
		local lspconfig = require("lspconfig")

		local custom_on_attach = require("global.lsp").on_attach
		local custom_capabilities = require("global.lsp").create_capabilities(require("cmp_nvim_lsp"))

		local cfg = require("yaml-companion").setup({
			on_attach = custom_on_attach,
			capabilities = custom_capabilities,
		})

		lspconfig.yamlls.setup(cfg)
	end,
}
