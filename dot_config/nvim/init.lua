if vim.g.vscode then
	print(vim.g.vscode)
	print("vscode/cursor detected")
	require("vsc.config.global")
else
	print("neovim detected")
	require("config.global")
	require("config.options")
	require("config.mappings")
	require("config.filetypes")
	require("config.lazy")
	require("config.colorschemes")
end
