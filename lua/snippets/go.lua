local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    -- Basic return if error
    s("iferr", fmt([[
        if {} != nil {{
            return {}
        }}
    ]], {
        i(1, "err"),
        i(2, "err"),
    })),

    -- Log the error
    s("iferrlog", fmt([[
        if {} != nil {{
            log.Println({})
            return {}
        }}
    ]], {
        i(1, "err"),
        i(2, "err"),
        i(3, "err"),
    })),

    -- Wrap the error
    s("iferrwrap", fmt([[
        if {} != nil {{
            return fmt.Errorf("{}: %w", {})
        }}
    ]], {
        i(1, "err"),
        i(2, "context"), -- e.g. "failed to read file"
        i(3, "err"),
    })),

    -- Panic on error
    s("iferrpanic", fmt([[
        if {} != nil {{
            panic({})
        }}
    ]], {
        i(1, "err"),
        i(2, "err"),
    })),

    -- Fatal log and exit (for main packages)
    s("iferrfatal", fmt([[
        if {} != nil {{
            log.Fatalf("{}: %v", {})
        }}
    ]], {
        i(1, "err"),
        i(2, "fatal error"),
        i(3, "err"),
    })),
}
