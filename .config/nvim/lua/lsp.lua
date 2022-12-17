local use = require("packer").use
local lsp = vim.lsp

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, { underline = true })

lsp.handlers["textDocument/signatureHelp"] =
	lsp.with(lsp.handlers.signature_help, { focusable = false, border = "rounded" })

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { focusable = false, border = "rounded" })

local gutter_signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(gutter_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

use({
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")

		local on_attach = function(client, bufnr)
			require("illuminate").on_attach(client)
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local base_config = {
			on_attach = on_attach,
			capabilities = capabilities,
		}

		local servers = {}

		servers["intelephense"] = {
			settings = {
				intelephense = {
					format = {
						enable = false,
						braces = "k&r",
					},
				},
			},
		}
		servers["bashls"] = {}
		servers["eslint"] = {}

		for server, config in pairs(servers) do
			config = vim.tbl_deep_extend("keep", config, base_config)
			lspconfig[server].setup(config)
		end
	end,
})

use({
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			null_ls.builtins.diagnostics.phpcs,
			null_ls.builtins.formatting.phpcbf,
			null_ls.builtins.diagnostics.cspell.with({
				diagnostic_config = {
					virtual_text = false,
					signs = false,
				},
			}),
			null_ls.builtins.code_actions.cspell,
			null_ls.builtins.formatting.stylua,
		}
		null_ls.setup({
			sources = sources,
			fallback_severity = vim.diagnostic.severity.INFO,
		})
	end,
})

local opts = { noremap = true }

vim.api.nvim_set_keymap("n", "<leader>n", '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>p",
	'<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
	opts
)
vim.api.nvim_set_keymap("n", "<leader>.", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>F", "<cmd>lua vim.lsp.buf.format({ timeout_ms = 3000, filter = function(client) return client.name ~= 'intelephense' end })<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions show_line=false initial_mode=normal<CR>", opts)
vim.api.nvim_set_keymap("n", "gD", "<cmd>Telescope lsp_type_definitions show_line=false initial_mode=normal<CR>", opts)
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references show_line=false initial_mode=normal<CR>", opts)
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>S", '<cmd>lua require"null-ls".toggle{name = "cspell"}<CR>', opts)
