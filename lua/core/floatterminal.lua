vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
vim.keymap.set("t", "<leader><esc>", "<esc>")

local state = {
    floating = {
        win = -1,
        terminals = {},  -- List of terminal buffers
        current_idx = 1, -- Currently active terminal index
    }
}

-- Forward declarations
local cleanup_terminals
local update_title
local switch_terminal
local new_terminal
local close_terminal

-- Generate title with tabs
local function generate_title()
    if #state.floating.terminals == 0 then
        return " TERMINAL "
    end
    
    local title_parts = {}
    for i, term_buf in ipairs(state.floating.terminals) do
        if vim.api.nvim_buf_is_valid(term_buf) then
            local marker = (i == state.floating.current_idx) and "●" or "○"
            table.insert(title_parts, string.format("%s %d", marker, i))
        end
    end
    
    return " " .. table.concat(title_parts, " │ ") .. " "
end

-- Update window title
update_title = function()
    if vim.api.nvim_win_is_valid(state.floating.win) then
        vim.api.nvim_win_set_config(state.floating.win, {
            title = generate_title(),
        })
    end
end

-- Clean up invalid terminal buffers
cleanup_terminals = function()
    local valid_terminals = {}
    for i, buf in ipairs(state.floating.terminals) do
        if vim.api.nvim_buf_is_valid(buf) then
            table.insert(valid_terminals, buf)
        elseif i == state.floating.current_idx then
            -- Current terminal was deleted, reset index
            state.floating.current_idx = 1
        end
    end
    state.floating.terminals = valid_terminals
    
    -- Adjust current index if needed
    if state.floating.current_idx > #state.floating.terminals then
        state.floating.current_idx = math.max(1, #state.floating.terminals)
    end
end

-- Switch to a specific terminal
switch_terminal = function(idx)
    cleanup_terminals()
    
    if #state.floating.terminals == 0 then
        return
    end
    
    -- Clamp index
    idx = math.max(1, math.min(idx, #state.floating.terminals))
    state.floating.current_idx = idx
    
    if vim.api.nvim_win_is_valid(state.floating.win) then
        local buf = state.floating.terminals[idx]
        vim.api.nvim_win_set_buf(state.floating.win, buf)
        update_title()
    end
end

-- Create new terminal tab
new_terminal = function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(buf, function()
        vim.cmd.terminal()
    end)
    
    -- Set up keymaps for this buffer
    local opts = { buffer = buf, noremap = true, silent = true }
    vim.keymap.set("n", "H", function() switch_terminal(state.floating.current_idx - 1) end, opts)
    vim.keymap.set("n", "L", function() switch_terminal(state.floating.current_idx + 1) end, opts)
    vim.keymap.set("n", "<leader>ta", new_terminal, opts)
    vim.keymap.set("n", "<leader>tw", close_terminal, opts)
    
    -- Number keys to switch directly
    for i = 1, 9 do
        vim.keymap.set("n", tostring(i), function() switch_terminal(i) end, opts)
    end
    
    -- Auto-close window when buffer is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
        buffer = buf,
        once = true,
        callback = function()
            cleanup_terminals()
            update_title()
        end,
    })
    
    table.insert(state.floating.terminals, buf)
    state.floating.current_idx = #state.floating.terminals
    
    if vim.api.nvim_win_is_valid(state.floating.win) then
        vim.api.nvim_win_set_buf(state.floating.win, buf)
        update_title()
    end
end

-- Close current terminal tab
close_terminal = function()
    cleanup_terminals()
    
    if #state.floating.terminals == 0 then
        return
    end
    
    -- Only allow closing if there's more than one terminal
    if #state.floating.terminals == 1 then
        return
    end
    
    local buf_to_delete = state.floating.terminals[state.floating.current_idx]
    
    -- Remove from list first
    table.remove(state.floating.terminals, state.floating.current_idx)
    
    -- Adjust current index and switch to another terminal BEFORE deleting the buffer
    state.floating.current_idx = math.min(state.floating.current_idx, #state.floating.terminals)
    
    -- Switch to the new current terminal (this changes the window's buffer)
    if vim.api.nvim_win_is_valid(state.floating.win) then
        local new_buf = state.floating.terminals[state.floating.current_idx]
        vim.api.nvim_win_set_buf(state.floating.win, new_buf)
        update_title()
    end
    
    -- Now it's safe to delete the old buffer
    if vim.api.nvim_buf_is_valid(buf_to_delete) then
        vim.api.nvim_buf_delete(buf_to_delete, { force = true })
    end
end

-- Create floating window
local function create_floating_window(buf)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
        title = generate_title(),
        title_pos = 'center'
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)
    return win
end

-- Toggle terminal window
local function toggle_terminal()
    if vim.api.nvim_win_is_valid(state.floating.win) then
        vim.api.nvim_win_hide(state.floating.win)
        return
    end
    
    cleanup_terminals()
    
    -- Create first terminal if none exist
    if #state.floating.terminals == 0 then
        new_terminal()
    end
    
    -- Open window with current terminal
    local buf = state.floating.terminals[state.floating.current_idx]
    state.floating.win = create_floating_window(buf)
end

-- Commands and keymaps
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<space>tt", toggle_terminal)
