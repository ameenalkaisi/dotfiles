return {
    "tpope/vim-sleuth",
    "mfussenegger/nvim-jdtls",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "tpope/vim-repeat",
    "tpope/vim-scriptease",
    "andreshazard/vim-freemarker",
    "folke/twilight.nvim",
    "vim-scripts/edifact.vim",
    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end
    },
    {
        "NMAC427/guess-indent.nvim",
        config = true,
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
            require("which-key").setup()
        end,
    },
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("alpha").setup(require("alpha.themes.startify").config)
        end,
    },
    {
        "kylechui/nvim-surround",
        -- tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true,
    },
    -- lsp, autocompletion, and snippets
    -- use('github/copilot.vim')
    {
        "akinsho/bufferline.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = true,
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                -- disable colorizer where document-color.nvim is applicable
                "*",
                -- An example
                "!css",
                "!html",
                "!tsx",
                "!dart",
            })

            vim.keymap.set("n", "<leader>ct", vim.cmd.ColorizerToggle)
        end,
    },
    {
        "mrshmllow/document-color.nvim",
        config = function()
            require("document-color").setup({})

            vim.keymap.set("n", "<leader>dct", require("document-color").buf_toggle)
        end,
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = true,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "nvim-treesitter", "nvim-dap" },
        config = true,
    },
    {
        "miversen33/netman.nvim",
        -- for now this will only work on Linux
        -- since it freezes on Windows / Mac for some reason
        enabled = require("global.system").cursys == "Linux",
        config = function()
            require("netman")
        end,
    },
    { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter" },
        config = function()
            require("neogen").setup({})
        end,
    },
}
