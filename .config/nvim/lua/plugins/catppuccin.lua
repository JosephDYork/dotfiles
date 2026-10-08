return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    tag = "v2.0.0", -- pin to stable version compatible with your Neovim
    opts ={
        integrations = {
            diffview = true,
            gitsigns = true,
            mason = true,
        },
    },
    config = function()
        vim.cmd([[colorscheme catppuccin-mocha]])
    end,
}
