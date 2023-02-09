return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require("nvim-tree").setup({
            update_focused_file = {
                enable = true,
            },
        })

        vim.api.nvim_create_autocmd({ "VimEnter" }, {
            callback = function(data)
                -- buffer is a directory
                local directory = vim.fn.isdirectory(data.file) == 1

                if not directory then
                    return
                end

                -- change to the directory
                vim.cmd.cd(data.file)

                -- open the tree
                require("nvim-tree.api").tree.open()
            end
        })

        vim.keymap.set("n", "<leader>nt", vim.cmd.NvimTreeToggle)
        vim.keymap.set("n", "<leader>nf", vim.cmd.NvimTreeFindFile)
    end
}
