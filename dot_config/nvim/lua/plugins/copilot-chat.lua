return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "main",
	dependencies = {
		{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
		{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log wrapper
	},
	build = "make tiktoken", -- Only on MacOS or Linux
	opts = {
		-- See Configuration section for options
		model = "claude-3.5-sonnet",
		show_help = true, -- Show help text for CopilotChatInPlace
		mappings = {
			reset = {
				normal = "<leader>pr",
				insert = "<C-r>",
			},
		},
		debug = {
			enabled = true,
			save_chat_history = true,
			save_path = vim.fn.stdpath("data") .. "/copilot-chat",
		},
	},

	config = function(_, opts)
		local chat = require("CopilotChat")

		chat.setup(opts)

		vim.keymap.set({ "n", "v" }, "<leader>pts", function()
			chat.toggle()
		end, { desc = "Toggle Chat (split mode)" })
		vim.keymap.set({ "n", "v" }, "<leader>ptf", function()
			chat.toggle({
				window = {
					layout = "float", -- 'split', 'float'
					relative = "editor",
					width = 0.8,
					height = 0.8,
					border = "rounded",
				},
			})
		end, { desc = "Toggle Chat (split mode)" })
		vim.keymap.set({ "n", "v" }, "<leader>pe", ":CopilotChatExplain<CR>", { desc = "Explain Code" })
		vim.keymap.set({ "n", "v" }, "<leader>pT", ":CopilotChatTests<CR>", { desc = "Generate Tests" })
		vim.keymap.set({ "n", "v" }, "<leader>pR", ":CopilotChatReview<CR>", { desc = "Review Code" })
		vim.keymap.set({ "n", "v" }, "<leader>pf", ":CopilotChatFix<CR>", { desc = "Fix Code" })

		local wk = require("which-key")

		wk.add({
			{ "<leader>p", group = "Copilot" },
			{ "<leader>pt", group = "Toggle Chat" },
		})
	end,
	-- See Commands section for default commands if you want to lazy load on them
}
