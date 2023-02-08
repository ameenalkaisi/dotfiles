return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require("nvim-tree").setup({
            update_focused_file = {
                enable = true,
            },
        })

        vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
        vim.keymap.set("n", "<leader>nf", vim.cmd.NvimTreeFindFile)
    end
}
