vim.api.nvim_set_keymap("n", "<leader>ta", "<cmd>tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tA", "<cmd>$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ti", "<cmd>-tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tI", "<cmd>0tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tq", "<cmd>tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>tabp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tN", "<cmd>+tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tP", "<cmd>-tabmove<CR>", { noremap = true })

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

			vim.api.nvim_set_keymap(
				"n",
				"<C-p>",
				'<cmd>lua require("telescope.builtin").find_files()<cr>',
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<C-f>",
				'<cmd>lua require("telescope.builtin").live_grep()<cr>',
				{ noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>*",
				'<cmd>lua require("telescope.builtin").grep_string()<cr>',
				{ noremap = true }
			)
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

			vim.api.nvim_set_keymap("n", "-", "<cmd>NvimTreeFindFileToggle<CR>", { noremap = true })
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
			vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>lua require('harpoon.mark').add_file()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>'", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>;", "<cmd>lua require('harpoon.ui').nav_next()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>:", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<CR>", { noremap = true })
		end
	}
}
