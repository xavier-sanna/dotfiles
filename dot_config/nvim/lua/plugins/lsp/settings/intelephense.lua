local util = require("lspconfig.util")

return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = { ".git", "composer.json" },
	init_options = {
		licenceKey = vim.fn.expand("$HOME/.intelephense/license.txt"),
		storagePath = vim.fn.expand("$HOME/.intelephense"),
		globalStoragePath = vim.fn.expand("$HOME/.intelephense"),
	},
}
