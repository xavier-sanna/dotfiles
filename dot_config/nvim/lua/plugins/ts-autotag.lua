return {
	"windwp/nvim-ts-autotag",
	opts = {},
	per_filetype = {
		["tsx"] = {
			enable_close_on_slash = true,
		},
		["jsx"] = {
			enable_close_on_slash = true,
		},
	},
	config = function(_, opts)
		require("nvim-ts-autotag").setup(opts)
	end,
}
