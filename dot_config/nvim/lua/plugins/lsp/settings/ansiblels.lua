return {
	root_dir = function(pattern)
		local cwd = vim.uv.cwd()
		local root = util.root_pattern("ansible.cfg")(pattern)

		-- prefer cwd if root is a descendant
		return util.path.is_descendant(cwd, root) and cwd or root
	end,
	root_markers = { "ansible.cfg", "ansible-lint" },
	filetypes = { "yaml.ansible" },
	settings = {
		validation = {
			enabled = true,
			lint = {
				enabled = true,
				path = "ansible-lint",
			},
		},
	},
}
