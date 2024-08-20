return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			python = { "isort", "black" },

			javascript = { "eslint_d", "eslint", stop_after_first = true },
			javascriptreact = { "eslint_d", "eslint", stop_after_first = true },
			typescript = { "eslint_d", "eslint", stop_after_first = true },
			typescriptreact = { "eslint_d", "eslint", stop_after_first = true },


			json = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			scss = { "prettierd", "prettier", stop_after_first = true },
			graphql = { "prettierd", "prettier", stop_after_first = true },

			sql = { "sql-formatter" },

			go = { "gofumpt" },

			java = { "google-java-format" }
		},
		-- Customize formatters
		formatters = {},
	}
}
