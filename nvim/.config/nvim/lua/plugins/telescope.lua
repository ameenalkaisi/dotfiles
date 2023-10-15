return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim" },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<leader>pgf", builtin.git_files, {})
        vim.keymap.set("n", "<leader>plg", builtin.live_grep, {})

        local telescope = require("telescope")
        telescope.load_extension("live_grep_args")
        vim.keymap.set("n", "<leader>pa", telescope.extensions.live_grep_args.live_grep_args)
    end,
}
