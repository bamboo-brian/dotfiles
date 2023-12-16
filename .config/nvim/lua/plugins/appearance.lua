return {
	{
		"EdenEast/nightfox.nvim",
		config = function(plugin, opts)
			vim.cmd([[colorscheme duskfox]])
		end,
		priority = 500
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	"RRethy/vim-illuminate",
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
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				mode = "foreground",
			},
		}
	}
}
