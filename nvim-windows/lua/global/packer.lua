-- Only required if you have packer configured as `opt`
vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-sleuth'

    -- Packer can manage itself
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        -- or                            , branch = "0.1.x",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {}
        end
    }
    use {
        "rose-pine/neovim",
        as = "rose-pine"
    }
    use { "ellisonleao/gruvbox.nvim" }
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {}
        end
    }
    use {
        "goolord/alpha-nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require "alpha".setup(require "alpha.themes.startify".config)
        end
    }
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("theprimeagen/harpoon")
    use("mbbill/undotree")
    use("tpope/vim-fugitive")
    use({
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    })
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup {}
        end
    })

    -- lsp, autocompletion, and snippets
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-cmdline")
    use("saadparwaiz1/cmp_luasnip")
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")
    use("folke/zen-mode.nvim")
    -- use("github/copilot.vim")
    use("nvim-tree/nvim-tree.lua")
    use("onsails/lspkind.nvim")
    use("lewis6991/gitsigns.nvim")
    use({
        "simrat39/symbols-outline.nvim",
        config = function()
            require("symbols-outline").setup()
            vim.keymap.set('n', '<leader>so', vim.cmd.SymbolsOutline)
        end
    })
    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {}
        end
    }
    use("jose-elias-alvarez/null-ls.nvim")
    use("akinsho/toggleterm.nvim")
    use { 'akinsho/bufferline.nvim',
        tag = "v3.*",
        requires = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup {}
        end
    }
    use { 'nvim-orgmode/orgmode' }
    use { 'tpope/vim-repeat' }
    use { 'mfussenegger/nvim-jdtls' }
    use { 'simrat39/rust-tools.nvim' }
    use { 'norcalli/nvim-colorizer.lua',
        config = function()
            require("colorizer").setup {}
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require("lspsaga").setup({})
        end,
        requires = { { "nvim-tree/nvim-web-devicons" } }
    })
end)
