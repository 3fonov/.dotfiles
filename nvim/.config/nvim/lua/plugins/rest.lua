local Plugin = {
	"rest-nvim/rest.nvim" }

Plugin.name = "rest.nvim"
Plugin.dependencies = { "luarocks.nvim" }
Plugin.ft = "http"
function Plugin.config()
	require("rest-nvim").setup()
end

return Plugin
