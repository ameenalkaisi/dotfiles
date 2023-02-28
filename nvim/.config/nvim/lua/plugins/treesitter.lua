return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = 'windwp/nvim-ts-autotag',
    build = ':TSUpdate',
    config = function()
        require 'nvim-treesitter.configs'.setup {
            -- A list of parser names, or "all"
            ensure_installed = { "help", "javascript", "typescript", "c", "lua", "rust", "vim" },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- latex highlighting handled by vimtex
                disable = { "latex" },

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { 'org' },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    scope_incremental = '<CR>',
                    node_incremental = '<TAB>',
                    node_decremental = '<S-TAB>',
                },
            },
            autotag = {
                enable = true,
            },
            indent = { enable = true },
        }

        if require("global.system").cursys == "Windows" then
            require("nvim-treesitter.install").compilers = { "clang" }
        end
    end
}
