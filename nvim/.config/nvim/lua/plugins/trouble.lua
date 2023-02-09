return {
    'folke/trouble.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        local opts = { silent = true, noremap = true }
        -- Lua
        vim.keymap.set("n", "<leader>xx", vim.cmd.TroubleToggle, opts)

        vim.keymap.set("n", "<leader>xw", function()
            vim.cmd("TroubleToggle document_diagnostics")
        end, opts)

        vim.keymap.set("n", "<leader>xd", function()
            vim.cmd("TroubleToggle document_diagnostics")
        end, opts)

        vim.keymap.set("n", "<leader>xl", function()
            vim.cmd("TroubleToggle loclist")
        end, opts)

        vim.keymap.set("n", "<leader>xq", function()
            vim.cmd("TroubleToggle quickfix")
        end, opts)

        vim.keymap.set("n", "gR", function()
            vim.cmd("TroubleToggle lsp_references")
        end, opts)
    end
}
