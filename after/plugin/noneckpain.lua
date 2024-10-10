require("no-neck-pain").setup({
    width = 120,
    minSideBufferWidth = 10,
    autocmds = {
        enableOnVimEnter = true,
    },
    mappings = {
        enabled = true,
    },
    buffers = {
        scratchPad = {
            enabled = true,
            location = "~/Git/ScratchPadFiles/"
        },
        bo = {
            filetype = "md",
        },
        -- not working for some reason!?
        colors = {
            backgroundColor = "#525252",
            right = {
                backgroundColor = "tokyonight-moon",
            },
            left = {
                backgroundColor = "tokyonight-moon",
            },
        },
        wo = {
            fillchars = "eob: ",
        }
    }
})
