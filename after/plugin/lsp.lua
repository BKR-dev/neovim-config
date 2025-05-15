local lsp = require('lsp-zero')

-- use reasonable preset
lsp.preset('recommended')

-- fix undefined "vim" global
lsp.nvim_workspace()


-- always use active LS to fromat on save
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

require('lspconfig').yamlls.setup {

    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.24.0-standalone-strict/all.json"] = "*.yaml",
            },
        },
    },
}


-- Enhanced hover handler for better formatting
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
    -- Format Go documentation more nicely
    if syntax == "go" or syntax == "gomod" then
        -- Process contents for better readability
        local formatted_contents = {}
        for _, line in ipairs(contents) do
            -- Split long lines at meaningful breaks
            if #line > 80 then
                line = line:gsub("(%S)%.(%S)", "%1.\n%2") -- Break after periods
            end
            table.insert(formatted_contents, line)
        end
        contents = formatted_contents
    end

    -- Configure the floating window
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.max_width = opts.max_width or 100
    opts.max_height = opts.max_height or 30

    -- Return the floating window using the original function
    return orig_util_open_floating_preview(contents, syntax, opts)
end

-- Set hover handler with improved formatting and wrapping
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        width = 100,
        border = "rounded",
        wrap = true,
        max_height = 30,
        max_width = 100,
    }
)

vim.diagnostic.config({
    virtual_text = {
        prefix = '● ',
        spacing = 4,
        format = function(diagnostic)
            -- For long messages, just show an indicator
            if #diagnostic.message > 80 then
                return "See details... [Press <leader>ld]"
            end
            return diagnostic.message
        end,
    },


    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
        },
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local copilot = require("copilot.suggestion") -- Ensure Copilot is properly set up

cmp.setup({

    sources = cmp.config.sources({
        { name = 'nvim_lsp' },                      -- LSP
        { name = 'nvim_lsp_signature_help' },       -- Function signatures
        { name = 'luasnip' },                       -- Snippets
        { name = 'path' },                          -- File paths
    }, {
        { name = 'buffer',    keyword_length = 3 }, -- Buffer text (min 3 chars)
        { name = 'nvim_lua' },                      -- Neovim Lua API
        { name = 'calc' },                          -- Math calculations
        { name = 'emoji' },                         -- Emoji completion
        { name = 'treesitter' },                    -- Treesitter-based completion
        { name = 'git' },                           -- Git completion (commit hashes, branches)
    }),

    formatting = {
        format = function(entry, vim_item)
            -- Fancy icons for different types
            local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
            }
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

            -- Show source name
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
                nvim_lua = "[Lua]",
                calc = "[Calc]",
            })[entry.source.name]

            return vim_item
        end,
    },

    mapping = {
        ["<Tab>"] = function(fallback)
            if copilot.is_visible() then
                copilot.accept()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        -- Add Enter mapping to confirm selection
        ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace
        }),
    },
    -- Add snippet support explicitly
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})


------------ gopls setup -----------------------

-- Enable gopls settings
local lsp_settings = {
    usePlaceholders = true,
    analyses = {
        unusedparams = true,
        unusedvars = true,
        shadowedvars = true,
        deadcode = true,
        nilness = true,
        useany = true,
        unusedwrite = true,
        undeclaredname = true,
    },
    -- Add these settings for better import handling
    gofumpt = true,
    staticcheck = true,
    -- Enable import organization
    codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
        run_govulncheck = true,
    },
    hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
    },
    semanticTokens = true,
    directoryFilters = { "-node_modules", "-vendor" },
    symbolMatcher = "fuzzy",
    symbolStyle = "dynamic",
    hoverKind = "FullDocumentation",
    linkTarget = "pkg.go.dev",
    linksInHover = true,
    importShortcut = "Definition",
}

