return {
	"vim-test/vim-test",
	config = function()
		vim.keymap.set("n", "<leader>t",":TestNearest<cr>")
		vim.keymap.set("n", "<leader>T",":TestFile<cr>")
		vim.keymap.set("n", "<leader>l",":TestLast<cr>")
		vim.keymap.set("n", "<leader>g",":TestVisit<cr>")
	end
}
