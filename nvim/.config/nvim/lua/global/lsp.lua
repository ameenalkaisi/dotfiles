local M = {}

function M.on_attach(attached_client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    -- vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format {
            --         -- disable tsserver formatting as it is very different from
            --         -- prettier, and not good at all
            --         -- at least by default
            filter = function(client) return client.name ~= "tsserver" and client.name ~= "jdtls" end,
            async = true,
        }
    end, bufopts)
    --vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, bufopts)


    --- Attach document-color.nvim
    if attached_client.server_capabilities.colorProvider then
        require("document-color").buf_attach(bufnr)
    end
end

return M
