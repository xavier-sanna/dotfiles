local files = {}

function files.get_filename(path)
	local filename, extension = path:match("^.+/(.+)%.(.+)$")

	return {
		filename = filename,
		ext = extension,
	}
end

return files
