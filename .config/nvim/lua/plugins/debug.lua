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

		end,
	}
}
