local use = require("packer").use

use({
	"hrsh7th/nvim-cmp",
	requires = {
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-calc",
		"onsails/lspkind-nvim",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			sources = {
				{ name = "nvim_lsp" },
				{
					name = "buffer",
					option = {
						get_bufnrs = function()
							return vim.api.nvim_list_bufs()
						end,
					},
				},
				{ name = "path" },
				{ name = "nvim_lua" },
				{ name = "calc" },
			},
			formatting = {
				format = lspkind.cmp_format({ with_text = false }),
			},
			mapping = {
				["<CR>"] = cmp.mapping(cmp.mapping.confirm(), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			},
		})
	end,
})

use({
	"windwp/nvim-autopairs",
	config = function()
		require("nvim-autopairs").setup()
	end,
})

vim.api.nvim_set_keymap("i", "<c-n>", '<cmd>lua require("cmp").select_next_item()<CR>', { noremap = true })
vim.api.nvim_set_keymap("i", "<c-p>", '<cmd>lua require("cmp").select_prev_item()<CR>', { noremap = true })
