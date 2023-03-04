return {
    'mfussenegger/nvim-jdtls',
    'JoosepAlviste/nvim-ts-context-commentstring',
    'tpope/vim-repeat',
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        dependencies = {
            'ellisonleao/gruvbox.nvim',
            'EdenEast/nightfox.nvim',
            'rebelot/kanagawa.nvim',
            'catppuccin/nvim',
        },
        lazy = false,
        priority = 1000,
        config = function()
            require('rose-pine').setup()
            -- set default colorscheme here
            --
            -- vim.cmd('colorscheme rose-pine')
            -- vim.cmd('colorscheme gruvbox')
            -- vim.cmd('colorscheme kanagawa')
            -- vim.cmd('colorscheme catppuccin')
            vim.cmd('colorscheme carbonfox')
        end
    },
    {
        'NMAC427/guess-indent.nvim',
        config = true
    },
    {
        'folke/which-key.nvim',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
            require('which-key').setup()
        end,
    },
    {
        'goolord/alpha-nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
        end
    },
    {
        'kylechui/nvim-surround',
        config = true
    },
    -- lsp, autocompletion, and snippets
    -- use('github/copilot.vim')
    {
        'simrat39/symbols-outline.nvim',
        config = function()
            require('symbols-outline').setup()

            vim.keymap.set('n', '<leader>so', vim.cmd.SymbolsOutline)
        end
    },
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = true
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup {}

            vim.keymap.set('n', '<leader>ct', vim.cmd.ColorizerToggle)
        end
    },
    {
        'mrshmllow/document-color.nvim',
        config = function()
            require('document-color').setup {};

            vim.keymap.set('n', '<leader>dct', require('document-color').buf_toggle)
        end
    },
    {
        'numToStr/Comment.nvim',
        dependencies={ 'JoosepAlviste/nvim-ts-context-commentstring' },
        config = function()
            require('Comment').setup {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = true
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = { 'nvim-treesitter', 'nvim-dap' },
        config = true
    },
    {
        'miversen33/netman.nvim',
        -- for now this will only work on non-Windows
        -- Systems since it freezes on Windows for some reason
        enabled = require('global.system').cursys ~= 'Windows',
        config = function()
            require('netman')
        end
    }
}
