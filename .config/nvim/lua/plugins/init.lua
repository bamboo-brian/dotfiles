local M = {
	"tpope/vim-repeat",
	"mbbill/undotree",
	"gpanders/editorconfig.nvim",
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			on_attach = function(bufnr)
				require("keymaps").gitsigns_attach_keymaps(bufnr)
			end
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"klen/nvim-config-local",
		opts = {
			silent = true,
			lookup_parents = true,
		},
	}
}

local modules = {
	"appearance",
	"completion",
	"navigation",
	"motion",
	"treesitter",
	"lsp",
	"testing",
	"debug",
}

for _, m in ipairs(modules) do
	package.loaded[m] = nil
	local module = require("plugins/" .. m)
	for _, spec in ipairs(module) do
		M[#M + 1] = spec
	end
end

return M
