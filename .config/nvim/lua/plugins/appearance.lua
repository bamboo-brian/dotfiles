return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme catppuccin-frappe")
		end,
	},
	{
		"nanozuki/tabby.nvim",
		config = function()
			require("tabby").setup()
			require("tabby.tabline").use_preset("tab_only", {
				theme = {
					fill = { guibg = "NONE" },
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true
	},
}
