return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.djlint.with({
          filetypes = { "htmldjango", "html" },
          extra_args = { "--profile=django" },
        }),
      },
    })
  end,
}
