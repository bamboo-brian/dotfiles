return {
	{
		"EdenEast/nightfox.nvim",
		config = function(plugin, opts)
			vim.cmd([[colorscheme duskfox]])

			local reference_highlight = { bold = true, underdotted = true }
			vim.api.nvim_set_hl(0, "LspReferenceText", reference_highlight)
			vim.api.nvim_set_hl(0, "LspReferenceRead", reference_highlight)
			vim.api.nvim_set_hl(0, "LspReferenceWrite", reference_highlight)
			vim.api.nvim_set_hl(0, "Search", { underline = true, italic = true })
			vim.api.nvim_set_hl(0, "CurSearch", { underline = true })
		end,
		priority = 500
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			show_current_context = true,
			filetype_exclude = { "dashboard" },
		},
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
