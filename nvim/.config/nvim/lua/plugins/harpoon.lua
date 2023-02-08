return {
    'theprimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>ha", mark.add_file)
        vim.keymap.set("n", "<leader>hh", ui.toggle_quick_menu)

        for i = 1, 6, 1 do
            vim.keymap.set("n", string.format("<leader>h%d", i), function() ui.nav_file(i) end)
        end
    end
}
