require("no-neck-pain").setup({
    width = 100,
    minSideBufferWidth = 10,
    autocmds = {
        enableOnVimEnter = true,
    },
    mappings = {
        enabled = true,
    },
    buffers = {
        -- not working for some reason!?
        scratchPad = {
            enabled = true,
            location = "~/Git/ScratchPadFiles/"
        },
        bo = {
            filetype = "md",
        },
        colors = {
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
