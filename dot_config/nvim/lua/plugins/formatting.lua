return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			php = { "php-cs-fixer" },
			yaml = { "yamlfmt" },
			sh = { "shfmt" },
		},
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
	config = function(_, opts)
		local conform = require("conform")

		conform.setup(opts)

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		local wk = require("which-key")

		wk.register({
			["<leader>m"] = {
				name = "formatting",
			},
		})
	end,
}
