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
		local server_names = vim.tbl_keys(servers)

		local has_setup_handlers = type(mason_lspconfig.setup_handlers) == "function"
		local mason_lspconfig_opts = {
			-- list of servers for mason to install
			ensure_installed = server_names,
		}

		if has_setup_handlers then
			mason_lspconfig_opts.automatic_installation = true
		else
			-- mason-lspconfig v2 uses vim.lsp.enable(); disable to avoid double setup.
			mason_lspconfig_opts.automatic_enable = false
		end

		mason_lspconfig.setup(mason_lspconfig_opts)

		local mason_packages = vim.list_extend(vim.deepcopy(tools), server_names)
		local seen = {}
		local ensure_installed = {}
		for _, package_name in ipairs(mason_packages) do
			if not seen[package_name] then
				seen[package_name] = true
				table.insert(ensure_installed, package_name)
			end
		end

		mason_tool_installer.setup({
			ensure_installed = ensure_installed,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
		lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(lsp_capabilities)

		local default_config = {
			on_attach = function() end,
			capabilities = lsp_capabilities,
		}

		local has_native_lsp = type(vim.lsp.config) == "table" and type(vim.lsp.enable) == "function"
		local lspconfig = nil
		local function has_runtime_config(server_name)
			return #vim.api.nvim_get_runtime_file(("lsp/%s.lua"):format(server_name), true) > 0
		end

		local function setup_server(server_name, server_config)
			local merged_config = vim.tbl_extend("force", default_config, server_config or {})
			if has_native_lsp then
				if not has_runtime_config(server_name) and merged_config.cmd == nil then
					return
				end

				vim.lsp.config(server_name, merged_config)
				vim.lsp.enable(server_name)
				return
			end

			if lspconfig == nil then
				lspconfig = require("lspconfig")
			end
			if lspconfig[server_name] == nil then
				return
			end

			lspconfig[server_name].setup(merged_config)
		end

		if has_setup_handlers and not has_native_lsp then
			mason_lspconfig.setup_handlers({
				function(server_name)
					setup_server(server_name, servers[server_name])
				end,
			})
		else
			for server_name, server_config in pairs(servers) do
				setup_server(server_name, server_config)
			end
		end
	end,
}
