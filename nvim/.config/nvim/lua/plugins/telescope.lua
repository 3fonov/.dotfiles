local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.branch = '0.1.x'

Plugin.dependencies = {
	{ 'nvim-lua/plenary.nvim' },
	{ 'BurntSushi/ripgrep' },
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}

Plugin.cmd = { 'Telescope' }

function Plugin.init()
	-- See :help telescope.builtin
	vim.keymap.set('n', '<leader>fo', '<cmd>Telescope oldfiles<cr>')
	vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>')
	vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
	vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
	vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')
	vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
end

function Plugin.config()
	require('telescope').load_extension('fzf')
	require('telescope').setup {
		defaults = {
			hidden = true,
			file_ignore_patterns = {
				"/static/*",
				"node_modules/*"
			}
		},
		pickers = {
			oldfiles = {
				cwd_only = true,
			}
		}
	}
end

return Plugin
