return { -- Autocompletion
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    dependencies = {
        "rafamadriz/friendly-snippets",
        "folke/lazydev.nvim",
    },

    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
        keymap = {
            -- All presets have the following mappings:
            -- <tab>/<s-tab>: move to right/left of your snippet expansion
            -- <c-space>: Open menu or open docs if already open
            -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
            -- <c-e>: Hide menu
            -- <c-k>: Toggle signature help
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            preset = "default",
        },

        appearance = {
            nerd_font_variant = "Nerd Font Mono",
        },

        completion = {
            -- By default, you may press `<c-space>` to show the documentation.
            -- Optionally, set `auto_show = true` to show the documentation after a delay.
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
            ghost_text = { enabled = true },
            menu = { auto_show = true },
        },

        sources = {
            default = { "lsp", "path", "snippets", "lazydev" },
            providers = {
                lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
            },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
    },
}
