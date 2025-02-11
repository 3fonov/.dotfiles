Plugin = {
	'mfussenegger/nvim-lint',
	config = function()
		-- Configure nvim-lint for SQLFluff
		local lint = require('lint')

		lint.enabled = true;
		-- Customize dialect as necessary for you
		lint.linters.sqlfluff.args = { "lint", "--format=json", "-" }
		lint.linters.sqlfluff.stdin = true


		lint.linters_by_ft = {
			sql = { 'sqlfluff', },
		}
	end
}
return Plugin
