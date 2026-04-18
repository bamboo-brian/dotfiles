return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make"
			},
		},
		config = function()
			require("telescope").setup({
				defaults = {
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							preview_height = 0.75,
						},
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						layout_config = {
							preview_height = nil,
							width = 0.6,
						},
					},
					lsp_code_actions = {
						theme = "cursor",
					},
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_genereic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")

		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				on_attach = function(bufnr)
					local api = require('nvim-tree.api')
					api.config.mappings.default_on_attach(bufnr)
					vim.keymap.set('n', '-', "<cmd>NvimTreeFindFileToggle<CR>", { buffer = bufnr})
				end,
			})
		end,
	},
	{
		"ThePrimeagen/harpoon",
		dependencies = {"nvim-telescope/telescope.nvim"},
		config = function()
			require('harpoon').setup({
				menu = {
					width = 120 
				}
			})
			require("telescope").load_extension('harpoon')
		end
	}
}
