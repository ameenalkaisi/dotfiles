return require('packer').startup(
	function()
		use 'wbthomason/packer.nvim'
		use
		{
			"williamboman/nvim-lsp-installer",
			"neovim/nvim-lspconfig",
		}
		use 'nvim-treesitter/nvim-treesitter'
		use 'preservim/nerdtree'
		use 'junegunn/fzf'
		use 'nvim-lua/plenary.nvim'
		use 'tpope/vim-fugitive'
		use 'jose-elias-alvarez/nvim-lsp-ts-utils'
		use 'alvan/vim-closetag'
		use
		{
			'nvim-lualine/lualine.nvim',
			requires = { 'kyazdani42/nvim-web-devicons', opt = true }
		}
		use 'folke/tokyonight.nvim'
		use
		{
			'goolord/alpha-nvim',
			requires = { 'kyazdani42/nvim-web-devicons' },
			config = function()
				require 'alpha'.setup(require 'alpha.themes.startify'.config)
			end
		}
		use 'akinsho/toggleterm.nvim'
		use 'ThePrimeagen/harpoon'
		use 'folke/which-key.nvim'
		use 'lervag/vimtex'
		use 'hrsh7th/cmp-nvim-lsp'
		use 'hrsh7th/cmp-buffer'
		use 'hrsh7th/cmp-path'
		use 'hrsh7th/cmp-cmdline'
		use 'hrsh7th/nvim-cmp'
		use 'SirVer/ultisnips'
		use 'quangnguyen30192/cmp-nvim-ultisnips'
		use 'tpope/vim-surround'
	end
)
