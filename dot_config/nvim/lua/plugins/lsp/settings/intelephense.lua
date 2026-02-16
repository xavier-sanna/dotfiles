return {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = { ".git", "composer.json" },
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	init_options = {
		licenceKey = vim.fn.expand("$HOME/.intelephense/license.txt"),
		storagePath = vim.fn.expand("$HOME/.intelephense"),
		globalStoragePath = vim.fn.expand("$HOME/.intelephense"),
	},
	settings = {
		intelephense = {
			telemetry = {
				enabled = false,
			},
			format = {
				enable = false,
			},
		},
	},
}
