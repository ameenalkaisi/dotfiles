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


local sysname = vim.loop.os_uname().sysname
if sysname == 'Darwin' or sysname == 'Linux' then
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
elseif sysname:find 'Windows' and true or false then
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
