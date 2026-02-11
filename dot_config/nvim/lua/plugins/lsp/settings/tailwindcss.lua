local util = require("lspconfig.util")
local tbl_unpack = table.unpack or unpack

local ROOT_FILES = {
	"tailwind.config.js",
	"tailwind.config.cjs",
	"tailwind.config.mjs",
	"tailwind.config.ts",
	"postcss.config.js",
	"postcss.config.cjs",
	"postcss.config.mjs",
	"postcss.config.ts",
	"theme/static_src/tailwind.config.js",
	"theme/static_src/postcss.config.js",
}

return {
	root_markers = ROOT_FILES,
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		local root = util.root_pattern(tbl_unpack(ROOT_FILES))(fname)
		if root then
			on_dir(root)
		end
	end,
}