-- Setup gopls
require('lspconfig').gopls.setup({
    settings = {
        gopls = lsp_settings,
    },
    -- Ensure imports are organized on save
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
                -- Organize imports before saving
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }

                local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
                if result and result[1] then
                    local actions = result[1].result
                    if actions and actions[1] then
                        vim.lsp.buf.code_action({
                            filter = function(action)
                                return action.title == "Organize Imports"
                            end,
                            apply = true
                        })
                    end
                end

                -- Format the buffer
                vim.lsp.buf.format({ async = false })
            end,
            group = vim.api.nvim_create_augroup("GoImports", { clear = true }),
        })
    end,
})

------------ gopls setup -----------------------

-- add templ files to lsp
vim.filetype.add({
    extension = {
        templ = "templ"
    },
})

-- setup terraform lsp
require 'lspconfig'.terraformls.setup {}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*.tf", "*.tfvars" },
    callback = function()
        vim.lsp.buf.format()
    end,
})


-- setup vtsls lsp
require 'lspconfig'.vls.setup {
    on_attach = function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()
    end
}



-- sets up configuration
lsp.setup()

local function display_lsp_info()
    -- Get current cursor position
    local line = vim.fn.line('.') - 1 -- LSP uses 0-based lines
    local bufnr = vim.api.nvim_get_current_buf()
    local current_line = vim.api.nvim_get_current_line()
    local filetype = vim.bo.filetype

    -- Get all diagnostics on the current line
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

    -- Check for inlay hints (like "could use tagged switch")
    local has_hint = current_line:find("could use") or current_line:find("consider") or current_line:find("■")

    -- If no diagnostics or hints, try to get hover information
    if #diagnostics == 0 and not has_hint then
        -- Fallback to hover info if available
        vim.lsp.buf.hover()
        return
    end

    -- Get context from the file
    local start_line = math.max(0, line - 5)
    local end_line = math.min(line + 5, vim.api.nvim_buf_line_count(0))
    local context = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

    -- Create content for the floating window
    local text = {}

    -- Add diagnostics information
    if #diagnostics > 0 then
        table.insert(text, "📊 LSP Diagnostics")
        table.insert(text, string.rep("─", 50))

        for _, diag in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diag.severity]
            local icon = "ℹ️ "
            if severity == "ERROR" then
                icon = "❌ "
            elseif severity == "WARN" then
                icon = "⚠️ "
            elseif severity == "HINT" then
                icon = "💡 "
            end

            table.insert(text, icon .. severity .. ": " .. diag.message)

            -- Add source if available
            if diag.source then
                table.insert(text, "   Source: " .. diag.source)
            end

            -- Add code if available
            if diag.code then
                table.insert(text, "   Code: " .. diag.code)
            end

            table.insert(text, "")
        end
    end

    -- Add inlay hint information
    if has_hint then
        local hint_text = current_line:match("■(.+)") or
            current_line:match("could use (.+)") or
            current_line:match("consider (.+)") or
            "Code improvement suggestion"

        table.insert(text, "💡 Code Suggestion")
        table.insert(text, string.rep("─", 50))
        table.insert(text, hint_text)
        table.insert(text, "")
    end

    -- Add code context
    table.insert(text, "📄 Code Context")
    table.insert(text, string.rep("─", 50))
    for i, ctx_line in ipairs(context) do
        local linenum = start_line + i
        if linenum == line then
            table.insert(text, "➤ " .. ctx_line) -- Highlight current line
        else
            table.insert(text, "  " .. ctx_line)
        end
    end

    -- Create a buffer for our floating window
    local new_bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(new_bufnr, 'filetype', 'markdown') -- Use markdown for nice formatting
    vim.api.nvim_buf_set_option(new_bufnr, 'bufhidden', 'wipe')


    -- Calculate floating window size
    local width = math.min(120, vim.o.columns - 4)
    local height = math.min(40, #text + 2)

    -- Calculate position (centered)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2) - 2

    -- Create floating window options
    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
        title = ' LSP Information ',
        title_pos = 'center'
    }

    -- Fill the buffer with content
    vim.api.nvim_buf_set_lines(new_bufnr, 0, -1, false, text)
    vim.api.nvim_buf_set_option(new_bufnr, 'modifiable', false)

    -- Create the window
    local win_id = vim.api.nvim_open_win(new_bufnr, true, win_opts)

    -- Add nice highlighting
    vim.api.nvim_win_set_option(win_id, 'winhl', 'Normal:Normal,FloatBorder:Special')

    -- Add keymaps to close the window
    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win_id, true) end,
        { buffer = new_bufnr, noremap = true })
    vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win_id, true) end,
        { buffer = new_bufnr, noremap = true })
    vim.keymap.set('n', '<CR>', function() vim.api.nvim_win_close(win_id, true) end,
        { buffer = new_bufnr, noremap = true })
