return {
	"j-morano/buffer_manager.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local opts = { noremap = true }
		local map = vim.keymap.set

		-- Setup
		require("buffer_manager").setup({
			select_menu_item_commands = {
				v = {
					key = "<C-v>",
					command = "vsplit"
				},
				h = {
					key = "<C-h>",
					command = "split"
				}
			},
			focus_alternate_buffer = false,
			short_file_names = true,
			short_term_names = true,
			loop_nav = false,
			highlight = 'Normal:BufferManagerBorder',
			win_extra_options = {
				winhighlight = 'Normal:BufferManagerNormal',
			},
		})

		-- Navigate buffers bypassing the menu
		local bmui = require("buffer_manager.ui")
		local keys = '1234567890'
		for i = 1, #keys do
			local key = keys:sub(i, i)
			map(
				'n',
				string.format('<leader>%s', key),
				function() bmui.nav_file(i) end,
				opts
			)
		end

		-- Just the menu
		map({ 't', 'n' }, '<leader> ', bmui.toggle_quick_menu, opts)
		-- Next/Prev
		map('n', '] ', bmui.nav_next, opts)
		map('n', '[ ', bmui.nav_prev, opts)
	end,
}
