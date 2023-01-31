require('rose-pine').setup()
vim.o.background = "dark"

function ColorNvim(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
end

ColorNvim("gruvbox")
