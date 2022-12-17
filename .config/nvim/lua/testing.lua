local use = require("packer").use

use({
	"nvim-neotest/neotest",
	requires = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"antoinemadec/FixCursorHold.nvim",
		"olimorris/neotest-phpunit",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-phpunit"),
			},
		})
		vim.api.nvim_set_keymap("n", "<leader>tt", '<cmd>lua require("neotest").run.run()<CR>', { noremap = true })
		vim.api.nvim_set_keymap(
			"n",
			"<leader>ts",
			'<cmd>lua require("neotest").summary.toggle()<CR>',
			{ noremap = true }
		)
		vim.api.nvim_set_keymap("n", "<leader>to", '<cmd>lua require("neotest").output.open()<CR>', { noremap = true })
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = vim.api.nvim_create_augroup("TestRunner", { clear = true }),
			pattern = "*Test.php",
			callback = function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
		})
	end,
})
