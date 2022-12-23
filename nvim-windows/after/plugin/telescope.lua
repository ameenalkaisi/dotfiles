local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pgf', builtin.git_files, {})
vim.keymap.set('n', '<leader>plg', builtin.live_grep, {})
