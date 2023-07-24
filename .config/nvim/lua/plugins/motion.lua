vim.api.nvim_set_keymap("", "<leader><leader>", "<cmd>HopWordMW<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>j", "<cmd>HopLineStartAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>k", "<cmd>HopLineStartBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>f", "<cmd>HopChar1<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<leader>/", "<cmd>HopPatternMW<CR>", { noremap = true })

return {
	"wellle/targets.vim",
	{
		"bkad/CamelCaseMotion",
		config = function()
			vim.g.camelcasemotion_key = "<leader>"
		end,
	},
	"tpope/vim-surround",
	"phaazon/hop.nvim",
}
