local Plugin = { 'nvim-treesitter/nvim-treesitter' }

Plugin.dependencies = {
	{ 'nvim-treesitter/nvim-treesitter-textobjects' },
	{ 'nvim-treesitter/nvim-treesitter-context' }
}

-- See :help nvim-treesitter-modules
Plugin.opts = {
	highlight = {
		enable = true,
	},
	-- :help nvim-treesitter-textobjects-modules
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['al'] = '@loop.outer',
				['il'] = '@loop.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			}
		},
	},
	ensure_installed = {
		'javascript',
		'typescript',
		'tsx',
		'lua',
		'go',
		'vim',
		'vimdoc',
		'css',
		'json',
		'graphql',
		'http',
		'xml',
		"luadoc",
		"markdown"
	},
}

function Plugin.config(name, opts)
	require('nvim-treesitter.configs').setup(opts)
end

return Plugin
