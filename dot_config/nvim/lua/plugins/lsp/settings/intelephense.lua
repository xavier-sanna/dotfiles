local util = require("lspconfig.util")

return {
	root_dir = function(pattern)
		local cwd = vim.loop.cwd()
		local root = util.root_pattern("composer.json", ".phpactor.json", ".phpactor.yml")(pattern)

		-- prefer cwd if root is a descendant
		print("chocapic")
		print(vim.inspect(root))
		return util.path.is_descendant(cwd, root) and cwd or root
	end,
	init_options = {
		licenceKey = "$HOME/intelephense/intelephense_licence_key",
	},
}
