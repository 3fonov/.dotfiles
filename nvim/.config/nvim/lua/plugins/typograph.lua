return {
	"3fonov/typograf.nvim",
	config = function()
		vim.keymap.set("v", "<leader>ty", ":<C-u>lua require('typograf').typograf()<CR>", { desc = "Типографировать текст" })
	end
}
