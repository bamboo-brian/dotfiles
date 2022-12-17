local use = require("packer").use

use({
	"nvim-treesitter/nvim-treesitter",
	requires = { "nvim-treesitter/nvim-treesitter-textobjects", "nvim-treesitter/playground" },
	run = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = "all",
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
				},
				swap = {
					enable = true,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
				lsp_interop = {
					enable = true,
					border = "single",
				},
			},
		})
	end,
})
