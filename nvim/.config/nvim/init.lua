local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end

load('user.settings')
load('user.commands')
load('user.keymaps')
load('user.autocmds')
require('user.plugins')

pcall(vim.cmd.colorscheme, 'catppuccin-frappe')
require('langmapper').automapping({ global = true, buffer = true })
