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

		local servers = require("plugins.lsp.mason-files.mason-servers")
		local tools = require("plugins.lsp.mason-files.mason-tools")

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = tools,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
		lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(lsp_capabilities)

		local default_config = {
			on_attach = function() end,
			capabilities = lsp_capabilities,
		}

		local lspconfig = require("lspconfig")
		mason_lspconfig.setup_handlers({
			function(server_name)
				local server_config = servers[server_name]
				local merged_config = vim.tbl_extend("force", default_config, { settings = server_config })
				lspconfig[server_name].setup(merged_config)
			end,
		})
	end,
}
