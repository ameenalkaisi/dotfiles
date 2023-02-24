return {
	'j-morano/buffer_manager.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		require("buffer_manager").setup({
			line_keys = "",
		})

		vim.api.nvim_command([[
			autocmd FileType buffer_manager vnoremap J :m '>+1<CR>gv=gv
			autocmd FileType buffer_manager vnoremap K :m '<-2<CR>gv=gv
		]])

		for i = 1, 20 do
			vim.keymap.set(
				'n',
				string.format('<leader>%s', i),
				function() require("buffer_manager.ui").nav_file(i) end,
				{}
			)
		end

		vim.keymap.set('n', '[n', require("buffer_manager.ui").nav_prev)
		vim.keymap.set('n', ']n', require("buffer_manager.ui").nav_next)
		vim.keymap.set('n', '<leader>.', require("buffer_manager.ui").toggle_quick_menu)
	end
}
