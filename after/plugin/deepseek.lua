-- ~/.config/nvim/lua/deepseek.lua
local http = require("plenary.http")
local job = require("plenary.job")
local notify = require("notify")

-- Replace with your model server's URL
local DEEPSEEK_URL = "http://gpu:3000/generate"

-- Send the current buffer's content to the model
function SendToDeepSeek()
    local lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    local prompt = table.concat(lines, "\n")

    print("Sending prompt to DeepSeek Coder...")
    notify("Sending prompt to DeepSeek Coder...", "info")

    -- Send POST request
    local resp = http.post(DEEPSEEK_URL, {
        json = {
            prompt = prompt,
            max_tokens = 200, -- Adjust based on your model
        },
    })

    if resp.status < 300 then
        local result = resp.body
        print("Received response from DeepSeek Coder:")
        notify("Received response from DeepSeek Coder", "info")
        vim.api.nvim_put({ result }, "l", true, true)
    else
        print("Error: " .. resp.status)
        notify("Error: " .. resp.status, "error")
    end
end

-- Map a key (e.g., <Leader>dc) to trigger the function
vim.api.nvim_create_autocmd(" BufReadPost", {
    callback = function()
        vim.keymap.set("n", "<Leader>dc", SendToDeepSeek, { desc = "DeepSeek Coder" })
    end,
})
