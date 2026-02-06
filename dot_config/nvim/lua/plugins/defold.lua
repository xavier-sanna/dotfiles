return {
	"atomicptr/defold.nvim",
	lazy = false,
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	opts = {
		defold = {
			-- Automatically set defold.nvim as the default editor in Defold (default: true)
			set_default_editor = true,

			-- Automatically fetch dependencies on launch (default: true)
			auto_fetch_dependencies = true,

			-- Enable hot reloading when saving scripts in Neovim (default: true)
			hot_reload_enabled = true,
		},

		launcher = {
			-- How to run neovim "neovide" or "terminal" (default: neovide)
			type = "terminal",

			-- path to your neovim or terminal executable (optional)
			executable = nil,

			-- extra arguments passed to the `executable` (or neovide)
			extra_arguments = nil,

			-- configure how the terminal is run (optional)
			terminal = {
				-- argument to define how to set the class name of the terminal, usually something like "--class="
				class_argument = nil,

				-- argument to define how to run neovim, usually "-e"
				run_argument = nil,
			},
		},

		debugger = {
			-- Enable the debugger (default: true)
			enable = true,

			-- Use a custom executable for the debugger (default: nil)
			custom_executable = nil,

			-- Add custom arguments to the debugger (default: nil)
			custom_arguments = nil,
		},

		babashka = {
			-- Use a custom executable for babashka (default: nil)
			custom_executable = nil,
		},

		-- setup keymaps for Defold actions
		keymaps = {

			-- build (& run) action
			build = {
				-- make this available in normal and insert mode
				mode = { "n", "i" },

				-- run via Ctrl+b
				mapping = "<C-b>",
			},
		},

		-- Force the plugin to be always enabled (even if we can't find the game.project file) (default: false)
		force_plugin_enabled = false,
	},
	config = function(_, opts)
		require("defold").setup(opts)
	end,
}
