-- Space as leader key
vim.g.mapleader = ' '

-- Shortcuts
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>h', '^')
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

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

vim.keymap.set('n', '<leader>dd', ':! dbt run -s %:t:r<cr>')
vim.keymap.set('n', '<leader>df', ':! dbt run -s %:t:r -f<cr>')
vim.keymap.set('n', '<leader>dp', ':! dbt run -s %:t:r+<cr>')

-- Rest nvim

vim.keymap.set('n', "<leader>rr", "<cmd>Rest run<cr>")
vim.keymap.set('n', "<leader>rl", "<cmd>Rest run last<cr>")

-- Oil Nvim
--
vim.keymap.set('n','-',"<cmd>lua require('oil').open()<cr>")

-- Neogit
--
--local neogit = require('neogit')
vim.keymap.set('n','<leader>gs', ":Neogit<CR>",{silent=true, noremap=true})
vim.keymap.set('n','<leader>gc',":Neogit commit<CR>",{silent=true, noremap=true})
vim.keymap.set('n','<leader>gp',":Neogit pull<CR>",{silent=true, noremap=true})
vim.keymap.set('n','<leader>gP',":Neogit push<CR>",{silent=true, noremap=true})
vim.keymap.set('n','<leader>gb',":Telescope git_branches<CR>",{silent=true, noremap=true})
vim.keymap.set('n','<leader>gB',":G blame<CR>",{silent=true, noremap=true})
