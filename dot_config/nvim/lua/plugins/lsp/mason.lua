return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"intelephense",
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"graphql",
				"prismals",
				"docker_compose_language_service",
				"dockerls",
				"yamlls",
				"eslint",
				"bashls",
				"gopls",
				"jqls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"stylua",
				"yamllint",
				"yamlfmt",
				"shfmt",
				"shellcheck",
				"luacheck",
				"golangci-lint",
			},
		})
	end,
}
