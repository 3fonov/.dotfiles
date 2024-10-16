-- Create group to assign commands
-- "clear = true" must be set to prevent loading an
-- auto-command repeatedly every time a file is resourced
local autocmd_group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.py" },
	desc = "Auto-format Python files after saving",
	callback = function()
		local fileName = vim.api.nvim_buf_get_name(0)
		vim.cmd(":silent !black --preview -q " .. fileName)
		vim.cmd(":silent !isort --profile black --float-to-top -q " .. fileName)
	end,
	group = autocmd_group,
})

local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require('go.format').goimports()
	end,
	group = format_sync_grp,
})


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.sql" },
	desc = "Auto-format SQL files after saving",
	callback = function()
		local fileName = vim.api.nvim_buf_get_name(0)
		vim.cmd(":silent !sqlfmt --line-length 88 -d clickhouse " .. fileName)
	end,
	group = autocmd_group,
})



vim.api.nvim_create_autocmd('FileType', {
	pattern = 'qf',
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		vim.keymap.set('n', '<C-n>', '<cmd>cn | wincmd p<CR>', opts)
		vim.keymap.set('n', '<C-p>', '<cmd>cN | wincmd p<CR>', opts)
	end,
})
-- Automatically lint on save or file open
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
	callback = function()
		require('lint').try_lint()
	end,
})
