return {
	"lukas-reineke/indent-blankline.nvim",
	opts = {},
	config = function(_, opts)
		require("ibl").setup(opts)
	end,
}
