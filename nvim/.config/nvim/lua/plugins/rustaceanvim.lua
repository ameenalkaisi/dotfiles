return {
	'mrcjkb/rustaceanvim',
	-- version = '^4', -- Recommended
	ft = { 'rust' },
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		vim.g.rustaceanvim = function()
			local custom_on_attach = require("global.lsp").on_attach

			return {
				server = {
					on_attach = custom_on_attach,
				},
			}
		end
	end
}
