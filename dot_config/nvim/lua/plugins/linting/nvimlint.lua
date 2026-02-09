return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			yaml = { "yamllint" },
			sh = { "shellcheck" },
			json = { "jsonlint" },
			python = { "flake8" },
			jinja = { "djlint" },
			jinja_inline = { "djlint" },
			-- php = { "php" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		local wk = require("which-key")

		wk.add({ "<leader>l", group = "linting" })
	end,
}
