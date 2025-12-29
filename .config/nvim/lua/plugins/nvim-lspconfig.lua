return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "j-hui/fidget.nvim", opts = {} },
        { "mason-org/mason.nvim", opts = {} },
        { "mason-org/mason-lspconfig.nvim", opts = {} },
        { "saghen/blink.cmp", opts = {} }, -- Allows extra capabilities provided by blink.cmp
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("jvim-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Rename the variable under your cursor.
                map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

                -- Execute a code action, usually your cursor needs to be on top of an error
                map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                -- Jump to the implementation of the word under your cursor.
                map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                -- Jump to the definition of the word under your cursor.
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- Fuzzy find all the symbols in your current document.
                map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

                -- Fuzzy find all the symbols in your current workspace.
                map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

                -- Jump to the type of the word under your cursor.
                map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

                -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup = vim.api.nvim_create_augroup("jvim-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("jvim-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "jvim-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end
            end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = "E! ",
                    [vim.diagnostic.severity.WARN] = "W! ",
                    [vim.diagnostic.severity.INFO] = "I! ",
                    [vim.diagnostic.severity.HINT] = "H! ",
                },
            } or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        local servers = {
            clangd = {},
            pyright = {},
            rust_analyzer = {
                check = {
                    allTargets = false,
                },
            },
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        diagnostics = { disable = { "missing-fields" } },
                    },
                },
            },
        }
    end,
}
