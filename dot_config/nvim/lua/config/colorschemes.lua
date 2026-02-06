local user_config = require("utils.json-configuration")

-- Autocmd: Reload colorscheme
local colorscheme = vim.api.nvim_create_augroup("colorscheme", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = colorscheme,
	callback = function(args)
		user_config.update_value("colorscheme", args.match)
	end,
})

-- Exec: load colorscheme from user configuration
vim.cmd("colorscheme " .. user_config.get_config()["colorscheme"])
