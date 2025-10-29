---@diagnostic disable: need-check-nil
local json_conf = {}

local extra_filename = vim.g.vscode and ".vscode" or ""
local config_path = vim.fn.stdpath("state") .. "/user-config" .. extra_filename .. ".json"

local DEFAULT_VALUES = {
	colorscheme = "default",
	lualine_theme = "bubbles",
}

local function write_content_to_file(content)
	local file = io.open(config_path, "w")
	file:write(vim.json.encode(content))
	file:close()
end

local function update_fields(content)
	for key, val in pairs(DEFAULT_VALUES) do
		if content[key] == nil then
			-- set key/value in content
			content[key] = val

			-- write config file with updated content
			write_content_to_file(vim.json.encode(content))
		end
	end
end

local function get_file_content()
	local content = nil

	if vim.fn.filereadable(config_path) == 0 then
		print(vim.inspect("user configuration file does not exist - creating.."))

		write_content_to_file(DEFAULT_VALUES)

		content = DEFAULT_VALUES
	else
		local file = io.open(config_path, "rb") -- r read mode and b binary mode
		local file_content = file:read("*a") -- *a or *all reads the whole file

		content = vim.json.decode(file_content)

		-- update file for potentially newly added field
		update_fields(content)
	end

	return content
end

function json_conf.update_value(key, val)
	local content = get_file_content()
	content[key] = val

	write_content_to_file(content)
end

function json_conf.get_config()
	return get_file_content()
end

return json_conf
