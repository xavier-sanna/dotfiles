return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	config = function()
		local wk = require("which-key")

		wk.add({ "<leader>M", group = "markdown" })

		local keyopts = { noremap = true, silent = true }

		vim.keymap.set(
			"n",
			"<leader>Mo",
			"<Cmd>MarkdownPreview<CR>",
			{ unpack(keyopts), desc = "Open markdown preview" }
		)

		vim.keymap.set(
			"n",
			"<leader>Mx",
			"<Cmd>MarkdownPreviewStop<CR>",
			{ unpack(keyopts), desc = "Close markdown preview" }
		)

		vim.keymap.set(
			"n",
			"<leader>Mp",
			"<Cmd>MarkdownPreviewToggle<CR>",
			{ unpack(keyopts), desc = "Toggle markdown preview" }
		)
	end,
}
