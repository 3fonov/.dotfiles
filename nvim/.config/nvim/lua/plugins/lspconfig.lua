local Plugin = { 'neovim/nvim-lspconfig' }
local user = {}

Plugin.dependencies = {
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'mason-org/mason-lspconfig.nvim' },
}

Plugin.cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' }

Plugin.event = { 'BufReadPre', 'BufNewFile' }

function Plugin.init()
	local sign = function(opts)
		-- See :help sign_define()
		vim.fn.sign_define(opts.name, {
			texthl = opts.name,
			text = opts.text,
			numhl = ''
		})
	end

	sign({ name = 'DiagnosticSignError', text = '✘' })
	sign({ name = 'DiagnosticSignWarn', text = '▲' })
	sign({ name = 'DiagnosticSignHint', text = '⚑' })
	sign({ name = 'DiagnosticSignInfo', text = '»' })

	-- See :help vim.diagnostic.config()
	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true,
		float = {
			border = 'rounded',
			source = 'always',
		},
	})

	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = 'rounded' }
	)

	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = 'rounded' }
	)
end

function Plugin.config()
	local capabilities = require('cmp_nvim_lsp').default_capabilities()

	require('mason-lspconfig').setup({
		automatic_enable = false,
		ensure_installed = {
			'eslint',
			'ts_ls',
			'html',
			'cssls',
			'lua_ls',
			'jinja_lsp',
			'emmet_language_server',
		},
	})

	local group = vim.api.nvim_create_augroup('lsp_cmds', { clear = true })

	vim.api.nvim_create_autocmd('LspAttach', {
		group = group,
		desc = 'LSP actions',
		callback = user.on_attach,
	})

	local function configure(server, opts)
		local config = opts and vim.deepcopy(opts) or {}
		config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
		vim.lsp.config(server, config)
		vim.lsp.enable(server)
	end

	configure('emmet_language_server', {
		filetypes = {
			'html',
			'htmldjango',
			'css',
			'javascriptreact',
			'typescriptreact',
			'vue',
			'svelte',
			'templ',
		},
		init_options = {
			html = {
				options = {
					['bem.enabled'] = true,
				},
			},
		},
	})

	configure('cssls', {
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = 'ignore',
				},
			},
			scss = {
				lint = { unknownAtRules = 'ignore' },
			},
			less = {
				lint = { unknownAtRules = 'ignore' },
			},
		},
	})

	configure('ts_ls', {
		settings = {
			completions = {
				completeFunctionCalls = true,
			},
		},
	})

	configure('html', {
		filetypes = { 'html', 'htmldjango' },
	})

	configure('lua_ls', require('plugins.lsp.lua_ls'))
	configure('eslint')
	configure('jinja_lsp')
end

function user.on_attach()
	local bufmap = function(mode, lhs, rhs)
		local opts = { buffer = true }
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- You can search each function in the help page.
	-- For example :help vim.lsp.buf.hover()

	bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
	bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
	bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
	bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
	bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
	bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
	bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
	bufmap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
	bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
	bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
	bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
	bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

return Plugin
