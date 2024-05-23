return {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        local opts = function(desc)
            return { silent = true, noremap = true, desc = desc }
        end
        -- Lua
        vim.keymap.set("n", "<leader>xx", vim.cmd.TroubleToggle, opts("Toggle trouble menu"))

        vim.keymap.set("n", "<leader>xd", function()
            vim.cmd("TroubleToggle document_diagnostics")
        end, opts("Toggle trouble document diagnostics"))

        vim.keymap.set("n", "<leader>xl", function()
            vim.cmd("TroubleToggle loclist")
        end, opts("Toggle trouble on local list"))

        vim.keymap.set("n", "<leader>xq", function()
            vim.cmd("TroubleToggle quickfix")
        end, opts("Toggle trouble on quick fix list"))

        vim.keymap.set("n", "gR", function()
            vim.cmd("TroubleToggle lsp_references")
        end, opts("Toggle trouble on lsp references"))
    end,
}
