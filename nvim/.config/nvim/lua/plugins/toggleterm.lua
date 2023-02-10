return {
    'akinsho/toggleterm.nvim',
    -- windows-only
    enabled = function()
        return require("global.system").cursys == "Windows"
    end,
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<C-\>]],
            close_on_exit = true,
            start_in_insert = true,
            hide_numbers = true,
            shell = "pwsh.exe -nologo",
            direction = "horizontal"
        })

        function _G.set_terminal_keymaps()
            local opts = { buffer = 0 }
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
            vim.keymap.set('t', '<C-w>h', function()
                vim.cmd("wincmd h")
            end, opts)
            vim.keymap.set('t', '<C-w>j', function()
                vim.cmd("wincmd j")
            end, opts)
            vim.keymap.set('t', '<C-w>k', function()
                vim.cmd("wincmd k")
            end, opts)
            vim.keymap.set('t', '<C-w>l', function()
                vim.cmd("wincmd l")
            end, opts)
        end

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
}
