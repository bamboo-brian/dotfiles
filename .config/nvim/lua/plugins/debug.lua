return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			dap.adapters.php = {
				type = 'executable',
				command = 'php-debug',
			}

			dap.configurations.php = {
				{
					type = 'php',
					request = 'launch',
					name = 'Listen for Xdebug',
					port = 9000,
					pathMappings = {
						['/var/www'] = vim.fn.getcwd()
					}
				}
			}

			vim.api.nvim_set_keymap("n", "<leader>dc", '<cmd>DapContinue<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dq", '<cmd>DapTerminate<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>db", '<cmd>DapToggleBreakpoint<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dj", '<cmd>DapStepOver<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dl", '<cmd>DapStepInto<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dh", '<cmd>DapStepOut<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dk", '<cmd>lua require("debug").hover()<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>dr", '<cmd>DapToggleRepl<CR>', { noremap = true })
			vim.api.nvim_set_keymap("n", "<leader>ds", '<cmd>lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)<CR>', { noremap = true })
		end,
	}
}
