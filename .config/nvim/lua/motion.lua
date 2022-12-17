local use = require("packer").use

use("wellle/targets.vim")

use({
	"bkad/CamelCaseMotion",
	setup = function()
		vim.g.camelcasemotion_key = "<leader>"
	end,
})

use("tpope/vim-surround")
use({
	"phaazon/hop.nvim",
	config = function()
		require("hop").setup({})
	end,
})

vim.api.nvim_set_keymap("", "<leader><leader>", "<cmd>HopWordMW<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>j", "<cmd>HopLineStartAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>k", "<cmd>HopLineStartBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>f", "<cmd>HopChar1<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>/", "<cmd>HopPatternMW<CR>", { noremap = true })