end





-- Enhanced Go documentation viewer

local function open_godoc()
    -- Get word under cursor
    local cword = vim.fn.expand('<cword>')
    -- Try to determine if it's a package or function
    local current_line = vim.api.nvim_get_current_line()
    local is_package = current_line:match('import%s+[%(%s]*"[^"]*' .. cword) ~= nil

    -- Create buffer for documentation
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    -- Determine if we should search for a package or symbol
    local cmd
    if is_package then
        cmd = 'go doc ' .. cword
    else
        -- Try to get the package name
        local package_name = vim.fn.expand('%:p:h:t')
        cmd = 'go doc ' .. cword
    end

    -- Execute godoc
    vim.fn.jobstart(cmd, {
        on_stdout = function(_, data, _)
            if data then
                -- Format the documentation
                local formatted_data = {}
                local in_code_block = false

                for _, line in ipairs(data) do
                    if line:match('^%s*$') and not in_code_block then
                        table.insert(formatted_data, "")
                    elseif line:match('^func') then
                        table.insert(formatted_data, "```go")
                        table.insert(formatted_data, line)
                        in_code_block = true
                    elseif line:match('^type') then
                        table.insert(formatted_data, "```go")
                        table.insert(formatted_data, line)
                        in_code_block = true
                    elseif line:match('^var') or line:match('^const') then
                        table.insert(formatted_data, "```go")
                        table.insert(formatted_data, line)
                        in_code_block = true
                    elseif in_code_block and line:match('^%s*$') then
                        table.insert(formatted_data, "```")
                        table.insert(formatted_data, "")
                        in_code_block = false
                    else
                        table.insert(formatted_data, line)
                    end
                end

                if in_code_block then
                    table.insert(formatted_data, "```")
                end

                vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_data)
            end
        end,
        on_stderr = function(_, data, _)
            if data and #data > 1 then
                vim.api.nvim_buf_set_lines(buf, 0, -1, false,
                    { "# Error:", "", "```", unpack(data), "```" })
            end
        end,
        on_exit = function(_, _, _)
            -- When job completes, show buffer in a floating window
            local width = math.min(120, vim.o.columns - 4)
            local height = math.min(40, vim.o.lines - 4)

            local win = vim.api.nvim_open_win(buf, true, {
                relative = 'editor',
                width = width,
                height = height,
                col = math.floor((vim.o.columns - width) / 2),
                row = math.floor((vim.o.lines - height) / 2),
                style = 'minimal',
                border = 'rounded',
                title = ' Go Documentation: ' .. cword .. ' ',
                title_pos = 'center'
            })

            -- Set options and keymaps
            vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:Special')
            vim.api.nvim_buf_set_option(buf, 'modifiable', false)

            vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end,
                { buffer = buf, noremap = true })
            vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end,
                { buffer = buf, noremap = true })
        end
    })
end


-- Function to show detailed type information for Go

