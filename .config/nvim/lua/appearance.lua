local use = require("packer").use

use({
	"EdenEast/nightfox.nvim",
	config = function()
		require("nightfox").setup({
			options = {
				transparent = true,
			},
		})
		vim.cmd([[colorscheme carbonfox]])

		local reference_highlight = { bold = true, underdotted = true }
		vim.api.nvim_set_hl(0, "LspReferenceText", reference_highlight)
		vim.api.nvim_set_hl(0, "LspReferenceRead", reference_highlight)
		vim.api.nvim_set_hl(0, "LspReferenceWrite", reference_highlight)
	end,
})

use({
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		vim.opt.list = true
		local blankline = require("indent_blankline")
		blankline.setup({
			show_current_context = true,
			filetype_exclude = { "dashboard" },
		})
	end,
})

use({
	"RRethy/vim-illuminate",
	config = function() end,
})

use({
	"nanozuki/tabby.nvim",
	after = "nightfox.nvim",
	config = function()
		require("tabby").setup()
		require("tabby.tabline").use_preset("tab_only", {
			theme = {
				fill = { guibg = "NONE" },
			},
		})
	end,
})

use({
	"nvim-lualine/lualine.nvim",
	requires = { "nvim-tree/nvim-web-devicons", opt = true },
	config = function()
		require("lualine").setup()
	end,
})
