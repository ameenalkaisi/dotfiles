return {
    'nvim-telescope/telescope.nvim',
    version = '0.1.0',
    -- or                            , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pgf', builtin.git_files, {})
        vim.keymap.set('n', '<leader>plg', builtin.live_grep, {})
    end
}
