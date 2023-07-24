local o = vim.o
local g = vim.g
local fn = vim.fn

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_python_provider = 0
g.loaded_matchit = 1

vim.g.mapleader = " "

o.grepprg = "rg --hidden --vimgrep --smart-case --"
o.hidden = true
o.splitbelow = true
o.splitright = true
o.mouse = "a"
o.updatetime = 250
o.ignorecase = true
o.smartcase = true
o.formatoptions = ""
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = false
o.scrolloff = 8

o.termguicolors = true
o.number = true
o.relativenumber = true
o.signcolumn = "yes:1"
o.colorcolumn = "140"
o.showmode = false
o.hlsearch = false
o.title = true
o.laststatus = 2

o.foldenable = false
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"

o.listchars = "eol:↴,tab:├┈,trail:█"

o.completeopt = "menu,menuone,noselect"

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end
vim.cmd([[packadd packer.nvim]])
local packer = require("packer")

packer.init()
packer.reset()

packer.use("wbthomason/packer.nvim")

packer.use("tpope/vim-repeat")

packer.use("gpanders/editorconfig.nvim")

packer.use({
	"lewis6991/gitsigns.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		require("gitsigns").setup({
			on_attach = function(bufnr)
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gp", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true })
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true })
			end
		})
	end,
})

packer.use("tpope/vim-fugitive")

packer.use({
	"sindrets/diffview.nvim",
	requires = { "nvim-lua/plenary.nvim" },
})

packer.use("mbbill/undotree")

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
	require(m)
end

vim.api.nvim_set_keymap("n", "<leader>R", "<cmd>source ~/.config/nvim/init.lua<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { noremap = true })
