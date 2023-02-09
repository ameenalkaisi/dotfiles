return {
    'mfussenegger/nvim-dap',
    dependencies = { 'rcarriga/nvim-dap-ui' },
    config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
        vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
        vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
        vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
        vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end)
        vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint() end)
        vim.keymap.set('n', '<leader>lp',
            ---@diagnostic disable-next-line: param-type-mismatch
            function() require('dap').set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
        vim.keymap.set('n', '<leader>dr', function() require('dap').repl.open() end)
        vim.keymap.set('n', '<leader>dl', function() require('dap').run_last() end)

        vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
            require('dap.ui.widgets').hover()
        end)

        vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
            require('dap.ui.widgets').preview()
        end)

        vim.keymap.set('n', '<leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end)

        vim.keymap.set('n', '<leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end)

        -- language configs
        -- c, cpp, rust
        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    ---@diagnostic disable-next-line: param-type-mismatch, redundant-parameter
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        -- adapters
        -- c, cpp, rust
        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                args = { "--port", "${port}" },

                -- On windows it will become false, other systems it is true
                detached = require("global.system").cursys ~= "Windows",
            }
        }
    end
}
