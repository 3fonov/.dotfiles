return {
	"3fonov/typograf.nvim",
	config = function()
		vim.keymap.set("v", "<leader>ty", ":<C-u>lua require('typograf').typograf()<CR>", { desc = "Типографировать текст" })
		vim.keymap.set("n", "ty", function()
			vim.o.operatorfunc = "v:lua.require'typograf'.typograf_range"
			return "g@"
		end, { expr = true, desc = "Типографировать motion" })
	end
}
