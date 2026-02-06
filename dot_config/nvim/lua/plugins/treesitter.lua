local install_list = {
	"json",
	"javascript",
	"typescript",
	"tsx",
	"yaml",
	"html",
	"css",
	"markdown",
	"markdown_inline",
	"bash",
	"lua",
	"vim",
	"dockerfile",
	"gotmpl",
	"gitignore",
	"git_config",
	"vimdoc",
	"go",
	"dot",
	"make",
	"php",
	"phpdoc",
	"python",
	"rasi",
	"regex",
	"rust",
	"scss",
	"sql",
	"terraform",
	"toml",
	"twig",
	"vim",
	"vimdoc",
	"yaml",
	"yuck",
	"hcl",
	"asm",
	"jinja",
	"jinja_inline",
}

return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		-- highlight
		highlight = {
			enable = true,
		},

		-- text objects
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
			},
			move = {
				enable = true,
				set_jumps = true,
			},
		},
		-- enable indentation
		indent = { enable = true },

		-- enable autotagging (w/ nvim-ts-autotag plugin)
		-- autotag = {
		-- 	enable = true,
		-- 	enable_rename = true,
		-- 	enable_close = true,
		-- 	enable_close_on_slash = true,
		-- 	filetypes = { "html", "xml" },
		-- },

		-- ensure these language parsers are installed
		ensure_installed = install_list,
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	},
	config = function(_, opts)
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup(opts)
	end,
}
