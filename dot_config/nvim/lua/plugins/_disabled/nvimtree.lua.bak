return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"JMarkin/nvim-tree.lua-float-preview",
			lazy = true,
			-- default
			opts = {
				-- Whether the float preview is enabled by default. When set to false, it has to be "toggled" on.
				toggled_on = false,
				-- wrap nvimtree commands
				wrap_nvimtree_commands = true,
				-- lines for scroll
				scroll_lines = 20,
				-- window config
				window = {
					style = "minimal",
					relative = "win",
					border = "rounded",
					wrap = false,
				},
				mapping = {
					-- scroll down float buffer
					down = { "<C-d>" },
					-- scroll up float buffer
					up = { "<C-e>", "<C-u>" },
					-- enable/disable float windows
					toggle = { "<C-p>" },
				},
				-- hooks if return false preview doesn't shown
				hooks = {
					pre_open = function(path)
						-- if file > 5 MB or not text -> not preview
						local size = require("float-preview.utils").get_size(path)
						if type(size) ~= "number" then
							return false
						end
						local is_text = require("float-preview.utils").is_text(path)
						return size < 5 and is_text
					end,
					post_open = function()
						return true
					end,
				},
			},
		},
	},
	opts = {
		view = {
			width = 35,
			relativenumber = false,
			adaptive_size = false,
		},
		-- change folder arrow icons
		renderer = {
			indent_markers = {
				enable = true,
			},
			icons = {
				glyphs = {
					folder = {
						arrow_closed = "", -- arrow when folder is closed
						arrow_open = "", -- arrow when folder is open
					},
				},
			},
		},
		-- disable window_picker for
		-- explorer to work well with
		-- window splits
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
			change_dir = {
				enable = false,
				restrict_above_cwd = true,
			},
		},
		filters = {
			custom = { ".DS_Store", ".idea", ".git" },
		},
		git = {
			enable = true,
			timeout = 300,
			ignore = false,
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			local FloatPreview = require("float-preview")

			-- attach preview plugin
			FloatPreview.attach_nvimtree(bufnr)

			-- local keymaps
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		end,
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		vim.keymap.set("n", "\\\\", "<cmd>NvimTreeToggle<CR>", { noremap = true, desc = "NvimTree Toggle" })
		vim.keymap.set("n", "\\r", "<cmd>NvimTreeRefresh<CR>", { noremap = true, desc = "nvimTree Refresh" })
	end,
}
