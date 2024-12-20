local util = require("lspconfig.util")

return {
	root_dir = function(pattern)
		local cwd = vim.uv.cwd()
		local root = util.root_pattern("composer.json")(pattern)

		-- prefer cwd if root is a descendant
		return util.path.is_descendant(cwd, root) and cwd or root
	end,
	init_options = {
		licenceKey = vim.fn.expand("$HOME/.intelephense/license.txt"),
		storagePath = vim.fn.expand("$HOME/.intelephense"),
		globalStoragePath = vim.fn.expand("$HOME/.intelephense"),
	},
}
