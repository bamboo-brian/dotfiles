local map = function(key, cmd) vim.keymap.set("", key, cmd, { noremap = true }) end
local nmap = function(key, cmd) vim.keymap.set("n", key, cmd, { noremap = true }) end
local imap = function(key, cmd) vim.keymap.set("i", key, cmd, { noremap = true }) end

nmap("<leader>R", "<cmd>source ~/.config/nvim/init.lua<CR>")
nmap("<leader>u", "<cmd>UndotreeToggle<CR>")

imap("<c-n>", require("cmp").select_next_item)
imap("<c-p>", require("cmp").select_prev_item)

nmap("<leader>n", '<cmd>cnext<cr>')
nmap("<leader>p", '<cmd>cprev<cr>')

-- Motion
map("<leader><leader>", "<cmd>HopWordMW<CR>")
map("<leader>j", "<cmd>HopLineStartAC<CR>")
map("<leader>k", "<cmd>HopLineStartBC<CR>")
map("<leader>f", "<cmd>HopChar1<CR>")

-- Navigation
nmap("<leader>ta", "<cmd>tabnew<CR>")
nmap("<leader>tA", "<cmd>$tabnew<CR>")
nmap("<leader>ti", "<cmd>-tabnew<CR>")
nmap("<leader>tI", "<cmd>0tabnew<CR>")
nmap("<leader>tq", "<cmd>tabclose<CR>")
nmap("<leader>tn", "<cmd>tabn<CR>")
nmap("<leader>tp", "<cmd>tabp<CR>")
nmap("<leader>tN", "<cmd>+tabmove<CR>")
nmap("<leader>tP", "<cmd>-tabmove<CR>")

nmap("<C-p>", require('telescope.builtin').find_files)
nmap("<C-f>", require('telescope.builtin').live_grep)
nmap("<leader>*", require('telescope.builtin').grep_string)
nmap("<leader>/", function()
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown())
end)

nmap("<leader>m", require('harpoon.mark').add_file)
nmap("<leader>'", require('harpoon.ui').toggle_quick_menu)
nmap("<leader>;", require('harpoon.ui').nav_next)
nmap("<leader>:", require('harpoon.ui').nav_prev)
nmap("<leader>1", function() require('harpoon.ui').nav_file(1) end)
nmap("<leader>2", function() require('harpoon.ui').nav_file(2) end)
nmap("<leader>3", function() require('harpoon.ui').nav_file(3) end)
nmap("<leader>4", function() require('harpoon.ui').nav_file(4) end)
nmap("<leader>5", function() require('harpoon.ui').nav_file(5) end)

-- Debug
nmap("<leader>dc", '<cmd>DapContinue<CR>')
nmap("<leader>dq", '<cmd>DapTerminate<CR>')
nmap("<leader>db", '<cmd>DapToggleBreakpoint<CR>')
nmap("<leader>dj", '<cmd>DapStepOver<CR>')
nmap("<leader>dl", '<cmd>DapStepInto<CR>')
nmap("<leader>dh", '<cmd>DapStepOut<CR>')
nmap("<leader>dk", require("util").debug_hover)
nmap("<leader>dr", '<cmd>DapToggleRepl<CR>')
nmap("<leader>ds", function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end)
nmap("-", "<cmd>NvimTreeFindFileToggle<CR>")

-- Testing
nmap("<leader>tt", require("neotest").run.run)
nmap("<leader>ts", require("neotest").summary.toggle)
nmap("<leader>to", require("neotest").output.open)


-- Yank
nmap("<leader>ym", require("util").copyMethod)
nmap("<leader>yc", require("util").copyClass)

-- LSP
return {
	lsp_attach_keymaps = function(bufnr)
		local bnmap = function(key, cmd) vim.keymap.set("n", key, cmd, { noremap = true, buffer = bufnr }) end
		local bimap = function(key, cmd) vim.keymap.set("i", key, cmd, { noremap = true, buffer = bufnr }) end

		bnmap("<leader>F", function() vim.lsp.buf.format({ timeout_ms = 3000}) end)
		bnmap("<leader>.", vim.lsp.buf.code_action)
		bnmap("<leader>r", vim.lsp.buf.rename)
		bnmap("]d", vim.diagnostic.goto_next)
		bnmap("[d", vim.diagnostic.goto_prev)
		bnmap("<leader>wd", '<cmd>Telescope diagnostics<CR>')
		bnmap("<leader>S", function() require"null-ls".toggle{name = "cspell"} end)
		bnmap("gd", "<cmd>Telescope lsp_definitions show_line=false initial_mode=normal<CR>")
		bnmap("gD", "<cmd>Telescope lsp_type_definitions show_line=false initial_mode=normal<CR>")
		bnmap("gr", "<cmd>Telescope lsp_references show_line=false initial_mode=normal<CR>")
		bnmap("K", vim.lsp.buf.hover)
		bimap("<c-k>", vim.lsp.buf.signature_help)
	end,

	gitsigns_attach_keymaps = function(bufnr)
		vim.api.nvim_buf_set_keymap(bufnr, "n", "]h", "<cmd>Gitsigns next_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { noremap = true })
		vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { noremap = true })
	end
}
