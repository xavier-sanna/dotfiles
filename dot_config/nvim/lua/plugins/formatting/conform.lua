local slow_format_filetypes = {}

local function lsp_fallback_for(bufnr)
	return vim.bo[bufnr].filetype ~= "php"
end

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
			php = { "php_cs_fixer" },
			yaml = { "yamlfmt" },
			sh = { "shfmt" },
			json = { "fixjson" },
			python = { "ruff" },
			css = { "prettierd" },
			hcl = { "hcl" },
			tf = { "terraform" },
			-- jinja = { "djlint" },
			-- jinja_inline = { "djlint" },
			sql = { "sleek" },
			toml = { "tombi" },
			scss = { "prettierd" },
		},

		-- formatters = {
		-- 	djlint = {
		-- 		condition = function(_, ctx)
		-- 			local filename = ((ctx and ctx.filename) or ""):lower()
		-- 			return filename:match("%.ya?ml%.j2$") == nil
		-- 		end,
		-- 	},
		-- },

		format_on_save = function(bufnr)
			if slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			local function on_format(err)
				if err and err:match("timeout$") then
					slow_format_filetypes[vim.bo[bufnr].filetype] = true
				end
			end

			return { timeout_ms = 200, lsp_fallback = lsp_fallback_for(bufnr) }, on_format
		end,

		format_after_save = function(bufnr)
			if not slow_format_filetypes[vim.bo[bufnr].filetype] then
				return
			end
			return { lsp_fallback = lsp_fallback_for(bufnr) }
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
			local bufnr = vim.api.nvim_get_current_buf()
			conform.format({
				lsp_fallback = lsp_fallback_for(bufnr),
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		local wk = require("which-key")

		wk.add({ "<leader>m", group = "formatting" })
	end,
}
