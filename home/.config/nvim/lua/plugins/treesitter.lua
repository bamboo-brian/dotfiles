return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				init = function()
					vim.g.no_plugin_maps = true
				end,
				config = function()
					require("nvim-treesitter-textobjects").setup({
						select = {
							lookahead = true,
						},
						swap = {},
						move = {
							set_jumps = true,
						},
						lsp_interop = {
							border = "single",
						},
					})
				end,
			},
		},
		config = function()
			require("nvim-treesitter").setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
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
	}
}
