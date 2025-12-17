return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = false,
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false, -- this will be removed in the next major release
		workspaces = {
			{
				name = "personal",
				path = "~/obs",
			},
		},
		ui = {
			enable = true,
			update_debounce = 200,
			bullets = {},
		},
		templates = {
			-- папка внутри vault
			folder = "templates",

			-- не обязательно, но удобно для других шаблонов
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		daily_notes = {
			folder = "daily", -- <<< ВАЖНО: именно эта папка должна совпадать с настроенной в Obsidian
			date_format = "%Y-%m-%d",
			alias_format = "%Y-%m-%d",
			default_tags = { "daily" },
			template = "daily.md",
		},
		note_id_func = function(title)
			if title ~= nil then
				return title:gsub("%s+", "-"):lower()
			else
				return tostring(os.time()) -- запасной вариант
			end
		end,
		-- see below for full list of options 👇
	},
}
