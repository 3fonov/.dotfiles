local Plugin = { 'nvim-lualine/lualine.nvim' }

Plugin.name = 'lualine'
Plugin.event = 'VeryLazy'

Plugin.opts = {
	options = {
		theme = 'tokyonight',
		icons_enabled = true,
		component_separators = '|',
		section_separators = '',
		disabled_filetypes = {
			statusline = { 'NvimTree' }
		}
	},

	sections = {
		lualine_c = {
			{
				function()
					-- Требуемый компонент: текущий путь в oil.nvim
					local oil = require("oil")
					local dir = oil.get_current_dir()
					if dir then
						return dir
					end
					return '' -- если это не Oil
				end,
				cond = function()
					-- Показывать ТОЛЬКО когда открыт Oil
					return vim.bo.filetype == "oil"
				end
			},
			{
				"filename",
				path = 1, -- 0 = только имя, 1 = относительный путь, 2 = абсолютный
			},
		}
	}
}

function Plugin.init()
	vim.opt.showmode = false
end

return Plugin
