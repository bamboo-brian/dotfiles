vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("TestRunner", {}),
	pattern = "*Test.php",
	callback = function()
		require("neotest").run.run(vim.fn.expand("%"))
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("PhpRead", {}),
	pattern = "*.php",
	callback = require('util').fold_php_uses
})
