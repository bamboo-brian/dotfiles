return {
	{
	  'f4z3r/gruvbox-material.nvim',
	  name = 'gruvbox-material',
	  lazy = false,
	  priority = 1000,
	  opts = { contrast = "hard" },
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
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
