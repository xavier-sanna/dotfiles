return {
	"norcalli/nvim-colorizer.lua",
	opts = {
		"*",
	},
	config = function(_, opts)
		-- Shim legacy command builder to avoid deprecated vim.tbl_flatten usage in this plugin.
		local colorizer_nvim = package.loaded["colorizer/nvim"] or require("colorizer/nvim")
		package.loaded["colorizer.nvim"] = colorizer_nvim
		local ex = colorizer_nvim.ex
		local ex_mt = getmetatable(ex)
		if ex_mt then
			ex_mt.__index = function(self, k)
				local mt = getmetatable(self)
				local cached = mt[k]
				if cached ~= nil then
					return cached
				end

				local command = k:gsub("_$", "!")
				local f = function(...)
					local cmd = table.concat(vim.iter({ command, ... }):flatten():totable(), " ")
					return vim.api.nvim_command(cmd)
				end

				mt[k] = f
				return f
			end
		end

		require("colorizer").setup(opts)
	end,
}
