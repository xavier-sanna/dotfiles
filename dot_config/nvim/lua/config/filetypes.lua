-- Json files without json extension
local filetypes_group = vim.api.nvim_create_augroup("filetypes", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = filetypes_group,
	pattern = { ".swcrc" },
	command = "set filetype=json",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = filetypes_group,
	pattern = { "*.tmpl" },
	command = "set filetype=gotmpl",
})
