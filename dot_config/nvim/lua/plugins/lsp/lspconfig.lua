return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"williamboman/mason-lspconfig.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local key_opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				key_opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", key_opts) -- show definition, references

				key_opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, key_opts) -- go to declaration

				key_opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", key_opts) -- show lsp definitions

				key_opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", key_opts) -- show lsp implementations

				key_opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", key_opts) -- show lsp type definitions

				key_opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, key_opts)

				key_opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, key_opts) -- smart rename

				key_opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", key_opts) -- show  diagnostics for file

				key_opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, key_opts) -- show diagnostics for line

				key_opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, key_opts) -- jump to previous diagnostic in buffer

				key_opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, key_opts) -- jump to next diagnostic in buffer

				key_opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, key_opts) -- show documentation for what is under cursor

				key_opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", key_opts) -- mapping to restart lsp if necessary
			end,
		})

		local wk = require("which-key")

		wk.add({ "<leader>r", group = "lsp" })

		-- Diagnostic sign text (Neovim 0.10+ style; replaces sign_define).
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
				},
			},
		})
	end,
}
