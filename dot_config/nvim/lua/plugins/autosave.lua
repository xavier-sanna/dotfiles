return {
	"okuuva/auto-save.nvim",
	cmd = "ASToggle", -- optional for lazy loading on command
	event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events

	opts = {
		enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
		trigger_events = { -- See :h events
			immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
			defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (after `debounce_delay`)
			cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
		},

		-- function that takes the buffer handle and determines whether to save the current buffer or not
		-- return true: if buffer is ok to be saved
		-- return false: if it's not ok to be saved
		-- if set to `nil` then no specific condition is applied
		condition = nil,
		write_all_buffers = false, -- write all buffers when the current one meets `condition`
		noautocmd = false, -- do not execute autocmds when saving
		debounce_delay = 1000, -- delay after which a pending save is executed
		-- log debug messages to 'auto-save.log' file in neovim cache directory, set to `true` to enable
		debug = false,
	},
	config = function(_, opts)
		require("auto-save").setup(opts)

		local group = vim.api.nvim_create_augroup("autosave", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			pattern = "AutoSaveWritePost",
			group = group,
			callback = function(callback_opts)
				if callback_opts.data.saved_buffer ~= nil then
					local filename = vim.api.nvim_buf_get_name(callback_opts.data.saved_buffer)
					local username = vim.env.USER

					print("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))

					if filename:match("^/home/" .. username .. "/.local/share/chezmoi/.*") then
						vim.cmd('silent ! chezmoi apply --source-path "%"')
						print("Chezmoi source file detected: auto applied " .. filename)
					end
				end
			end,
		})
	end,
}

-- vim: set filetype=lua:
