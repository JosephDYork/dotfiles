return {
    "sindrets/diffview.nvim",
    opts = {
        enhanced_diff_hl = true,
        use_icons = true,
        signs = {
            fold_closed = "",
            fold_open = "",
        },
        view = {
            -- Keep a balanced layout with context
            merge_tool = {
                layout = "diff3_mixed",
                disable_diagnostics = true,
            },
            default = {
                layout = "diff2_horizontal",
            },
        },
        file_panel = {
            listing_style = "tree",
            win_config = { position = "left", width = 35 },
        },
        file_history_panel = {
            log_options = { git = { single_file = { diff_merges = "combined" } } },
            win_config = { position = "bottom", height = 12 },
        },
    },
    config = function()
        vim.keymap.set("n", "<leader>hvo", ":DiffviewOpen<CR>")
        vim.keymap.set("n", "<leader>hvc", ":DiffviewClose<CR>")
    end,
}
