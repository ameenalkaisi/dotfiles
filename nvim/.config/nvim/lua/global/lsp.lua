local M = {}

local set_vim_keymap_with_desc = function(mode, lhs, rhs, opts, desc)
    local desc_option = { desc = desc }
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('error', opts, desc_option))
end

function M.on_attach(attached_client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    set_vim_keymap_with_desc("n", "gD", vim.lsp.buf.declaration, bufopts, "Go to declaration")
    set_vim_keymap_with_desc('n', 'K', function() vim.lsp.buf.hover({ border = "rounded" }) end, bufopts,
        "Show hover information")
    set_vim_keymap_with_desc("n", "gi", vim.lsp.buf.implementation, bufopts, "Go to implementation")
    set_vim_keymap_with_desc({ "n", "i" }, "<C-s>",
        function() vim.lsp.buf.signature_help({ border = "rounded" }) end
        , { silent = true, buffer = bufnr },
        "Show signature help")
    set_vim_keymap_with_desc("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
    set_vim_keymap_with_desc("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
    set_vim_keymap_with_desc("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts, "List workspace folders")
    set_vim_keymap_with_desc("n", "<leader>D", vim.lsp.buf.type_definition, bufopts, "Go to type definition")
    set_vim_keymap_with_desc("n", "<leader>o", function()
        require("Comment.api").insert.linewise.above()
        vim.cmd("normal ATODO: ")
    end, bufopts, "Create a TODO comment")

    -- set_vim_keymap_with_desc('n', '<leader>rn', vim.lsp.buf.rename, bufopts, "Rename symbol")
    -- set_vim_keymap_with_desc('n', '<leader>ca', vim.lsp.buf.code_action, bufopts, "Code action")
    -- set_vim_keymap_with_desc('n', '<leader>rr', vim.lsp.buf.references, bufopts, "Find references")
    --[[ set_vim_keymap_with_desc("n", "<leader>f", function()
        vim.lsp.buf.format({
            -- disable on tsserver and jdtls
            filter = function(client)
                return client.name ~= "tsserver" and client.name ~= "jdtls"
            end,
            async = true,
        })
    end, bufopts, "Format document") ]]
    -- set_vim_keymap_with_desc("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, bufopts, "Search workspace symbols")

    --- Attach document-color.nvim
    if attached_client and attached_client.server_capabilities.colorProvider then
        require("document-color").buf_attach(bufnr)
    end
end

-- @param nvim_lsp_cmp result of require('nvim_lsp_cmp')
function M.create_capabilities(nvim_lsp_cmp)
    local capabilities = nvim_lsp_cmp.default_capabilities()
    capabilities.textDocument.colorProvider = {
        dynamicRegistration = true,
    }
end

return M