local function show_go_type_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local line = vim.fn.line('.') - 1
    local col = vim.fn.col('.') - 1
    local cword = vim.fn.expand('<cword>')

    -- Request gopls to provide detailed type information
    local params = {
        textDocument = {
            uri = vim.uri_from_fname(fname)
        },
        position = {
            line = line,
            character = col
        }
    }

    vim.lsp.buf_request(bufnr, 'textDocument/hover', params, function(err, result, _, _)
        if err or not result or not result.contents then
            -- Fallback to regular hover
            vim.lsp.buf.hover()
            return
        end

        local contents = result.contents
        local markdown_lines = {}

        -- Extract the content based on structure
        if type(contents) == 'string' then
            for line in contents:gmatch("[^\r\n]+") do
                table.insert(markdown_lines, line)
            end
        elseif contents.kind == 'markdown' then
            for line in contents.value:gmatch("[^\r\n]+") do
                table.insert(markdown_lines, line)
            end
        elseif contents.language then
            -- It's a MarkedString
            table.insert(markdown_lines, '```' .. contents.language)
            table.insert(markdown_lines, contents.value)
            table.insert(markdown_lines, '```')
        elseif type(contents) == 'table' then
            -- It might be an array of MarkedString or MarkupContent
            for _, content in ipairs(contents) do
                if type(content) == 'string' then
                    table.insert(markdown_lines, content)
                elseif content.kind == 'markdown' then
                    for line in content.value:gmatch("[^\r\n]+") do
                        table.insert(markdown_lines, line)
                    end
                elseif content.language then
                    table.insert(markdown_lines, '```' .. content.language)
                    table.insert(markdown_lines, content.value)
                    table.insert(markdown_lines, '```')
                end
            end
        end

        -- Enhanced display when possible
        if fname:match("%.go$") and #markdown_lines > 0 then
            -- If we have type info, try to enhance it
            local enhanced = false

            -- Try to extract better type info via gopls query
            vim.lsp.buf_request(bufnr, 'workspace/executeCommand', {
                command = 'gopls.type_definition',
                arguments = {
                    vim.uri_from_fname(fname),
                    { line = line, character = col }
                }
            }, function(err, type_result, _, _)
                if not err and type_result then
                    -- We got more detailed type info
                    enhanced = true

                    -- Display both the basic info and enhanced info
                    local text = {
                        "# Type Information for " .. cword,
                        string.rep("─", 50),
                        "",
                        "## Basic Info",
                    }

                    for _, line in ipairs(markdown_lines) do
                        table.insert(text, line)
                    end

                    -- Add usage examples if available
                    -- TODO: This could be enhanced with method lookup etc.

                    -- Open float with the combined info
                    local buf = vim.api.nvim_create_buf(false, true)
                    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

                    local width = math.min(120, vim.o.columns - 4)
                    local height = math.min(#text + 2, vim.o.lines - 4)

                    local win = vim.api.nvim_open_win(buf, true, {
                        relative = 'editor',
                        width = width,
                        height = height,
                        col = math.floor((vim.o.columns - width) / 2),
                        row = math.floor((vim.o.lines - height) / 2),
                        style = 'minimal',
                        border = 'rounded',
                        title = ' Go Type Info: ' .. cword .. ' ',
                        title_pos = 'center'
                    })

                    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:Normal,FloatBorder:Special')
                    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

                    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end,
                        { buffer = buf, noremap = true })
                    vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end,
                        { buffer = buf, noremap = true })
                end

                -- If we failed to get enhanced info, fall back to regular hover
                if not enhanced then
                    vim.lsp.buf.hover()
                end
            end)
        else
            -- Fallback to regular hover
            vim.lsp.buf.hover()
        end
    end)
end



