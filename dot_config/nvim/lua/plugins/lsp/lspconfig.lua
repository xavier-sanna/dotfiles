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
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

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
				keymap.set("n", "[d", vim.diagnostic.goto_prev, key_opts) -- jump to previous diagnostic in buffer

				key_opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, key_opts) -- jump to next diagnostic in buffer

				key_opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, key_opts) -- show documentation for what is under cursor

				key_opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", key_opts) -- mapping to restart lsp if necessary
			end,
		})

		local wk = require("which-key")

		wk.add({ "<leader>r", group = "lsp" })

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local handle_setup = function(server_name, extra_config)
			local config = {
				capabilities = capabilities,
			}

			if extra_config ~= nil then
				config = { table.unpack(config), table.unpack(extra_config) }
			end

			lspconfig[server_name].setup(config)
		end

		mason_lspconfig.setup_handlers({
			handle_setup,
			["gopls"] = handle_setup("gopls", require("plugins.lsp.settings.gopls")),
			["lua_ls"] = handle_setup("lua_ls", require("plugins.lsp.settings.lua-ls")),
			["yamlls"] = handle_setup("yamlls", require("plugins.lsp.settings.yamlls")),
			["intelephense"] = handle_setup("intelephense", require("plugins.lsp.settings.intelephense")),
		})
	end,
}
