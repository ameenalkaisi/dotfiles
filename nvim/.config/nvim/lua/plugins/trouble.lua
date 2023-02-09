return {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        -- Lua
        vim.keymap.set("n", "<leader>xx", vim.cmd.TroubleToggle,
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xw", function()
            vim.cmd("TroubleToggle document_diagnostics")
        end,
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xd",
            function()
                vim.cmd("TroubleToggle document_diagnostics")
            end,
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xl",
            function()
                vim.cmd("TroubleToggle loclist")
            end,
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "<leader>xq",
            function()
                vim.cmd("TroubleToggle quickfix")
            end,
            { silent = true, noremap = true }
        )
        vim.keymap.set("n", "gR", function()
            vim.cmd("TroubleToggle lsp_references")
        end,
            { silent = true, noremap = true }
        )
    end
}
