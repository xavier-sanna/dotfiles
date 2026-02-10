local slow_format_filetypes = {}

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			php = { "php-cs-fixer" },
			yaml = { "yamlfmt" },
			sh = { "shfmt" },
			json = { "fixjson" },
			python = { "ruff" },
			css = { "prettierd" },
			hcl = { "hcl" },
			tf = { "terraform" },
			jinja = { "djlint" },
			jinja_inline = { "djlint" },
			sql = { "sleek" },
		},
		format_on_save = function(bufnr)
			if slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			local function on_format(err)
				if err and err:match("timeout$") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return { timeout_ms = 200, lsp_fallback = true }, on_format
		end,

		format_after_save = function(bufnr)
			if not slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			return { lsp_fallback = true }
		end,
		-- format_on_save = {
		-- 	-- These options will be passed to conform.format()
		-- 	timeout_ms = 500,
		-- 	lsp_fallback = true,
		-- },
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

		wk.add({ "<leader>m", group = "formatting" })
	end,
}
