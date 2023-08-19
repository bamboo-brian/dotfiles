return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"olimorris/neotest-phpunit",
		},
		config = function()
			require("neotest").setup({
				log_level = vim.log.levels.DEBUG,
				adapters = {
					require("neotest-phpunit")({
						phpunit_cmd = function()
							return "phpunit"
						end
					}),
				},
			})
		end,
	}
}
