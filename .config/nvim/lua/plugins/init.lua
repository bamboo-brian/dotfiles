local M = {
	"tpope/vim-repeat",
	"mbbill/undotree",
	"gpanders/editorconfig.nvim",
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			on_attach = function(bufnr)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true })
			end
		},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
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
