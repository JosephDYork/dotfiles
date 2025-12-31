return {
    "axkirillov/unified.nvim",
    opts = {
        signs = {
            add = "│",
            delete = "│",
            change = "│",
        },
        highlights = {
            add = "DiffAdd",
            delete = "DiffDelete",
            change = "DiffChange",
        },
        line_symbols = {
            add = "+",
            delete = "-",
            change = "~",
        },
        auto_refresh = true, -- Whether to automatically refresh diff when buffer changes
    },
}
