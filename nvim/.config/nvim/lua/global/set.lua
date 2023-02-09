vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 9

vim.opt.guicursor = "n-c-v:block-nC"

vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false


local sys = require("global.system").cursys
if sys == "Mac" or sys == "Linux" then
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
elseif sys == "Windows" then
	vim.opt.undodir = "C:/Users/ameen/.vim/undodir"
end


vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "0"

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
