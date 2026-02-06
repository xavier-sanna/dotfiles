return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		animation = true,
		auto_hide = 0,
		tabpages = true,
		insert_at_end = false,
		sidebar_filetypes = {
			-- ['NvimTree'] = true,
			["neo-tree"] = true,
		},
	},
	version = "^1.0.0",
	config = function(_, opts)
		require("barbar").setup(opts)

		-- keymaps
		local keyopts = { noremap = true, silent = true }

		-- Move to previous/next
		vim.keymap.set("n", "<M-,>", "<Cmd>BufferPrevious<CR>", { unpack(keyopts), desc = "Go to previous buffer" })
		vim.keymap.set("n", "<M-.>", "<Cmd>BufferNext<CR>", { unpack(keyopts), desc = "Go to next buffer" })
		-- Re-order to previous/next
		vim.keymap.set(
			"n",
			"<M-S-,>",
			"<Cmd>BufferMovePrevious<CR>",
			{ unpack(keyopts), desc = "Move buffer to previous positon" }
		)
		vim.keymap.set(
			"n",
			"<M-S-.>",
			"<Cmd>BufferMoveNext<CR>",
			{ unpack(keyopts), desc = "Move buffer to next positon" }
		)
		-- Goto buffer in position...
		vim.keymap.set("n", "<M-1>", "<Cmd>BufferGoto 1<CR>", { unpack(keyopts), desc = "Go to buffer #1" })
		vim.keymap.set("n", "<M-2>", "<Cmd>BufferGoto 2<CR>", { unpack(keyopts), desc = "Go to buffer #2" })
		vim.keymap.set("n", "<M-3>", "<Cmd>BufferGoto 3<CR>", { unpack(keyopts), desc = "Go to buffer #3" })
		vim.keymap.set("n", "<M-4>", "<Cmd>BufferGoto 4<CR>", { unpack(keyopts), desc = "Go to buffer #4" })
		vim.keymap.set("n", "<M-5>", "<Cmd>BufferGoto 5<CR>", { unpack(keyopts), desc = "Go to buffer #5" })
		vim.keymap.set("n", "<M-6>", "<Cmd>BufferGoto 6<CR>", { unpack(keyopts), desc = "Go to buffer #6" })
		vim.keymap.set("n", "<M-7>", "<Cmd>BufferGoto 7<CR>", { unpack(keyopts), desc = "Go to buffer #7" })
		vim.keymap.set("n", "<M-8>", "<Cmd>BufferGoto 8<CR>", { unpack(keyopts), desc = "Go to buffer #8" })
		vim.keymap.set("n", "<M-9>", "<Cmd>BufferGoto 9<CR>", { unpack(keyopts), desc = "Go to buffer #9" })
		vim.keymap.set("n", "<M-0>", "<Cmd>BufferLast<CR>", { unpack(keyopts), desc = "Go to last buffer" })
		-- Pin/unpin buffer
		vim.keymap.set("n", "<M-p>", "<Cmd>BufferPin<CR>", { unpack(keyopts), desc = "Pin current buffer" })
		-- Close buffer
		vim.keymap.set("n", "<M-c>", "<Cmd>BufferClose<CR>", { unpack(keyopts), desc = "Close current buffer" })
		-- Wipeout buffer
		--                 :BufferWipeout
		-- Close commands
		--                 :BufferCloseAllButCurrent
		--                 :BufferCloseAllButPinned
		--                 :BufferCloseAllButCurrentOrPinned
		--                 :BufferCloseBuffersLeft
		--                 :BufferCloseBuffersRight
		-- Magic buffer-picking mode
		vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { unpack(keyopts), desc = "Pin current buffer" })
		-- Sort automatically by...
		vim.keymap.set(
			"n",
			"<leader>bb",
			"<Cmd>BufferOrderByBufferNumber<CR>",
			{ unpack(keyopts), desc = "Order buffers by number" }
		)
		vim.keymap.set(
			"n",
			"<leader>bn",
			"<Cmd>BufferOrderByName<CR>",
			{ unpack(keyopts), desc = "Order buffers by name" }
		)
		vim.keymap.set(
			"n",
			"<leader>bd",
			"<Cmd>BufferOrderByDirectory<CR>",
			{ unpack(keyopts), desc = "Order buffers by directory" }
		)
		vim.keymap.set(
			"n",
			"<leader>bl",
			"<Cmd>BufferOrderByLanguage<CR>",
			{ unpack(keyopts), desc = "Order buffers by language" }
		)
		vim.keymap.set(
			"n",
			"<leader>bw",
			"<Cmd>BufferOrderByWindowNumber<CR>",
			{ unpack(keyopts), desc = "Order buffers by window number" }
		)

		-- which-key
		local wk = require("which-key")

		wk.add({ "<leader>b", name = "+buffer" })
	end,
}
