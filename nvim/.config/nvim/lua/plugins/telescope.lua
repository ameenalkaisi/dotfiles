return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim", "nvim-telescope/telescope-file-browser.nvim", "folke/trouble.nvim" },
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<leader>pgf", builtin.git_files, {})
        vim.keymap.set("n", "<leader>plg", builtin.live_grep, {})

        local telescope = require("telescope")
        telescope.load_extension("live_grep_args")

        local live_grep_args = telescope.extensions.live_grep_args.live_grep_args
        vim.keymap.set("n", "<leader>pa", live_grep_args)

        telescope.load_extension("file_browser")
        vim.keymap.set("n", "<leader>pb", telescope.extensions.file_browser.file_browser)

        local actions = require("telescope.actions")

        -- From https://github.com/nvim-telescope/telescope.nvim/issues/2201#issuecomment-1284691502
        local ts_select_dir_for_grep = function(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local fb = require("telescope").extensions.file_browser
            local live_grep = telescope.extensions.live_grep_args.live_grep_args
            local current_line = action_state.get_current_line()

            fb.file_browser({
                files = false,
                depth = false,
                attach_mappings = function(prompt_bufnr)
                    actions.select_default:replace(function()
                        local entry_path = action_state.get_selected_entry().Path
                        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
                        local relative = dir:make_relative(vim.fn.getcwd())
                        local absolute = dir:absolute()

                        live_grep({
                            results_title = relative .. "/",
                            cwd = absolute,
                            default_text = current_line,
                        })
                    end)

                    return true
                end,
            })
        end

        local open_with_trouble = require("trouble.sources.telescope").open

        -- Use this to add more results without clearing the trouble list
        local add_to_trouble = require("trouble.sources.telescope").add

        telescope.setup({
            pickers = {
                live_grep = {
                    mappings = {
                        i = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                        n = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                    },
                },
            },
            defaults = {
                mappings = {
                    i = { ["<c-t>"] = open_with_trouble },
                    n = { ["<c-t>"] = open_with_trouble },
                },
            },
        })
    end,
}
