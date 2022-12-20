require('rose-pine').setup()

function ColorNvim(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
end

ColorNvim()
