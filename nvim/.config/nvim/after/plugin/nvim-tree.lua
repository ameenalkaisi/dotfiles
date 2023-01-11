require("nvim-tree").setup({
    update_focused_file = {
        enable = true,
        update_root = true,
    },
})

vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>nf", vim.cmd.NvimTreeFindFile)
