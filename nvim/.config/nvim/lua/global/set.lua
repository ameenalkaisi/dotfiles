-- vim.g.netrw_browse_split = 0
-- vim.g.netrw_banner = 0
-- vim.g.netrw_winsize = 25
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 9

vim.opt.guicursor = "n-c-v:block-nC"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false


vim.opt.undodir = require("global.system").home_path .. "/.vim/undodir"

vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "0"

vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

local augroup = vim.api.nvim_create_augroup
local fix_spaces_group = augroup("FixSpaces", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = fix_spaces_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
