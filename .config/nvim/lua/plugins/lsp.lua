local lsp = vim.lsp

--lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, { underline = true })

lsp.handlers["textDocument/signatureHelp"] =
	lsp.with(lsp.handlers.signature_help, { focusable = false, border = "rounded" })

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { focusable = false, border = "rounded" })

local gutter_signs = {
	Error = "",
	Warn = "",
	Hint = "",
	Info = "",
}

for type, icon in pairs(gutter_signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			local on_attach = function(client, bufnr)
				require("keymaps").lsp_attach_keymaps(bufnr)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local base_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			local servers = {
				intelephense = {
					settings = {
						intelephense = {
							format = {
								braces = "k&r",
							},
						},
					},
				},
				--phpactor = {},
				bashls = {},
				eslint = {},
				elixirls = {
					cmd = {"elixir-ls"},
				},
				gopls = {},
				ts_ls = {},
				omnisharp = {
					cmd = {"OmniSharp"},
				},
				pyright = {},
				nushell = {
					root_dir = function(fname)
						if fname == vim.fn.expand("~/.config/nushell/config.nu") then
							return vim.fs.dirname(fname)
						end
						return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
					end,
					single_file_support = false
				},
			}


			for server_name, config in pairs(servers) do
				config = vim.tbl_deep_extend("keep", config, base_config)
				local server = lspconfig[server_name]
				local cmd = (config.cmd and config.cmd[1]) or 
					(server.default_config and server.default_config.cmd) or
					(server.document_config and server.document_config.default_config and server.document_config.default_config.cmd[1])
				if not cmd then
					return
				end
				if vim.fn.executable(cmd) == 1 then
					server.setup(config)
				end
			end
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"davidmh/cspell.nvim"
		},
		config = function()
			local cspell = require("cspell")
			local null_ls = require("null-ls")

			local selected_sources = {
				diagnostics = {
					phpcs = {},
				},
				formatting = {
					phpcbf = {},
					stylua = {},
				},
			}

			local sources = {
				cspell.diagnostics.with({
						diagnostic_config = {
							virtual_text = false,
							signs = false,
						}
					}),
				cspell.code_actions
			}

			for type, type_sources in pairs(selected_sources) do
				for source, options in pairs(type_sources) do
					local builtin = null_ls.builtins[type][source]
					local command = builtin._opts and builtin._opts.command or builtin.name
					if vim.fn.executable(command) == 1 then
						table.insert(sources, builtin.with(options))
					end
				end
			end

			null_ls.setup({
				sources = sources,
				fallback_severity = vim.diagnostic.severity.INFO,
			})
		end,
	}
}
