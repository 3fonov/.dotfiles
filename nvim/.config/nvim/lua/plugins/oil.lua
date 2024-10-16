Plugin = {
	'stevearc/oil.nvim',
	opts = {
		skip_confirm_for_simple_edits = true,
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = true,
			-- This function defines what will never be shown, even when `show_hidden` is set
			is_always_hidden = function(name, _)
				return name == ".." or name == ".git"
			end
		}
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
return Plugin
