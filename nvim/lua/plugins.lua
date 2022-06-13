return require('packer').startup(
	function()
		use
		{
			"williamboman/nvim-lsp-installer",
			"neovim/nvim-lspconfig",
		}
		use 'wbthomason/packer.nvim'
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
	end
)
