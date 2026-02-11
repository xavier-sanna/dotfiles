-- disable netrw for neotree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Compatibility shim for plugins still using deprecated vim.lsp.get_active_clients.
if vim.lsp and type(vim.lsp.get_clients) == "function" then
	vim.lsp.get_active_clients = function(filter)
		local opts = filter
		if opts and opts.bufnr == 0 then
			opts = vim.tbl_deep_extend("force", opts, { bufnr = vim.api.nvim_get_current_buf() })
		end
		return vim.lsp.get_clients(opts)
	end
end
