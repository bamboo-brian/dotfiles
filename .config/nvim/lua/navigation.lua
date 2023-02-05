local use = require("packer").use

use({
	"nvim-telescope/telescope.nvim",
	requires = {
		{ "nvim-lua/plenary.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
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
		require('telescope').load_extension('fzf')

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
})

use({
	"kyazdani42/nvim-tree.lua",
	requires = {
		"kyazdani42/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			view = {
				mappings = {
					list = {
						{ key = "-", action = "" },
					},
				},
			},
		})

		vim.api.nvim_set_keymap("n", "-", "<cmd>NvimTreeFindFileToggle<CR>", { noremap = true })
	end,
})

vim.api.nvim_set_keymap("n", "<leader>ta", "<cmd>tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tA", "<cmd>$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ti", "<cmd>-tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tI", "<cmd>0tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tq", "<cmd>tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", "<cmd>tabp<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tN", "<cmd>+tabmove<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tP", "<cmd>-tabmove<CR>", { noremap = true })
