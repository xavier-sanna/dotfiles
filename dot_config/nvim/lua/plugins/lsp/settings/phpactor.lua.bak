return {
	root_dir = function(startPath)
		local rp = (require("lspconfig.util")).root_pattern
		for _, pattern in pairs({ "composer.json" }) do
			local found = rp({ pattern })(startPath)
			if found and found ~= "" then
				return found
			end
		end
		return nil
	end,
}
