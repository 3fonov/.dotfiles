-- Space as leader key
vim.g.mapleader = ' '

-- Shortcuts
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set('n', '<leader>q', ':cclose<CR>', { desc = 'Quickfix: close' })

-- Basic clipboard interaction
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y') -- copy
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p') -- paste

-- Delete text
vim.keymap.set({ 'n', 'x' }, 'x', '"_x')
vim.keymap.set({ 'n', 'x' }, 'X', '"_d')
vim.keymap.set('n', '<BS>', 'ciw')

-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set({ 'x', 'n' }, '<leader>p', '"_dP')


-- DBT
vim.keymap.set('n', '<leader>dc', ':DbtCompile<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dy', ':DbtModelYaml<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dr', ':DbtRun<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>db', ':DbtBuild<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>df', ':DbtRunFull<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>dt', ':DbtTest<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d+', ':DbtListUpstreamModels<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>d-', ':DbtListDownstreamModels<CR>', { noremap = true, silent = true })

-- Rest nvim

vim.keymap.set('n', "<leader>rr", "<cmd>Rest run<cr>")
vim.keymap.set('n', "<leader>rl", "<cmd>Rest run last<cr>")

-- Oil Nvim
--
vim.keymap.set('n', '-', "<cmd>lua require('oil').open()<cr>")

-- Neogit
--
--local neogit = require('neogit')
vim.keymap.set('n', '<leader>gs', ":Neogit<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gc', ":Neogit commit<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gp', ":Neogit pull<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gP', ":Neogit push<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gb', ":Telescope git_branches<CR>", { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gB', ":G blame<CR>", { silent = true, noremap = true })

-- move
--
local opts = { noremap = true, silent = true }
-- Normal-mode commands
vim.keymap.set('n', '<M-j>', ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', '<M-k>', ':MoveLine(-1)<CR>', opts)
vim.keymap.set('n', '<M-h>', ':MoveHChar(-1)<CR>', opts)
vim.keymap.set('n', '<M-l>', ':MoveHChar(1)<CR>', opts)
vim.keymap.set('n', '<leader>wf', ':MoveWord(1)<CR>', opts)
vim.keymap.set('n', '<leader>wb', ':MoveWord(-1)<CR>', opts)

-- Visual-mode commands
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-h>', ':MoveHBlock(-1)<CR>', opts)
vim.keymap.set('v', '<A-l>', ':MoveHBlock(1)<CR>', opts)


-- Typograf

-- vim.keymap.set("v", "<leader>ty", function() require("typograf").typograf() end, { desc = "Типографировать текст" })
