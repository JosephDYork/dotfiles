return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            rust = { "rustfmt", lsp_format = "fallback" },
            python = { "black" },
            cs = { "csharpier" },
            csproj = { "csharpier" },

            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
        formatters = {
            stylua = {
                inherit = false,
                command = "/usr/bin/stylua",
                args = {
                    "--search-parent-directories",
                    "--indent-type", "Spaces",
                    "--stdin-filepath",
                    "$FILENAME",
                    "-",
                },
            },
            csharpier = {
                command = "csharpier",
                args = {
                    "format",
                    "--write-stdout",
                },
                to_stdin = true,
            },
        },
    },
}
