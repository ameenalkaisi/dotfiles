return {
	'mrcjkb/rustaceanvim',
	version = '^5',
	lazy = false,
	config = function()
		vim.g.rustaceanvim = function()
			return {
				-- Plugin configuration
				tools = {
				},
				-- LSP configuration
				server = {
					on_attach = require("global.lsp").on_attach,
					default_settings = {
						-- rust-analyzer language server configuration
						['rust-analyzer'] = {
						},
					},
				},
				-- DAP configuration
				dap = {
				},
			}
		end
	end
}
