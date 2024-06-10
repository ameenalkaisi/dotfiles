return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mrcjkb/rustaceanvim",
		"rcasia/neotest-java",
		"stevanmilic/neotest-scala"
	},
	config = function()
		require('neotest').setup {
			adapters = {
				require('rustaceanvim.neotest'),
				--[[ require("neotest-java")({
					-- why is there shada files
					-- ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
					-- junit_jar = "path/to/junit-standalone.jar",
					-- default: .local/share/nvim/neotest-java/junit-platform-console-standalone-[version].jar
				}), ]]
				require("neotest-scala")({
					-- Command line arguments for runner
					-- Can also be a function to return dynamic values
					--[[ args = { "--no-color" }, ]]
					-- Runner to use. Will use bloop by default.
					-- Can be a function to return dynamic value.
					-- For backwards compatibility, it also tries to read the vim-test scala config.
					-- Possibly values bloop|sbt.
					--[[ runner = "bloop", ]]
					-- Test framework to use. Will use utest by default.
					-- Can be a function to return dynamic value.
					-- Possibly values utest|munit|scalatest.
					--[[ framework = "utest", ]]
				})
			},
		}
	end
}
