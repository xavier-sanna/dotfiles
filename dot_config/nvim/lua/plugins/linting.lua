return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			-- php = { "phpmd", "phpstan", "phpcs" },
			yaml = { "yamllint" },
			sh = { "shellcheck" },
			lua = { "luacheck" },
		}

		-->> Custom configurations
		-- local eslint = lint.linters.eslint
		-- eslint.cmd = function()
		-- 	local binary_name = "eslint"
		-- 	local function get_local_binary()
		-- 		local files = vim.fs.find({ "node_modules" }, { limit = 3 })
		-- 		print("Files")
		-- 		print(vim.inspect(files))
		-- 		for _, dir in ipairs(files) do
		-- 			local path = dir .. "/.bin/" .. binary_name
		-- 			print("Path:")
		-- 			print(vim.inspect(path))
		-- 			local stat = vim.uv.fs_stat(path)
		-- 			print("Stat:")
		-- 			print(vim.inspect(stat))
		-- 			if stat then
		-- 				return path
		-- 			end
		--
		-- 			return binary_name
		-- 		end
		-- 	end
		--
		-- 	local binary = get_local_binary()
		--
		-- 	print(vim.inspect(binary))
		--
		-- 	return binary
		-- end
		--<<

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

		wk.register({
			["<leader>l"] = {
				name = "linting",
			},
		})

		-- local phpcs = require("lint").linters.phpcs
		-- phpcs.args = {
		-- 	"-q",
		-- 	"--standard=ruleset.xml",
		-- 	"--report=json",
		-- 	"-", -- need `-` at the end for stdin support
		-- }
		-- local phpmd = require("lint").linters.phpmd
		-- phpmd.args = {
		--   "-q",
		--   -- <- Add a new parameter here
		--   "--report=json",
		--   "-",
		-- }
	end,
}
