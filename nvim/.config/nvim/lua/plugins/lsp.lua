return {
    'williamboman/mason.nvim',
    dependencies = {
        'nvim-dap-ui',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
        'onsails/lspkind.nvim',

        'jose-elias-alvarez/null-ls.nvim',
        'jay-babu/mason-null-ls.nvim',

        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',

        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',

        'simrat39/rust-tools.nvim',
        'folke/neodev.nvim',
    },
    config = function()
        require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true }
        })
        require("mason").setup()
        require("mason-lspconfig").setup()

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                { border = 'rounded' }
            )

        vim.diagnostic.config({
            virtual_text = false,
            severity_sort = true,
            float = {
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
            }
        })

        local custom_on_attach = require("global.lsp").on_attach

        local lspconfig = require("lspconfig")
        require("mason-lspconfig").setup_handlers {
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.
            function(server_name) -- default handler (optional)
                lspconfig[server_name].setup {
                    on_attach = custom_on_attach,
                }
            end,
            ["jdtls"] = function() -- handled under ftplugin
            end,
            ["rust_analyzer"] = function()
                local extension_path = vim.fn.stdpath("data") .. "/codelldb/extension/"
                local codelldb_path = extension_path .. 'adapter/codelldb'
                local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

                require("rust-tools").setup {
                    server = {
                        on_attach = custom_on_attach,
                    },
                    dap = {
                        adapter = require('rust-tools.dap').get_codelldb_adapter(
                            codelldb_path, liblldb_path)
                    }
                }
            end
        }

        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")

        local cmp = require("cmp")
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs( -4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable( -1) then
                        luasnip.jump( -1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                --- { name = 'vsnip' }, -- For vsnip users.
                { name = 'luasnip' }, -- For luasnip users.
                --{ name = "ultisnips" }, -- For ultisnips users.
                -- { name = 'snippy' }, -- For snippy users.
                { name = "orgmode" },
            }, {
                { name = "buffer" },
            }),
            formatting = {
                format = require('lspkind').cmp_format({
                    mode = "symbol", -- show only symbol annotations
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                    -- The function below will be called before any actual modifications from lspkind
                    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                    before = function(_, vim_item)
                        return vim_item
                    end,
                }),
            },
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
                { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
                { name = "buffer" },
            }),
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end
}
