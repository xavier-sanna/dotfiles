return {
	root_dir = function(startPath)
		local rp = (require("lspconfig.util")).root_pattern
		for _, pattern in pairs({ "composewr.json" }) do
			local found = rp({ pattern })(startPath)
			print("### PHPACTOR ###")
			print(vim.inspect(pattern))
			print(vim.inspect(found))
			print("chocapic")
			if found and found ~= "" then
				return found
			end
		end
		return nil
	end,
}
