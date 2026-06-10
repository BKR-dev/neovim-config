return {
    "theprimeagen/harpoon",
    keys = {
        "<leader>a", "<C-e>",
        "<leader>1", "<leader>2", "<leader>3", "<leader>4",
        "<leader>8", "<leader>9", "<leader>0",
    },
    config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>a", mark.add_file)
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

        vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
        vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
        vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
        vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
        vim.keymap.set("n", "<leader>8", function() ui.nav_file(5) end)
        vim.keymap.set("n", "<leader>9", function() ui.nav_file(6) end)
        vim.keymap.set("n", "<leader>0", function() ui.nav_file(7) end)
    end
}
