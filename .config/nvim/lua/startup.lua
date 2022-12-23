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
		local ok, items = pcall(require, 'menu')
		if not ok then return end

		local custom_center = {}
		for _, item in ipairs(items) do
			table.insert(custom_center, {
				icon = padIcon(item.icon),
				desc = padDesc(item.desc),
				action = item.action
			})
		end
		db.custom_center = custom_center
	end,
})
