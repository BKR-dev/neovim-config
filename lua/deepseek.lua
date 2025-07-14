-- ~/.config/nvim/after/plugin/deepseek.lua
local keymap = vim.keymap
local api = vim.api
local fn = vim.fn

-- State management
local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

-- Define defaults in two steps to avoid nil errors
local defaults = {
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.4),
    border = "rounded",
    title = "OLLAMA COMMAND",
}
defaults.col = math.floor((vim.o.columns - defaults.width) / 2)
defaults.row = math.floor((vim.o.lines - defaults.height) / 2)

-- Create floating window
local function create_floating_window(opts)
    opts = vim.tbl_extend("force", defaults, opts or {})

    local buf = opts.buf or api.nvim_create_buf(false, true)

    api.nvim_buf_set_option(buf, "buftype", "nofile")
    api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    api.nvim_buf_set_option(buf, "buflisted", false)
    api.nvim_buf_set_lines(buf, 0, -1, false, { "Press <Enter> to run command..." })

    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = opts.width,
        height = opts.height,
        col = opts.col,
        row = opts.row,
        style = "minimal",
        border = opts.border,
    })

    -- Bind <Enter> to send_to_ollama (must be global or in _G)
    api.nvim_win_set_keymap(win, "n", "<CR>", "<cmd>lua send_to_ollama()<CR>", {
        noremap = true,
        silent = true
    })

    return win
end

-- Define send_to_ollama in the global scope
function send_to_ollama()
    print("Running send_to_ollama...")
    -- Your implementation here
end

-- Function to open the floating window
function open_floating_window()
    if state.floating.win and api.nvim_win_is_valid(state.floating.win) then
        api.nvim_win_close(state.floating.win, true)
    end

    state.floating.win = create_floating_window()
end

-- Return module functions
return {
    open_floating_window = open_floating_window
}
