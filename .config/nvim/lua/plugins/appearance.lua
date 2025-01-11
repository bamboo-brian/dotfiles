return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 500,
		opts = {
			highlight_groups = {
				SpecialKey = {fg = "overlay"},
				NonText = {fg = "overlay"}
			}
		}
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
