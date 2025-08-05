local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s("iferr", fmt([[
        if {} != nil {{
            {}
        }}
    ]], {
        i(1, "err"),
        i(2, 'return err'),
    })),
}
