local Plugin = { 'echasnovski/mini.nvim', version = false }

function Plugin.config()
	require('mini.comment').setup()
	require('mini.ai').setup()
	require('mini.git').setup()
	require('mini.icons').setup()
	require('mini.starter').setup()
end

return Plugin
