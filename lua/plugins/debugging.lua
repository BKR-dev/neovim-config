return {
    {
        'mfussenegger/nvim-dap',
        -- Lazy: the whole dap/dapui/nio stack only loads on first debug keypress.
        keys = {
            "<Leader>dw", "<Leader>do", "<Leader>di", "<Leader>d",
            "<Leader>q", "<Leader>Q", "<Leader>lp", "<Leader>dr",
            "<Leader>dl", "<Leader>w", "<Leader>W",
        },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "leoluz/nvim-dap-go",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require('dap'), require('dapui')
            local dapgo = require('dap-go')
            dapui.setup()
            dapgo.setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set('n', '<Leader>dw', function() require('dap').continue() end)
            vim.keymap.set('n', '<Leader>do', function() require('dap').step_over() end)
            vim.keymap.set('n', '<Leader>di', function() require('dap').step_into() end)
            vim.keymap.set('n', '<Leader>d', function() require('dap').step_out() end)
            vim.keymap.set('n', '<Leader>q', function()
                require('dap').toggle_breakpoint()
            end)
            vim.keymap.set('n', '<Leader>Q', function()
                require('dap').set_breakpoint()
            end)
            vim.keymap.set('n', '<Leader>lp', function()
                require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end)
            vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
            vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)

            vim.keymap.set('n', '<Leader>w', function() dapui.open() end)
            vim.keymap.set('n', '<Leader>W', function() dapui.close() end)
        end
    }
}
