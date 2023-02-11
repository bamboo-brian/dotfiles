local use = require("packer").use

use({
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
	end
})


local M = {}

M.hover = function()
	local ts_utils = require('nvim-treesitter.ts_utils')
	local widgets = require('dap.ui.widgets')


	local node = ts_utils.get_node_at_cursor()

	if not node then
		return 
	end

	if node:type() == 'name' then
		node = node:parent()
	end

	local expr = vim.treesitter.query.get_node_text(node, 0)

	widgets.hover(expr)
end

return M
