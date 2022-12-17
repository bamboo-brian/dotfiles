local use = require("packer").use

use("tpope/vim-obsession")

use({
	"glepnir/dashboard-nvim",
	config = function()
		local db = require("dashboard")
		db.session_directory = "~/.local/share/nvim/sessions"
		db.custom_header = {
			" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
			" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
			" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
			" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
			" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
			" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
			" ",
		}
		local padIcon = function(str)
			return string.format("%-4s", str)
		end
		local padDesc = function(str)
			return string.format("%-30s", str)
		end
		db.custom_center = {
			{
				icon = padIcon(""),
				desc = padDesc("Payroll Gateway"),
				action = "source ~/.local/share/nvim/sessions/payroll-gateway.vim",
			},
			{
				icon = padIcon(""),
				desc = padDesc("Main"),
				action = "source ~/.local/share/nvim/sessions/main.vim",
			},
			{
				icon = padIcon(""),
				desc = padDesc("Neovim Config"),
				action = "source ~/.local/share/nvim/sessions/nvim-config.vim",
			},
		}
	end,
})