local function open_package_browser()
    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')

    -- Starting with standard library packages
    local text = {
        "# Go Package Browser",
        string.rep("─", 50),
        "",
        "## Loading packages...",
        "",
        "Please wait while we load the package list..."
    }

    -- Show initial buffer
    local width = math.min(120, vim.o.columns - 4)
    local height = math.min(40, vim.o.lines - 4)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
        row = math.floor((vim.o.lines - height) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' Go Package Browser ',
        title_pos = 'center'
    })

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, text)

    -- Add keymaps
    vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end,
        { buffer = buf, noremap = true })
    vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end,
        { buffer = buf, noremap = true })

    -- Load packages async
    vim.fn.jobstart('go list std', {
        on_stdout = function(_, data, _)
            if data and #data > 1 then
                local packages = {}
                table.insert(packages, "# Go Standard Library Packages")
                table.insert(packages, string.rep("─", 50))
                table.insert(packages, "")

                -- Group packages by top-level namespace
                local groups = {}
                for _, pkg in ipairs(data) do
                    if pkg and pkg ~= "" then
                        local top_level = pkg:match("^([^/]+)")
                        if not groups[top_level] then
                            groups[top_level] = {}
                        end
                        table.insert(groups[top_level], pkg)
                    end
                end

                -- Format the output
                local sorted_groups = {}
                for group, _ in pairs(groups) do
                    table.insert(sorted_groups, group)
                end
                table.sort(sorted_groups)

                for _, group in ipairs(sorted_groups) do
                    table.insert(packages, "## " .. group)
                    table.insert(packages, "")
                    for _, pkg in ipairs(groups[group]) do
                        table.insert(packages, "- `" .. pkg .. "`")
                    end
                    table.insert(packages, "")
                end

                table.insert(packages, "----")
                table.insert(packages, "")
                table.insert(packages, "Press Enter on a package name to view documentation")

                -- Update buffer content
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, packages)

                -- Add keymapping to view package docs when cursor is on a package
                vim.keymap.set('n', '<CR>', function()
                    local line = vim.api.nvim_get_current_line()
                    local pkg = line:match("`([^`]+)`")
                    if pkg then
                        -- Get package doc and display in split
                        vim.fn.jobstart('go doc ' .. pkg, {
                            on_stdout = function(_, doc_data, _)
                                if doc_data and #doc_data > 1 then
                                    local doc_buf = vim.api.nvim_create_buf(false, true)
                                    vim.api.nvim_buf_set_option(doc_buf, 'filetype', 'markdown')

                                    local doc_text = {
                                        "# Package " .. pkg,
                                        string.rep("─", 50),
                                        ""
                                    }

                                    -- Format the documentation
                                    local in_code_block = false
                                    for _, line in ipairs(doc_data) do
                                        if line:match('^func') or line:match('^type')
                                            or line:match('^var') or line:match('^const') then
                                            if not in_code_block then
                                                table.insert(doc_text, "```go")
                                                in_code_block = true
                                            end
                                        elseif in_code_block and line:match('^%s*$') then
                                            table.insert(doc_text, "```")
                                            table.insert(doc_text, "")
                                            in_code_block = false
                                        end

                                        table.insert(doc_text, line)
                                    end

                                    if in_code_block then
                                        table.insert(doc_text, "```")
                                    end

                                    -- Show the documentation in a new float
                                    local doc_win = vim.api.nvim_open_win(doc_buf, true, {
                                        relative = 'editor',
                                        width = width,
                                        height = height,
                                        col = math.floor((vim.o.columns - width) / 2),
                                        row = math.floor((vim.o.lines - height) / 2),
                                        style = 'minimal',
                                        border = 'rounded',
                                        title = ' Package: ' .. pkg .. ' ',
                                        title_pos = 'center'
                                    })

                                    vim.api.nvim_buf_set_lines(doc_buf, 0, -1, false, doc_text)
                                    vim.api.nvim_buf_set_option(doc_buf, 'modifiable', false)

                                    -- Add close keymaps
                                    vim.keymap.set('n', 'q', function()
                                        vim.api.nvim_win_close(doc_win, true)
                                    end, { buffer = doc_buf, noremap = true })
                                    vim.keymap.set('n', '<Esc>', function()
                                        vim.api.nvim_win_close(doc_win, true)
                                    end, { buffer = doc_buf, noremap = true })
                                end
                            end
                        })
                    end
                end, { buffer = buf, noremap = true })
            end
        end
    })
end

-- Add key mapping for Go package browser
vim.keymap.set('n', '<leader>gp', open_package_browser,
    { desc = "Browse Go packages" })

-- Create a keymapping
vim.keymap.set('n', '<leader>ch', display_lsp_info,
    { desc = "Display enhanced LSP information" })

-- Add key mapping for Go documentation lookup
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set('n', '<leader>gd', open_godoc,
            { buffer = true, desc = "Open Go documentation for symbol under cursor" })
    end
})
-- Add key mapping for Go type information
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set('n', '<leader>gt', show_go_type_info,
            { buffer = true, desc = "Show detailed Go type information" })
    end
})

-- Add a keymap to see full diagnostics
vim.keymap.set('n', '<leader>ld', vim.diagnostic.open_float, { desc = "Show diagnostic details" })
