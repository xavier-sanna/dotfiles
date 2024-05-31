return {
	yaml = {
		validate = true,
		schemas = {
			["https://taskfile.dev/schema.json"] = {
				"Taskfile.{yml,yaml}",
				"*.Taskfile.{yml,yaml}",
			},
		},
	},
}
