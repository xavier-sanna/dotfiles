local util = require("lspconfig.util")

return {
	-- root_dir = function(pattern)
	-- 	local cwd = vim.uv.cwd()
	-- 	local root = util.root_pattern("ansible.cfg", ".ansible-lint")(pattern)
	--
	-- 	-- prefer cwd if root is a descendant
	-- 	if root and util.path.is_descendant(cwd, root) then
	-- 		return cwd
	-- 	end
	--
	-- 	return root
	-- end,
	root_markers = { "ansible.cfg", ".ansible-lint" },
	filetypes = { "yaml.ansible" },
	settings = {
		ansible = {
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			python = {
				interpreterPath = "python",
			},
			validation = {
				enabled = true,
				lint = {
					enabled = true,
					path = "ansible-lint",
				},
			},
		},
	},
}
