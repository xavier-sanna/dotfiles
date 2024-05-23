local user_config = require("utils.json-configuration")
local file_utils = require("utils.files")
local table_utils = require("utils.tables")

local function load_theme()
	return user_config.get_config()["lualine_theme"]
end

local get_themes_list = function()
	local paths = vim.api.nvim_get_runtime_file("lua/plugins/lualine/themes/*.lua", true)
	local filenames = {}

	for _, v in ipairs(paths) do
		filenames[#filenames + 1] = file_utils.get_filename(v).filename
	end

	return filenames
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			disabled_filetypes = {
				"neo-tree",
			},
		},
		extensions = { "neo-tree" },
	},
	config = function(_, opts)
		local lazy_opts = require("plugins.lualine.themes." .. load_theme()).opts

		local lualine = require("lualine")

		lualine.setup(table_utils.merge(opts, lazy_opts))

		-- User Command: select
		vim.api.nvim_create_user_command("LualineTheme", function(tbl)
			local theme_name = tbl.fargs[1]

			local themes = get_themes_list()

			if table_utils.check(theme_name, themes) == false then
				print("theme: " .. theme_name .. " was not found")
				return
			end

			user_config.update_value("lualine_theme", theme_name)

			lualine.hide(_)
			vim.cmd("Lazy reload lualine.nvim")
		end, {
			nargs = 1,
			complete = function(_, _, _)
				return get_themes_list()
			end,
		})
	end,
}
