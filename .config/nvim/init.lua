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
o.title = true
o.laststatus = 2

o.foldenable = true

o.list = true
o.listchars = "eol:↴,tab:▎ ,trail:█"

o.completeopt = "menu,menuone,noselect"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("keymaps")
require("autocmds")
