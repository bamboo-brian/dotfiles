return {
	"wellle/targets.vim",
	{
		"bkad/CamelCaseMotion",
		config = function()
			vim.g.camelcasemotion_key = "<leader>"
		end,
	},
	"tpope/vim-surround",
	{
		"phaazon/hop.nvim",
		config = true,
	},
}
