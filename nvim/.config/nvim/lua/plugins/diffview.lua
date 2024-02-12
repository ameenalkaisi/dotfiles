return {
	"sindrets/diffview.nvim",
	config = function()
		vim.keymap.set("n", "<leader>hdo", vim.cmd.DiffviewOpen, { desc = "Open Diffview" })
		vim.keymap.set("n", "<leader>hdc", vim.cmd.DiffviewClose, { desc = "Close Diffview" })
		vim.keymap.set("n", "<leader>hdfh", vim.cmd.DiffviewFileHistory, { desc = "Diffview File History" })
		vim.keymap.set("n", "<leader>hdtf", vim.cmd.DiffviewToggleFiles, { desc = "Diffivew Toggle Files" })
	end
}
