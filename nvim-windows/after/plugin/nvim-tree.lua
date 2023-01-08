require("nvim-tree").setup()

vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>nf", vim.cmd.NvimTreeFindFile)
