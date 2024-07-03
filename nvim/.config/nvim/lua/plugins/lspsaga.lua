return {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        --Please make sure you install markdown and markdown_inline parser
        "nvim-treesitter/nvim-treesitter",

        -- Assuming this is needed since it can extend gitsigns
        "lewis6991/gitsigns.nvim",
    },
    config = function()
        require("lspsaga").setup({})

        -- LSP finder - Find the symbol's definition
        -- If there is no definition, it will instead be hidden
        -- When you use an action in finder like "open vsplit",
        -- you can use <C-t> to jump back
        vim.keymap.set("n", "gh", function()
            vim.cmd("Lspsaga finder")
        end, {desc="Open Lspsaga finder"})

        -- Code action
        vim.keymap.set({ "n", "v" }, "<leader>ca", function()
            vim.cmd("Lspsaga code_action")
        end, {desc="Lspsaga Code Actions"})

        -- Rename all occurrences of the hovered word for the entire file
        --vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>")

        -- Rename all occurrences of the hovered word for the selected files
        vim.keymap.set("n", "<leader>r", function()
            vim.cmd("Lspsaga rename ++project")
        end, {desc="Lspsaga Project-wide Rename"})

        -- Peek definition
        -- You can edit the file containing the definition in the floating window
        -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
        -- It also supports tagstack
        -- Use <C-t> to jump back
        -- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

        -- Go to definition
        vim.keymap.set("n", "gd", function()
            vim.cmd("Lspsaga goto_definition")
        end, {desc="Lspsaga Go To Definition"})

        -- Go to type definition
        vim.keymap.set("n", "gt", function()
            vim.cmd("Lspsaga goto_type_definition")
        end, {desc="Lspsaga Go to Type Definition"})

        -- Show line diagnostics
        -- You can pass argument ++unfocus to
        -- unfocus the show_line_diagnostics floating window
        vim.keymap.set("n", "<leader>sl", function()
            vim.cmd("Lspsaga show_line_diagnostics")
        end, {desc="Lspsaga Show Line Diagnostics"})

        -- Show cursor diagnostics
        -- Like show_line_diagnostics, it supports passing the ++unfocus argument
        vim.keymap.set("n", "<leader>sc", function()
            vim.cmd("Lspsaga show_cursor_diagnostics")
        end, {desc="Lspsaga Show Cursor Diagnostics"})

        -- Show buffer diagnostics
        vim.keymap.set("n", "<leader>sb", function()
            vim.cmd("Lspsaga show_buf_diagnostics")
        end, {desc="Lspsaga Show Buffer Diagnostics"})

        -- Diagnostic jump
        -- You can use <C-o> to jump back to your previous location
        vim.keymap.set("n", "[d", function()
            vim.cmd("Lspsaga diagnostic_jump_prev")
        end)
        vim.keymap.set("n", "]d", function()
            vim.cmd("Lspsaga diagnostic_jump_next")
        end)

        -- Diagnostic jump with filters such as only jumping to an error
        vim.keymap.set("n", "[D", function()
            require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end)
        vim.keymap.set("n", "]D", function()
            require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)

        -- Toggle outline
        vim.keymap.set("n", "<leader>so", "<cmd>Lspsaga outline<CR>", {desc="Lspsaga Show Line Diagnostics"})

        -- Hover Doc
        -- If there is no hover doc,
        -- there will be a notification stating that
        -- there is no information available.
        -- To disable it just use ":Lspsaga hover_doc ++quiet"
        -- Pressing the key twice will enter the hover window
        vim.keymap.set("n", "K", function()
            vim.cmd("Lspsaga hover_doc")
        end, {desc="Lspsaga Hover"})

        -- If you want to keep the hover window in the top right hand corner,
        -- you can pass the ++keep argument
        -- Note that if you use hover with ++keep, pressing this key again will
        -- close the hover window. If you want to jump to the hover window
        -- you should use the wincmd command "<C-w>w"
        --vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

        -- Call hierarchy
        vim.keymap.set("n", "<Leader>ci", function()
            vim.cmd("Lspsaga incoming_calls")
        end, {desc="Lspsaga Incoming Calls"})
        vim.keymap.set("n", "<Leader>co", function()
            vim.cmd("Lspsaga outgoing_calls")
        end, {desc="Lspsaga Outgoing Calls"})

        -- Floating terminal
        vim.keymap.set({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
    end,
}
