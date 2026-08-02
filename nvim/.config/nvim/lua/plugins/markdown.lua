return {
	'MeanderingProgrammer/render-markdown.nvim',
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },   -- if you use the mini.nvim suite
	opts = {
		image = {
			enabled = true,

			-- максимальная высота в строках терминала
			max_height = 10,

			-- можно дополнительно ограничить ширину
			max_width = 60,

			-- чтобы изображение масштабировалось
			scale = 1.0,
		},
	},
}
