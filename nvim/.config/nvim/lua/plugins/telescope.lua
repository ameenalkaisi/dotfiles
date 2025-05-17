return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-live-grep-args.nvim", "nvim-telescope/telescope-file-browser.nvim", "folke/trouble.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        local telescope = require("telescope")

        vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>ph", function() builtin.find_files({ hidden = true, no_ignore = true }) end,
            { desc = "Telescope find hidden files" })
        vim.keymap.set("n", "<leader>pgf", builtin.git_files, { desc = "Telescope find git files" })
        vim.keymap.set("n", "<leader>plg", builtin.live_grep, { desc = "Telescope find in files (live grep)" })
        vim.keymap.set("n", "<leader>pn", builtin.lsp_incoming_calls, { desc = "Telescope incoming calls" })
        vim.keymap.set("n", "<leader>pr", builtin.lsp_references, { desc = "Telescope references" })
        vim.keymap.set("n", "<leader>pd", builtin.lsp_definitions, { desc = "Telescope defintions" })
        vim.keymap.set("n", "<leader>pi", builtin.lsp_implementations, { desc = "Telescope implementation" })
        vim.keymap.set("n", "<leader>psr", builtin.resume, { desc = "Telescope search resume" })

        vim.keymap.set("n", "<leader>pb", telescope.extensions.file_browser.file_browser, {
            desc =
            "Telescope file browser"
        })

        local live_grep_args = telescope.extensions.live_grep_args.live_grep_args
        vim.keymap.set("n", "<leader>pa", live_grep_args, { desc = "Telescope live grep args" })

        local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
        vim.keymap.set("v", "<leader>gv", live_grep_args_shortcuts.grep_word_under_cursor,
            { desc = "Telescope live grep under selection" })

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

        local lga_actions = require("telescope-live-grep-args.actions")
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
            extensions = {
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    -- define mappings, e.g.
                    mappings = {         -- extend mappings
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = lga_actions.to_fuzzy_refine,
                        },
                    },
                    -- ... also accepts theme settings, for example:
                    -- theme = "dropdown", -- use dropdown theme
                    -- theme = { }, -- use own theme spec
                    -- layout_config = { mirror=true }, -- mirror preview pane
                }
            }
        })

        telescope.load_extension("live_grep_args")
        telescope.load_extension("file_browser")
    end,
}
