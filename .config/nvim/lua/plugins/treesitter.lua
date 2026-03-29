return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = "all",
				ignore_install = {"norg"},
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
	}
}
