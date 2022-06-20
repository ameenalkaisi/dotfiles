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
		use 'ms-jpq/coq_nvim'
		use 'ms-jpq/coq.artifacts'
		use 'ms-jpq/coq.thirdparty'
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
		use 'emakman/neovim-latex-previewer'
	end
)
